#!/usr/bin/env python3
import json
import re
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
    Path("spec/extensions.md"),
    Path("examples/capabilities/capabilities-with-extensions.json"),
    Path("examples/extensions/method-request.json"),
    Path("examples/extensions/method-response.json"),
    Path("examples/extensions/event-envelope.json"),
    Path("examples/extensions/session-field-extension.json"),
    Path("conformance/fixtures/extensions/extension-catalog.json"),
    Path("conformance/fixtures/extensions/ignore-behavior.json"),
]

REQUIRED_SPEC_SNIPPETS = [
    "Allowed Extension Surfaces",
    "Namespacing Rules",
    "Capability Advertisement",
    "Unknown Extension Behavior",
    "Closed Core Schemas",
    "x.vendor.method_name",
    "x.vendor.event_name",
    "x_vendor_feature",
    "MUST NOT redefine core field meanings",
]

EXPECTED_SURFACE_KINDS = {
    "capability_document",
    "namespaced_method_request",
    "namespaced_method_response",
    "namespaced_event",
    "open_surface_field_extension",
}

EXPECTED_IGNORE_CASES = {
    "unknown_extension_field_on_open_core_object",
    "unknown_extension_event_type",
    "unknown_extension_capability_flag",
    "closed_core_method_params_require_namespaced_method",
    "closed_core_event_payload_requires_namespaced_event",
}

METHOD_PATTERN = re.compile(r"^x\.[a-z0-9]+(?:\.[a-z0-9_]+)+$")
EVENT_PATTERN = re.compile(r"^x\.[a-z0-9]+(?:\.[a-z0-9_]+)+$")
FIELD_PATTERN = re.compile(r"^x_[a-z0-9]+(?:_[a-z0-9]+)+$")
EXTENSION_FAMILY_PATTERN = re.compile(r"^x\.[a-z0-9]+(?:\.[a-z0-9_]+)*$")
CAPABILITY_FLAG_PATTERN = re.compile(r"^x_[a-z0-9]+(?:_[a-z0-9]+)+$")


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
        raise SystemExit("Missing extension semantics assets:\n- " + "\n- ".join(missing))


def ensure_spec_content():
    extension_doc = read_text("spec/extensions.md")
    missing = [snippet for snippet in REQUIRED_SPEC_SNIPPETS if snippet not in extension_doc]
    if missing:
        raise SystemExit(
            "spec/extensions.md is missing required extension sections:\n- "
            + "\n- ".join(missing)
        )


def build_store():
    core_schema = read_json("schema/ascp-core.schema.json")
    capabilities_schema = read_json("schema/ascp-capabilities.schema.json")
    methods_schema = read_json("schema/ascp-methods.schema.json")

    store = {
        core_schema["$id"]: core_schema,
        capabilities_schema["$id"]: capabilities_schema,
        methods_schema["$id"]: methods_schema,
        "ascp-core.schema.json": core_schema,
        "ascp-capabilities.schema.json": capabilities_schema,
        "ascp-methods.schema.json": methods_schema,
    }
    return core_schema, capabilities_schema, methods_schema, store


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


def ensure_pattern(value, pattern, label):
    assert_true(bool(pattern.match(value)), f"{label} must match {pattern.pattern}: {value}")


def validate_extension_catalog():
    fixture = read_json("conformance/fixtures/extensions/extension-catalog.json")
    namespacing = fixture["namespacing"]
    surfaces = fixture["surfaces"]

    assert_true(
        set(item["kind"] for item in surfaces) == EXPECTED_SURFACE_KINDS,
        "extension-catalog.json must cover capability, method, event, and field extension surfaces",
    )
    assert_true(
        namespacing["method_prefix"] == "x.",
        "extension-catalog.json must document x. as the method prefix",
    )
    assert_true(
        namespacing["event_prefix"] == "x.",
        "extension-catalog.json must document x. as the event prefix",
    )
    assert_true(
        namespacing["field_prefix"] == "x_",
        "extension-catalog.json must document x_ as the field prefix",
    )
    assert_true(
        namespacing["capability_flag_prefix"] == "x_",
        "extension-catalog.json must document x_ as the capability-flag prefix",
    )
    assert_true(
        namespacing["extension_family_prefix"] == "x.",
        "extension-catalog.json must document x. as the extension family prefix",
    )


def validate_capability_example(capabilities_schema, store):
    doc = read_json("examples/capabilities/capabilities-with-extensions.json")
    validate_root_schema(doc, capabilities_schema, store, "CapabilityDocument")

    capability_flags = [
        name for name in doc["capabilities"] if name.startswith("x_")
    ]
    assert_true(
        capability_flags,
        "capabilities-with-extensions.json must include at least one namespaced capability flag",
    )
    for flag in capability_flags:
        ensure_pattern(flag, CAPABILITY_FLAG_PATTERN, "Capability flag")

    extensions = doc["extensions"]
    assert_true(
        extensions,
        "capabilities-with-extensions.json must advertise at least one active extension family",
    )
    for extension_name in extensions:
        ensure_pattern(extension_name, EXTENSION_FAMILY_PATTERN, "Extension family")


def validate_method_examples(core_schema, store):
    request = read_json("examples/extensions/method-request.json")
    response = read_json("examples/extensions/method-response.json")

    validate_instance(request, core_schema, "RequestEnvelope", store)
    validate_instance(response, core_schema, "SuccessResponseEnvelope", store)

    ensure_pattern(request["method"], METHOD_PATTERN, "Extension method name")
    assert_true(
        response["id"] == request["id"],
        "Extension method response id must match the request id",
    )


def validate_event_and_field_examples(core_schema, store):
    event_doc = read_json("examples/extensions/event-envelope.json")
    validate_instance(event_doc, core_schema, "EventEnvelope", store)
    ensure_pattern(event_doc["type"], EVENT_PATTERN, "Extension event type")

    session_doc = read_json("examples/extensions/session-field-extension.json")
    validate_instance(session_doc, core_schema, "Session", store)
    added_fields = [field for field in session_doc if field.startswith("x_")]
    assert_true(
        added_fields,
        "session-field-extension.json must include at least one additive namespaced field",
    )
    for field_name in added_fields:
        ensure_pattern(field_name, FIELD_PATTERN, "Extension field name")


def validate_ignore_behavior(methods_schema):
    fixture = read_json("conformance/fixtures/extensions/ignore-behavior.json")
    cases = {item["case"]: item for item in fixture["cases"]}

    assert_true(
        set(cases) == EXPECTED_IGNORE_CASES,
        "ignore-behavior.json must cover field, event, capability, and closed-schema behavior",
    )

    for name in (
        "unknown_extension_field_on_open_core_object",
        "unknown_extension_event_type",
        "unknown_extension_capability_flag",
    ):
        assert_true(
            cases[name]["behavior"] == "ignore",
            f"{name} must default to ignore behavior",
        )

    method_case = cases["closed_core_method_params_require_namespaced_method"]
    assert_true(
        method_case["behavior"] == "reject_inline_extension_fields",
        "Closed core method params must reject inline extension fields",
    )
    ensure_pattern(
        method_case["alternative_method"],
        METHOD_PATTERN,
        "Alternative extension method",
    )

    event_case = cases["closed_core_event_payload_requires_namespaced_event"]
    assert_true(
        event_case["behavior"] == "use_namespaced_event",
        "Closed core event payloads must use a namespaced event instead of inline extra fields",
    )
    ensure_pattern(
        event_case["alternative_event_type"],
        EVENT_PATTERN,
        "Alternative extension event type",
    )

    closed_params = methods_schema["$defs"]["SessionsStartParams"]
    assert_true(
        closed_params.get("additionalProperties") is False,
        "SessionsStartParams must remain closed while validating extension rules",
    )


def main():
    ensure_required_paths()
    ensure_spec_content()
    core_schema, capabilities_schema, methods_schema, store = build_store()
    validate_extension_catalog()
    validate_capability_example(capabilities_schema, store)
    validate_method_examples(core_schema, store)
    validate_event_and_field_examples(core_schema, store)
    validate_ignore_behavior(methods_schema)

    catalog = read_json("conformance/fixtures/extensions/extension-catalog.json")
    ignore_behavior = read_json("conformance/fixtures/extensions/ignore-behavior.json")
    print(
        "Validated extension semantics: "
        f"{len(catalog['surfaces'])} extension surfaces and "
        f"{len(ignore_behavior['cases'])} ignore-behavior rules."
    )


if __name__ == "__main__":
    main()
