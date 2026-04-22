#!/usr/bin/env python3
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "reference-client" / "src"

if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from reference_client.client import ReferenceClient  # noqa: E402
from reference_client.demo import run_reference_demo  # noqa: E402


class ReferenceClientValidationTests(unittest.TestCase):
    def test_discovery_and_session_reads_are_consumed_from_the_mock(self):
        with ReferenceClient.launch_mock(ROOT) as client:
            capabilities = client.capabilities_get()
            self.assertEqual(capabilities.result["protocol_version"], "0.1.0")
            self.assertTrue(capabilities.result["capabilities"]["session_list"])

            runtimes = client.runtimes_list()
            self.assertEqual(runtimes.result["runtimes"][0]["id"], "codex_local")

            sessions = client.sessions_list(status="running")
            self.assertEqual(sessions.result["sessions"][0]["id"], "sess_abc123")

            session = client.sessions_get(
                "sess_abc123",
                include_runs=True,
                include_pending_approvals=True,
            )
            self.assertEqual(session.result["session"]["runtime_id"], "codex_local")
            self.assertEqual(session.result["runs"][0]["id"], "run_9")
            self.assertEqual(session.result["pending_approvals"][0]["id"], "apr_77")

    def test_approvals_artifacts_diffs_and_live_input_are_available(self):
        with ReferenceClient.launch_mock(ROOT) as client:
            approvals = client.approvals_list(session_id="sess_abc123", status="pending")
            self.assertEqual(approvals.result["approvals"][0]["id"], "apr_77")

            artifacts = client.artifacts_list("sess_abc123")
            self.assertEqual(artifacts.result["artifacts"][0]["id"], "art_3")

            artifact = client.artifacts_get("art_3")
            self.assertEqual(artifact.result["artifact"]["mime_type"], "text/x-diff")

            diff = client.diffs_get("sess_abc123")
            self.assertEqual(diff.result["diff"]["files_changed"], 4)

            steering = client.sessions_send_input(
                "sess_abc123",
                "Continue, but focus on the checkout API mock.",
            )
            self.assertTrue(steering.result["accepted"])
            self.assertEqual(
                [event["type"] for event in steering.events],
                [
                    "message.user",
                    "message.assistant.started",
                    "message.assistant.completed",
                ],
            )

    def test_subscribe_exposes_snapshot_replay_and_cursor_state(self):
        with ReferenceClient.launch_mock(ROOT) as client:
            subscription = client.sessions_subscribe(
                "sess_abc123",
                include_snapshot=True,
                from_seq=34,
            )
            self.assertEqual(subscription.result["session_id"], "sess_abc123")
            self.assertEqual(subscription.subscription_id, "sub_01")

            event_types = [event["type"] for event in subscription.events]
            self.assertEqual(event_types[0], "sync.snapshot")
            self.assertIn("message.assistant.delta", event_types)
            self.assertIn("artifact.created", event_types)
            self.assertEqual(event_types[-2], "sync.replayed")
            self.assertEqual(event_types[-1], "sync.cursor_advanced")
            self.assertEqual(subscription.cursor, "seq:38")
            self.assertEqual(subscription.replay_event_count, 4)

    def test_demo_flow_summarizes_the_reference_client_capabilities(self):
        summary = run_reference_demo(ROOT, session_id="sess_abc123", from_seq=34)
        self.assertEqual(summary["protocol_version"], "0.1.0")
        self.assertEqual(summary["runtime_ids"], ["codex_local"])
        self.assertEqual(summary["session_id"], "sess_abc123")
        self.assertEqual(summary["pending_approval_ids"], ["apr_77"])
        self.assertEqual(summary["artifact_ids"], ["art_3"])
        self.assertEqual(summary["diff_files_changed"], 4)
        self.assertEqual(summary["subscription_cursor"], "seq:38")
        self.assertEqual(summary["subscription_event_types"][0], "sync.snapshot")
        self.assertEqual(summary["subscription_event_types"][-1], "sync.cursor_advanced")


if __name__ == "__main__":
    unittest.main()
