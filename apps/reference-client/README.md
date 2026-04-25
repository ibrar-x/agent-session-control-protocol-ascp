# ASCP Reference Client

This directory contains a small downstream proof client for the frozen ASCP v0.1 workspace. It talks to the deterministic mock server over stdio JSON-RPC and validates consumed responses and emitted events against the published schemas under `protocol/schema/`.

## Layout

- `src/reference_client/`: minimal client, transport wrapper, schema validation, and demo flow
- `tests/validate_reference_client.py`: repeatable validation entrypoint

## Run

From the repository root:

```bash
PYTHONPATH="$PWD/apps/reference-client/src" python3 -m reference_client.demo
```

## Validate

```bash
bash tooling/scripts/validate_reference_client.sh
```
