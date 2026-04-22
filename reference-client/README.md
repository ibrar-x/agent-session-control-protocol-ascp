# ASCP Reference Client

This directory contains a small downstream proof client for the frozen ASCP v0.1 workspace. It talks to the existing mock server over line-oriented stdio JSON-RPC and validates consumed responses and emitted events against the published schemas under `schema/`.

## What It Proves

- a downstream client can discover capabilities and runtimes without hidden protocol assumptions
- the mock server can be consumed through a thin transport and client layer
- session inspection, approval reads, artifact reads, diff reads, and replay-aware subscriptions work against the frozen contract set
- one clean Python consumer path can be validated end-to-end with the repository fixtures and schemas

## What It Does Not Prove

- production transport resilience beyond the deterministic stdio mock
- vendor-specific UI behavior
- auth middleware or policy enforcement beyond the published protocol hooks
- multi-language SDK packaging

## Layout

- `src/reference_client/stdio_transport.py`: line-oriented stdio JSON-RPC transport
- `src/reference_client/schema_validation.py`: schema-backed validation for consumed responses and events
- `src/reference_client/client.py`: minimal client wrapper for the mock-server method surface
- `src/reference_client/demo.py`: repeatable demo flow that summarizes downstream proof coverage
- `tests/validate_reference_client.py`: branch validator for the reference-client slice

## Run The Demo

```bash
PYTHONPATH="$PWD/reference-client/src" python3 -m reference_client.demo
```

## Run Validation

```bash
./scripts/validate_reference_client.sh
```

The validator launches the existing mock server, exercises discovery, session reads, subscribe/replay, approvals, artifacts, diffs, and live input, and fails if any consumed method response or event no longer matches the published ASCP schemas.
