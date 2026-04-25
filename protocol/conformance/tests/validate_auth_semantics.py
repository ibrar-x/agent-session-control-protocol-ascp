#!/usr/bin/env python3
import json
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
    Path("spec/auth.md"),
    Path("examples/approvals/approval-request-command.json"),
    Path("examples/approvals/approval-flow-approved.json"),
    Path("examples/approvals/approval-flow-rejected.json"),
    Path("examples/approvals/approval-flow-expired.json"),
    Path("examples/errors/sessions-start-unauthorized.json"),
    Path("examples/errors/sessions-start-forbidden.json"),
    Path("examples/errors/sessions-list-unauthorized.json"),
    Path("examples/errors/approvals-respond-unauthorized.json"),
    Path("examples/errors/approvals-respond-forbidden.json"),
    Path("examples/errors/artifacts-get-unauthorized.json"),
    Path("conformance/fixtures/auth/auth-scope-matrix.json"),
    Path("conformance/fixtures/auth/approval-lifecycle.json"),
]

REQUIRED_SPEC_SNIPPETS = [
    "Method Scope Matrix",
    "UNAUTHORIZED",
    "FORBIDDEN",
    "actor_id",
    "device_id",
    "correlation_id",
    "sessions.start",
    "approvals.respond",
    "artifacts.get",
    "diffs.get",
    "ASCP Approval-Aware",
]

EXPECTED_METHOD_SCOPES = {
    "capabilities.get": ("read", ["read:capabilities"], False),
    "hosts.get": ("read", ["read:hosts"], False),
    "runtimes.list": ("read", ["read:runtimes"], False),
    "sessions.list": ("read", ["read:sessions"], False),
    "sessions.get": ("read", ["read:sessions"], False),
    "sessions.subscribe": ("read", ["read:sessions"], False),
    "sessions.unsubscribe": ("read", ["read:sessions"], False),
    "sessions.start": ("control", ["write:sessions"], True),
    "sessions.resume": ("control", ["write:sessions"], True),
    "sessions.stop": ("control", ["write:sessions"], True),
    "sessions.send_input": ("control", ["write:sessions"], True),
    "approvals.list": ("read", ["read:approvals"], False),
    "approvals.respond": ("control", ["write:approvals"], True),
    "artifacts.list": ("read", ["read:artifacts"], False),
    "artifacts.get": ("read", ["read:artifacts"], False),
    "diffs.get": ("read", ["read:artifacts"], False),
}

EVENT_TYPE_TO_DEF = {
    "approval.updated": "ApprovalUpdatedEvent",
    "approval.approved": "ApprovalApprovedEvent",
    "approval.rejected": "ApprovalRejectedEvent",
    "approval.expired": "ApprovalExpiredEvent",
}


def read_text(relative_path: str) -> str:
    return (ROOT / relative_path).read_text()


def read_json(relative_path: str):
    return json.loads((ROOT / relative_path).read_text())


def assert_true(condition, message):
    if not condition:
        raise SystemExit(message)


def ensure_required_paths():
    missing = [str(path) for path in REQUIRED_PATHS if not (ROOT / path).exists()]
    if missing:
        raise SystemExit("Missing auth semantics assets:\n- " + "\n- ".join(missing))


def ensure_spec_content():
    auth_doc = read_text("spec/auth.md")
    missing = [snippet for snippet in REQUIRED_SPEC_SNIPPETS if snippet not in auth_doc]
    if missing:
        raise SystemExit(
            "spec/auth.md is missing required auth sections:\n- " + "\n- ".join(missing)
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
    return core_schema, methods_schema, events_schema, store


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


def validate_scope_matrix():
    fixture = read_json("conformance/fixtures/auth/auth-scope-matrix.json")
    scopes = fixture["scopes"]
    methods = {entry["method"]: entry for entry in fixture["methods"]}

    assert_true(
        set(methods) == set(EXPECTED_METHOD_SCOPES),
        "Auth scope matrix must cover the full frozen core method surface",
    )
    assert_true("admin:host" in scopes, "Auth scope matrix must document admin:host")

    for method, (access, recommended_scopes, sensitive) in EXPECTED_METHOD_SCOPES.items():
        entry = methods[method]
        assert_true(
            entry["access"] == access,
            f"{method}: expected access {access}, found {entry['access']}",
        )
        assert_true(
            entry["recommended_scopes"] == recommended_scopes,
            f"{method}: expected scopes {recommended_scopes}, found {entry['recommended_scopes']}",
        )
        assert_true(
            entry["sensitive"] is sensitive,
            f"{method}: expected sensitive={sensitive}",
        )


def validate_error_example(
    relative_path,
    methods_schema,
    store,
    def_name,
    expected_code,
    expected_method,
    expected_scope=None,
):
    doc = read_json(relative_path)
    validate_instance(doc, methods_schema, def_name, store)
    error = doc["error"]
    details = error.get("details") or {}
    assert_true(
        error["code"] == expected_code,
        f"{relative_path}: expected error code {expected_code}",
    )
    assert_true(
        error["retryable"] is False,
        f"{relative_path}: auth examples should not be retryable",
    )
    assert_true(
        details.get("method") == expected_method,
        f"{relative_path}: details.method must be {expected_method}",
    )
    if expected_code == "FORBIDDEN":
        assert_true(
            details.get("required_scope") == expected_scope,
            f"{relative_path}: FORBIDDEN examples must carry required_scope={expected_scope}",
        )
    if expected_code == "UNAUTHORIZED":
        assert_true(
            "required_scope" not in details,
            f"{relative_path}: UNAUTHORIZED examples must not claim missing scope",
        )


def validate_event(event, events_schema, store, relative_path):
    event_type = event["type"]
    assert_true(
        event_type in EVENT_TYPE_TO_DEF,
        f"{relative_path}: unsupported approval lifecycle event type {event_type}",
    )
    try:
        validate_instance(event, events_schema, EVENT_TYPE_TO_DEF[event_type], store)
    except SystemExit as exc:
        raise SystemExit(f"{relative_path}: {exc}") from exc


def validate_approval_examples(core_schema, methods_schema, events_schema, store):
    approval_request = read_json("examples/approvals/approval-request-command.json")
    validate_instance(approval_request, core_schema, "ApprovalRequest", store)
    assert_true(
        approval_request["status"] == "pending",
        "approval-request-command example must remain pending",
    )
    assert_true(
        approval_request["kind"] == "command",
        "approval-request-command example must remain a command approval",
    )

    lifecycle = read_json("conformance/fixtures/auth/approval-lifecycle.json")
    for flow in lifecycle["flows"]:
        fixture_path = flow["fixture"]
        doc = read_json(fixture_path)

        validate_instance(doc["approval"], core_schema, "ApprovalRequest", store)
        assert_true(
            doc["approval"]["status"] == "pending",
            f"{fixture_path}: lifecycle fixtures must start from pending",
        )
        assert_true(
            doc["expected_scope"] == "write:approvals",
            f"{fixture_path}: approval lifecycle fixtures must require write:approvals",
        )

        audit_context = doc["audit_context"]
        for field in flow["required_audit_fields"]:
            assert_true(
                field in audit_context and audit_context[field],
                f"{fixture_path}: missing required audit field {field}",
            )

        events = doc["events"]
        assert_true(
            len(events) == 2,
            f"{fixture_path}: approval lifecycle fixtures must contain approval.updated and one terminal event",
        )
        for event in events:
            validate_event(event, events_schema, store, fixture_path)

        updated_event, terminal_event = events
        assert_true(
            updated_event["type"] == "approval.updated",
            f"{fixture_path}: first event must be approval.updated",
        )
        assert_true(
            "status" in updated_event["payload"]["changed_fields"],
            f"{fixture_path}: approval.updated must include status in changed_fields",
        )
        assert_true(
            terminal_event["type"] == flow["terminal_event"],
            f"{fixture_path}: terminal event must be {flow['terminal_event']}",
        )
        assert_true(
            updated_event["payload"]["approval_id"] == doc["approval"]["id"],
            f"{fixture_path}: approval.updated must target the fixture approval id",
        )
        assert_true(
            terminal_event["payload"]["approval_id"] == doc["approval"]["id"],
            f"{fixture_path}: terminal event must target the fixture approval id",
        )
        assert_true(
            updated_event["seq"] < terminal_event["seq"],
            f"{fixture_path}: approval.updated must precede the terminal event in seq order",
        )

        if flow["decision"] is None:
            assert_true(
                "request" not in doc and "response" not in doc,
                f"{fixture_path}: non-user terminal flows must not include approvals.respond request/response",
            )
            assert_true(
                "actor_id" not in terminal_event["payload"],
                f"{fixture_path}: expired approvals must not invent actor_id",
            )
        else:
            validate_instance(doc["request"], methods_schema, "ApprovalsRespondRequest", store)
            validate_instance(
                doc["response"], methods_schema, "ApprovalsRespondSuccessResponse", store
            )
            assert_true(
                doc["request"]["params"]["approval_id"] == doc["approval"]["id"],
                f"{fixture_path}: request approval_id must match the approval object",
            )
            assert_true(
                doc["request"]["params"]["decision"] == flow["decision"],
                f"{fixture_path}: request decision must match the lifecycle fixture",
            )
            assert_true(
                doc["response"]["result"]["approval_id"] == doc["approval"]["id"],
                f"{fixture_path}: response approval_id must match the approval object",
            )
            assert_true(
                doc["response"]["result"]["status"] == flow["terminal_status"],
                f"{fixture_path}: response status must match the lifecycle fixture",
            )
            if flow["requires_actor_id"]:
                assert_true(
                    terminal_event["payload"]["actor_id"] == audit_context["actor_id"],
                    f"{fixture_path}: terminal actor_id must match audit_context.actor_id",
                )
            if flow["requires_note"]:
                assert_true(
                    doc["request"]["params"]["note"] == terminal_event["payload"]["note"],
                    f"{fixture_path}: rejection note must match between request and event",
                )
            else:
                assert_true(
                    "note" not in terminal_event["payload"],
                    f"{fixture_path}: terminal event must not carry note for this flow",
                )

    conflict = lifecycle["conflict_example"]
    conflict_doc = read_json(conflict["file"])
    validate_instance(conflict_doc, methods_schema, "ApprovalsRespondErrorResponse", store)
    details = conflict_doc["error"]["details"]
    assert_true(
        conflict_doc["error"]["code"] == conflict["error_code"],
        "Approval conflict example must use CONFLICT",
    )
    assert_true(
        details.get("method") == conflict["method"],
        "Approval conflict example must identify approvals.respond in details.method",
    )
    assert_true(
        details.get("status") in conflict["allowed_terminal_statuses"],
        "Approval conflict example must identify a terminal approval status",
    )


def main():
    ensure_required_paths()
    ensure_spec_content()
    core_schema, methods_schema, events_schema, store = build_store()
    validate_scope_matrix()
    validate_approval_examples(core_schema, methods_schema, events_schema, store)

    validate_error_example(
        "examples/errors/sessions-start-unauthorized.json",
        methods_schema,
        store,
        "SessionsStartErrorResponse",
        "UNAUTHORIZED",
        "sessions.start",
    )
    validate_error_example(
        "examples/errors/sessions-start-forbidden.json",
        methods_schema,
        store,
        "SessionsStartErrorResponse",
        "FORBIDDEN",
        "sessions.start",
        "write:sessions",
    )
    validate_error_example(
        "examples/errors/sessions-list-unauthorized.json",
        methods_schema,
        store,
        "SessionsListErrorResponse",
        "UNAUTHORIZED",
        "sessions.list",
    )
    validate_error_example(
        "examples/errors/sessions-list.json",
        methods_schema,
        store,
        "SessionsListErrorResponse",
        "FORBIDDEN",
        "sessions.list",
        "read:sessions",
    )
    validate_error_example(
        "examples/errors/approvals-respond-unauthorized.json",
        methods_schema,
        store,
        "ApprovalsRespondErrorResponse",
        "UNAUTHORIZED",
        "approvals.respond",
    )
    validate_error_example(
        "examples/errors/approvals-respond-forbidden.json",
        methods_schema,
        store,
        "ApprovalsRespondErrorResponse",
        "FORBIDDEN",
        "approvals.respond",
        "write:approvals",
    )
    validate_error_example(
        "examples/errors/artifacts-get-unauthorized.json",
        methods_schema,
        store,
        "ArtifactsGetErrorResponse",
        "UNAUTHORIZED",
        "artifacts.get",
    )
    validate_error_example(
        "examples/errors/artifacts-get.json",
        methods_schema,
        store,
        "ArtifactsGetErrorResponse",
        "FORBIDDEN",
        "artifacts.get",
        "read:artifacts",
    )

    print(
        "Validated auth semantics: 3 approval lifecycle fixtures, "
        "1 scope matrix, and 8 auth/error examples."
    )


if __name__ == "__main__":
    main()
