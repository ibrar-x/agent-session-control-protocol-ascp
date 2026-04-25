#!/usr/bin/env python3
import json
import sys
import warnings
from pathlib import Path

warnings.filterwarnings("ignore", category=DeprecationWarning)

try:
    from jsonschema import Draft202012Validator, RefResolver
except ModuleNotFoundError as exc:
    raise SystemExit(
        "Missing dependency: jsonschema. Install it with "
        "`python3 -m pip install --user jsonschema`."
    ) from exc


ROOT = Path(__file__).resolve().parents[2]

REQUIRED_PATHS = [
    Path("spec/replay.md"),
    Path("conformance/fixtures/replay/subscribe-with-snapshot.json"),
    Path("conformance/fixtures/replay/subscribe-from-seq.json"),
    Path("conformance/fixtures/replay/subscribe-from-event-id.json"),
    Path("conformance/fixtures/replay/subscribe-with-opaque-cursor.json"),
    Path("conformance/fixtures/replay/replay-retention-fallback.json"),
]

REQUIRED_SPEC_SNIPPETS = [
    "sessions.resume",
    "sessions.subscribe",
    "sync.snapshot",
    "sync.replayed",
    "from_seq",
    "from_event_id",
    "opaque",
    "retention",
    "ASCP Replay-Capable",
]

EVENT_TYPE_TO_DEF = {
    "message.user": "MessageUserEvent",
    "message.assistant.delta": "MessageAssistantDeltaEvent",
    "message.assistant.completed": "MessageAssistantCompletedEvent",
    "sync.snapshot": "SyncSnapshotEvent",
    "sync.replayed": "SyncReplayedEvent",
    "sync.cursor_advanced": "SyncCursorAdvancedEvent",
}


def read_text(relative_path: str) -> str:
    return (ROOT / relative_path).read_text()


def read_json(relative_path: str):
    return json.loads((ROOT / relative_path).read_text())


def ensure_required_paths():
    missing = [str(path) for path in REQUIRED_PATHS if not (ROOT / path).exists()]
    if missing:
        raise SystemExit("Missing replay semantics assets:\n- " + "\n- ".join(missing))


def ensure_spec_content():
    replay_doc = read_text("spec/replay.md")
    missing = [snippet for snippet in REQUIRED_SPEC_SNIPPETS if snippet not in replay_doc]
    if missing:
        raise SystemExit(
            "spec/replay.md is missing required replay sections:\n- "
            + "\n- ".join(missing)
        )


def build_store():
    core_schema = read_json("schema/ascp-core.schema.json")
    capabilities_schema = read_json("schema/ascp-capabilities.schema.json")
    errors_schema = read_json("schema/ascp-errors.schema.json")
    methods_schema = read_json("schema/ascp-methods.schema.json")
    events_schema = read_json("schema/ascp-events.schema.json")

    store = {
        core_schema["$id"]: core_schema,
        capabilities_schema["$id"]: capabilities_schema,
        errors_schema["$id"]: errors_schema,
        methods_schema["$id"]: methods_schema,
        events_schema["$id"]: events_schema,
        "ascp-core.schema.json": core_schema,
        "ascp-capabilities.schema.json": capabilities_schema,
        "ascp-errors.schema.json": errors_schema,
        "ascp-methods.schema.json": methods_schema,
        "ascp-events.schema.json": events_schema,
    }
    return core_schema, errors_schema, methods_schema, events_schema, store


def inline_local_refs(schema_root, node):
    if isinstance(node, dict):
        if set(node.keys()) == {"$ref"} and node["$ref"].startswith("#/$defs/"):
            target_name = node["$ref"].split("/")[-1]
            return inline_local_refs(schema_root, schema_root["$defs"][target_name])
        return {key: inline_local_refs(schema_root, value) for key, value in node.items()}
    if isinstance(node, list):
        return [inline_local_refs(schema_root, item) for item in node]
    return node


def validate_instance(instance, schema_root, def_name, store):
    resolver = RefResolver.from_schema(schema_root, store=store)
    schema = inline_local_refs(schema_root, schema_root["$defs"][def_name])
    validator = Draft202012Validator(schema, resolver=resolver)
    errors = sorted(validator.iter_errors(instance), key=lambda err: err.json_path)
    if errors:
        lines = [f"Validation failed against {def_name}"]
        for error in errors:
            lines.append(f"- {error.json_path}: {error.message}")
        raise SystemExit("\n".join(lines))


def validate_event(event, events_schema, store, fixture_path):
    event_type = event["type"]
    if event_type not in EVENT_TYPE_TO_DEF:
        raise SystemExit(f"{fixture_path}: unsupported replay fixture event type {event_type}")
    try:
        validate_instance(event, events_schema, EVENT_TYPE_TO_DEF[event_type], store)
    except SystemExit as exc:
        raise SystemExit(f"{fixture_path}: {exc}") from exc


def load_fixture(relative_path: str):
    return read_json(relative_path)


def assert_true(condition, message):
    if not condition:
        raise SystemExit(message)


def validate_success_fixture(relative_path, fixture, methods_schema, events_schema, store):
    request = fixture["request"]
    response = fixture["response"]
    expectations = fixture["expectations"]
    stream = fixture["stream"]

    validate_instance(request, methods_schema, "SessionsSubscribeRequest", store)
    validate_instance(response, methods_schema, "SessionsSubscribeSuccessResponse", store)

    for event in stream:
        validate_event(event, events_schema, store, relative_path)

    include_snapshot = expectations["include_snapshot"]
    snapshot_events = [idx for idx, event in enumerate(stream) if event["type"] == "sync.snapshot"]
    if include_snapshot:
        assert_true(
            snapshot_events == [0],
            f"{relative_path}: snapshot fixtures must start with exactly one leading sync.snapshot",
        )
        assert_true(
            response["result"]["snapshot_emitted"] is True,
            f"{relative_path}: response.snapshot_emitted must be true when include_snapshot is expected",
        )
    else:
        assert_true(
            not snapshot_events,
            f"{relative_path}: snapshot-free fixtures must not contain sync.snapshot",
        )
        assert_true(
            response["result"]["snapshot_emitted"] is False,
            f"{relative_path}: response.snapshot_emitted must be false when no snapshot is expected",
        )

    replay_markers = [idx for idx, event in enumerate(stream) if event["type"] == "sync.replayed"]
    if expectations["replay_marker_required"]:
        assert_true(
            len(replay_markers) == 1,
            f"{relative_path}: success fixtures must contain exactly one sync.replayed marker",
        )
    replay_index = replay_markers[0]
    replay_marker = stream[replay_index]

    history_events = [
        event
        for event in stream[:replay_index]
        if event["type"] != "sync.snapshot"
    ]
    assert_true(history_events, f"{relative_path}: replay segment must contain historical events")

    history_seqs = [event.get("seq") for event in history_events]
    assert_true(
        all(isinstance(seq, int) for seq in history_seqs),
        f"{relative_path}: replayed historical events must carry integer seq values",
    )
    assert_true(
        history_seqs == sorted(history_seqs) and len(set(history_seqs)) == len(history_seqs),
        f"{relative_path}: replayed historical seq values must be strictly increasing",
    )

    marker_payload = replay_marker["payload"]
    assert_true(
        marker_payload["event_count"] == expectations["replayed_event_count"],
        f"{relative_path}: sync.replayed event_count must match the replayed historical segment",
    )
    assert_true(
        len(history_events) == expectations["replayed_event_count"],
        f"{relative_path}: replayed historical segment length does not match expectations",
    )
    assert_true(
        history_seqs[0] == expectations["from_seq"] == marker_payload["from_seq"],
        f"{relative_path}: replayed segment start seq does not match expectations",
    )
    assert_true(
        history_seqs[-1] == expectations["to_seq"] == marker_payload["to_seq"],
        f"{relative_path}: replayed segment end seq does not match expectations",
    )

    request_params = request["params"]
    if "from_seq" in request_params:
        assert_true(
            request_params["from_seq"] == expectations["from_seq"],
            f"{relative_path}: request from_seq must match expectations.from_seq",
        )
    if "from_event_id" in request_params:
        assert_true(
            expectations["anchor_event_id"] == request_params["from_event_id"],
            f"{relative_path}: anchor_event_id must match request.from_event_id",
        )
        assert_true(
            history_events[0]["id"] == expectations["first_replayed_event_id"],
            f"{relative_path}: first replayed event id does not match expectations",
        )
        assert_true(
            history_events[0]["id"] != expectations["anchor_event_id"],
            f"{relative_path}: replay after from_event_id must resume after the anchor event",
        )

    if "request_extension" in fixture:
        extension = fixture["request_extension"]
        assert_true(
            extension["kind"] == "opaque_cursor" and extension["token"],
            f"{relative_path}: opaque cursor fixtures must declare a non-empty opaque cursor token",
        )

    live_events = [
        event
        for event in stream[replay_index + 1 :]
        if event["type"] != "sync.cursor_advanced"
    ]
    assert_true(live_events, f"{relative_path}: replay success fixtures must continue into live events")

    live_seqs = [event.get("seq") for event in live_events if "seq" in event]
    assert_true(
        all(seq > expectations["to_seq"] for seq in live_seqs),
        f"{relative_path}: live event seq values must advance beyond replay to_seq",
    )

    if "expected_cursor" in expectations:
        cursor_events = [event for event in stream if event["type"] == "sync.cursor_advanced"]
        assert_true(
            cursor_events,
            f"{relative_path}: expected_cursor requires a sync.cursor_advanced event",
        )
        assert_true(
            cursor_events[-1]["payload"]["cursor"] == expectations["expected_cursor"],
            f"{relative_path}: final sync.cursor_advanced cursor does not match expectations",
        )


def validate_retention_fixture(relative_path, fixture, methods_schema, store):
    validate_instance(fixture["request"], methods_schema, "SessionsSubscribeRequest", store)
    validate_instance(
        fixture["error_response"], methods_schema, "SessionsSubscribeErrorResponse", store
    )

    assert_true(
        fixture["expected_outcome"] == "error",
        f"{relative_path}: retention fixture must currently model an error outcome",
    )
    error = fixture["error_response"]["error"]
    allowed = fixture["allowed_error_codes"]
    assert_true(
        error["code"] in allowed,
        f"{relative_path}: error code {error['code']} is not in the allowed replay fallback set",
    )
    details = error.get("details", {})
    assert_true(
        details.get("session_id") == fixture["request"]["params"]["session_id"],
        f"{relative_path}: retention fallback details must echo the session_id",
    )
    assert_true(
        "requested_from_seq" in details or "requested_from_event_id" in details,
        f"{relative_path}: retention fallback details must identify the rejected replay anchor",
    )


def main() -> int:
    ensure_required_paths()
    ensure_spec_content()
    _, _, methods_schema, events_schema, store = build_store()

    success_fixtures = [
        "conformance/fixtures/replay/subscribe-with-snapshot.json",
        "conformance/fixtures/replay/subscribe-from-seq.json",
        "conformance/fixtures/replay/subscribe-from-event-id.json",
        "conformance/fixtures/replay/subscribe-with-opaque-cursor.json",
    ]
    for relative_path in success_fixtures:
        validate_success_fixture(
            relative_path,
            load_fixture(relative_path),
            methods_schema,
            events_schema,
            store,
        )

    retention_fixture = "conformance/fixtures/replay/replay-retention-fallback.json"
    validate_retention_fixture(
        retention_fixture,
        load_fixture(retention_fixture),
        methods_schema,
        store,
    )

    print(f"Validated {len(success_fixtures) + 1} replay semantics fixtures.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
