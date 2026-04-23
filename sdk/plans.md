# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript SDK analytics and production hardening
- Branch: `feature/typescript-sdk-analytics`
- Goal: add opt-in structured analytics hooks, actionable remediation diagnostics, and baseline production package metadata without changing ASCP protocol semantics or widening into full client behavior
- Active language target: TypeScript SDK
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/prompts/typescript-sdk-transport-client.md`
  - `docs/branches/typescript-sdk-transport.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/models/types.ts`
  - `typescript/src/methods/types.ts`
  - `typescript/src/events/types.ts`
  - `typescript/src/errors/types.ts`
  - `typescript/src/validation/index.ts`
  - `typescript/src/transport/`
  - `typescript/src/validation/types.ts`
  - `../spec/methods.md`
  - `../spec/events.md`
  - `../spec/replay.md`
  - `../mock-server/README.md`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- an analytics entry point published from the TypeScript package
- opt-in transport analytics hooks with structured lifecycle and failure events
- remediation diagnostics on transport and validation errors so downstream consumers can tell what failed, where, and what the next likely fix is
- production package metadata such as repository and bug-reporting fields that should exist before downstream use
- AGENTS and prompt-pack updates so future branches keep observability and production-hardening concerns in scope automatically
- focused runtime and type-level tests that prove the analytics surface and metadata expectations
- branch documentation that explains usage, rationale, verification evidence, limits, and handoff context

Explicitly out of scope:

- bundled third-party analytics vendors or remote telemetry backends
- non-optional telemetry that emits data without explicit consumer configuration
- full typed client wrappers for the ASCP method catalog
- replay helper ergonomics beyond existing transport and validation surfaces
- protocol-core schema or spec changes
- Dart SDK work

## Planned Files

Files to add:

- analytics implementation files under `typescript/src/analytics/`
- analytics tests under `typescript/test/`
- analytics type tests under `typescript/test-d/`
- analytics branch documentation under `docs/branches/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add failing analytics and production-hardening tests for the new public surface | tests prove telemetry hooks are opt-in, remediation diagnostics are actionable, and required production metadata exists before implementation is added |
| done | implement analytics contracts and remediation helpers | the package exposes structured analytics event types and error-diagnostic helpers without baking in vendor-specific telemetry |
| done | integrate analytics hooks into the existing runtime surfaces | transport activity and failures emit structured analytics only when configured, and existing error types expose remediation context |
| done | document the analytics branch in detail and update repo operating guidance | branch docs, package docs, AGENTS.md, and the prompt pack explain usage, rationale, limits, and how future branches inherit the observability rules |
| done | leave a checkpoint for the analytics branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- the TypeScript package exports an analytics entry point with opt-in structured telemetry contracts
- existing runtime code can emit useful analytics events without changing ASCP protocol semantics
- transport and validation errors expose actionable remediation context that helps identify what failed, where it failed, and the next likely fix
- the TypeScript package declares baseline production metadata that a downstream consumer would expect for repository, homepage, and issue reporting
- focused tests cover both success and failure behavior
- documentation explains how later branches should keep observability and production-hardening concerns in scope without introducing silent telemetry

## Next Likely Step

Create `feature/typescript-sdk-client` from updated `main` after this branch lands and build typed core-method wrappers on top of the shared transport, validation, and analytics surfaces so the client branch inherits observability hooks instead of re-inventing them.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-analytics`
- Analytics evidence:
  - `npm test -- analytics.test.ts` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm run build` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `AGENTS.md`
  - `plans.md`
  - `README.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/prompts/README.md`
  - `docs/prompts/typescript-sdk-transport-client.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-analytics.md`
  - `typescript/README.md`
  - `typescript/package.json`
