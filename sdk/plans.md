# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript typed client methods
- Branch: `feature/typescript-sdk-client`
- Goal: expose the complete ASCP core method catalog through typed client wrappers on top of the existing transport, validation, and analytics surfaces without widening into replay convenience helpers
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
  - `docs/branches/typescript-sdk-analytics.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/models/types.ts`
  - `typescript/src/methods/types.ts`
  - `typescript/src/events/types.ts`
  - `typescript/src/errors/types.ts`
  - `typescript/src/validation/index.ts`
  - `typescript/src/transport/`
  - `typescript/src/analytics/`
  - `typescript/src/validation/types.ts`
  - `../spec/methods.md`
  - `../spec/events.md`
  - `../spec/replay.md`
  - `../examples/responses/`
  - `../examples/errors/`
  - `../mock-server/README.md`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- a `client` entry point published from the TypeScript package
- typed wrappers for every ASCP core method named in `../spec/methods.md`
- protocol-faithful params and result types that reuse `typescript/src/methods/types.ts`
- normalized protocol error mapping that preserves the original ASCP error object and response envelope
- request option pass-through to the existing transport layer
- focused runtime and type-level tests that prove wrapper dispatch, result unwrapping, protocol-error mapping, and public API typing
- branch documentation that explains usage, wrapper shape, alternatives rejected, verification evidence, limits, and replay handoff context

Explicitly out of scope:

- replay helper ergonomics such as cursor carry-forward or snapshot-plus-replay orchestration
- new transport adapters or changes to stdio/WebSocket framing
- protocol-core schema or spec changes
- bundled telemetry vendors or silent analytics behavior
- adapter, daemon, product UI, or runtime-specific behavior
- Dart SDK work

## Planned Files

Files to add:

- client implementation files under `typescript/src/client/`
- client tests under `typescript/test/`
- client type tests under `typescript/test-d/`
- client branch documentation under `docs/branches/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add failing typed-client tests for the new public surface | tests prove all core wrappers dispatch the exact method names, return success results, pass request options through, and normalize ASCP error responses before implementation is added |
| done | implement the typed client contracts and protocol-error class | the package exposes a replaceable-transport client with every core method wrapper and a protocol error type that preserves method, ASCP error object, response envelope, retryability, and correlation id |
| done | export the client surface from the package | root and `./client` exports expose runtime client helpers and public types without moving existing model, method, validation, transport, or analytics import paths |
| done | document the client branch in detail | branch docs and package docs explain usage, wrapper shape, error mapping, alternatives rejected, verification evidence, limits, and what the replay branch should inherit |
| done | leave a checkpoint for the client branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- every core ASCP method is wrapped by a typed public client method
- wrappers reuse the existing transport request path and do not reimplement JSON-RPC framing or response validation
- successful responses unwrap to protocol result objects without hiding ASCP field names
- error responses throw a normalized protocol error that preserves the original error object and envelope
- request options such as timeout and abort signals pass through to transport requests
- focused tests cover dispatch, result unwrapping, option pass-through, error mapping, root exports, and type-level method signatures
- documentation explains how to use the client surface and what replay work remains deferred

## Next Likely Step

Create `feature/typescript-sdk-replay` from updated `main` after this branch lands and build replay helpers on top of the typed client, `sessions.subscribe`, and the existing transport subscription stream without changing the wrapper result shapes.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-client`
- Client evidence:
  - `npm test -- client.test.ts` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm run build` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-client.md`
  - `typescript/README.md`
  - `typescript/package.json`
