# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Method contracts
- Branch: `feature/method-contracts`
- Goal: freeze exact request, success-response, and allowed error contracts for every core ASCP method using the schema-foundation nouns and shared envelopes without widening into event payloads, replay flow, auth implementation, or mock-server behavior
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/method-contracts.md`
  - `docs/schema-foundation.md`
  - `schema/ascp-core.schema.json`
  - `schema/ascp-capabilities.schema.json`
  - `schema/ascp-errors.schema.json`
  - existing core examples under `examples/`
  - current chat requirements for the method-contracts slice only

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for method contracts is met: schema foundation assets are present under `schema/` and `examples/`.
- No existing method-contract schema, spec, or request/response/error example assets are present yet.
- This branch starts from up-to-date `main` at commit `6a4e78e`.

## Feature Boundary

Included in this branch:

- exact request params for every core ASCP method
- exact success result shapes for every core ASCP method
- explicit allowed error-code mapping per method, including shared validation and host-failure behavior
- schema material for validating method requests and responses against the frozen core nouns
- example request, success-response, and error-response envelopes for every core method
- supporting documentation that ties the method surface back to capability advertisement and schema foundation
- validation commands or scripts needed to verify the method-contract fixtures

Explicitly out of scope:

- exact event payload schemas beyond method-triggered references
- replay stream sequencing semantics beyond method-level flags and references
- auth middleware implementation details beyond method-level error and capability notes
- conformance harness expansion beyond validating the method-contract fixtures
- mock-server behavior

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for method contracts | `plans.md` records the method-contract branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| done | create canonical method-contract schema material under `schema/` | `schema/ascp-methods.schema.json` defines exact params, success result shapes, and method-specific error envelopes while reusing the schema-foundation nouns and shared envelopes |
| done | add request, success-response, and error-response examples for every core method | `examples/requests/`, `examples/responses/`, and `examples/errors/` contain schema-valid envelopes for each core method |
| done | document capability gating and method error mapping | normative docs explain which methods rely on core compatibility versus advertised capability flags, and list the allowed error codes without requiring chat context |
| done | add repeatable validation for method-contract assets | `scripts/validate_method_contracts.sh` validates the method schema plus the request/response/error example set |
| done | verify all method-contract assets and checkpoint the branch | fresh validation passes, `docs/status.md` records the checkpoint, and the branch is ready for commit without widening scope |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- every core ASCP method has exact request params and success result shapes
- request `id` echo behavior and `result` versus `error` exclusivity stay explicit and testable
- the method contracts reuse the canonical schema-foundation nouns rather than redefining them
- allowed error codes are explicit per method and align with the detailed spec plus documented validation and host-failure rules
- request, response, and error examples validate against the method-contract and shared schemas
- documentation is sufficient for a later agent to begin event-contract work without reconstructing the method surface from chat history

## Next Likely Step

After this branch is complete, the next feature should be `event contracts` on `feature/event-contracts`, using the frozen method triggers, shared `EventEnvelope`, and schema-foundation nouns as the base contract inputs.

## Completion Outcome

- Status: complete on `feature/method-contracts`
- Validation evidence: `./scripts/validate_method_contracts.sh` completed successfully and validated 48 method-contract example files
- Merge target: `main`
- Recommended next branch: `feature/event-contracts`
- Recommended next scope:
  - exact payload contracts for the core event taxonomy
  - event examples and validators based on the shared `EventEnvelope`
  - event-level notes for snapshot, replay references, and transport-neutral streaming behavior without revisiting method shapes
