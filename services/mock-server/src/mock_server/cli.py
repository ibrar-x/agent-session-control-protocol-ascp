#!/usr/bin/env python3
import json
import sys
from pathlib import Path

if __package__ in {None, ""}:
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from mock_server.server import MockServer


def main():
    root = Path(__file__).resolve().parents[4]
    server = MockServer(root=root)
    for line in sys.stdin:
        stripped = line.strip()
        if not stripped:
            continue
        request = json.loads(stripped)
        response, emitted = server.handle_request(request)
        sys.stdout.write(json.dumps(response) + "\n")
        for event in emitted:
            sys.stdout.write(json.dumps(event) + "\n")
        sys.stdout.flush()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
