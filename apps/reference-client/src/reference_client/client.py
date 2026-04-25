import sys
from dataclasses import dataclass, field
from pathlib import Path

from .schema_validation import SchemaValidator
from .stdio_transport import StdioJsonRpcTransport


@dataclass
class RpcExchange:
    method: str
    response: dict
    events: list[dict] = field(default_factory=list)

    @property
    def result(self):
        return self.response["result"]

    @property
    def subscription_id(self):
        return self.result.get("subscription_id")

    @property
    def cursor(self):
        for event in reversed(self.events):
            if event["type"] == "sync.cursor_advanced":
                return event["payload"]["cursor"]
        return None

    @property
    def replay_event_count(self):
        for event in reversed(self.events):
            if event["type"] == "sync.replayed":
                return event["payload"]["event_count"]
        return None


class ReferenceClient:
    def __init__(self, root, transport):
        self.root = Path(root)
        self.transport = transport
        self.validator = SchemaValidator(self.root)
        self._request_counter = 0

    @classmethod
    def launch_mock(cls, root):
        root = Path(root)
        cli = root / "services" / "mock-server" / "src" / "mock_server" / "cli.py"
        transport = StdioJsonRpcTransport([sys.executable, str(cli)], cwd=root)
        return cls(root=root, transport=transport)

    def __enter__(self):
        self.transport.start()
        return self

    def __exit__(self, exc_type, exc, tb):
        self.close()

    def close(self):
        self.transport.close()

    def _next_request_id(self, method_name):
        self._request_counter += 1
        return f"ref_{method_name.replace('.', '_')}_{self._request_counter}"

    def _call(self, method_name, params=None):
        payload = {
            "jsonrpc": "2.0",
            "id": self._next_request_id(method_name),
            "method": method_name,
            "params": params or {},
        }
        response, events = self.transport.request(payload)
        if "error" in response:
            raise AssertionError(f"{method_name} returned protocol error: {response['error']}")
        self.validator.validate_method_response(method_name, response)
        for event in events:
            self.validator.validate_event(event)
        return RpcExchange(method=method_name, response=response, events=events)

    def capabilities_get(self):
        return self._call("capabilities.get")

    def runtimes_list(self, kind=None, adapter_kind=None):
        params = {}
        if kind is not None:
            params["kind"] = kind
        if adapter_kind is not None:
            params["adapter_kind"] = adapter_kind
        return self._call("runtimes.list", params)

    def sessions_list(self, runtime_id=None, status=None, search_text=None, limit=None):
        params = {}
        if runtime_id is not None:
            params["runtime_id"] = runtime_id
        if status is not None:
            params["status"] = status
        if search_text is not None:
            params["search_text"] = search_text
        if limit is not None:
            params["limit"] = limit
        return self._call("sessions.list", params)

    def sessions_get(self, session_id, include_runs=True, include_pending_approvals=False):
        return self._call(
            "sessions.get",
            {
                "session_id": session_id,
                "include_runs": include_runs,
                "include_pending_approvals": include_pending_approvals,
            },
        )

    def sessions_send_input(self, session_id, text, input_kind="text"):
        return self._call(
            "sessions.send_input",
            {
                "session_id": session_id,
                "input": text,
                "input_kind": input_kind,
            },
        )

    def sessions_subscribe(
        self,
        session_id,
        include_snapshot=False,
        from_seq=None,
        from_event_id=None,
    ):
        params = {"session_id": session_id, "include_snapshot": include_snapshot}
        if from_seq is not None:
            params["from_seq"] = from_seq
        if from_event_id is not None:
            params["from_event_id"] = from_event_id
        return self._call("sessions.subscribe", params)

    def approvals_list(self, session_id=None, status=None):
        params = {}
        if session_id is not None:
            params["session_id"] = session_id
        if status is not None:
            params["status"] = status
        return self._call("approvals.list", params)

    def artifacts_list(self, session_id, kind=None):
        params = {"session_id": session_id}
        if kind is not None:
            params["kind"] = kind
        return self._call("artifacts.list", params)

    def artifacts_get(self, artifact_id):
        return self._call("artifacts.get", {"artifact_id": artifact_id})

    def diffs_get(self, session_id):
        return self._call("diffs.get", {"session_id": session_id})
