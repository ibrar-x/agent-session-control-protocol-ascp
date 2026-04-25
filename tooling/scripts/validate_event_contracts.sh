#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

/usr/bin/python3 <<'PY'
import json
from pathlib import Path
import warnings

warnings.filterwarnings("ignore", category=DeprecationWarning)

try:
    from jsonschema import Draft202012Validator, RefResolver
except ModuleNotFoundError as exc:
    raise SystemExit(
        "Missing dependency: jsonschema. Install it with "
        "`python3 -m pip install --user jsonschema`."
    ) from exc

root = Path.cwd()


def read_json(relative_path: str):
    return json.loads((root / relative_path).read_text())


core_schema = read_json("protocol/schema/ascp-core.schema.json")
capabilities_schema = read_json("protocol/schema/ascp-capabilities.schema.json")
errors_schema = read_json("protocol/schema/ascp-errors.schema.json")
methods_schema = read_json("protocol/schema/ascp-methods.schema.json")
events_schema = read_json("protocol/schema/ascp-events.schema.json")

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

resolver = RefResolver.from_schema(events_schema, store=store)

events = [
    ("session-created", "SessionCreatedEvent"),
    ("session-updated", "SessionUpdatedEvent"),
    ("session-status-changed", "SessionStatusChangedEvent"),
    ("session-deleted", "SessionDeletedEvent"),
    ("run-started", "RunStartedEvent"),
    ("run-paused", "RunPausedEvent"),
    ("run-resumed", "RunResumedEvent"),
    ("run-completed", "RunCompletedEvent"),
    ("run-failed", "RunFailedEvent"),
    ("run-cancelled", "RunCancelledEvent"),
    ("message-user", "MessageUserEvent"),
    ("message-assistant-started", "MessageAssistantStartedEvent"),
    ("message-assistant-delta", "MessageAssistantDeltaEvent"),
    ("message-assistant-completed", "MessageAssistantCompletedEvent"),
    ("message-system", "MessageSystemEvent"),
    ("tool-started", "ToolStartedEvent"),
    ("tool-stdout", "ToolStdoutEvent"),
    ("tool-stderr", "ToolStderrEvent"),
    ("tool-completed", "ToolCompletedEvent"),
    ("tool-failed", "ToolFailedEvent"),
    ("terminal-opened", "TerminalOpenedEvent"),
    ("terminal-output", "TerminalOutputEvent"),
    ("terminal-closed", "TerminalClosedEvent"),
    ("terminal-resize-requested", "TerminalResizeRequestedEvent"),
    ("approval-requested", "ApprovalRequestedEvent"),
    ("approval-updated", "ApprovalUpdatedEvent"),
    ("approval-approved", "ApprovalApprovedEvent"),
    ("approval-rejected", "ApprovalRejectedEvent"),
    ("approval-expired", "ApprovalExpiredEvent"),
    ("artifact-created", "ArtifactCreatedEvent"),
    ("artifact-updated", "ArtifactUpdatedEvent"),
    ("diff-ready", "DiffReadyEvent"),
    ("diff-updated", "DiffUpdatedEvent"),
    ("connection-state-changed", "ConnectionStateChangedEvent"),
    ("sync-snapshot", "SyncSnapshotEvent"),
    ("sync-replayed", "SyncReplayedEvent"),
    ("sync-cursor-advanced", "SyncCursorAdvancedEvent"),
    ("error-transient", "ErrorTransientEvent"),
    ("error-fatal", "ErrorFatalEvent"),
]


def inline_local_refs(node):
    if isinstance(node, dict):
        if set(node.keys()) == {"$ref"} and node["$ref"].startswith("#/$defs/"):
            target_name = node["$ref"].split("/")[-1]
            return inline_local_refs(events_schema["$defs"][target_name])
        return {key: inline_local_refs(value) for key, value in node.items()}
    if isinstance(node, list):
        return [inline_local_refs(item) for item in node]
    return node


def validate(def_name: str, relative_path: str):
    instance = read_json(relative_path)
    schema = inline_local_refs(events_schema["$defs"][def_name])
    validator = Draft202012Validator(schema, resolver=resolver)
    errors = sorted(validator.iter_errors(instance), key=lambda err: err.json_path)
    if errors:
        lines = [f"{relative_path} failed validation against {def_name}"]
        for error in errors:
            lines.append(f"- {error.json_path}: {error.message}")
        raise SystemExit("\n".join(lines))


for file_base, def_name in events:
    validate(def_name, f"protocol/examples/events/{file_base}.json")

print(f"Validated {len(events)} event-contract example files.")
PY
