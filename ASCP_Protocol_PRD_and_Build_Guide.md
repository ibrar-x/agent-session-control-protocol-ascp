# ASCP Protocol — Protocol-Only PRD and Build Guide

Version: 1.0
Date: 2026-04-21

## 1. Purpose

This file is only about the protocol.

It is not the startup product plan.
It is not the platform or ecosystem plan.
It is not the mobile app build plan.

It answers one question:

> How do we define, structure, version, validate, secure, and publish the ASCP protocol itself?

Use this file as:
- a protocol PRD
- a spec-writing brief
- a build guide for AI coding agents
- a checklist for turning the idea into a real protocol

---

## 2. Core Problem

The agent ecosystem is fragmented.

Some runtimes expose:
- session resume
- streamed events
- approvals
- history APIs
- remote control

Others expose:
- only terminal I/O
- local files
- partial session state
- no formal discovery
- no typed event taxonomy

That means every client has to:
- build custom integrations
- guess session semantics
- reinvent replay and reconnect
- invent approval handling
- normalize different runtime behaviors manually

The missing layer is not tools or data access.
The missing layer is:

> a session-control protocol for discovering, observing, resuming, steering, and approving agent sessions.

That is the purpose of ASCP.

---

## 3. Mission

### Mission statement

ASCP is a vendor-neutral, session-first protocol for discovering, observing, controlling, resuming, and approving long-running AI agent sessions across clients, hosts, and runtimes.

### Success criteria

ASCP succeeds if it allows:
1. one client to work with multiple runtimes
2. one runtime to expose a stable control plane to many clients
3. approvals to be portable
4. session recovery to be reliable
5. live state to be streamed and replayed
6. implementations to be testable and conformant

---

## 4. Scope

### In scope

ASCP covers:
- host discovery
- runtime discovery
- capability advertisement
- session listing
- session metadata
- session start
- session resume
- session stop/cancel
- sending user input
- event subscriptions
- replay after reconnect
- approvals
- artifact metadata
- diff metadata
- error model
- auth hooks
- authorization hooks
- audit correlation
- versioning
- conformance

### Out of scope

ASCP does not standardize:
- model APIs
- prompt formats
- tool schemas
- memory formats
- UI systems
- agent planning internals
- full cloud runtime infrastructure
- vendor billing

### Why these boundaries matter

The protocol must stay:
- narrow enough to implement
- broad enough to be useful
- strict enough to test
- extensible enough to evolve

---

## 5. Design Principles

### 5.1 Session-first
The core abstraction is the session.

Why:
- users care about ongoing work
- remote control is mostly about continuing sessions
- long-running agent workflows need continuity

### 5.2 Capability-based
Clients must discover real support, not assume it.

Why:
- not every runtime supports approvals
- not every runtime supports diffs
- not every runtime supports replay
- some runtimes only support PTY fallback

### 5.3 Event-driven
State changes should stream as typed events.

Why:
- mobile and remote UIs need incremental updates
- transcript, approvals, and tool actions are naturally event streams

### 5.4 Transport-neutral
The protocol must work across:
- WebSocket
- HTTP + SSE
- local sockets
- stdio
- relay tunnels

### 5.5 Replay-safe
Disconnect is normal.

Why:
- phones suspend
- laptops sleep
- networks drop
- sessions continue without the client

### 5.6 Auditable
Sensitive control decisions must be attributable.

### 5.7 Explicit and boring
Prefer:
- explicit JSON
- stable field names
- JSON Schema
- additive evolution

That makes AI-assisted implementation easier.

---

## 6. Canonical Objects

ASCP should standardize these nouns first.

### Host
Represents the machine or server boundary.

Fields:
- id
- name
- platform
- arch
- labels
- transports

### Runtime
Represents a concrete agent implementation.

Fields:
- id
- kind
- display_name
- version
- adapter_kind
- capabilities

Adapter kinds:
- native
- wrapper
- pty

### Session
Primary protocol object.

Fields:
- id
- runtime_id
- title
- workspace
- status
- created_at
- updated_at
- last_activity_at
- summary
- metadata
- active_run_id

Statuses:
- idle
- running
- waiting_input
- waiting_approval
- completed
- failed
- stopped
- disconnected

### Run
A bounded execution phase inside a session.

Fields:
- id
- session_id
- status
- started_at
- ended_at
- exit_code

### ApprovalRequest
A standardized human approval object.

Fields:
- id
- session_id
- run_id
- kind
- title
- description
- risk_level
- status
- payload
- created_at
- resolved_at

Kinds:
- command
- file_write
- network
- tool
- generic

### Artifact
An output produced by a session.

Fields:
- id
- session_id
- run_id
- kind
- name
- uri
- mime_type
- size_bytes
- created_at
- metadata

Kinds:
- file
- diff
- patch
- image
- log
- report
- other

### DiffSummary
A normalized code-change summary.

Fields:
- session_id
- run_id
- files_changed
- insertions
- deletions
- files[]

### EventEnvelope
Universal event wrapper.

Fields:
- id
- type
- ts
- session_id
- run_id
- seq
- payload

Why this object model:
- it is minimal
- it maps to product needs
- it maps to multiple runtime styles
- it is structured enough for schemas, SDKs, and tests

---

## 7. Core Flows

### Discovery flow
1. fetch capabilities
2. inspect supported runtimes
3. inspect transport support
4. enable or disable features based on capabilities

### Session list flow
1. call sessions.list
2. receive normalized session list
3. render summary state

### Session start flow
1. call sessions.start
2. receive session
3. subscribe to events

### Session resume flow
1. call sessions.resume
2. runtime rehydrates session
3. emit snapshot
4. replay missing events
5. continue live stream

### Input flow
1. call sessions.send_input
2. runtime accepts user steering input
3. transcript/events continue

### Approval flow
1. runtime emits approval.requested
2. client shows approval UI
3. client calls approvals.respond
4. runtime continues or aborts
5. audit and approval events are recorded

### Artifact/diff flow
1. runtime emits artifact or diff event
2. client fetches metadata
3. client fetches content on demand

### Reconnect flow
1. client reconnects with cursor
2. server replays missed events where supported
3. client resumes current stream

---

## 8. Method Surface

Keep v1 method surface small.

Required methods:
- capabilities.get
- hosts.get
- runtimes.list
- sessions.list
- sessions.get
- sessions.start
- sessions.resume
- sessions.stop
- sessions.send_input
- sessions.subscribe
- sessions.unsubscribe
- approvals.list
- approvals.respond
- artifacts.list
- artifacts.get
- diffs.get

Why this set:
- enough for discovery
- enough for session control
- enough for approvals
- enough for output review
- still small enough to freeze early

---

## 9. Event Taxonomy

### Session lifecycle
- session.created
- session.updated
- session.status_changed
- session.deleted

### Run lifecycle
- run.started
- run.paused
- run.resumed
- run.completed
- run.failed
- run.cancelled

### Transcript
- message.user
- message.assistant.started
- message.assistant.delta
- message.assistant.completed
- message.system

### Tool activity
- tool.started
- tool.stdout
- tool.stderr
- tool.completed
- tool.failed

### PTY fallback
- terminal.opened
- terminal.output
- terminal.closed
- terminal.resize_requested

### Approvals
- approval.requested
- approval.updated
- approval.approved
- approval.rejected
- approval.expired

### Artifacts and diffs
- artifact.created
- artifact.updated
- diff.ready
- diff.updated

### Sync and connectivity
- connection.state_changed
- sync.snapshot
- sync.replayed
- sync.cursor_advanced

### Errors
- error.transient
- error.fatal

Why this taxonomy:
- it covers the real user-facing lifecycle
- it works for both structured adapters and PTY fallbacks
- it supports replay and real-time UI
- it keeps naming stable and understandable

---

## 10. Transport Guidance

### WebSocket
Recommended primary transport for interactive clients.

Why:
- duplex
- real-time
- fits JSON-RPC well

### HTTP + SSE
Recommended secondary transport.

Why:
- easier deployment
- simpler proxy compatibility
- useful for hosted setups

### Local socket / named pipe
Useful for trusted local-only scenarios.

### Stdio
Useful for adapter internals and embedded runtime integrations.

Rule:
- protocol objects must stay transport-independent

---

## 11. Serialization and Validation

Use:
- JSON
- JSON Schema
- explicit enums
- explicit timestamps
- stable field names

Why:
- simple
- cross-language
- code-generation-friendly
- easy for AI coding tools to scaffold

Recommended schema layout:
- core entities
- request envelopes
- response envelopes
- event envelopes
- capabilities
- errors
- examples

---

## 12. Versioning

### Protocol versioning
Use semantic versioning:
- major = breaking
- minor = additive
- patch = clarifications and fixes

### Compatibility rules
- unknown fields must be ignored
- unknown event types must be ignored safely
- additive fields are preferred over shape changes
- extensions must not redefine core meaning

### Why versioning must come early
Without compatibility rules, the protocol will fragment immediately.

---

## 13. Extensions

ASCP should allow optional extensions.

Use:
- namespaced capabilities
- namespaced fields where necessary
- optional extension docs

Examples:
- x-codex-*
- x-enterprise-*
- x-audit-*

Rule:
- extensions may add, but must not redefine core semantics

---

## 14. Error Model

Recommended protocol errors:
- INVALID_REQUEST
- UNAUTHORIZED
- FORBIDDEN
- NOT_FOUND
- CONFLICT
- UNSUPPORTED
- RATE_LIMITED
- ADAPTER_ERROR
- RUNTIME_ERROR
- TRANSIENT_UNAVAILABLE
- INTERNAL_ERROR

Error payload fields:
- code
- message
- retryable
- details
- correlation_id

Why:
- clients need predictable failure handling
- retry logic depends on error classification
- audit and debugging depend on correlation IDs

---

## 15. Security Hooks

This is protocol-level security, not full product security.

ASCP should define hooks for:
- actor identity
- device identity
- scopes
- audit correlation
- approval attribution
- revocation compatibility

Sensitive operations:
- sessions.start
- sessions.resume
- sessions.stop
- sessions.send_input
- approvals.respond
- artifact access when code may be exposed

Why:
- protocol consumers need a stable security surface
- products built on top of ASCP need to plug into auth cleanly

---

## 16. Conformance Strategy

A real protocol needs conformance levels.

### ASCP Core Compatible
Supports:
- capabilities
- runtime listing
- session listing
- session get
- event envelopes

### ASCP Interactive
Supports:
- start or resume
- send input
- event subscriptions

### ASCP Approval-Aware
Supports:
- approval events
- approval responses

### ASCP Artifact-Aware
Supports:
- artifacts
- diff summaries

Publish:
- schema fixtures
- golden examples
- compatibility matrix
- contract tests
- mock server

Why:
- otherwise “compatible” implementations will drift

---

## 17. What to Build First

Protocol-first implementation order:

1. scope.md
2. design-principles.md
3. canonical object schemas
4. method schemas
5. event taxonomy
6. error model
7. versioning rules
8. capability document
9. mock server
10. conformance tests

Do not start the protocol project by building the mobile app.
The first proof of the protocol is:
- spec
- schemas
- examples
- mock implementation
- tests

---

## 18. Repository Shape

```text
ascp-protocol/
  README.md
  LICENSE
  CONTRIBUTING.md
  CHANGELOG.md
  docs/
    scope.md
    design-principles.md
    versioning.md
    extensions.md
    replay-and-sync.md
    security-hooks.md
  schema/
    ascp-core.schema.json
    ascp-events.schema.json
    ascp-capabilities.schema.json
    ascp-errors.schema.json
  examples/
    capabilities/
    sessions/
    approvals/
    events/
  conformance/
    fixtures/
    tests/
  mock/
    server/
    sample-event-streams/
```

---

## 19. Definition of Done

The protocol is real when:
- scope is frozen
- canonical objects are frozen
- method surface is frozen
- event taxonomy is frozen
- schemas validate examples
- versioning rules are documented
- error model is documented
- security hooks are documented
- conformance levels exist
- mock server exists
- a test client can consume it

Until then, it is still an internal API draft, not a protocol.

---

## 20. Final Recommendation

Build ASCP as a serious protocol, not as a loose internal contract.

That means:
- define nouns first
- define flows second
- define events third
- define validation and conformance before product polish
- keep the core narrow, explicit, and replay-safe

That is how you get a protocol other people can implement.
