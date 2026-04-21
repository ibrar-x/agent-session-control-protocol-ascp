# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Schema foundation
- Branch: `feature/schema-foundation`
- Goal: freeze the canonical ASCP protocol nouns and shared validation assets needed before method contracts and event payload expansion
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - current chat requirements for the schema foundation slice only

## Bootstrap Outcome

- The repository-level workstream breakdown on `main` is complete.
- The next unfinished task from repository state is `schema foundation`.
- No existing `schema/` or `examples/` assets are present yet.
- This branch starts from up-to-date `main` at commit `f005d81`.

## Feature Boundary

Included in this branch:

- canonical object schemas
- shared envelope schema material
- capability schema
- error schema
- schema-valid examples for `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, and `EventEnvelope`
- supporting documentation needed to explain scope, additive evolution, and versioning assumptions used by the schemas

Explicitly out of scope:

- per-method request and response contracts
- expanded event payload fixtures beyond a minimal `EventEnvelope` example
- replay flow implementation
- auth middleware behavior
- conformance harnesses
- mock server behavior

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | update branch plan for schema foundation | `plans.md` records the current branch, feature boundary, source inputs, task list, and acceptance criteria |
| done | create canonical shared schemas under `schema/` | `schema/ascp-core.schema.json`, `schema/ascp-capabilities.schema.json`, and `schema/ascp-errors.schema.json` match the detailed spec field names, enums, required fields, and optional fields |
| done | add schema-valid examples for required core objects | example files exist for `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, and `EventEnvelope` and validate against the corresponding schemas |
| done | add capability and error examples | capability and error examples validate against their schemas and reflect the compatibility and error guidance from the detailed spec |
| done | document schema-foundation assumptions | supporting docs explain scope limits, additive evolution, unknown-field handling, and versioning assumptions so later method-contract work does not need chat context |
| done | verify schemas and examples | fresh validation confirms the example set is schema-valid before task completion is reported |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- canonical objects from the detailed spec validate without guessing
- required fields, optional fields, enums, and exact field names match the detailed spec
- capability and error examples validate against their schemas
- unknown fields are handled in a way that preserves additive evolution and safe ignore behavior
- documentation is sufficient for a later agent to begin method contracts without reconstructing schema intent from chat history

## Next Likely Step

After this branch is complete, the next feature should be `method contracts` on `feature/method-contracts`, using the frozen schema assets from this branch as the base contract nouns.

## Completion Outcome

- Status: complete on `feature/schema-foundation`
- Merge target: `main`
- Recommended next branch: `feature/method-contracts`
- Recommended next scope:
  - exact request and response contracts for every core ASCP method
  - method-specific validation assets based on the frozen core nouns and shared envelopes from this branch
  - method examples and compatibility notes without widening into replay, auth behavior, or full event-fixture expansion
