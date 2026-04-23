# ASCP SDK Build Roadmap

This document is the operator-facing roadmap for building the ASCP SDKs from start to finish.

It is intentionally practical:

- each step has a clear goal
- each step stays on one feature boundary
- each step includes a compact prompt you can give to the next agent
- each prompt tells the agent which files to read before implementation

Use this document together with `AGENTS.md`, `plans.md`, and `docs/status.md`.

## Global Rules

Before every implementation step:

1. start from updated `main`
2. create a dedicated feature branch
3. update `plans.md` first
4. keep the work scoped to one feature
5. update docs before commit
6. add a checkpoint to `docs/status.md`

Before closing any branch, document the branch in enough detail that the next contributor can understand both usage and rationale without hidden chat context.

That branch documentation should explain at minimum:

- what the branch adds and what remains out of scope
- how to use the current branch output locally
- what upstream ASCP sources directly informed the work
- the implementation thought process and the constraints that shaped the design
- why the chosen approach was used instead of the most plausible alternatives
- verification commands and what they prove
- known limitations, deferred work, and follow-on risks
- the next likely branch and the clean handoff context for it

Global source files for almost every step:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`
- `../../schema/`
- `../../spec/`
- `../../examples/`
- `../../conformance/`

## Phase 0 - Repository Bootstrap

Status:
- done on `feature/sdk-repo-bootstrap`

Goal:
- create the SDK workspace operating system, docs, prompts, and local skills

Main outputs:
- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/repo-operating-system.md`
- `docs/prompts/`
- `.agents/skills/`

Compact prompt:

```text
Bootstrap the ASCP SDK workspace as an SDK-only repository. Read `AGENTS.md`, the parent protocol assets, `../../ASCP_TypeScript_SDK_Implementation_Plan.md`, `../../ASCP_Dart_SDK_Implementation_Plan.md`, and `../../ASCP_Next_Phase_Master_Roadmap.md`. Create or update the repository operating files, docs index, status log, prompt starters, and local skills so future work can start with the TypeScript SDK without hidden chat context, and document the branch in enough detail that a future session understands how to use the repository state, why the structure was chosen, what alternatives were rejected, what was verified, and what branch should come next.
```

## Phase 1 - TypeScript SDK Foundation

Recommended branch:
- `feature/typescript-sdk-foundation`

Goal:
- scaffold the TypeScript package and lock in the package structure, public exports, and model strategy

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../schema/`
- `../../examples/`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `project-context-reference.md`
- `prompts/typescript-sdk-foundation.md`

Deliverables:

- initial package scaffold under `../typescript/`
- `package.json`
- `tsconfig` and test tooling baseline
- source layout that matches the implementation plan
- clear export surface
- documented model generation or authoring strategy
- package README updates

Compact prompt:

```text
Build the TypeScript SDK foundation only. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `schema/`, `examples/`, `ASCP_TypeScript_SDK_Implementation_Plan.md`, and `sdk/docs/prompts/typescript-sdk-foundation.md`. On a fresh `feature/typescript-sdk-foundation` branch, scaffold `sdk/typescript/`, define the package structure and public exports, make the model strategy explicit without widening into transport or client work, and document how to use the foundation branch, the thought process behind the package shape, why this approach beat the alternatives, what was verified, and what the validation branch should assume next.
```

Done when:

- the package structure matches the plan
- the model strategy is explicit
- later validation and transport work can continue without restructuring

## Phase 2 - TypeScript Validation Layer

Recommended branch:
- `feature/typescript-sdk-validation`

Goal:
- make ASCP payload parsing safe and schema-backed

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../schema/`
- `../../spec/`
- `../../examples/`
- `../../conformance/`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `prompts/typescript-sdk-validation.md`

Deliverables:

- AJV setup
- schema loading or embedding strategy
- validators for core entities, method responses, and event envelopes
- useful validation error formatting
- unit tests for success and failure paths

Compact prompt:

```text
Implement the TypeScript SDK validation layer only. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `schema/`, `spec/`, `examples/`, `conformance/`, `ASCP_TypeScript_SDK_Implementation_Plan.md`, and `sdk/docs/prompts/typescript-sdk-validation.md`. On a fresh `feature/typescript-sdk-validation` branch, add schema-backed validation with AJV, expose safe parsing helpers, add focused tests without mixing in transport or full client work, and document how to use the validation surface, why the validator structure and error approach were chosen, what alternatives were rejected, what was verified, and what the next branch can safely build on.
```

Done when:

- core entities validate against upstream schemas
- method results and event envelopes validate cleanly
- validation failures are actionable

## Phase 3 - TypeScript Transport Layer

Recommended branch:
- `feature/typescript-sdk-transport`

Goal:
- implement replaceable transport primitives for real integration work

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../spec/methods.md`
- `../../mock-server/README.md`
- `../../reference-client/README.md`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `prompts/typescript-sdk-transport-client.md`

Deliverables:

- stdio transport
- WebSocket transport
- shared request and subscription interface
- transport error normalization
- targeted tests or stubs

Compact prompt:

```text
Implement the TypeScript SDK transport layer only. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `spec/methods.md`, `mock-server/README.md`, `reference-client/README.md`, `ASCP_TypeScript_SDK_Implementation_Plan.md`, and `sdk/docs/prompts/typescript-sdk-transport-client.md`. On `feature/typescript-sdk-transport`, add stdio and WebSocket transports with a replaceable interface and focused tests, without adding the full typed client surface yet, and document how to use the transport layer, why the abstraction was chosen, what alternatives were rejected, what was verified, and what the client branch should inherit.
```

Done when:

- the mock server can be reached through stdio transport primitives
- WebSocket transport shape exists for future host use
- transport stays independent from business logic

## Phase 4 - TypeScript Typed Client Methods

Recommended branch:
- `feature/typescript-sdk-client`

Goal:
- expose the full ASCP method surface through typed wrappers

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../spec/methods.md`
- `../../examples/responses/`
- `../../examples/errors/`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `prompts/typescript-sdk-transport-client.md`

Deliverables:

- typed wrappers for every core method
- request parameter helpers where useful
- normalized error mapping
- docs for public client usage
- tests for core request and response flow

Compact prompt:

```text
Build the TypeScript typed client surface only. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `spec/methods.md`, `examples/responses/`, `examples/errors/`, `ASCP_TypeScript_SDK_Implementation_Plan.md`, and `sdk/docs/prompts/typescript-sdk-transport-client.md`. On `feature/typescript-sdk-client`, implement typed wrappers for the full ASCP method set on top of the transport layer and validation helpers, without widening into replay convenience work yet, and document how to use the client surface, why the wrapper shape and error mapping were chosen, what alternatives were rejected, what was verified, and what the replay branch should inherit.
```

Done when:

- every core method is wrapped
- method params and result types stay protocol-faithful
- error handling is consistent and documented

## Phase 5 - TypeScript Replay And Event Helpers

Recommended branch:
- `feature/typescript-sdk-replay`

Goal:
- make subscriptions and reconnect/replay behavior usable downstream

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../spec/replay.md`
- `../../spec/events.md`
- `../../examples/events/`
- `../../conformance/fixtures/replay/`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`

Deliverables:

- replay helpers for `from_seq`
- replay helpers for `from_event_id`
- opaque cursor pass-through
- snapshot plus replay subscription helpers
- tests for replay behavior

Compact prompt:

```text
Implement the TypeScript replay and event helper layer only. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `spec/replay.md`, `spec/events.md`, `examples/events/`, `conformance/fixtures/replay/`, and `ASCP_TypeScript_SDK_Implementation_Plan.md`. On `feature/typescript-sdk-replay`, add event-stream and replay helpers that preserve ASCP semantics exactly, including cursor handling and snapshot-versus-replay distinctions, and document how to use the replay layer, why the chosen helper shape preserves protocol meaning better than the alternatives, what was verified, and what examples/tests work should build next.
```

Done when:

- replay helpers exist without hiding protocol meaning
- cursor information is preserved
- event helpers match upstream replay fixtures

## Phase 6 - TypeScript Examples And Integration Tests

Recommended branch:
- `feature/typescript-sdk-examples-tests`

Goal:
- prove the TypeScript SDK end to end against the parent mock server

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../mock-server/README.md`
- `../../reference-client/README.md`
- `../../examples/`
- `../../conformance/`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`

Deliverables:

- end-to-end integration tests against the mock server
- examples for subscribe and replay
- approval example
- artifact and diff example
- package README usage guidance

Compact prompt:

```text
Finish the TypeScript SDK with examples and integration tests. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `mock-server/README.md`, `reference-client/README.md`, `examples/`, `conformance/`, and `ASCP_TypeScript_SDK_Implementation_Plan.md`. On `feature/typescript-sdk-examples-tests`, add end-to-end tests and usage examples that prove the package works against the mock server without hand-written protocol glue, and document how to run the examples/tests, why the examples are structured that way, what was verified end to end, and what remains before release-readiness.
```

Done when:

- integration tests pass against the mock server
- downstream TypeScript consumers no longer need hand-written DTOs
- the package README is enough to start using the SDK

## Phase 7 - TypeScript Release Readiness

Recommended branch:
- `feature/typescript-sdk-release-readiness`

Goal:
- clean up the package for sustained downstream use

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../typescript/README.md`
- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- the latest completed TypeScript branch docs

Deliverables:

- versioning decision
- package export cleanup
- release notes or package README polish
- final validation checklist

Compact prompt:

```text
Prepare the TypeScript SDK for release-quality downstream use. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `sdk/typescript/README.md`, `ASCP_TypeScript_SDK_Implementation_Plan.md`, and the docs from the completed TypeScript branches. On `feature/typescript-sdk-release-readiness`, tighten exports, package metadata, docs, and validation evidence without introducing new feature scope, and document how to consume the release-ready package, why the final package boundaries were chosen, what final tradeoffs remain, what evidence supports release quality, and what Dart planning should use as downstream reference material.
```

Done when:

- package boundaries are clear
- docs and examples are coherent
- the TypeScript SDK is ready to act as the reference package

## Phase 8 - Dart SDK Planning Refresh

Recommended branch:
- `feature/dart-sdk-planning`

Goal:
- start Dart intentionally after TypeScript is stable

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../typescript/README.md`
- `../dart/README.md`
- `../../../ASCP_Dart_SDK_Implementation_Plan.md`
- `../../../ASCP_Next_Phase_Master_Roadmap.md`
- `prompts/dart-sdk-planning.md`

Deliverables:

- refreshed Dart plan if needed
- package layout decision
- model and codec strategy
- subscription and replay surface plan

Compact prompt:

```text
Plan the Dart SDK intentionally after the TypeScript SDK is stable. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `sdk/typescript/README.md`, `sdk/dart/README.md`, `ASCP_Dart_SDK_Implementation_Plan.md`, `ASCP_Next_Phase_Master_Roadmap.md`, and `sdk/docs/prompts/dart-sdk-planning.md`. On `feature/dart-sdk-planning`, confirm the Dart package scope, package layout, model strategy, and validation/replay plan without mixing in Flutter UI work, and document how to use the planning outputs, why the chosen Dart direction was preferred over alternatives, what assumptions remain open, and what the first implementation branch should build.
```

Done when:

- the Dart plan is explicit
- future implementation can proceed without re-deciding scope

## Phase 9 - Dart SDK Foundation

Recommended branch:
- `feature/dart-sdk-foundation`

Goal:
- scaffold the Dart package and define the package surface

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../schema/`
- `../../examples/`
- `../../../ASCP_Dart_SDK_Implementation_Plan.md`

Deliverables:

- Dart package scaffold
- package metadata
- source layout
- model and JSON codec strategy
- package README

Compact prompt:

```text
Build the Dart SDK foundation only. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `schema/`, `examples/`, and `ASCP_Dart_SDK_Implementation_Plan.md`. On `feature/dart-sdk-foundation`, scaffold `sdk/dart/`, define the package structure and model/json strategy, keep the scope limited to foundation work, and document how to use the foundation branch, why the package and codec strategy were chosen, what alternatives were rejected, what was verified, and what the executable Dart branch should inherit.
```

## Phase 10 - Dart Transport, Client, And Replay

Recommended branch:
- `feature/dart-sdk-client`

Goal:
- implement the Dart executable surface after the package foundation exists

Read first:

- `../AGENTS.md`
- `../plans.md`
- `status.md`
- `../../spec/`
- `../../examples/`
- `../../mock-server/README.md`
- `../../../ASCP_Dart_SDK_Implementation_Plan.md`

Deliverables:

- method wrappers
- stream-based subscription support
- replay helpers
- transport abstraction
- validation and auth hooks
- tests and examples

Compact prompt:

```text
Implement the Dart SDK executable surface. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `spec/`, `examples/`, `mock-server/README.md`, and `ASCP_Dart_SDK_Implementation_Plan.md`. On `feature/dart-sdk-client`, add typed methods, stream-based subscriptions, replay helpers, transport abstraction, validation hooks, and focused tests without pulling in Flutter UI concerns, and document how to use the current Dart SDK surface, why its API shape and transport choices were preferred over alternatives, what was verified, what remains limited, and what the repository should do after Dart reaches parity.
```

Done when:

- the Dart SDK covers the planned surface
- subscriptions and replay work
- the package remains SDK-only

## Final End State

The SDK effort is effectively complete when:

- the TypeScript SDK exists and is integration-tested against the mock server
- the TypeScript SDK acts as the first reference downstream package
- the Dart SDK exists with typed models, method wrappers, event subscriptions, replay helpers, and validation hooks
- both packages stay faithful to upstream ASCP contracts
- repository docs, plans, and status logs make continuation obvious

## If You Want One Short Master Prompt

Use this only when you want the next agent to select the next unfinished roadmap phase rather than forcing one specific step.

```text
Continue the ASCP SDK roadmap from repository state. Read `sdk/AGENTS.md`, `sdk/plans.md`, `sdk/docs/status.md`, `sdk/docs/sdk-build-roadmap.md`, the upstream protocol assets under `schema/`, `spec/`, `examples/`, and `conformance/`, plus the relevant implementation plan file. Identify the next unfinished SDK phase, keep the work scoped to one feature branch, update the plan first, implement only that phase, update docs before commit, leave a checkpoint in `sdk/docs/status.md`, and document the branch in enough detail that the next contributor understands how to use the branch output, why the chosen approach beat the alternatives, what was verified, what remains limited, and which branch should come next.
```
