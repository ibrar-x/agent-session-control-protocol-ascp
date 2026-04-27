# Replay Semantics Design

## Summary

This design defines the `feature/replay-semantics` branch for ASCP. The branch will add a normative replay document, replay-oriented fixture streams, and a minimal conformance slice that makes reconnect, snapshot, ordering, cursor, and retention-limit behavior explicit and testable without widening into auth-policy design or mock-server implementation.

## Motivation

The schema-foundation, method-contract, and event-contract branches froze the nouns, method triggers, and event payloads. The next protocol slice is to define how a reconnecting client safely returns to a session stream without guessing event order, snapshot meaning, or cursor advancement behavior.

## Scope

Included in this branch:

- normative replay and sync semantics in `spec/replay.md`
- explicit reconnect flow from `sessions.resume` or `sessions.subscribe` through replay and live continuation
- cursor rules for `from_seq`, `from_event_id`, and opaque cursors
- retention-limit and replay-fallback behavior
- replay-oriented fixture streams and minimal conformance validation

Explicitly out of scope:

- auth middleware policy beyond replay-related error behavior
- broad conformance program design outside replay coverage
- mock-server transport or storage implementation
- new core event types or reopened event payload contracts

## Protocol Impact

The branch must preserve these rules from the source specs:

- implementations claiming `replay=true` must support replay by `from_seq` or an equivalent cursor
- replay preserves original event ordering within a session where ordering exists
- historical event content must not be mutated during replay
- snapshots describe current state and must not masquerade as history
- `sync.replayed` marks the replay boundary before live continuation
- opaque cursors may be implementation-defined but must advance through `sync.cursor_advanced` when supported
- if replay cannot be provided safely, `capabilities.replay` must be `false`

## Architecture

The normative protocol write-up will live in `spec/replay.md` to match the detailed spec's suggested repository shape. That document will define reconnect flows, ordering guarantees, snapshot boundaries, cursor interpretation, retention behavior, and replay-capable compatibility expectations.

Replay fixtures will live under `conformance/fixtures/replay/` as multi-event stream documents rather than individual event examples. This keeps the fixture layer focused on ordered stream behavior and avoids overloading `examples/events/`, which already serves as the single-event illustrative catalog.

Validation will use a small shell entrypoint backed by `python3` and `jsonschema`, reusing the existing schema files and event examples where needed. The replay validator will assert sequence monotonicity, allowed replay markers, snapshot placement, cursor advancement behavior, and documented retention-limit outcomes.

## File Layout

Files to create:

- `spec/replay.md`
- `conformance/fixtures/replay/subscribe-with-snapshot.json`
- `conformance/fixtures/replay/subscribe-from-seq.json`
- `conformance/fixtures/replay/subscribe-from-event-id.json`
- `conformance/fixtures/replay/subscribe-with-opaque-cursor.json`
- `conformance/fixtures/replay/replay-retention-fallback.json`
- `conformance/tests/validate_replay_semantics.py`
- `scripts/validate_replay_semantics.sh`
- `docs/superpowers/specs/2026-04-22-replay-semantics-design.md`
- `docs/superpowers/plans/2026-04-22-replay-semantics.md`

Files to modify:

- `plans.md`
- `docs/status.md`

## Design Decisions

### Conformance slice now

Replay is the first feature where ordered multi-event streams are part of the contract, so a minimal `conformance/` tree is justified now. The branch will keep that slice intentionally narrow to replay semantics only.

### Snapshot versus history

`sync.snapshot` remains current-state material and is not counted as historical replay, even when emitted before replayed events. Replay fixtures must show that snapshot payloads are bounded current-state views while replayed history continues to use the original event envelopes and sequence values.

### Cursor model

The branch will not invent a new cursor object schema. Instead it will document how `from_seq`, `from_event_id`, and opaque cursors affect replay eligibility and stream start position, then express those rules through fixture metadata and validation checks.

### Retention-limited behavior

When a requested replay window is no longer available, hosts may respond with snapshot-only recovery or an allowed replay failure such as `TRANSIENT_UNAVAILABLE` or `UNSUPPORTED` with explanatory details. The branch will make those outcomes explicit and testable without defining storage internals.

## Validation Strategy

Validation should prove the replay semantics rather than just file presence:

- fixture manifests identify the recovery request shape and expected outcome
- success fixtures assert ordered event sequences, replay boundaries, and live continuation markers
- retention fixtures assert only the allowed fallback outcomes from the spec
- validation reuses the frozen event-contract examples for payload expectations where practical

## Risks And Controls

Risk: replay fixtures drift into redefining event payloads.
Control: keep replay fixtures composed from already-frozen event types and document that payload contracts remain owned by `schema/ascp-events.schema.json`.

Risk: snapshot semantics become ambiguous.
Control: require validators to reject fixtures that treat `sync.snapshot` as a replayed history count or place `sync.replayed` before replayed history finishes.

Risk: retention behavior gets specified too narrowly.
Control: constrain retention outcomes to the spec-allowed set while leaving storage policy and retention duration out of scope.

## Follow-Up

After this branch lands, the next protocol slice should be auth and approvals or the broader conformance branch. Both will be able to build on the replay docs and fixtures without reopening the replay contract surface.
