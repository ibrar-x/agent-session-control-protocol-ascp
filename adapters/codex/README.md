# @ascp/adapter-codex

TypeScript workspace for a truthful ASCP adapter over the official `codex app-server` surface.

## Implemented adapter surface

- runtime discovery and conservative capability resolution for `codex_local`
- deterministic ASCP session, run, approval, and event identifiers
- `sessions.list`
- `sessions.get`
- `sessions.resume`
- `sessions.send_input`
- `sessions.subscribe`
- `sessions.unsubscribe`
- `approvals.list`
- `approvals.respond` (truthful fallback to `UNSUPPORTED` when Codex does not expose a response method)
- `diffs.get` (derived from `fileChange` turn items)
- `artifacts.list`
- `artifacts.get`
- event normalization helpers for `turn/started`, `turn/completed`, `agentMessageDelta`, and `turn/diff/updated`
- approval request mapping helpers for `item/commandExecution/requestApproval`, `item/fileChange/requestApproval`, and `item/permissions/requestApproval`
- replay queue behavior for `sessions.subscribe` with `from_seq` and `from_event_id` over sequenced in-memory event history

Operational `thread/*` and `turn/*` requests now lazily perform the required `initialize` handshake with `codex app-server`, so downstream callers do not need to call `client.initialize()` manually before using the service layer.

## Current capability behavior

- `stream_events` and `notifications` are true when runtime notifications are observable
- `approval_requests` becomes true once approval request notifications are observed
- `approval_respond` stays false until an approval response method succeeds at runtime
- `diffs` and `artifacts` are true because the adapter derives metadata from `thread/read` turn items
- `replay` is true for in-memory subscribe replay behavior (`from_seq` / `from_event_id`) in the running service instance

The adapter does not fake unsupported runtime behavior: if Codex does not expose an approval response method, `approvals.respond` returns `UNSUPPORTED` instead of guessing.

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

The live script rebuilds the adapter before launch so it runs against fresh local code. It currently focuses on session discovery/read/resume/input flows and does not expose dedicated CLI subcommands for subscribe, approvals, diffs, or artifacts yet.

When `send-input` targets a persisted Codex session from `sessions.list`, the adapter now reattaches that thread with `thread/resume` before starting a new turn. This keeps historical sessions usable in the live smoke flow instead of failing with a raw `thread not found` runtime error.
