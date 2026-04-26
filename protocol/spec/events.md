# ASCP Event Contracts

This document freezes the `feature/event-contracts` branch. It defines the exact `EventEnvelope` payload contracts for every core ASCP event type without widening into replay implementation, auth middleware behavior, or mock-server logic.

## Scope And Dependency

These contracts depend on the frozen schema-foundation and method-contract outputs:

- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-errors.schema.json`
- `schema/ascp-methods.schema.json`
- `spec/methods.md`
- canonical examples under `examples/core/`, `examples/capabilities/`, `examples/errors/`, and `examples/events/`
- `docs/schema-foundation.md`

The event-contract schema must reuse those nouns and shared envelopes. It must not redefine `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, or the base `EventEnvelope` loosely.

## Event Families

- session lifecycle
- run lifecycle
- transcript
- input requests
- tool activity
- terminal fallback
- approvals
- artifacts and diffs
- sync and connectivity
- errors

## Contract Rules

- every streamed event MUST be an `EventEnvelope`
- `type` values MUST exactly match the detailed spec
- `payload` wrapper shapes are explicit and closed per event type
- shared canonical nouns remain additive and are reused rather than copied
- snapshots describe current state and MUST NOT masquerade as replayed history
- replay markers describe stream progress and MUST NOT replace historical event envelopes
- unknown event types remain safe to ignore under the protocol versioning rules, but the core compatibility set below is normative for ASCP v0.1

## Schema And Example Layout

- event schema: `schema/ascp-events.schema.json`
- event fixtures: `examples/events/`
- validation command: `./scripts/validate_event_contracts.sh`

## Event Catalog

| Event Type | Schema Definition | Example File |
| --- | --- | --- |
| `session.created` | `#/$defs/SessionCreatedEvent` | `examples/events/session-created.json` |
| `session.updated` | `#/$defs/SessionUpdatedEvent` | `examples/events/session-updated.json` |
| `session.status_changed` | `#/$defs/SessionStatusChangedEvent` | `examples/events/session-status-changed.json` |
| `session.deleted` | `#/$defs/SessionDeletedEvent` | `examples/events/session-deleted.json` |
| `run.started` | `#/$defs/RunStartedEvent` | `examples/events/run-started.json` |
| `run.paused` | `#/$defs/RunPausedEvent` | `examples/events/run-paused.json` |
| `run.resumed` | `#/$defs/RunResumedEvent` | `examples/events/run-resumed.json` |
| `run.completed` | `#/$defs/RunCompletedEvent` | `examples/events/run-completed.json` |
| `run.failed` | `#/$defs/RunFailedEvent` | `examples/events/run-failed.json` |
| `run.cancelled` | `#/$defs/RunCancelledEvent` | `examples/events/run-cancelled.json` |
| `message.user` | `#/$defs/MessageUserEvent` | `examples/events/message-user.json` |
| `message.assistant.started` | `#/$defs/MessageAssistantStartedEvent` | `examples/events/message-assistant-started.json` |
| `message.assistant.delta` | `#/$defs/MessageAssistantDeltaEvent` | `examples/events/message-assistant-delta.json` |
| `message.assistant.completed` | `#/$defs/MessageAssistantCompletedEvent` | `examples/events/message-assistant-completed.json` |
| `message.system` | `#/$defs/MessageSystemEvent` | `examples/events/message-system.json` |
| `input.requested` | `#/$defs/InputRequestedEvent` | `examples/events/input-requested.json` |
| `input.completed` | `#/$defs/InputCompletedEvent` | `examples/events/input-completed.json` |
| `input.expired` | `#/$defs/InputExpiredEvent` | `examples/events/input-expired.json` |
| `tool.started` | `#/$defs/ToolStartedEvent` | `examples/events/tool-started.json` |
| `tool.stdout` | `#/$defs/ToolStdoutEvent` | `examples/events/tool-stdout.json` |
| `tool.stderr` | `#/$defs/ToolStderrEvent` | `examples/events/tool-stderr.json` |
| `tool.completed` | `#/$defs/ToolCompletedEvent` | `examples/events/tool-completed.json` |
| `tool.failed` | `#/$defs/ToolFailedEvent` | `examples/events/tool-failed.json` |
| `terminal.opened` | `#/$defs/TerminalOpenedEvent` | `examples/events/terminal-opened.json` |
| `terminal.output` | `#/$defs/TerminalOutputEvent` | `examples/events/terminal-output.json` |
| `terminal.closed` | `#/$defs/TerminalClosedEvent` | `examples/events/terminal-closed.json` |
| `terminal.resize_requested` | `#/$defs/TerminalResizeRequestedEvent` | `examples/events/terminal-resize-requested.json` |
| `approval.requested` | `#/$defs/ApprovalRequestedEvent` | `examples/events/approval-requested.json` |
| `approval.updated` | `#/$defs/ApprovalUpdatedEvent` | `examples/events/approval-updated.json` |
| `approval.approved` | `#/$defs/ApprovalApprovedEvent` | `examples/events/approval-approved.json` |
| `approval.rejected` | `#/$defs/ApprovalRejectedEvent` | `examples/events/approval-rejected.json` |
| `approval.expired` | `#/$defs/ApprovalExpiredEvent` | `examples/events/approval-expired.json` |
| `artifact.created` | `#/$defs/ArtifactCreatedEvent` | `examples/events/artifact-created.json` |
| `artifact.updated` | `#/$defs/ArtifactUpdatedEvent` | `examples/events/artifact-updated.json` |
| `diff.ready` | `#/$defs/DiffReadyEvent` | `examples/events/diff-ready.json` |
| `diff.updated` | `#/$defs/DiffUpdatedEvent` | `examples/events/diff-updated.json` |
| `connection.state_changed` | `#/$defs/ConnectionStateChangedEvent` | `examples/events/connection-state-changed.json` |
| `sync.snapshot` | `#/$defs/SyncSnapshotEvent` | `examples/events/sync-snapshot.json` |
| `sync.replayed` | `#/$defs/SyncReplayedEvent` | `examples/events/sync-replayed.json` |
| `sync.cursor_advanced` | `#/$defs/SyncCursorAdvancedEvent` | `examples/events/sync-cursor-advanced.json` |
| `error.transient` | `#/$defs/ErrorTransientEvent` | `examples/events/error-transient.json` |
| `error.fatal` | `#/$defs/ErrorFatalEvent` | `examples/events/error-fatal.json` |

## Event Notes

### Session lifecycle

- `session.created` carries a normalized `Session` object at creation time.
- `session.updated` carries a partial session view plus `changed_fields`, so clients can update summary state without guessing full-session diffs.
- `session.status_changed` is intentionally narrower than `session.updated`; it isolates status transitions for clients that only need state progression.
- `session.deleted` records removal intent without inventing a tombstone object.

### Run lifecycle

- `run.started` carries the canonical `Run` object.
- `run.paused`, `run.resumed`, `run.completed`, `run.failed`, and `run.cancelled` all bind to `run_id` rather than replaying the full `Run` object every time.
- `run.failed` uses protocol error codes in `error_code` so client handling stays aligned with the frozen error catalog.

### Transcript

- transcript events carry stable `message_id` values so clients can stitch incremental output together without transport-specific logic
- `message.assistant.delta` is the streaming fragment event
- `message.assistant.completed` carries the finalized content for the same assistant message

### Input requests

- `input.requested` carries the canonical `InputRequest`
- `input.completed` records that a pending input request was answered or otherwise satisfied
- `input.expired` records that a pending input request can no longer be answered successfully
- adapters own the inference that maps runtime-native blocked-question signals into `input_type`; the protocol only freezes the resulting values and event payload shape

### Tool activity

- tool events normalize non-transcript execution into `tool_call_id`, `tool_name`, output chunks, and completion state
- PTY fallback remains a separate family and must not replace normalized tool events where the runtime can provide them

### Terminal fallback

- terminal events are for fallback transport when normalized tool activity is not sufficient
- terminal output remains wrapped in `EventEnvelope`; PTY fallback is not an excuse to skip the event envelope contract

### Approval events

- `approval.requested` carries the canonical `ApprovalRequest`
- status-change approval events carry explicit attribution and timestamps where the detailed spec requires them
- these events are the stream surface for `ASCP Approval-Aware` implementations and stay separate from the method contracts for `approvals.list` and `approvals.respond`

### Artifacts And Diffs

- `artifact.created` and `artifact.updated` are metadata-only signals
- `diff.ready` and `diff.updated` provide summary metadata only; full patch bodies remain outside this branch

### Sync And Connectivity

- `connection.state_changed` carries one of `connected`, `disconnected`, `reconnecting`, or `reconnected`
- `sync.snapshot` carries current session state, optional `active_run`, pending approvals, and pending inputs; it is current-state material, not replay history
- `sync.replayed` marks the boundary between historical replay and resumed live streaming
- `sync.cursor_advanced` is the stream-side hook for opaque replay cursors when implementations advertise them

### Errors

- `error.transient` communicates retry-relevant stream issues without terminating the session view
- `error.fatal` communicates stream-visible failure that clients should treat as terminal for the affected session or connection surface

## Compatibility Notes

| Compatibility Level | Event Requirement |
| --- | --- |
| `ASCP Core Compatible` | support `EventEnvelope` plus the core event taxonomy needed to observe session state |
| `ASCP Interactive` | support live event subscriptions and the interactive families needed for transcript, run, input-request, tool, or terminal streaming |
| `ASCP Approval-Aware` | support `approval.requested`, `approval.updated`, `approval.approved`, `approval.rejected`, and `approval.expired` |
| `ASCP Artifact-Aware` | support `artifact.created`, `artifact.updated`, `diff.ready`, and `diff.updated` |
| `ASCP Replay-Capable` | support replay-safe sync events, replay markers, and documented snapshot versus replay behavior |

`ASCP Replay-Capable` specifically depends on these event rules:

- `sync.snapshot` is current state only
- replayed history keeps its original event payloads and ordering
- `sync.replayed` marks the end of the replay segment
- `sync.cursor_advanced` is the protocol hook for opaque cursor advancement where supported

## Follow-Up

The next branch should build replay semantics on top of this locked event surface. That work can define cursor handling, retention behavior, and replay conformance tests without reopening the event payload catalog.
