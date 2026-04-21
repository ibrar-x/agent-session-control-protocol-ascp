import json
from copy import deepcopy
from pathlib import Path


def load_json(path: Path):
    return json.loads(path.read_text())


class FixtureStore:
    def __init__(self, root: Path):
        self.root = Path(root)
        self.fixture_root = self.root / "mock-server" / "fixtures"
        self.stream_root = self.root / "mock-server" / "sample-event-streams"
        self._state = load_json(self.fixture_root / "state.json")

    def capability_document(self):
        return deepcopy(self._state["capability_document"])

    def host(self):
        return deepcopy(self._state["host"])

    def runtimes(self):
        return deepcopy(self._state["runtimes"])

    def sessions(self):
        return deepcopy(self._state["sessions"])

    def session_bundle(self, session_id: str):
        for bundle in self._state["sessions"]:
            if bundle["session"]["id"] == session_id:
                return deepcopy(bundle)
        return None

    def event_stream(self, session_id: str):
        return load_json(self.stream_root / f"{session_id}.json")
