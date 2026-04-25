#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

PYTHONPATH="$ROOT/services/mock-server/src${PYTHONPATH:+:$PYTHONPATH}" \
  /usr/bin/python3 services/mock-server/tests/validate_mock_server.py
