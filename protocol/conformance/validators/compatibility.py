#!/usr/bin/env python3
import json
import subprocess
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

LEVEL_ORDER = [
    "ASCP Core Compatible",
    "ASCP Interactive",
    "ASCP Approval-Aware",
    "ASCP Artifact-Aware",
    "ASCP Replay-Capable",
]

CROSS_CUTTING_EVIDENCE = {
    "schema_and_contract_validation",
    "auth_failure_handling",
    "extension_ignore_behavior",
}

CORE_METHODS = {
    "capabilities.get",
    "hosts.get",
    "runtimes.list",
    "sessions.list",
    "sessions.get",
    "sessions.start",
    "sessions.resume",
    "sessions.stop",
    "sessions.send_input",
    "sessions.subscribe",
    "sessions.unsubscribe",
    "approvals.list",
    "approvals.respond",
    "artifacts.list",
    "artifacts.get",
    "diffs.get",
}


def read_text(relative_path: str) -> str:
    return (ROOT / relative_path).read_text()


def read_json(relative_path: str):
    return json.loads((ROOT / relative_path).read_text())


def assert_true(condition, message):
    if not condition:
        raise SystemExit(message)


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
    return {
        "core": core_schema,
        "capabilities": capabilities_schema,
        "errors": errors_schema,
        "methods": methods_schema,
        "events": events_schema,
        "store": store,
    }


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


def validate_root_schema(instance, schema_root, store, label):
    resolver = RefResolver.from_schema(schema_root, store=store)
    validator = Draft202012Validator(schema_root, resolver=resolver)
    errors = sorted(validator.iter_errors(instance), key=lambda err: err.json_path)
    if errors:
        lines = [f"Validation failed against {label}"]
        for error in errors:
            lines.append(f"- {error.json_path}: {error.message}")
        raise SystemExit("\n".join(lines))


def validate_by_schema_name(path: str, schema_name: str, schemas):
    instance = read_json(path)
    store = schemas["store"]

    if schema_name == "CapabilityDocument":
        validate_root_schema(instance, schemas["capabilities"], store, schema_name)
        return

    for schema_key in ("core", "methods", "events", "errors"):
        schema_root = schemas[schema_key]
        if schema_name in schema_root.get("$defs", {}):
            validate_instance(instance, schema_root, schema_name, store)
            return

    raise SystemExit(f"{path}: unknown schema name {schema_name}")


def collect_validator_scripts(matrix_doc):
    scripts = []
    for entry in matrix_doc["cross_cutting_evidence"]:
        scripts.extend(entry["validator_scripts"])
    for level in matrix_doc["levels"]:
        scripts.extend(level["validator_scripts"])
    return sorted(set(scripts))


def run_script(relative_path: str):
    script_path = ROOT / relative_path
    assert_true(script_path.exists(), f"Missing validator script: {relative_path}")
    result = subprocess.run(
        ["bash", str(script_path)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        message = [f"{relative_path} failed"]
        if result.stdout.strip():
            message.append(result.stdout.strip())
        if result.stderr.strip():
            message.append(result.stderr.strip())
        raise SystemExit("\n".join(message))
    return result.stdout.strip()
