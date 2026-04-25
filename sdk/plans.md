# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript examples and integration tests
- Branch: `feature/typescript-sdk-examples-tests`
- Goal: prove the TypeScript SDK end to end against the parent mock server with consumer-facing examples and executable integration coverage that use the published client, transport, validation, and replay surfaces directly
- Active language target: TypeScript SDK
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/branches/typescript-sdk-client.md`
  - `docs/branches/typescript-sdk-replay.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/client/`
  - `typescript/src/replay/`
  - `typescript/src/transport/`
  - `typescript/src/validation/`
  - `typescript/test/`
  - `../mock-server/README.md`
  - `../mock-server/src/mock_server/`
  - `../reference-client/README.md`
  - `../reference-client/src/reference_client/demo.py`
  - `../examples/`
  - `../conformance/`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- end-to-end integration tests that launch the upstream mock server over stdio and exercise the published TypeScript SDK surface instead of hand-written protocol glue
- executable TypeScript examples for subscribe-and-replay, approval handling, and artifact-plus-diff inspection
- example helpers only where needed to keep consumer flows concise without inventing new ASCP semantics
- README guidance that shows how to install, run, and reason about the examples and integration tests
- branch documentation that explains the example structure, the end-to-end proof coverage, the tradeoffs taken to stay protocol-faithful, and what still remains before release-readiness

Explicitly out of scope:

- protocol-core schema or spec changes
- new transport protocols or deep transport refactors
- runtime adapters, daemons, or product UI work
- changing ASCP field names into SDK-specific DTO aliases
- release-readiness polish unrelated to proving end-to-end behavior
- Dart SDK work

## Planned Files

Files to add:

- example scripts under `typescript/examples/`
- end-to-end integration tests under `typescript/test/`
- example documentation under `docs/branches/`

Files expected to change:

- `plans.md`
- `docs/status.md`
- `typescript/README.md`
- `typescript/package.json`
- `typescript/src/index.ts` if root exports need example-facing helpers
- `typescript/test/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add failing integration and example tests first | at least one new test file fails against the current package while asserting subscribe/replay, approval, artifact/diff, and no-hand-written-DTO consumer flows against the upstream mock server |
| done | implement the minimum example-facing package and test support | the integration tests can drive the published TypeScript SDK end to end without bypassing the package surface or re-creating protocol DTO types in test code |
| done | add executable consumer examples | `typescript/examples/` contains subscribe/replay, approval, and artifact/diff examples that run against the upstream mock server and reflect the README guidance |
| done | document the examples/tests branch in detail | package and branch docs explain how to run the examples/tests, why the examples are structured around thin protocol-faithful flows, what was verified, what remains limited, and what the release-readiness branch should pick up next |
| done | leave a checkpoint for the examples/tests branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- integration tests pass against the upstream mock server over stdio
- subscribe/replay, approval, and artifact/diff flows are proven through the published TypeScript SDK surface
- downstream examples do not need hand-written protocol DTO definitions outside the SDK package
- the package README is enough to get a consumer running the mock-server examples and tests
- documentation explains why the examples stay thin and protocol-faithful, what was verified end to end, and what release-readiness work remains

## Next Likely Step

Create the release-readiness branch from updated `main` after the examples/tests branch lands and tighten package polish, auth hooks, packaging details, and any remaining production-facing verification gaps that the end-to-end proof work exposes.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-examples-tests`
- End-to-end evidence:
  - `npm test -- examples.integration.test.ts` in `typescript/`
  - `npm run build` in `typescript/`
  - `npm run test:integration` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/README.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-examples-tests.md`
  - `typescript/README.md`
  - `typescript/package.json`
