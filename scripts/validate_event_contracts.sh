#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 <<'PY'
from pathlib import Path

required = [
    Path("schema/ascp-events.schema.json"),
    Path("spec/events.md"),
    Path("examples/events/session-created.json"),
    Path("examples/events/error-fatal.json"),
]

missing = [str(path) for path in required if not path.exists()]
if missing:
    raise SystemExit("Missing event-contract assets:\n- " + "\n- ".join(missing))
PY
