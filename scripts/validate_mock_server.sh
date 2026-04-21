#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PYTHONPATH="$ROOT/mock-server/src${PYTHONPATH:+:$PYTHONPATH}" \
  python3 mock-server/tests/validate_mock_server.py
