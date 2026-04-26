# @ascp/adapter-codex

TypeScript workspace for a truthful ASCP adapter over the official `codex app-server` surface.

## Implemented adapter surface

- runtime discovery and conservative capability resolution for `codex_local`
- deterministic ASCP session, run, approval, and event identifiers
- `sessions.list`
- `sessions.get`
- `sessions.resume`
- `sessions.send_input`
- event normalization helpers for `turn/started`, `turn/completed`, `agentMessageDelta`, and `turn/diff/updated`
- approval request mapping helpers for `item/commandExecution/requestApproval`, `item/fileChange/requestApproval`, and `item/permissions/requestApproval`

Operational `thread/*` and `turn/*` requests now lazily perform the required `initialize` handshake with `codex app-server`, so downstream callers do not need to call `client.initialize()` manually before using the service layer.

## Current advertised capability fallbacks

- `stream_events=false`
- `notifications=false`
- `approval_requests=false`
- `approval_respond=false`
- `diffs=false`
- `artifacts=false`
- `replay=false`

These flags stay false until the adapter proves the corresponding official Codex subscribe, approval-response, diff-read, artifact, or replay surface end to end. The mapping helpers in this package do not widen those claims on their own.

## Validation

```bash
bash ../../tooling/scripts/validate_codex_adapter.sh
npm --workspace @ascp/adapter-codex run check
```

## Live runtime smoke testing

The package includes a checked-in live smoke script over the real `codex app-server`.

Interactive guided flow:

```bash
npm --workspace @ascp/adapter-codex run live
```

Direct read-only subcommands:

```bash
npm --workspace @ascp/adapter-codex run live -- discover
npm --workspace @ascp/adapter-codex run live -- list --limit 5
npm --workspace @ascp/adapter-codex run live -- get codex:thread_id --runs
```

Mutating subcommands:

```bash
npm --workspace @ascp/adapter-codex run live -- resume codex:thread_id
npm --workspace @ascp/adapter-codex run live -- send-input codex:thread_id "continue from here"
```

The live script rebuilds the adapter before launch so it runs against fresh local code. It intentionally does not expose `sessions.subscribe`, replay, artifacts, diff reads, or approval response flows.

When `send-input` targets a persisted Codex session from `sessions.list`, the adapter now reattaches that thread with `thread/resume` before starting a new turn. This keeps historical sessions usable in the live smoke flow instead of failing with a raw `thread not found` runtime error.
