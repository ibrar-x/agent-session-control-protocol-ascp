# Host Daemon Replay Persistence Design

**Date:** 2026-04-27
**Branch:** `branch-host-daemon`
**Status:** Draft for review

## Goal

Add a SQLite-backed replay and event persistence boundary to `services/host-daemon` so the daemon, not the Codex adapter, owns durable session baselines, stored event envelopes, and replay cursor state for attached sessions.

## Why This Slice

The current Codex path keeps replay history in adapter memory. That is useful for one running process, but it does not survive daemon restart and it mixes runtime truth with daemon infrastructure concerns.

This slice moves persistence and replay ownership up one layer:

- `adapters/codex` stays responsible for truthful runtime reads and event production
- `packages/host-service` stays responsible for WebSocket JSON-RPC transport and subscription routing
- `services/host-daemon` becomes responsible for durable session baselines, normalized event storage, cursor advancement, and replay serving

This keeps ASCP core semantics unchanged while making replay durable and daemon-scoped.

## Non-Goals

This slice does **not**:

- redesign ASCP methods, events, statuses, or capability names
- replace `packages/host-service`
- move transcript, approval, input, artifact, or diff derivation logic out of the adapter
- add relay transport
- add device pairing UX or full auth enforcement
- promise continuous capture for sessions the daemon has never attached to

## Scope

This slice adds:

- SQLite persistence inside `services/host-daemon`
- a daemon-owned `attachment_manager`
- a daemon-owned `event_store`
- a daemon-owned `session_store`
- a daemon-owned `cursor_store`
- a daemon-owned `replay_broker`
- seeding of truthful current session baselines from Codex reads on first attach
- additive snapshot metadata for completeness and attachment state

## Existing State

Today:

- `services/host-daemon` can start the reusable local ASCP host
- `adapters/codex/src/service.ts` owns in-memory subscription queues and replay history
- the host console already consumes truthful `sync.snapshot`, replay, transcript, approval, input, artifact, and diff flows

The current adapter replay queue is the behavior reference for this slice, not the storage boundary to keep.

## Core Rules

### 1. Truthful seeded baseline

A valid seeded baseline has this minimum floor:

- `session`
- `active_run` when truthfully present
- `pending_approvals`
- `pending_inputs`

If Codex cannot truthfully supply any of those, the daemon stores the snapshot as partial rather than pretending the missing fields are empty or complete.

### 2. Snapshot completeness metadata is a client-visible contract

Snapshot completeness metadata is not store-internal debugging data.

When `replay_broker` serves `sync.snapshot`, it includes additive daemon metadata:

- `snapshot_origin`: `"seeded_snapshot"` or `"live_stream"`
- `completeness`: `"complete"` or `"partial"`
- `missing_fields`: stable field-name list such as `active_run`, `pending_approvals`, `pending_inputs`
- `missing_reasons`: machine-readable reason keyed by missing field where known
- `attachment_status`: `"attached"` or `"detached"`

This metadata is additive downstream host behavior. It does not rewrite frozen ASCP core snapshot fields, and clients that do not understand it may ignore it safely.

### 3. Cursor origin is distinct from event sequence

A seeded snapshot is **not** treated as event zero.

Rules:

- the baseline snapshot is stored as current state, not replayed history
- cursor origin starts as `seeded_snapshot`
- session event sequence begins with the first real persisted `EventEnvelope`
- `sync.replayed` only describes replay of real stored envelopes, never synthetic seed history

This keeps downstream relay and replay consumers from confusing a seeded baseline with a real historical event stream.

### 4. Normalization ownership belongs to the attachment manager

Every inbound adapter event passes through one daemon normalization boundary before persistence.

Rules:

- `attachment_manager` always normalizes before persisting
- normalization may be a no-op for already-conformant envelopes
- `event_store` only accepts daemon-approved normalized `EventEnvelope`s

This removes per-event ambiguity about whether normalization happened.

### 5. Replay capture is daemon-wide, not subscriber-scoped

Attached sessions continue to persist events and advance cursors even when there are zero connected ASCP subscribers.

Rules:

- if a session is attached, live adapter events persist regardless of UI subscriber count
- if a session is indexed but detached, the daemon can only serve the last truthful seeded baseline plus `attachment_status: "detached"`
- clients must not treat detached seeded state as continuously updated live state

## Architecture

### `attachment_manager`

This is the first component built in the slice and the load-bearing boundary for everything else.

Responsibilities:

- decide when a session becomes daemon-attached
- read current session state from the adapter on first attach
- build the seeded baseline payload
- evaluate completeness and missing-field metadata
- write the baseline into `session_store`
- initialize cursor origin in `cursor_store`
- subscribe to live adapter events for attached sessions
- normalize every inbound event
- append normalized events to `event_store`
- advance durable cursor state after persistence
- keep capture running even with zero external subscribers

This component must be verified before any replay broker subscribe path is built.

### `session_store`

Stores one latest baseline record per session.

Fields:

- `session_id`
- `runtime_id`
- `session_json`
- `active_run_json`
- `pending_approvals_json`
- `pending_inputs_json`
- `snapshot_origin`
- `completeness`
- `missing_fields_json`
- `missing_reasons_json`
- `attachment_status`
- `seeded_at`
- `updated_at`

### `event_store`

Append-only store for normalized `EventEnvelope`s.

Fields:

- `session_id`
- `seq`
- `event_id`
- `event_type`
- `event_ts`
- `event_json`
- `persisted_at`

Rules:

- unique key on `session_id + seq`
- unique key on `event_id`
- only real normalized envelopes are stored here
- no synthetic snapshot-as-history row

### `cursor_store`

Stores durable replay position and origin metadata.

Fields:

- `session_id`
- `origin`
- `last_seq`
- `last_event_id`
- `cursor_json`
- `updated_at`

`origin` values for this slice:

- `seeded_snapshot`
- `live_stream`

### `replay_broker`

Reads from daemon persistence and serves replay to host-service-facing session subscription flows.

Responsibilities:

- build the `sync.snapshot` payload from `session_store`
- include completeness and attachment metadata in that snapshot payload
- resolve replay from `from_seq` or `from_event_id` using `event_store`
- emit `sync.replayed` after replayed real envelopes
- fan out newly persisted live events to active transport subscribers

`replay_broker` must not own live event capture. It only serves what `attachment_manager` and the stores already made durable.

## Data Flow

### A. First attach

1. daemon decides to attach a session
2. `attachment_manager` calls truthful adapter read APIs
3. `attachment_manager` builds baseline state with:
   - `session`
   - `active_run`
   - `pending_approvals`
   - `pending_inputs`
4. `attachment_manager` computes:
   - `snapshot_origin = seeded_snapshot`
   - `completeness`
   - `missing_fields`
   - `missing_reasons`
   - `attachment_status = attached`
5. `session_store` persists the baseline
6. `cursor_store` initializes origin metadata with no fake event sequence
7. `attachment_manager` opens live event capture for that session

### B. Live capture

1. adapter emits event or notification-derived envelope
2. `attachment_manager` normalizes it
3. `event_store` appends normalized envelope
4. `cursor_store` advances `last_seq` and `last_event_id`
5. `session_store` may update latest session-side derived state if the event changes current snapshot material
6. `replay_broker` may fan out to active subscribers

This path must work with zero connected subscribers.

### C. Subscribe and replay

1. subscriber calls `sessions.subscribe`
2. `replay_broker` loads baseline from `session_store`
3. `replay_broker` emits `sync.snapshot` with additive completeness and attachment metadata
4. `replay_broker` loads matching real envelopes from `event_store`
5. `replay_broker` emits replayed envelopes in stored order
6. `replay_broker` emits `sync.replayed`
7. `replay_broker` continues live fanout from newly persisted events

### D. Indexed but detached session

1. session exists in `session_store`
2. daemon is not currently attached
3. `replay_broker` may still serve the last truthful baseline
4. the snapshot metadata includes:
   - `attachment_status = detached`
   - `snapshot_origin`
   - `completeness`
5. clients can distinguish detached last-known state from actively refreshed attached state

## Capability and Protocol Behavior

This slice does not rename or redesign any ASCP surface.

Expected protocol behavior remains:

- `sessions.subscribe` still yields `sync.snapshot`, replayed real events, and `sync.replayed`
- `sync.snapshot` remains current-state material, not replayed history
- replay ordering remains per stored `seq`
- unknown additive metadata remains safe to ignore

Capability claims:

- `replay=true` remains truthful only for sessions with daemon-backed replay storage
- if a session has only a detached seeded baseline and no real stored events, the daemon may still serve `sync.snapshot` truthfully but must advertise replay for that session as effectively unavailable until real stored events exist
- implementation rule for this slice: detached-only seeded sessions are treated as `replay=false` for truthful behavior, even if the daemon can still return a baseline snapshot

## SQLite Shape

Suggested tables for this slice:

- `daemon_sessions`
- `daemon_session_events`
- `daemon_session_cursors`
- optionally `daemon_attachments` if attachment lifecycle state becomes noisy enough to split from `daemon_sessions`

This slice should use straightforward JSON columns for stored protocol objects rather than prematurely normalizing every field into relational columns.

## Build Order

This order is mandatory for the slice.

### Milestone 1: attachment manager and stores

Deliver:

- SQLite connection/bootstrap
- `session_store`
- `event_store`
- `cursor_store`
- `attachment_manager`

Verification:

- attach to a session
- persist seeded baseline
- persist new live events
- advance durable cursor state
- do all of that with zero external subscribers

### Milestone 2: replay broker integration

Deliver:

- `replay_broker`
- host-daemon wiring from `sessions.subscribe` to daemon persistence-backed replay
- additive snapshot metadata

Verification:

- subscribe receives seeded snapshot
- replay comes from `event_store`, not adapter memory
- `sync.replayed` boundaries remain truthful

### Milestone 3: detached baseline behavior and docs

Deliver:

- indexed-but-detached session serving rules
- README and branch checkpoint updates
- focused tests for partial seeds and detached baselines

Verification:

- detached session snapshot includes `attachment_status=detached`
- partial seeded snapshot includes completeness metadata

## File Boundaries

Planned additions inside `services/host-daemon/src/`:

- `sqlite.ts` — SQLite connection/bootstrap
- `stores/session-store.ts`
- `stores/event-store.ts`
- `stores/cursor-store.ts`
- `attachment-manager.ts`
- `replay-broker.ts`
- `metadata.ts` — completeness and attachment metadata builders

Likely modifications:

- `services/host-daemon/src/main.ts`
- `services/host-daemon/src/index.ts`
- `services/host-daemon/README.md`
- `internal/plans.md`
- `internal/status.md`

Likely tests:

- `services/host-daemon/tests/session-store.test.ts`
- `services/host-daemon/tests/event-store.test.ts`
- `services/host-daemon/tests/cursor-store.test.ts`
- `services/host-daemon/tests/attachment-manager.test.ts`
- `services/host-daemon/tests/replay-broker.test.ts`
- `services/host-daemon/tests/integration-replay.test.ts`

## Risks and Guards

### Risk: stale partial seed presented as authoritative

Guard:

- completeness metadata is always included in served snapshots
- detached state is always surfaced separately through `attachment_status`

### Risk: synthetic seed pollutes replay semantics

Guard:

- seed baseline stays in `session_store`
- only real envelopes enter `event_store`

### Risk: adapter and daemon both claim replay ownership

Guard:

- daemon becomes the durable replay source for attached sessions
- adapter remains the runtime event and state truth source

### Risk: subscriber presence accidentally controls capture

Guard:

- `attachment_manager` persists events independent of subscriber count

## Definition of Done

This design slice is done when:

- daemon-attached sessions persist truthful seeded baselines into SQLite
- daemon-attached sessions persist normalized live `EventEnvelope`s into SQLite
- durable cursor state advances without subscriber presence
- `sessions.subscribe` serves seeded baseline plus persistence-backed replay through daemon infrastructure
- partial and detached state are visible to clients through additive snapshot metadata
- no ASCP core method or event semantics are rewritten
