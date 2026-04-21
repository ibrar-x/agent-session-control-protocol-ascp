# ASCP Mock Server

This directory contains a deterministic proof implementation of the frozen ASCP v0.1 protocol surface. It is intentionally small and fixture-backed so protocol consumers can test discovery, session inspection, approvals, artifacts, diffs, subscriptions, and replay behavior without guessing at payloads.

## What It Covers

- JSON-RPC request and response handling over a line-oriented stdio transport
- deterministic host, runtime, session, approval, artifact, and diff data
- replay-aware subscription output with explicit `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced` boundaries
- approval resolution state transitions for the seeded pending approval

## What It Does Not Cover

- product UI or vendor-specific runtime behavior
- transport auth enforcement
- non-deterministic scheduling, multi-client synchronization, or persistence across process restarts
- extension-specific method handling beyond the published capability document

## Fixture Layout

- `fixtures/state.json`: seeded host, runtime, session, approval, artifact, and diff state
- `sample-event-streams/sess_abc123.json`: deterministic replay data for the seeded session
- `src/mock_server/`: fixture loader, request dispatcher, and CLI entrypoint
- `tests/validate_mock_server.py`: branch-specific validator for the mock surface

## Running The Mock

Start the line-oriented stdio server:

```bash
python3 mock-server/src/mock_server/cli.py
```

Send one JSON-RPC request per line on stdin. The mock writes the response first and then any emitted events as individual JSON lines on stdout.

Example:

```json
{"jsonrpc":"2.0","id":"req_sub_1","method":"sessions.subscribe","params":{"session_id":"sess_abc123","include_snapshot":true,"from_seq":34}}
```

The response line is followed by deterministic snapshot and replay events for `sess_abc123`.

## Validation

Run:

```bash
./scripts/validate_mock_server.sh
```

That validator checks the public mock surface against the frozen schemas and verifies the docs index and protocol usage guide added on this branch.
