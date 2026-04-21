#!/usr/bin/env python3
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from conformance.validators.compatibility import (  # noqa: E402
    CORE_METHODS,
    CROSS_CUTTING_EVIDENCE,
    LEVEL_ORDER,
    assert_true,
    build_store,
    collect_validator_scripts,
    read_json,
    read_text,
    run_script,
    validate_by_schema_name,
)


REQUIRED_PATHS = [
    Path("spec/compatibility.md"),
    Path("conformance/fixtures/compatibility/compatibility-matrix.json"),
    Path("conformance/fixtures/compatibility/golden-examples.json"),
    Path("conformance/validators/compatibility.py"),
    Path("scripts/validate_conformance.sh"),
]

REQUIRED_SPEC_SNIPPETS = [
    "ASCP Core Compatible",
    "ASCP Interactive",
    "ASCP Approval-Aware",
    "ASCP Artifact-Aware",
    "ASCP Replay-Capable",
    "Cross-Cutting Evidence",
    "auth failure handling",
    "extension ignore behavior",
    "Compatibility levels are cumulative",
]

EXPECTED_SCENARIOS = {
    "core-discovery-and-session-read",
    "interactive-session-control",
    "approval-resolution",
    "artifact-access",
    "replay-recovery",
    "auth-failure-classification",
    "extension-ignore-safe",
}

EXPECTED_LEVEL_SCENARIOS = {
    "ASCP Core Compatible": {"core-discovery-and-session-read"},
    "ASCP Interactive": {"interactive-session-control"},
    "ASCP Approval-Aware": {"approval-resolution"},
    "ASCP Artifact-Aware": {"artifact-access"},
    "ASCP Replay-Capable": {"replay-recovery"},
}

EXPECTED_CROSS_CUTTING_SCENARIOS = {
    "schema_and_contract_validation": {
        "core-discovery-and-session-read",
        "interactive-session-control",
    },
    "auth_failure_handling": {"auth-failure-classification"},
    "extension_ignore_behavior": {"extension-ignore-safe"},
}


def ensure_required_paths():
    missing = [str(path) for path in REQUIRED_PATHS if not (ROOT / path).exists()]
    if missing:
        raise SystemExit("Missing conformance assets:\n- " + "\n- ".join(missing))


def ensure_spec_content():
    compatibility_doc = read_text("spec/compatibility.md")
    missing = [snippet for snippet in REQUIRED_SPEC_SNIPPETS if snippet not in compatibility_doc]
    if missing:
        raise SystemExit(
            "spec/compatibility.md is missing required conformance sections:\n- "
            + "\n- ".join(missing)
        )


def validate_matrix(matrix_doc, scenario_ids):
    assert_true(
        matrix_doc["protocol_version"] == "0.1.0",
        "compatibility-matrix.json must target protocol_version 0.1.0",
    )
    assert_true(
        matrix_doc["cumulative"] is True,
        "compatibility-matrix.json must declare cumulative compatibility levels",
    )

    cross_cutting = {
        entry["name"]: entry for entry in matrix_doc["cross_cutting_evidence"]
    }
    assert_true(
        set(cross_cutting) == CROSS_CUTTING_EVIDENCE,
        "compatibility-matrix.json must cover the expected cross-cutting evidence set",
    )

    for name, entry in cross_cutting.items():
        assert_true(
            set(entry["scenario_ids"]) == EXPECTED_CROSS_CUTTING_SCENARIOS[name],
            f"{name}: unexpected scenario coverage",
        )
        for scenario_id in entry["scenario_ids"]:
            assert_true(
                scenario_id in scenario_ids,
                f"{name}: unknown scenario id {scenario_id}",
            )
        for script in entry["validator_scripts"]:
            assert_true((ROOT / script).exists(), f"{name}: missing validator script {script}")

    levels = matrix_doc["levels"]
    level_names = [level["level"] for level in levels]
    assert_true(
        level_names == LEVEL_ORDER,
        "compatibility-matrix.json must preserve the ASCP compatibility level order",
    )

    for index, level in enumerate(levels):
        name = level["level"]
        expected_inherits = [] if index == 0 else [LEVEL_ORDER[index - 1]]
        assert_true(
            level["inherits"] == expected_inherits,
            f"{name}: unexpected inherits chain",
        )
        assert_true(
            set(level["scenario_ids"]) == EXPECTED_LEVEL_SCENARIOS[name],
            f"{name}: unexpected scenario coverage",
        )
        for scenario_id in level["scenario_ids"]:
            assert_true(
                scenario_id in scenario_ids,
                f"{name}: unknown scenario id {scenario_id}",
            )

        for method_name in level.get("required_methods", []):
            assert_true(
                method_name in CORE_METHODS,
                f"{name}: unknown method {method_name}",
            )

        for group in level.get("required_method_one_of", []):
            assert_true(group, f"{name}: required_method_one_of groups must not be empty")
            for method_name in group:
                assert_true(
                    method_name in CORE_METHODS,
                    f"{name}: unknown method {method_name} in required_method_one_of",
                )

        for script in level["validator_scripts"]:
            assert_true((ROOT / script).exists(), f"{name}: missing validator script {script}")


def validate_golden_examples(golden_doc, schemas):
    scenarios = golden_doc["scenarios"]
    scenario_ids = [scenario["id"] for scenario in scenarios]
    assert_true(
        set(scenario_ids) == EXPECTED_SCENARIOS,
        "golden-examples.json must cover the full expected scenario set",
    )
    assert_true(
        len(set(scenario_ids)) == len(scenario_ids),
        "golden-examples.json must not repeat scenario ids",
    )

    validated_files = 0
    for scenario in scenarios:
        has_evidence = False
        for key in ("capabilities", "requests", "responses", "events", "errors", "entities"):
            entries = scenario.get(key, [])
            if entries:
                has_evidence = True
            for entry in entries:
                path = entry["path"]
                schema_name = entry["schema"]
                assert_true((ROOT / path).exists(), f"{scenario['id']}: missing evidence file {path}")
                validate_by_schema_name(path, schema_name, schemas)
                validated_files += 1

        for entry in scenario.get("fixtures", []):
            has_evidence = True
            path = entry["path"]
            assert_true((ROOT / path).exists(), f"{scenario['id']}: missing fixture {path}")

        assert_true(has_evidence, f"{scenario['id']}: scenario must carry evidence")

    return set(scenario_ids), validated_files


def main():
    ensure_required_paths()
    ensure_spec_content()

    schemas = build_store()
    matrix_doc = read_json("conformance/fixtures/compatibility/compatibility-matrix.json")
    golden_doc = read_json("conformance/fixtures/compatibility/golden-examples.json")

    scenario_ids, validated_files = validate_golden_examples(golden_doc, schemas)
    validate_matrix(matrix_doc, scenario_ids)

    script_outputs = []
    for script in collect_validator_scripts(matrix_doc):
        script_outputs.append((script, run_script(script)))

    print(
        "Validated "
        f"{len(matrix_doc['levels'])} compatibility levels, "
        f"{len(scenario_ids)} golden scenarios, "
        f"{validated_files} schema-backed evidence files, and "
        f"{len(script_outputs)} composed validator scripts."
    )


if __name__ == "__main__":
    main()
