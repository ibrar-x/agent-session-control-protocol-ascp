import json
from copy import deepcopy
from pathlib import Path

from .fixtures import FixtureStore


class MockServer:
    def __init__(self, root):
        self.root = Path(root)
        self.fixtures = FixtureStore(self.root)
        self.capability_document = self.fixtures.capability_document()
        self.host = self.fixtures.host()
        self.runtimes = self.fixtures.runtimes()
        self.sessions = {
            bundle["session"]["id"]: bundle for bundle in self.fixtures.sessions()
        }
        self.subscriptions = {}
        self._session_counter = 1

    def handle_request(self, request):
        method = request.get("method")
        params = request.get("params") or {}
        request_id = request.get("id")

        handlers = {
            "capabilities.get": self._capabilities_get,
            "hosts.get": self._hosts_get,
            "runtimes.list": self._runtimes_list,
            "sessions.list": self._sessions_list,
            "sessions.get": self._sessions_get,
            "sessions.start": self._sessions_start,
            "sessions.resume": self._sessions_resume,
            "sessions.stop": self._sessions_stop,
            "sessions.send_input": self._sessions_send_input,
            "sessions.subscribe": self._sessions_subscribe,
            "sessions.unsubscribe": self._sessions_unsubscribe,
            "approvals.list": self._approvals_list,
            "approvals.respond": self._approvals_respond,
            "artifacts.list": self._artifacts_list,
            "artifacts.get": self._artifacts_get,
            "diffs.get": self._diffs_get,
        }

        handler = handlers.get(method)
        if handler is None:
            return self._error(
                request_id,
                "INVALID_REQUEST",
                f"Unsupported method: {method}",
                {"method": method},
            ), []

        result, emitted = handler(request_id, params)
        return result, emitted

    def _success(self, request_id, result):
        return {"jsonrpc": "2.0", "id": request_id, "result": result}

    def _error(self, request_id, code, message, details=None):
        payload = {
            "jsonrpc": "2.0",
            "id": request_id,
            "error": {
                "code": code,
                "message": message,
                "retryable": False,
                "details": details or {},
                "correlation_id": f"corr_{request_id}",
            },
        }
        return payload

    def _bundle_or_error(self, request_id, session_id):
        bundle = self.sessions.get(session_id)
        if bundle is None:
            return None, self._error(
                request_id,
                "NOT_FOUND",
                "Session not found",
                {"session_id": session_id},
            )
        return bundle, None

    def _capabilities_get(self, request_id, _params):
        return self._success(request_id, deepcopy(self.capability_document)), []

    def _hosts_get(self, request_id, _params):
        return self._success(request_id, {"host": deepcopy(self.host)}), []

    def _runtimes_list(self, request_id, params):
        runtimes = deepcopy(self.runtimes)
        kind = params.get("kind")
        adapter_kind = params.get("adapter_kind")
        if kind:
            runtimes = [runtime for runtime in runtimes if runtime["kind"] == kind]
        if adapter_kind:
            runtimes = [
                runtime
                for runtime in runtimes
                if runtime.get("adapter_kind") == adapter_kind
            ]
        return self._success(request_id, {"runtimes": runtimes}), []

    def _sessions_list(self, request_id, params):
        sessions = [deepcopy(bundle["session"]) for bundle in self.sessions.values()]
        runtime_id = params.get("runtime_id")
        status = params.get("status")
        search_text = params.get("search_text")
        limit = params.get("limit")
        if runtime_id:
            sessions = [item for item in sessions if item["runtime_id"] == runtime_id]
        if status:
            sessions = [item for item in sessions if item["status"] == status]
        if search_text:
            query = search_text.lower()
            sessions = [
                item
                for item in sessions
                if query in item.get("title", "").lower()
                or query in item.get("summary", "").lower()
            ]
        if limit is not None:
            sessions = sessions[: int(limit)]
        return self._success(request_id, {"sessions": sessions, "next_cursor": None}), []

    def _sessions_get(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []
        include_runs = params.get("include_runs", True)
        include_pending_approvals = params.get("include_pending_approvals", False)
        result = {"session": deepcopy(bundle["session"])}
        result["runs"] = deepcopy(bundle["runs"]) if include_runs else []
        if include_pending_approvals:
            result["pending_approvals"] = [
                deepcopy(approval)
                for approval in bundle["approvals"]
                if approval["status"] == "pending"
            ]
        else:
            result["pending_approvals"] = []
        return self._success(request_id, result), []

    def _sessions_start(self, request_id, params):
        self._session_counter += 1
        session_id = f"sess_new_{self._session_counter - 1}"
        run_id = f"run_new_{self._session_counter - 1}"
        title = params.get("title") or "Deterministic mock session"
        workspace = params.get("workspace") or "/Users/me/mock-workspace"
        session = {
            "id": session_id,
            "runtime_id": params.get("runtime_id", "codex_local"),
            "title": title,
            "workspace": workspace,
            "status": "running",
            "created_at": "2026-04-21T10:20:00Z",
            "updated_at": "2026-04-21T10:20:00Z",
        }
        bundle = {
            "session": session,
            "runs": [
                {
                    "id": run_id,
                    "session_id": session_id,
                    "status": "running",
                    "started_at": "2026-04-21T10:20:00Z",
                    "ended_at": None,
                    "exit_code": None,
                }
            ],
            "approvals": [],
            "artifacts": [],
            "diff": None,
        }
        self.sessions[session_id] = bundle
        return self._success(request_id, {"session": deepcopy(session)}), []

    def _sessions_resume(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []
        return self._success(
            request_id,
            {
                "session": deepcopy(bundle["session"]),
                "snapshot_emitted": True,
                "replay_supported": True,
            },
        ), []

    def _sessions_stop(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []
        bundle["session"]["status"] = "stopped"
        bundle["session"]["updated_at"] = "2026-04-21T10:31:00Z"
        return self._success(
            request_id,
            {"session_id": bundle["session"]["id"], "status": "stopped"},
        ), []

    def _sessions_send_input(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []
        emitted = [
            {
                "id": "evt_live_0001",
                "type": "message.user",
                "ts": "2026-04-21T10:21:05Z",
                "session_id": bundle["session"]["id"],
                "run_id": bundle["runs"][0]["id"],
                "seq": 41,
                "payload": {
                    "message_id": "msg_user_live_1",
                    "content": params.get("input", ""),
                },
            },
            {
                "id": "evt_live_0002",
                "type": "message.assistant.started",
                "ts": "2026-04-21T10:21:06Z",
                "session_id": bundle["session"]["id"],
                "run_id": bundle["runs"][0]["id"],
                "seq": 42,
                "payload": {"message_id": "msg_assistant_live_1"},
            },
            {
                "id": "evt_live_0003",
                "type": "message.assistant.completed",
                "ts": "2026-04-21T10:21:07Z",
                "session_id": bundle["session"]["id"],
                "run_id": bundle["runs"][0]["id"],
                "seq": 43,
                "payload": {
                    "message_id": "msg_assistant_live_1",
                    "content": "Mock server accepted the steering input and continued deterministically.",
                },
            },
        ]
        return self._success(
            request_id, {"accepted": True, "session_id": bundle["session"]["id"]}
        ), emitted

    def _sessions_subscribe(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []

        stream = self.fixtures.event_stream(bundle["session"]["id"])
        from_seq = params.get("from_seq")
        from_event_id = params.get("from_event_id")
        include_snapshot = params.get("include_snapshot", False)

        replayable_events = deepcopy(stream["replayable_events"])
        if from_seq is not None:
            replayable_events = [
                event for event in replayable_events if event["seq"] > int(from_seq)
            ]
        elif from_event_id:
            seen = False
            filtered = []
            for event in replayable_events:
                if seen:
                    filtered.append(event)
                if event["id"] == from_event_id:
                    seen = True
            replayable_events = filtered

        subscription_id = self.subscriptions.get(bundle["session"]["id"])
        if subscription_id is None:
            subscription_id = f"sub_{len(self.subscriptions) + 1:02d}"
            self.subscriptions[bundle["session"]["id"]] = subscription_id

        emitted = []
        if include_snapshot:
            emitted.append(deepcopy(stream["snapshot"]))

        emitted.extend(replayable_events)

        if replayable_events:
            from_seq_value = replayable_events[0]["seq"]
            to_seq_value = replayable_events[-1]["seq"]
        else:
            from_seq_value = int(from_seq) if from_seq is not None else stream["snapshot"]["seq"]
            to_seq_value = from_seq_value

        emitted.append(
            {
                "id": "evt_0039",
                "type": "sync.replayed",
                "ts": "2026-04-21T10:21:05Z",
                "session_id": bundle["session"]["id"],
                "seq": 39,
                "payload": {
                    "from_seq": from_seq_value,
                    "to_seq": to_seq_value,
                    "event_count": len(replayable_events),
                },
            }
        )
        emitted.append(
            {
                "id": "evt_0040",
                "type": "sync.cursor_advanced",
                "ts": "2026-04-21T10:21:06Z",
                "session_id": bundle["session"]["id"],
                "seq": 40,
                "payload": {"cursor": f"seq:{to_seq_value}"},
            }
        )

        return self._success(
            request_id,
            {
                "subscription_id": subscription_id,
                "session_id": bundle["session"]["id"],
                "snapshot_emitted": include_snapshot,
            },
        ), emitted

    def _sessions_unsubscribe(self, request_id, params):
        subscription_id = params.get("subscription_id")
        for session_id, active_subscription in list(self.subscriptions.items()):
            if active_subscription == subscription_id:
                del self.subscriptions[session_id]
                break
        return self._success(
            request_id,
            {"subscription_id": subscription_id, "unsubscribed": True},
        ), []

    def _approvals_list(self, request_id, params):
        approvals = []
        session_id = params.get("session_id")
        status = params.get("status")
        for bundle in self.sessions.values():
            for approval in bundle["approvals"]:
                if session_id and approval["session_id"] != session_id:
                    continue
                if status and approval["status"] != status:
                    continue
                approvals.append(deepcopy(approval))
        return self._success(request_id, {"approvals": approvals, "next_cursor": None}), []

    def _approvals_respond(self, request_id, params):
        approval_id = params.get("approval_id")
        decision = params.get("decision")
        for bundle in self.sessions.values():
            for approval in bundle["approvals"]:
                if approval["id"] != approval_id:
                    continue
                if approval["status"] != "pending":
                    return self._error(
                        request_id,
                        "CONFLICT",
                        "Approval already resolved",
                        {
                            "method": "approvals.respond",
                            "approval_id": approval_id,
                            "status": approval["status"],
                        },
                    ), []
                approval["status"] = decision
                approval["resolved_at"] = "2026-04-21T10:07:00Z"
                emitted = [
                    {
                        "id": "evt_approval_1",
                        "type": "approval.updated",
                        "ts": "2026-04-21T10:06:30Z",
                        "session_id": approval["session_id"],
                        "run_id": approval["run_id"],
                        "seq": 26,
                        "payload": {
                            "approval_id": approval_id,
                            "changed_fields": ["status"],
                        },
                    },
                    {
                        "id": "evt_approval_2",
                        "type": f"approval.{decision}",
                        "ts": "2026-04-21T10:07:00Z",
                        "session_id": approval["session_id"],
                        "run_id": approval["run_id"],
                        "seq": 27,
                        "payload": {
                            "approval_id": approval_id,
                            "resolved_at": "2026-04-21T10:07:00Z",
                            "actor_id": "device_user_1",
                        },
                    },
                ]
                if decision == "rejected":
                    emitted[1]["payload"]["note"] = params.get("note") or "Rejected by mock policy"
                return self._success(
                    request_id, {"approval_id": approval_id, "status": decision}
                ), emitted

        return self._error(
            request_id,
            "NOT_FOUND",
            "Approval not found",
            {"approval_id": approval_id},
        ), []

    def _artifacts_list(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []
        kind = params.get("kind")
        artifacts = deepcopy(bundle["artifacts"])
        if kind:
            artifacts = [artifact for artifact in artifacts if artifact["kind"] == kind]
        return self._success(request_id, {"artifacts": artifacts}), []

    def _artifacts_get(self, request_id, params):
        artifact_id = params.get("artifact_id")
        for bundle in self.sessions.values():
            for artifact in bundle["artifacts"]:
                if artifact["id"] == artifact_id:
                    return self._success(
                        request_id, {"artifact": deepcopy(artifact)}
                    ), []
        return self._error(
            request_id,
            "NOT_FOUND",
            "Artifact not found",
            {"artifact_id": artifact_id},
        ), []

    def _diffs_get(self, request_id, params):
        bundle, error = self._bundle_or_error(request_id, params.get("session_id"))
        if error is not None:
            return error, []
        if bundle["diff"] is None:
            return self._error(
                request_id,
                "NOT_FOUND",
                "Diff not found",
                {"session_id": params.get("session_id")},
            ), []
        return self._success(request_id, {"diff": deepcopy(bundle["diff"])}), []

    def dumps(self, payload):
        return json.dumps(payload, separators=(",", ":"), sort_keys=False)
