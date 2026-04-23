# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript SDK transport layer
- Branch: `feature/typescript-sdk-transport`
- Goal: add replaceable stdio and WebSocket transport primitives with a shared request/subscription interface and normalized transport errors, without widening into the full typed client surface or replay convenience helpers
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
  - `docs/branches/typescript-sdk-validation.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/models/types.ts`
  - `typescript/src/methods/types.ts`
  - `typescript/src/events/types.ts`
  - `typescript/src/errors/types.ts`
  - `typescript/src/validation/index.ts`
  - `typescript/src/transport/`
  - `../spec/methods.md`
  - `../spec/events.md`
  - `../spec/replay.md`
  - `../mock-server/README.md`
  - `../mock-server/src/mock_server/cli.py`
  - `../reference-client/README.md`
  - `../reference-client/src/reference_client/stdio_transport.py`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- a transport entry point published from the TypeScript package
- a shared request and subscription contract that later client work can build on
- a persistent stdio transport for the upstream mock server and other line-oriented JSON-RPC hosts
- a WebSocket transport with the same request/subscription contract for future host use
- transport error normalization for connection, framing, timeout, and protocol-shape failures
- focused runtime and type-level tests that prove the transport surface and mock-server reachability
- branch documentation that explains usage, rationale, verification evidence, limits, and handoff context

Explicitly out of scope:

- full typed client wrappers for the ASCP method catalog
- replay helper ergonomics beyond the raw subscription surface
- auth policy abstractions beyond transport configuration hooks
- protocol-core schema or spec changes
- Dart SDK work

## Planned Files

Files to add:

- transport implementation files under `typescript/src/transport/`
- transport tests under `typescript/test/`
- transport type tests under `typescript/test-d/`
- transport branch documentation under `docs/branches/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add failing transport tests for the new public surface | tests prove stdio request flow, streamed subscription delivery, WebSocket request flow, and normalized transport failures before implementation is added |
| done | implement shared transport contracts and normalized transport errors | the package exposes a replaceable transport interface and stable error vocabulary without baking in typed client behavior |
| done | implement stdio and WebSocket transport adapters | the stdio adapter can reach the upstream mock server over a persistent child-process transport and the WebSocket adapter follows the same contract for future hosts |
| done | document the transport branch in detail | a dedicated branch reference plus package docs explain usage, rationale, alternatives, verification evidence, limits, and next-step handoff |
| done | leave a checkpoint for the transport branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- the TypeScript package exports a transport entry point with a replaceable request/subscription interface
- the mock server can be reached through the stdio transport primitives without hand-written transport code in tests
- the WebSocket transport surface exists and follows the same request/subscription contract
- transport failures normalize to explicit error types without hiding underlying protocol or IO details
- focused tests cover both success and failure behavior
- documentation explains how the later typed client branch should build on the transport layer without changing its semantics

## Next Likely Step

Create `feature/typescript-sdk-client` from updated `main` after this branch lands and build typed core-method wrappers on top of the shared transport and validation surfaces instead of re-implementing request execution or response parsing.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-transport`
- Transport evidence:
  - `npm test -- transport.test.ts` in `typescript/`
  - `npm run build` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `README.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-transport.md`
  - `typescript/README.md`
  - `typescript/package.json`
