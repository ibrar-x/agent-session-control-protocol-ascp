#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 <<'PY'
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


core_schema = read_json("schema/ascp-core.schema.json")
capabilities_schema = read_json("schema/ascp-capabilities.schema.json")
errors_schema = read_json("schema/ascp-errors.schema.json")
methods_schema = read_json("schema/ascp-methods.schema.json")

store = {
    core_schema["$id"]: core_schema,
    capabilities_schema["$id"]: capabilities_schema,
    errors_schema["$id"]: errors_schema,
    methods_schema["$id"]: methods_schema,
    "ascp-core.schema.json": core_schema,
    "ascp-capabilities.schema.json": capabilities_schema,
    "ascp-errors.schema.json": errors_schema,
    "ascp-methods.schema.json": methods_schema,
}

resolver = RefResolver.from_schema(methods_schema, store=store)

methods = [
    ("capabilities-get", "CapabilitiesGet"),
    ("hosts-get", "HostsGet"),
    ("runtimes-list", "RuntimesList"),
    ("sessions-list", "SessionsList"),
    ("sessions-get", "SessionsGet"),
    ("sessions-start", "SessionsStart"),
    ("sessions-resume", "SessionsResume"),
    ("sessions-stop", "SessionsStop"),
    ("sessions-send-input", "SessionsSendInput"),
    ("sessions-subscribe", "SessionsSubscribe"),
    ("sessions-unsubscribe", "SessionsUnsubscribe"),
    ("approvals-list", "ApprovalsList"),
    ("approvals-respond", "ApprovalsRespond"),
    ("artifacts-list", "ArtifactsList"),
    ("artifacts-get", "ArtifactsGet"),
    ("diffs-get", "DiffsGet"),
]


def inline_local_refs(node):
    if isinstance(node, dict):
        if set(node.keys()) == {"$ref"} and node["$ref"].startswith("#/$defs/"):
            target_name = node["$ref"].split("/")[-1]
            return inline_local_refs(methods_schema["$defs"][target_name])
        return {key: inline_local_refs(value) for key, value in node.items()}
    if isinstance(node, list):
        return [inline_local_refs(item) for item in node]
    return node


def validate(def_name: str, relative_path: str):
    instance = read_json(relative_path)
    schema = inline_local_refs(methods_schema["$defs"][def_name])
    validator = Draft202012Validator(schema, resolver=resolver)
    errors = sorted(validator.iter_errors(instance), key=lambda err: err.json_path)
    if errors:
        lines = [f"{relative_path} failed validation against {def_name}"]
        for error in errors:
            lines.append(f"- {error.json_path}: {error.message}")
        raise SystemExit("\n".join(lines))


for file_base, def_base in methods:
    validate(
        f"{def_base}Request",
        f"examples/requests/{file_base}.json",
    )
    validate(
        f"{def_base}SuccessResponse",
        f"examples/responses/{file_base}.json",
    )
    validate(
        f"{def_base}ErrorResponse",
        f"examples/errors/{file_base}.json",
    )

print(f"Validated {len(methods) * 3} method-contract example files.")
PY
