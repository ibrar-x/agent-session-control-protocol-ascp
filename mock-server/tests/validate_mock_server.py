#!/usr/bin/env python3
import json
import subprocess
import sys
import unittest
import warnings
from pathlib import Path

warnings.filterwarnings("ignore", category=DeprecationWarning)

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "mock-server" / "src"

sys.path.insert(0, str(SRC))

from jsonschema import Draft202012Validator, RefResolver  # noqa: E402
from mock_server.server import MockServer  # noqa: E402


def read_json(relative_path: str):
    return json.loads((ROOT / relative_path).read_text())


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
        raise AssertionError("\n".join(lines))


def validate_root_schema(instance, schema_root, store, label):
    resolver = RefResolver.from_schema(schema_root, store=store)
    validator = Draft202012Validator(schema_root, resolver=resolver)
    errors = sorted(validator.iter_errors(instance), key=lambda err: err.json_path)
    if errors:
        lines = [f"Validation failed against {label}"]
        for error in errors:
            lines.append(f"- {error.json_path}: {error.message}")
        raise AssertionError("\n".join(lines))


class MockServerValidationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.schemas = build_store()

    def setUp(self):
        self.server = MockServer(root=ROOT)

    def assert_method_response(self, response, schema_name):
        validate_instance(
            response,
            self.schemas["methods"],
            schema_name,
            self.schemas["store"],
        )

    def assert_event(self, event, schema_name):
        validate_instance(
            event,
            self.schemas["events"],
            schema_name,
            self.schemas["store"],
        )

    def test_discovery_and_session_reads_are_schema_valid(self):
        response, emitted = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_cap_1",
                "method": "capabilities.get",
                "params": {},
            }
        )
        self.assert_method_response(response, "CapabilitiesGetSuccessResponse")
        self.assertEqual(response["result"]["protocol_version"], "0.1.0")
        self.assertEqual(emitted, [])

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_host_1",
                "method": "hosts.get",
                "params": {},
            }
        )
        self.assert_method_response(response, "HostsGetSuccessResponse")
        self.assertEqual(response["result"]["host"]["id"], "host_01")

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_runtime_1",
                "method": "runtimes.list",
                "params": {},
            }
        )
        self.assert_method_response(response, "RuntimesListSuccessResponse")
        self.assertEqual(response["result"]["runtimes"][0]["id"], "codex_local")

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_list_1",
                "method": "sessions.list",
                "params": {},
            }
        )
        self.assert_method_response(response, "SessionsListSuccessResponse")
        self.assertEqual(response["result"]["sessions"][0]["id"], "sess_abc123")

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_get_1",
                "method": "sessions.get",
                "params": {"session_id": "sess_abc123", "include_runs": True, "include_pending_approvals": True},
            }
        )
        self.assert_method_response(response, "SessionsGetSuccessResponse")
        self.assertEqual(response["result"]["runs"][0]["id"], "run_9")
        self.assertEqual(response["result"]["pending_approvals"][0]["id"], "apr_77")

    def test_approvals_artifacts_and_diffs_are_available(self):
        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_appr_list_1",
                "method": "approvals.list",
                "params": {"session_id": "sess_abc123"},
            }
        )
        self.assert_method_response(response, "ApprovalsListSuccessResponse")
        self.assertEqual(response["result"]["approvals"][0]["status"], "pending")

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_art_list_1",
                "method": "artifacts.list",
                "params": {"session_id": "sess_abc123"},
            }
        )
        self.assert_method_response(response, "ArtifactsListSuccessResponse")
        self.assertEqual(response["result"]["artifacts"][0]["id"], "art_3")

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_art_get_1",
                "method": "artifacts.get",
                "params": {"artifact_id": "art_3"},
            }
        )
        self.assert_method_response(response, "ArtifactsGetSuccessResponse")
        self.assertEqual(response["result"]["artifact"]["mime_type"], "text/x-diff")

        response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_diff_1",
                "method": "diffs.get",
                "params": {"session_id": "sess_abc123"},
            }
        )
        self.assert_method_response(response, "DiffsGetSuccessResponse")
        self.assertEqual(response["result"]["diff"]["files_changed"], 4)

    def test_approval_response_updates_state_and_emits_events(self):
        response, emitted = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_appr_1",
                "method": "approvals.respond",
                "params": {"approval_id": "apr_77", "decision": "approved", "note": "Looks safe"},
            }
        )
        self.assert_method_response(response, "ApprovalsRespondSuccessResponse")
        self.assertEqual(response["result"]["status"], "approved")
        self.assertEqual([event["type"] for event in emitted], ["approval.updated", "approval.approved"])
        self.assert_event(emitted[0], "ApprovalUpdatedEvent")
        self.assert_event(emitted[1], "ApprovalApprovedEvent")

        session_response, _ = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_get_after_approval",
                "method": "sessions.get",
                "params": {"session_id": "sess_abc123", "include_pending_approvals": True},
            }
        )
        self.assertEqual(session_response["result"]["pending_approvals"], [])

    def test_subscription_supports_snapshot_replay_and_live_tail(self):
        response, emitted = self.server.handle_request(
            {
                "jsonrpc": "2.0",
                "id": "req_sub_1",
                "method": "sessions.subscribe",
                "params": {
                    "session_id": "sess_abc123",
                    "include_snapshot": True,
                    "from_seq": 34,
                },
            }
        )
        self.assert_method_response(response, "SessionsSubscribeSuccessResponse")
        self.assertEqual(response["result"]["session_id"], "sess_abc123")
        self.assertGreaterEqual(len(emitted), 4)
        self.assertEqual(emitted[0]["type"], "sync.snapshot")
        self.assert_event(emitted[0], "SyncSnapshotEvent")
        self.assertEqual(emitted[-2]["type"], "sync.replayed")
        self.assert_event(emitted[-2], "SyncReplayedEvent")
        self.assertEqual(emitted[-1]["type"], "sync.cursor_advanced")
        self.assert_event(emitted[-1], "SyncCursorAdvancedEvent")
        replayed_event_types = {event["type"] for event in emitted[1:-2]}
        self.assertIn("message.assistant.delta", replayed_event_types)
        self.assertTrue(all(event["seq"] >= 35 for event in emitted[1:-1]))

    def test_stdio_cli_emits_response_then_events(self):
        cli = ROOT / "mock-server" / "src" / "mock_server" / "cli.py"
        request = {
            "jsonrpc": "2.0",
            "id": "req_sub_cli",
            "method": "sessions.subscribe",
            "params": {
                "session_id": "sess_abc123",
                "include_snapshot": True,
                "from_seq": 34,
            },
        }
        proc = subprocess.run(
            [sys.executable, str(cli)],
            input=json.dumps(request) + "\n",
            text=True,
            capture_output=True,
            cwd=ROOT,
            check=False,
        )
        self.assertEqual(proc.returncode, 0, proc.stderr)
        output_lines = [json.loads(line) for line in proc.stdout.splitlines() if line.strip()]
        self.assertGreaterEqual(len(output_lines), 4)
        self.assertEqual(output_lines[0]["id"], "req_sub_cli")
        self.assertEqual(output_lines[1]["type"], "sync.snapshot")
        self.assertEqual(output_lines[-1]["type"], "sync.cursor_advanced")

    def test_docs_index_and_usage_guide_exist(self):
        docs_index = ROOT / "docs" / "README.md"
        usage_doc = ROOT / "docs" / "protocol-usage-and-dto-generation.md"

        self.assertTrue(docs_index.exists(), "docs/README.md should exist")
        self.assertTrue(usage_doc.exists(), "docs/protocol-usage-and-dto-generation.md should exist")

        docs_index_text = docs_index.read_text()
        usage_doc_text = usage_doc.read_text()

        self.assertIn("# Docs Index", docs_index_text)
        self.assertIn("Mock Server", docs_index_text)
        self.assertIn("# Using ASCP", usage_doc_text)
        self.assertIn("DTO generation", usage_doc_text)
        self.assertIn("json-schema-to-typescript", usage_doc_text)


if __name__ == "__main__":
    unittest.main()
