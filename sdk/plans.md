# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript SDK validation layer
- Branch: `feature/typescript-sdk-validation`
- Goal: add schema-backed runtime validation for core ASCP entities, method responses, and event envelopes without widening into transport, replay, or full client behavior
- Active language target: TypeScript SDK
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/prompts/typescript-sdk-validation.md`
  - `docs/branches/typescript-sdk-foundation.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/models/types.ts`
  - `typescript/src/methods/types.ts`
  - `typescript/src/events/types.ts`
  - `typescript/src/errors/types.ts`
  - `typescript/src/validation/index.ts`
  - `../schema/ascp-core.schema.json`
  - `../schema/ascp-capabilities.schema.json`
  - `../schema/ascp-methods.schema.json`
  - `../schema/ascp-events.schema.json`
  - `../schema/ascp-errors.schema.json`
  - `../spec/methods.md`
  - `../spec/events.md`
  - `../examples/`
  - `../conformance/`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- AJV setup for schema-backed runtime validation
- an embedded upstream-schema strategy inside the TypeScript package
- validators for core entities, method success and error responses, and event envelopes
- safe parse and assertion helpers with actionable validation error formatting
- focused unit tests that cover success and failure paths using upstream examples
- branch documentation that explains usage, rationale, verification evidence, limits, and handoff context

Explicitly out of scope:

- transport implementations
- full typed client wrappers
- replay helper ergonomics beyond what validation needs
- protocol-core schema or spec changes
- Dart SDK work

## Planned Files

Files to add:

- validation tests under `typescript/test/`
- validation implementation files under `typescript/src/validation/`
- validation branch documentation under `docs/branches/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add failing validation tests for the new public surface | tests prove expected success and failure behavior for representative entities, method responses, and event envelopes before implementation is added |
| done | implement AJV-backed schema registry and public validation helpers | the package exposes safe parse and assert helpers that compile validators from embedded upstream schemas and preserve ASCP semantics |
| done | document the validation branch in detail | a dedicated branch reference plus package docs explain usage, rationale, alternatives, verification evidence, limits, and next-step handoff |
| done | leave a checkpoint for the validation branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- core entities validate against upstream schemas through exported helpers
- method responses validate cleanly against upstream method contracts
- event envelopes validate cleanly against upstream event contracts
- validation failures report the target schema, JSON path, and rule details clearly enough to debug payload issues
- focused tests cover both success and failure behavior
- documentation explains how downstream transport and client branches should build on the validation surface without changing its semantics

## Next Likely Step

Create `feature/typescript-sdk-transport` from updated `main` after this branch lands and build transport adapters on top of the exported validation helpers instead of re-implementing payload checks.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-validation`
- Validation evidence:
  - `npm test -- validation.test.ts` in `typescript/`
  - `npm run build` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-validation.md`
  - `typescript/README.md`
