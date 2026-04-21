# ASCP Replay Semantics

This document freezes the `feature/replay-semantics` branch. It defines the replay, reconnect, snapshot, cursor, and retention-limit rules that sit on top of the frozen method and event contracts without reopening event payload shapes, auth policy design, or mock-server implementation.

## Scope And Dependency

Replay semantics depend on the frozen method and event-contract outputs:

- `schema/ascp-methods.schema.json`
- `schema/ascp-events.schema.json`
- `spec/methods.md`
- `spec/events.md`
- replay-relevant examples under `examples/requests/`, `examples/responses/`, `examples/errors/`, and `examples/events/`

This branch does not redefine the request envelopes for `sessions.resume` or `sessions.subscribe`, and it does not redefine the sync event payloads. Instead it makes their reconnect and replay behavior explicit and testable.

## Capability Gate

- `ASCP Replay-Capable` requires `capabilities.replay=true`.
- Hosts that cannot safely replay ordered history MUST advertise `capabilities.replay=false`.
- A replay-capable host MUST support `from_seq` or a documented equivalent cursor path.
- `from_event_id` is a core request option on `sessions.subscribe`.
- Opaque cursors are implementation-defined. Because the frozen core `sessions.subscribe` params do not define a `cursor` field, opaque-cursor support must be documented as an additive extension or transport-specific resume token rather than inferred silently.

## Replay Entry Points

### `sessions.resume`

`sessions.resume` reattaches control state to an existing session. Its success result carries:

- `session`
- `snapshot_emitted`
- `replay_supported`

`sessions.resume` does not replace streamed replay. A reconnecting client uses it to confirm the session still exists, discover whether replay is supported, and learn whether the host has already emitted an immediate snapshot on the active transport.

If `replay_supported=false`, the client must not assume replay is available later in the flow.

### `sessions.subscribe`

`sessions.subscribe` is the stream entry point for replay and live continuation. Its frozen core params allow:

- `session_id`
- `from_seq`
- `from_event_id`
- `include_snapshot`

After a successful subscribe response, `EventEnvelope` objects begin streaming on the active transport. Replay, snapshots, and live continuation all happen on that stream surface.

## Reconnect Flows

### Subscribe-first recovery

Use this flow when the client already knows the target session and reconnect point.

1. client reconnects transport
2. client calls `sessions.subscribe`
3. host returns a subscribe success response
4. host optionally emits `sync.snapshot` when `include_snapshot=true` or the host requires current-state context
5. host emits replayed historical event envelopes in original order
6. host emits `sync.replayed`
7. host continues with live event envelopes
8. host may emit `sync.cursor_advanced` when it supports opaque resume tokens

### Resume-then-subscribe recovery

Use this flow when the client needs to confirm session availability before resubscribing.

1. client calls `sessions.resume`
2. host returns `session`, `snapshot_emitted`, and `replay_supported`
3. if the session remains interactive and replay is supported, the client calls `sessions.subscribe`
4. replay and live continuation then follow the subscribe-first rules above

The resume response is not a substitute for replayed event history. It is an attachment confirmation and capability hint.

## Ordering Rules

- Replayed history MUST preserve original event ordering where ordering exists.
- Historical event envelopes MUST keep their original `id`, `type`, `ts`, and payload content.
- When replay uses `seq`, the replayed historical segment MUST advance monotonically and MUST NOT reuse sequence numbers within that segment.
- `sync.replayed.payload.event_count` counts only replayed historical event envelopes. It does not count `sync.snapshot`, `sync.replayed`, or `sync.cursor_advanced`.
- `sync.replayed.payload.from_seq` and `to_seq` describe the replayed historical segment only.
- Live continuation events that carry `seq` should advance beyond the replayed `to_seq`.

## Snapshot Rules

- `sync.snapshot` describes current session state at the time of recovery.
- A snapshot is current-state material, not historical replay.
- A host may emit `sync.snapshot` before replayed history when the client asks for `include_snapshot=true` or the host requires current-state context.
- Snapshot payloads should include current session state, current active run when present, and current pending approvals.
- Snapshot payloads must not be interpreted as replayed historical events, even if the snapshot includes a `seq` field representing the current stream high-water mark.

The important distinction is transport order versus historical order:

- transport order may be `sync.snapshot`, then replayed history, then `sync.replayed`, then live events
- historical order still belongs only to the replayed historical events themselves

## Cursor Semantics

### `from_seq`

- `from_seq` is an inclusive lower bound for replay by sequence number
- the first replayed historical event should have `seq >= from_seq`
- if the requested `from_seq` is still retained and replayable, the host should begin replay from the earliest retained event at or above that sequence

### `from_event_id`

- `from_event_id` is an exclusive anchor
- the host should replay events that occur after the identified event
- if the identified event is no longer retained, retention-limit rules apply

### Opaque cursors

- opaque cursors are implementation-defined resume tokens
- they do not change the meaning of the core `from_seq` or `from_event_id` fields
- because the frozen core `sessions.subscribe` schema does not define a cursor param, opaque-cursor support must be documented as an additive extension or transport-specific token path
- when a host supports opaque cursors, it should emit `sync.cursor_advanced` with the latest usable token after replay or live advancement changes the best reconnect point

Opaque cursors are an implementation convenience layer, not a redefinition of the core replay semantics.

## `sync.replayed` And `sync.cursor_advanced`

### `sync.replayed`

`sync.replayed` marks the boundary between replayed historical history and resumed live streaming.

Rules:

- emit it after the replayed historical segment finishes
- do not use it as a replacement for the historical event envelopes themselves
- keep its payload aligned with the actual replayed segment:
  - `from_seq` equals the first replayed historical `seq` when sequence replay is used
  - `to_seq` equals the last replayed historical `seq`
  - `event_count` equals the number of replayed historical event envelopes

### `sync.cursor_advanced`

`sync.cursor_advanced` communicates the latest opaque reconnect token when the host supports opaque cursors.

Rules:

- it may appear after replay, after live continuation advances the reconnect point, or both
- it is not a historical event replacement
- it does not change the meaning of `seq`

## Retention And Replay Limits

Replay may be bounded by retention policy. A host is not required to retain every historical event forever.

When the requested replay window is no longer available, allowed behaviors are:

- snapshot-only recovery when the host can still provide current state safely
- a replay-related method error with explanatory details

Allowed replay-related method errors for this branch are:

- `TRANSIENT_UNAVAILABLE`
- `UNSUPPORTED`

The error details should explain why the requested recovery point cannot be served, for example:

- requested replay floor is older than the retained history window
- replay store is temporarily warming or unavailable
- this runtime supports live subscriptions but not historical replay

Retention behavior must be explicit enough that clients can distinguish:

- history replay succeeded
- only current-state recovery is possible
- replay is temporarily unavailable
- replay is unsupported on this host or runtime

## Compatibility Notes

`ASCP Replay-Capable` depends on these rules:

- replay support is advertised honestly
- replayed history keeps original ordering and content
- snapshots remain current-state material
- `sync.replayed` marks replay completion before live continuation
- cursor behavior is documented for `from_seq`, `from_event_id`, and any opaque token path the implementation exposes
- retention-limit behavior is documented without guessing

## Conformance Material In This Branch

This branch adds:

- replay fixture manifests under `conformance/fixtures/replay/`
- replay-specific validation in `conformance/tests/validate_replay_semantics.py`
- a shell entrypoint at `scripts/validate_replay_semantics.sh`

Those assets make the replay rules executable without broadening the full conformance program yet.
