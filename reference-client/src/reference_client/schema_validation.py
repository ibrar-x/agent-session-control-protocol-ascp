import json
from pathlib import Path

from jsonschema import Draft202012Validator, RefResolver


METHOD_RESPONSE_SCHEMAS = {
    "capabilities.get": "CapabilitiesGetSuccessResponse",
    "runtimes.list": "RuntimesListSuccessResponse",
    "sessions.list": "SessionsListSuccessResponse",
    "sessions.get": "SessionsGetSuccessResponse",
    "sessions.send_input": "SessionsSendInputSuccessResponse",
    "sessions.subscribe": "SessionsSubscribeSuccessResponse",
    "approvals.list": "ApprovalsListSuccessResponse",
    "artifacts.list": "ArtifactsListSuccessResponse",
    "artifacts.get": "ArtifactsGetSuccessResponse",
    "diffs.get": "DiffsGetSuccessResponse",
}

EVENT_TYPE_SCHEMAS = {
    "message.user": "MessageUserEvent",
    "message.assistant.started": "MessageAssistantStartedEvent",
    "message.assistant.completed": "MessageAssistantCompletedEvent",
    "message.assistant.delta": "MessageAssistantDeltaEvent",
    "artifact.created": "ArtifactCreatedEvent",
    "diff.ready": "DiffReadyEvent",
    "sync.snapshot": "SyncSnapshotEvent",
    "sync.replayed": "SyncReplayedEvent",
    "sync.cursor_advanced": "SyncCursorAdvancedEvent",
}


def _read_json(path: Path):
    return json.loads(path.read_text())


def _inline_local_refs(schema_root, node):
    if isinstance(node, dict):
        if set(node.keys()) == {"$ref"} and node["$ref"].startswith("#/$defs/"):
            target_name = node["$ref"].split("/")[-1]
            return _inline_local_refs(schema_root, schema_root["$defs"][target_name])
        return {key: _inline_local_refs(schema_root, value) for key, value in node.items()}
    if isinstance(node, list):
        return [_inline_local_refs(schema_root, item) for item in node]
    return node


class SchemaValidator:
    def __init__(self, root):
        self.root = Path(root)
        schema_root = self.root / "schema"
        self.core_schema = _read_json(schema_root / "ascp-core.schema.json")
        self.capabilities_schema = _read_json(schema_root / "ascp-capabilities.schema.json")
        self.errors_schema = _read_json(schema_root / "ascp-errors.schema.json")
        self.methods_schema = _read_json(schema_root / "ascp-methods.schema.json")
        self.events_schema = _read_json(schema_root / "ascp-events.schema.json")
        self.store = {
            self.core_schema["$id"]: self.core_schema,
            self.capabilities_schema["$id"]: self.capabilities_schema,
            self.errors_schema["$id"]: self.errors_schema,
            self.methods_schema["$id"]: self.methods_schema,
            self.events_schema["$id"]: self.events_schema,
            "ascp-core.schema.json": self.core_schema,
            "ascp-capabilities.schema.json": self.capabilities_schema,
            "ascp-errors.schema.json": self.errors_schema,
            "ascp-methods.schema.json": self.methods_schema,
            "ascp-events.schema.json": self.events_schema,
        }

    def _validate_def(self, instance, schema_root, def_name, label):
        resolver = RefResolver.from_schema(schema_root, store=self.store)
        schema = _inline_local_refs(schema_root, schema_root["$defs"][def_name])
        validator = Draft202012Validator(schema, resolver=resolver)
        errors = sorted(validator.iter_errors(instance), key=lambda err: err.json_path)
        if errors:
            lines = [f"Validation failed for {label}"]
            for error in errors:
                lines.append(f"- {error.json_path}: {error.message}")
            raise AssertionError("\n".join(lines))

    def validate_method_response(self, method_name, response):
        def_name = METHOD_RESPONSE_SCHEMAS.get(method_name)
        if def_name is None:
            raise AssertionError(f"No method-response schema configured for {method_name}")
        self._validate_def(response, self.methods_schema, def_name, method_name)

    def validate_event(self, event):
        def_name = EVENT_TYPE_SCHEMAS.get(event["type"])
        if def_name is None:
            self._validate_def(event, self.core_schema, "EventEnvelope", event["type"])
            return
        self._validate_def(event, self.events_schema, def_name, event["type"])
