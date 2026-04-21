# ASCP Task Plan

This file tracks the current planning boundary and the next implementation-ready protocol work for the repository.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Mark task status as work progresses.
- Do not mix unrelated features into the same active plan.
- If the conversation drifts, stop and split the new work into a new branch and a new scoped plan.

## Active Feature

- Feature name: Top-level ASCP protocol workstream plan
- Branch: `main` for planning only; implementation should move to dedicated feature branches
- Goal: break ASCP into protocol-first workstreams, define dependency order, and choose the first build slice
- Source inputs:
  - `AGENTS.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `docs/status.md`
  - recent git history
  - current chat requirements about bootstrapping and planning first

## Bootstrap Outcome

- The previous active feature, `Repository operating system for ASCP work`, is complete and logged in `docs/status.md`.
- No unfinished task remains from that completed feature.
- The next logical unfinished task is the initial ASCP protocol workstream breakdown required by `AGENTS.md`.

## Planning Deliverables

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | map top-level ASCP workstreams, dependency order, and first build slice | `plans.md` records workstream purpose, dependencies, deliverables, acceptance criteria, and branch guidance |
| done | create reusable starter prompts for each workstream under `docs/prompts/` | repository contains a prompt pack with one self-contained prompt per workstream plus usage guidance |

## Protocol Workstreams

### 1. Schema foundation

- Purpose: freeze canonical protocol objects, shared envelopes, capability advertisement, and error objects as machine-valid assets.
- Dependencies: source specs only.
- Deliverables:
  - `schema/ascp-core.schema.json`
  - `schema/ascp-capabilities.schema.json`
  - `schema/ascp-errors.schema.json`
  - schema-valid examples for `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, and `EventEnvelope`
  - supporting protocol docs for scope, design principles, and versioning where needed to anchor the schemas
- Acceptance criteria:
  - canonical objects and shared envelopes from detailed spec sections 4-6 validate without guessing
  - required fields, optional fields, enums, and field names match the detailed spec exactly
  - capability and error examples validate against their schemas
  - repository outputs demonstrate additive evolution and safe handling of unknown fields
- Own feature branch: yes, `feature/schema-foundation`

### 2. Method contracts

- Purpose: define exact request, response, and error behavior for every core ASCP method.
- Dependencies: schema foundation.
- Deliverables:
  - per-method request and success/error response examples for all core methods
  - method validation assets for params and result shapes
  - method compatibility notes tied to the capability document
  - documentation for request/response envelopes and method semantics
- Acceptance criteria:
  - every core method in the spec has exact params, result shape, and allowed error codes
  - request `id` echo behavior and `result`/`error` exclusivity are testable
  - request and response examples are schema-valid and aligned with the detailed spec
  - no method redefines core object semantics outside the canonical schemas
- Own feature branch: yes, `feature/method-contracts`

### 3. Event contracts

- Purpose: define exact payload shapes and fixtures for all core event families emitted through `EventEnvelope`.
- Dependencies: schema foundation.
- Deliverables:
  - `schema/ascp-events.schema.json`
  - exact payload fixtures for session, run, transcript, tool, terminal, approval, artifact, diff, sync, and error events
  - event support notes tied to compatibility claims
- Acceptance criteria:
  - every event type listed in the detailed spec section 8 has an explicit payload definition
  - event examples validate inside `EventEnvelope`
  - event family names and payload fields remain spec-accurate and replay-safe
  - fixture coverage includes snapshot, replay, approval, and artifact-related events
- Own feature branch: yes, `feature/event-contracts`

### 4. Replay semantics

- Purpose: make reconnect, cursor, snapshot, ordering, and retention behavior explicit and testable.
- Dependencies: method contracts and event contracts.
- Deliverables:
  - replay and sync documentation
  - snapshot and replay example streams
  - cursor model notes for `from_seq`, `from_event_id`, and opaque cursors
  - replay-focused conformance fixtures and tests
- Acceptance criteria:
  - `sessions.subscribe` replay behavior is explicit from reconnect through live stream continuation
  - sequence monotonicity, snapshot boundaries, and cursor advancement rules are testable
  - retention-limit behavior and fallback errors are documented without ambiguity
  - replay claims can be verified for `ASCP Replay-Capable`
- Own feature branch: yes, `feature/replay-semantics`

### 5. Auth and approvals

- Purpose: define auth hooks, scope expectations, actor attribution, and approval lifecycle behavior for sensitive control actions.
- Dependencies: schema foundation, method contracts, and event contracts.
- Deliverables:
  - auth hooks documentation
  - scope matrix for read and write methods
  - approval request, response, and event fixtures
  - auth failure examples showing `UNAUTHORIZED` vs `FORBIDDEN`
  - actor, device, and correlation attribution notes
- Acceptance criteria:
  - sensitive methods have explicit control-scope requirements
  - approval lifecycle behavior is consistent across methods, entities, and events
  - auth failures are distinguishable and auditable
  - approval history and actor attribution remain first-class protocol concerns
- Own feature branch: yes, `feature/auth-approvals`

### 6. Extensions

- Purpose: lock down how vendors extend ASCP without mutating core semantics.
- Dependencies: schema foundation, method contracts, and event contracts.
- Deliverables:
  - extension rules documentation
  - namespaced method, event, field, and capability examples
  - ignore-unknown fixtures for extension fields and events
  - capability advertisement examples for active extensions
- Acceptance criteria:
  - extensions never redefine core semantics
  - namespacing rules are explicit and consistent
  - unknown extensions are ignored safely by default
  - extension support can be tested without changing the core protocol contract
- Own feature branch: no for the initial pass; keep it with adjacent contract-hardening work unless a concrete extension family becomes large enough to justify its own branch

### 7. Conformance

- Purpose: turn the written protocol into verifiable compatibility claims with fixtures, validators, and tests.
- Dependencies: schema foundation, method contracts, event contracts, replay semantics, auth and approvals, and extension rules.
- Deliverables:
  - `conformance/fixtures/`
  - `conformance/validators/`
  - `conformance/tests/`
  - compatibility matrix covering all advertised ASCP levels
  - golden examples for requests, responses, events, replay flows, and auth failures
- Acceptance criteria:
  - conformance checks cover schema validity, method validation, event validation, replay ordering, auth failure handling, and extension ignore behavior
  - compatibility levels are backed by explicit evidence instead of prose claims
  - golden fixtures are stable enough for third-party implementers to consume
- Own feature branch: yes, `feature/conformance`

### 8. Mock server

- Purpose: provide a deterministic proof implementation that exercises the protocol without product-specific runtime behavior.
- Dependencies: schema foundation, method contracts, event contracts, replay semantics, auth and approvals, and a minimal conformance baseline.
- Deliverables:
  - `mock-server/`
  - sample event streams
  - deterministic host, runtime, session, approval, artifact, and diff fixtures
  - basic compatibility notes for what the mock supports
- Acceptance criteria:
  - a client can discover capabilities, inspect sessions, and exercise live and replay flows without guessing protocol behavior
  - emitted responses and events are schema-valid
  - mock behavior stays protocol-first and vendor-neutral
  - the mock is useful for client development and conformance debugging
- Own feature branch: yes, `feature/mock-server`

## Dependency Order

1. schema foundation
2. method contracts
3. event contracts
4. replay semantics
5. auth and approvals
6. extensions policy hardening
7. conformance
8. mock server

Event contracts can begin as soon as schema foundation is stable, but replay, auth, conformance, and the mock server should not move ahead until method and event contracts stop shifting.

## Next Unfinished Task

- Workstream: schema foundation
- Proposed branch: `feature/schema-foundation`
- Why first:
  - it matches the implementation order in `AGENTS.md` and both ASCP source specs
  - it freezes the nouns, envelopes, capability document, and error objects that every later workstream depends on
  - it produces immediately checkable assets: schemas, examples, and validation targets
- First build slice boundary:
  - create the initial `schema/` layout
  - define canonical object schemas plus capability and error schemas
  - add schema-valid example fixtures for the core entities and shared envelopes
  - document any required scope, design-principle, or versioning notes that the schemas depend on

## Workstream Backlog

| Status | Workstream | Dependency Gate |
| --- | --- | --- |
| pending | schema foundation | ready now |
| pending | method contracts | after schema foundation |
| pending | event contracts | after schema foundation |
| pending | replay semantics | after method contracts and event contracts |
| pending | auth and approvals | after schema foundation, method contracts, and event contracts |
| pending | extensions | after schema foundation, method contracts, and event contracts |
| pending | conformance | after upstream contract work is stable |
| pending | mock server | after upstream protocol contracts are stable enough to implement without guessing |
