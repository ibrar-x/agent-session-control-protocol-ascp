#!/usr/bin/env python3
import json
import sys
from pathlib import Path

if __package__ in {None, ""}:
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
    from reference_client.client import ReferenceClient
else:
    from .client import ReferenceClient


def run_reference_demo(root, session_id="sess_abc123", from_seq=34):
    with ReferenceClient.launch_mock(root) as client:
        capabilities = client.capabilities_get()
        runtimes = client.runtimes_list()
        session = client.sessions_get(
            session_id,
            include_runs=True,
            include_pending_approvals=True,
        )
        approvals = client.approvals_list(session_id=session_id, status="pending")
        artifacts = client.artifacts_list(session_id)
        diff = client.diffs_get(session_id)
        subscription = client.sessions_subscribe(
            session_id,
            include_snapshot=True,
            from_seq=from_seq,
        )

    return {
        "protocol_version": capabilities.result["protocol_version"],
        "runtime_ids": [runtime["id"] for runtime in runtimes.result["runtimes"]],
        "session_id": session.result["session"]["id"],
        "pending_approval_ids": [
            approval["id"] for approval in approvals.result["approvals"]
        ],
        "artifact_ids": [artifact["id"] for artifact in artifacts.result["artifacts"]],
        "diff_files_changed": diff.result["diff"]["files_changed"],
        "subscription_cursor": subscription.cursor,
        "subscription_event_types": [event["type"] for event in subscription.events],
    }


def main(argv=None):
    argv = argv or sys.argv[1:]
    root = Path(__file__).resolve().parents[4]
    session_id = argv[0] if argv else "sess_abc123"
    summary = run_reference_demo(root, session_id=session_id)
    sys.stdout.write(json.dumps(summary, indent=2) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
