# @ascp/adapter-codex

TypeScript workspace for a truthful ASCP adapter over the official `codex app-server` surface.

## Implemented adapter surface

- runtime discovery and conservative capability resolution for `codex_local`
- deterministic ASCP session, run, approval, and event identifiers
- `sessions.list`
- `sessions.get`
- `sessions.start`
- `sessions.resume`
- `sessions.send_input`
- `sessions.subscribe`
- `sessions.unsubscribe`
- `approvals.list`
- `approvals.respond`
- `diffs.get` (derived from `fileChange` turn items)
- `artifacts.list`
- `artifacts.get`
- event normalization helpers for `turn/started`, `turn/completed`, `agentMessageDelta`, and `turn/diff/updated`
- approval request mapping helpers for `item/commandExecution/requestApproval`, `item/fileChange/requestApproval`, and `item/permissions/requestApproval`
- host-derived interaction translation for `waiting_approval` and `waiting_input` thread states when Codex exposes blocked session state without a native protocol object
- replay queue behavior for `sessions.subscribe` with `from_seq` and `from_event_id` over sequenced in-memory event history

Operational `thread/*` and `turn/*` requests now lazily perform the required `initialize` handshake with `codex app-server`, so downstream callers do not need to call `client.initialize()` manually before using the service layer.

## Current capability behavior

- `session_start` is true because the adapter now implements `sessions.start` on top of `thread/start`
- `stream_events` and `notifications` are true when runtime notifications are observable
- `approval_requests` is true when `thread/read` is available because the adapter can surface either runtime-native approval notifications or host-derived blocked approval state from Codex session reads
- `approval_respond` is true when the adapter can route a response either through a native Codex approval method or through truthful blocked-session input fallback
- `diffs` and `artifacts` are true because the adapter derives metadata from `thread/read` turn items
- `replay` is true for in-memory subscribe replay behavior (`from_seq` / `from_event_id`) in the running service instance

The adapter does not fake unsupported runtime behavior: it prefers native Codex approval requests when they exist, derives blocked interactions only from observable thread state, and returns `UNSUPPORTED` or `CONFLICT` explicitly when a blocked request cannot be routed or is no longer pending.

## Blocked interaction behavior

- Native approval notifications still win over any derived approval for the same session.
- `sessions.get(include_pending_approvals=true)` can now populate a host-derived approval object for `waiting_approval` sessions even when Codex only exposes blocked status plus turn content.
- `sessions.get(include_pending_inputs=true)` can now populate a host-derived input request for `waiting_input` sessions.
- `sessions.send_input` accepts a `metadata.request_id` value for pending input requests so the adapter can enforce `CONFLICT` when that request is no longer pending.
- `approvals.respond` first tries native Codex approval methods and falls back to blocked-session message routing only when that is the truthful path available for the session.

## Validation

```bash
bash ../../tooling/scripts/validate_codex_adapter.sh
npm --workspace @ascp/adapter-codex run check
```

## Local WebSocket host and browser console

The adapter now includes a Codex-backed launch path for the reusable local ASCP WebSocket host service.

Start the host:

```bash
npm --workspace @ascp/adapter-codex run host
```

The host prints a JSON object with its WebSocket URL and defaults to `ws://127.0.0.1:8765`. It is intentionally local-only in this branch: single-user, no auth, no multi-client security boundary yet.

Start the separate Codex-first browser console:

```bash
npm --workspace @ascp/app-host-console run dev
```

The console exercises:

- `capabilities.get`
- `sessions.list`
- `sessions.get`
- `sessions.subscribe`
- `sessions.send_input`
- `approvals.list` and `approvals.respond`
- `artifacts.list` and `artifacts.get`
- `diffs.get`

This browser path uses the TypeScript SDK browser websocket transport rather than a one-off client, so it is a real SDK-backed proof of the hosted ASCP surface.

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

Expanded method-style smoke commands:

```bash
npm --workspace @ascp/adapter-codex run live -- sessions.subscribe codex:thread_id --snapshot
npm --workspace @ascp/adapter-codex run live -- watch codex:thread_id --input "summarize this" --snapshot
npm --workspace @ascp/adapter-codex run live -- sessions.subscribe codex:thread_id --from-seq 10
npm --workspace @ascp/adapter-codex run live -- sessions.subscribe codex:thread_id --from-event-id codex:event_id
npm --workspace @ascp/adapter-codex run live -- sessions.unsubscribe codex:subscription:thread_id:1
npm --workspace @ascp/adapter-codex run live -- approvals.respond codex:approval_id approved --note "smoke approval"
npm --workspace @ascp/adapter-codex run live -- artifacts.list codex:thread_id
npm --workspace @ascp/adapter-codex run live -- artifacts.get codex:artifact:thread_id:turn_id:item_id:0
npm --workspace @ascp/adapter-codex run live -- diffs.get codex:thread_id codex:thread_id:turn_id
```

For stream testing, use `watch` (or interactive `w`) to subscribe, optionally send input, and print drained events continuously until idle timeout inside one process. Subscription queues are in-memory, so separate CLI invocations do not share subscription state.

Short interactive guidance:

1. Run `npm --workspace @ascp/adapter-codex run live` and select a recent session.
2. Use `resume` or `send input` interactively to create fresh runtime activity.
3. Use the `w` action to watch stream events continuously, or `p` for manual subscribe+drain.
4. Finish with `sessions.unsubscribe` for the active subscription.

The live script rebuilds the adapter before launch so it runs against fresh local code.

When `send-input` targets a persisted Codex session from `sessions.list`, the adapter now reattaches that thread with `thread/resume` before starting a new turn. This keeps historical sessions usable in the live smoke flow instead of failing with a raw `thread not found` runtime error.
