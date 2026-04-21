# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Event contracts
- Branch: `feature/event-contracts`
- Goal: freeze exact `EventEnvelope` payload contracts for every core ASCP event type using the canonical schema-foundation nouns and frozen method triggers without widening into replay implementation, auth middleware behavior, or mock-server logic
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/event-contracts.md`
  - `docs/superpowers/specs/2026-04-22-event-contracts-design.md`
  - `docs/schema-foundation.md`
  - `schema/ascp-core.schema.json`
  - `schema/ascp-capabilities.schema.json`
  - `schema/ascp-errors.schema.json`
  - `schema/ascp-methods.schema.json`
  - `spec/methods.md`
  - existing core examples under `examples/`
  - current chat requirements for the event-contracts slice only

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for event contracts is met: schema foundation, method contracts, and the seed `EventEnvelope` example are present under `schema/`, `spec/`, and `examples/`.
- No dedicated event-contract schema, full event fixture set, or event support spec is present yet.
- This branch starts from up-to-date `main` at commit `3f76faf`.

## Feature Boundary

Included in this branch:

- exact `EventEnvelope` payload contracts for every core event type named in the detailed spec
- event-family and event-type schema material under `schema/`
- one schema-valid example fixture per core event type under `examples/events/`
- event support and compatibility notes that distinguish live events, snapshots, and replay markers
- validation commands or scripts needed to verify the event-contract assets

Explicitly out of scope:

- replay retention rules or storage implementation
- sequence generation implementation beyond schema-level replay-safe constraints
- auth middleware behavior beyond fields already required by approval or audit-related events
- mock-server streaming behavior
- conformance harness expansion beyond validating the event-contract fixtures

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for event contracts | `plans.md` records the event-contract branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| done | create canonical event-contract schema material under `schema/` | `schema/ascp-events.schema.json` defines exact envelope and payload contracts for every core event type while reusing the schema-foundation nouns and shared envelope |
| done | add schema-valid event fixtures for every core event type | `examples/events/` contains one concrete `EventEnvelope` fixture for each spec-defined event type |
| done | document event support, compatibility expectations, and replay-safe boundaries | `spec/events.md` explains the event families, exact payload support, compatibility notes, and the difference between snapshots and replay markers |
| done | add repeatable validation for event-contract assets | `scripts/validate_event_contracts.sh` validates the event schema plus the event fixture set |
| done | verify all event-contract assets and checkpoint the branch | fresh validation passes, `docs/status.md` records the checkpoint, and the branch is ready for commit without widening scope |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- every event type listed in the detailed spec has an explicit payload definition
- every event example validates as an `EventEnvelope` with the exact matching `type`
- event family names and payload field names exactly match the detailed spec
- the event contracts reuse the canonical schema-foundation nouns rather than redefining them
- snapshot and replay-marker events remain replay-safe and do not blur historical ordering
- documentation is sufficient for a later agent to begin replay-semantics work without reconstructing the event surface from chat history

## Next Likely Step

After this branch is complete, the next feature should be `replay semantics` on `feature/replay-semantics`, using the locked event contracts as the base contract inputs for cursor, ordering, and retention notes.

## Completion Outcome

- Status: complete on `feature/event-contracts`
- Validation evidence: `./scripts/validate_event_contracts.sh` completed successfully and validated 39 event-contract example files
- Merge target: `main`
- Recommended next branch: `feature/replay-semantics`
- Recommended next scope:
  - cursor and replay resumption rules built on the frozen event contracts
  - sequence handling expectations and retention notes
  - replay conformance tests without reopening event payload shapes
