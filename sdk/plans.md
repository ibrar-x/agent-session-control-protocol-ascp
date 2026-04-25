# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript replay and event helpers
- Branch: `feature/typescript-sdk-replay`
- Goal: make downstream subscriptions and reconnect/replay handling usable on top of the existing typed client and transport layers without hiding snapshot, replay-boundary, or opaque-cursor semantics
- Active language target: TypeScript SDK
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-client.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/client/`
  - `typescript/src/events/types.ts`
  - `typescript/src/methods/types.ts`
  - `typescript/src/models/types.ts`
  - `typescript/src/replay/`
  - `typescript/src/transport/`
  - `typescript/src/validation/index.ts`
  - `../spec/events.md`
  - `../spec/replay.md`
  - `../examples/events/`
  - `../conformance/fixtures/replay/`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- a published `replay` entry point for the TypeScript package
- replay request builders for `from_seq` and `from_event_id`
- opaque replay-cursor pass-through that stays additive to the frozen core subscribe params
- a snapshot-plus-replay subscription helper built on `AscpClient.subscribe`, `AscpClient.unsubscribe`, and `AscpClient.events`
- replay stream items that keep original event envelopes visible while classifying snapshot, historical replay, replay-boundary, live, and cursor-advance events
- cursor tracking that preserves host-provided opaque cursor values instead of inferring them from `seq`
- focused runtime and type-level tests that prove request shaping, snapshot-versus-replay distinctions, cursor preservation, unsubscribe cleanup, and public API typing against upstream replay fixtures
- branch documentation that explains usage, replay shape rationale, alternatives rejected, verification evidence, limits, and what the examples/tests branch should build next

Explicitly out of scope:

- new transport adapters or changes to stdio/WebSocket framing
- protocol-core schema or spec changes
- hiding ASCP replay boundaries behind synthetic combined DTOs
- inferring opaque cursor values from `seq` or other local heuristics
- full mock-server integration workflows and end-to-end examples beyond focused replay tests
- adapter, daemon, product UI, or runtime-specific behavior
- Dart SDK work

## Planned Files

Files to add:

- replay implementation files under `typescript/src/replay/`
- replay tests under `typescript/test/`
- replay type tests under `typescript/test-d/`
- replay branch documentation under `docs/branches/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add failing replay tests for the new public surface | tests prove `from_seq`, `from_event_id`, snapshot ordering, replay-boundary handling, opaque cursor pass-through, and unsubscribe cleanup against upstream replay fixtures before implementation is added |
| done | implement replay request builders and subscription helpers | the package exposes thin replay helpers on top of the existing client surface without changing ASCP method or event semantics |
| done | export the replay surface from the package | root and `./replay` exports expose replay helpers and public types without moving existing client, transport, validation, or analytics import paths |
| done | document the replay branch in detail | branch docs and package docs explain usage, why the helper shape preserves protocol meaning, alternatives rejected, verification evidence, limits, and what the examples/tests branch should build next |
| done | leave a checkpoint for the replay branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- replay helpers exist for `from_seq`, `from_event_id`, and opaque cursor pass-through
- snapshot events stay distinct from replayed historical events and from resumed live events
- replay boundary handling matches the upstream `sync.replayed` semantics
- host-provided cursor information is preserved only when explicitly emitted instead of being guessed from `seq`
- helpers reuse `AscpClient.subscribe`, `AscpClient.unsubscribe`, and `AscpClient.events` rather than reimplementing transport or JSON-RPC behavior
- focused tests cover fixture-aligned replay classification, request shaping, cleanup, exports, and type-level API expectations
- documentation explains how to use the replay layer and what examples/integration work remains for the next branch

## Next Likely Step

Create `feature/typescript-sdk-examples-tests` from updated `main` after this branch lands and add end-to-end examples plus mock-server integration coverage that exercises the new replay helpers against executable upstream flows.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-replay`
- Replay evidence:
  - `npm test -- replay.test.ts` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm run build` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-replay.md`
  - `typescript/README.md`
  - `typescript/package.json`
