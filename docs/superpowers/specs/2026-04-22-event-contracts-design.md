# Event Contracts Design

## Summary

This design defines the `feature/event-contracts` branch for ASCP. The branch will add a dedicated event-contract schema, one concrete `EventEnvelope` fixture per core event type, a normative event-support document, and a repeatable validator that proves the event payload catalog is exact and schema-valid.

## Motivation

The schema foundation and method-contract branches froze the shared nouns, envelopes, and method triggers. The next protocol slice is to make the observable stream surface exact, because replay, reconnect, approvals, transcript rendering, artifact review, and compatibility claims all depend on stable event payloads rather than inferred or runtime-specific shapes.

## Scope

Included in this branch:

- `EventEnvelope`-based contracts for every core event named in the detailed spec
- exact payload definitions for session lifecycle, run lifecycle, transcript, tool activity, terminal fallback, approval, artifact and diff, sync and connectivity, and error events
- schema-valid event fixtures under `examples/events/`
- validation tooling for the event schema and fixtures
- event support documentation tied to compatibility and replay-safe behavior

Explicitly out of scope:

- replay retention policy behavior
- replay storage implementation
- sequence generation algorithms
- auth middleware behavior beyond event fields already required by the spec
- mock-server streaming logic

## Protocol Impact

The branch must preserve these rules from the source specs:

- every streamed event is an `EventEnvelope`
- `seq` remains monotonic per session stream when replay is supported
- snapshots are current-state material and must not masquerade as replayed history
- replayed events preserve original ordering where ordering exists
- clients may resume with `from_seq`, `from_event_id`, or an opaque cursor when supported
- if replay cannot be supported safely, capability `replay` must be `false`

The branch will also freeze exact payloads for these concrete event types:

- `session.created`
- `session.updated`
- `session.status_changed`
- `session.deleted`
- `run.started`
- `run.paused`
- `run.resumed`
- `run.completed`
- `run.failed`
- `run.cancelled`
- `message.user`
- `message.assistant.started`
- `message.assistant.delta`
- `message.assistant.completed`
- `message.system`
- `tool.started`
- `tool.stdout`
- `tool.stderr`
- `tool.completed`
- `tool.failed`
- `terminal.opened`
- `terminal.output`
- `terminal.closed`
- `terminal.resize_requested`
- `approval.requested`
- `approval.updated`
- `approval.approved`
- `approval.rejected`
- `approval.expired`
- `artifact.created`
- `artifact.updated`
- `diff.ready`
- `diff.updated`
- `connection.state_changed`
- `sync.snapshot`
- `sync.replayed`
- `sync.cursor_advanced`
- `error.transient`
- `error.fatal`

## Architecture

The implementation will add one canonical schema file at `schema/ascp-events.schema.json`. That file will reuse `ascp-core.schema.json` for shared nouns such as `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, and the base `EventEnvelope` fields, then narrow `payload` by event type through explicit per-event definitions.

Fixtures will live in `examples/events/` as one file per concrete event. This keeps the future conformance layer simple because validators and golden event streams can refer to stable event names and individual example files without reconstructing compound documents.

Normative event notes will live in `spec/events.md`. That document should explain event families, payload constraints, compatibility expectations, and the replay-safe distinction between live events, replayed history, and `sync.snapshot`.

## File Layout

Files to create:

- `schema/ascp-events.schema.json`
- `spec/events.md`
- `scripts/validate_event_contracts.sh`
- `examples/events/session-created.json`
- `examples/events/session-updated.json`
- `examples/events/session-status-changed.json`
- `examples/events/session-deleted.json`
- `examples/events/run-started.json`
- `examples/events/run-paused.json`
- `examples/events/run-resumed.json`
- `examples/events/run-completed.json`
- `examples/events/run-failed.json`
- `examples/events/run-cancelled.json`
- `examples/events/message-user.json`
- `examples/events/message-assistant-started.json`
- `examples/events/message-assistant-delta.json`
- `examples/events/message-assistant-completed.json`
- `examples/events/message-system.json`
- `examples/events/tool-started.json`
- `examples/events/tool-stdout.json`
- `examples/events/tool-stderr.json`
- `examples/events/tool-completed.json`
- `examples/events/tool-failed.json`
- `examples/events/terminal-opened.json`
- `examples/events/terminal-output.json`
- `examples/events/terminal-closed.json`
- `examples/events/terminal-resize-requested.json`
- `examples/events/approval-requested.json`
- `examples/events/approval-updated.json`
- `examples/events/approval-approved.json`
- `examples/events/approval-rejected.json`
- `examples/events/approval-expired.json`
- `examples/events/artifact-created.json`
- `examples/events/artifact-updated.json`
- `examples/events/diff-ready.json`
- `examples/events/diff-updated.json`
- `examples/events/connection-state-changed.json`
- `examples/events/sync-snapshot.json`
- `examples/events/sync-replayed.json`
- `examples/events/sync-cursor-advanced.json`
- `examples/events/error-transient.json`
- `examples/events/error-fatal.json`

Files to modify:

- `plans.md`
- `docs/status.md`

## Design Decisions

### Envelope layering

The base `EventEnvelope` stays in `ascp-core.schema.json` because it is a canonical shared object. The event-contract schema will not redefine it loosely. Instead it will build event-specific envelope definitions that inherit the base fields and then bind `type` plus the matching `payload`.

### Exact payloads without over-closing shared nouns

Shared nouns such as `Session` and `ApprovalRequest` stay additive because previous branches intentionally left them extensible. Event payload wrappers, however, should be explicit and closed so the protocol can validate the exact top-level shape for each event without restating every nested shared object.

### Replay-safe sync events

`sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced` belong in this branch because they are named event types with exact payloads. The branch will document their payloads and contract boundaries, but it will not implement retention rules, replay stores, or live replay algorithms.

### Compatibility documentation

`spec/events.md` should make support claims explicit:

- `ASCP Core Compatible` requires event envelope support
- `ASCP Interactive` requires live event subscriptions
- `ASCP Approval-Aware` requires approval events
- `ASCP Artifact-Aware` requires artifact and diff events
- `ASCP Replay-Capable` requires replay-safe sync events and documented replay behavior notes

## Validation Strategy

Validation should mirror the existing method-contract workflow:

- use a small shell entrypoint in `scripts/validate_event_contracts.sh`
- use `python3` plus `jsonschema`
- load the shared core, capability, error, method, and event schemas into one resolver store
- validate each fixture against its concrete event-envelope definition
- fail with per-file, per-path messages when a fixture drifts

## Risks And Controls

Risk: mixing snapshot state with replayed history.
Control: document and validate `sync.snapshot` separately from replay markers, and avoid any payload fields that imply historical sequencing inside snapshots.

Risk: event fixtures drift from the exact event names in the detailed spec.
Control: keep one fixture per event type with filenames derived directly from the event name and list them in `spec/events.md`.

Risk: duplicate or incompatible definitions for shared fields.
Control: reuse the canonical nouns and base envelope from the frozen schema foundation instead of copying fields into the event schema.

## Follow-Up

After this branch lands, the next feature should be replay semantics. That branch can build on the locked event contracts to define cursor behavior, sequence handling expectations, replay retention notes, and later replay conformance tests without reopening event payload shapes.
