# ASCP Mock Server

This directory contains the deterministic ASCP proof mock. It serves fixed fixture-backed protocol responses and event streams so SDKs, apps, and adapters can validate against a repeatable surface without reopening protocol-core semantics.

## Layout

- `src/mock_server/`: server and stdio CLI
- `fixtures/`: deterministic session, approval, artifact, diff, and capability data
- `sample-event-streams/`: replay and snapshot event streams
- `tests/validate_mock_server.py`: repeatable validation entrypoint

## Run

From the repository root:

```bash
python3 services/mock-server/src/mock_server/cli.py
```

## Validate

```bash
bash tooling/scripts/validate_mock_server.sh
```
