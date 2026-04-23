# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript SDK foundation
- Branch: `feature/typescript-sdk-foundation`
- Goal: scaffold the TypeScript SDK package, lock in the source layout and public exports, and make the schema-led model strategy explicit without widening into transport, validation, replay, or full client work
- Active language target: TypeScript
- Source inputs:
  - `AGENTS.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../schema/`
  - `../examples/`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`
  - `docs/project-context-reference.md`
  - `docs/prompts/typescript-sdk-foundation.md`

## Scope

Included in this branch:

- initial package scaffold under `typescript/`
- package metadata and script baseline
- TypeScript compiler and test tooling baseline
- source layout matching the implementation plan
- explicit public exports for the foundation model surface
- documented model generation or authoring strategy
- package README updates and any directly related SDK workflow doc fixes

Explicitly out of scope:

- AJV-backed validation behavior
- stdio or WebSocket transport implementations
- full typed client wrappers for core methods
- replay helpers
- Dart SDK work
- protocol changes or adapter-specific behavior

## Planned Files

Files to add:

- `typescript/.gitignore`
- `typescript/package.json`
- `typescript/tsconfig.json`
- `typescript/tsconfig.build.json`
- `typescript/tsconfig.type-tests.json`
- `typescript/vitest.config.ts`
- `typescript/src/index.ts`
- `typescript/src/metadata.ts`
- `typescript/src/models/index.ts`
- `typescript/src/methods/index.ts`
- `typescript/src/events/index.ts`
- `typescript/src/errors/index.ts`
- `typescript/src/models/types.ts`
- `typescript/src/methods/types.ts`
- `typescript/src/events/types.ts`
- `typescript/src/errors/types.ts`
- `typescript/src/client/index.ts`
- `typescript/src/transport/index.ts`
- `typescript/src/validation/index.ts`
- `typescript/src/replay/index.ts`
- `typescript/src/auth/index.ts`
- `typescript/test/metadata.test.ts`
- `typescript/test-d/public-api.test-d.ts`
- `typescript/README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | activate the foundation branch plan and align the prompt docs | `plans.md` reflects the foundation feature and the relevant prompt files point at the correct upstream inputs |
| done | scaffold the package and toolchain baseline | `typescript/` contains `package.json`, TypeScript configs, Vitest baseline, and a repeatable install/build/test script set |
| done | make the model strategy explicit | the package documents the schema-indexed authored model strategy and pins it behind stable barrels for later validation work |
| done | define the public export surface | root and subpath exports are explicit for models, methods, events, and errors without exposing transport or client work early |
| done | prove the scaffold with baseline checks | a type-level public API check and a runtime metadata test pass without requiring transport or validation implementation |

## Acceptance Criteria

The task is done only when all of the following are true:

- `typescript/` is an installable package scaffold with a stable source layout
- the public export surface is explicit at the package root and relevant subpaths
- the model strategy is documented and tied directly to the upstream schema and example assets
- later validation and transport work can add implementation without moving the package structure
- the README and checkpoint files describe the completed foundation state and the next likely TypeScript slice

## Next Likely Step

Build the TypeScript validation slice on its own branch, using the foundation package layout and schema-indexed authored model surface without restructuring the package root.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-foundation`
- Validation evidence:
  - `npm run build`
  - `npm test`
  - `npm run test:types`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `README.md`
  - `docs/project-context-reference.md`
  - `docs/status.md`
  - `docs/prompts/typescript-sdk-foundation.md`
  - `docs/prompts/typescript-sdk-validation.md`
  - `docs/prompts/typescript-sdk-transport-client.md`
  - `docs/prompts/dart-sdk-planning.md`
  - `typescript/README.md`
