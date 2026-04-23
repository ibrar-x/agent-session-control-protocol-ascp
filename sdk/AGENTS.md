# AGENTS.md

## Purpose

This repository is a downstream ASCP workspace for **SDK creation only**.

It exists to turn the finished ASCP protocol assets into reusable language SDKs without reopening protocol-core scope by default.

The current priority is:

1. TypeScript SDK
2. Dart SDK

Do not treat this repository as a place for protocol-core invention, runtime adapter work, daemon work, product UI work, or mobile app work unless the source plans are deliberately revised.

## Source Material

Treat these inputs as the source material for this repository:

1. `../ASCP_Protocol_Detailed_Spec_v0_1.md`
2. `../ASCP_Protocol_PRD_and_Build_Guide.md`
3. `../schema/`
4. `../spec/`
5. `../examples/`
6. `../conformance/`
7. `../mock-server/`
8. `../reference-client/`
9. `../../ASCP_TypeScript_SDK_Implementation_Plan.md`
10. `../../ASCP_Next_Phase_Master_Roadmap.md`
11. `../../ASCP_Dart_SDK_Implementation_Plan.md`

If they disagree, prefer:

1. `../ASCP_Protocol_Detailed_Spec_v0_1.md` for exact contracts, payloads, schemas, compatibility behavior, replay rules, and error semantics
2. `../schema/`, `../spec/`, `../examples/`, and `../conformance/` for executable protocol truth and implementation-facing evidence
3. `../../ASCP_TypeScript_SDK_Implementation_Plan.md` for TypeScript SDK scope, architecture, and sequencing
4. `../../ASCP_Next_Phase_Master_Roadmap.md` for downstream work order and branch sequencing
5. `../../ASCP_Dart_SDK_Implementation_Plan.md` only when planning or implementing the Dart SDK

## Repository Scope

This repository currently covers:

- TypeScript SDK planning and implementation
- Dart SDK planning and later implementation
- shared SDK-facing documentation
- SDK-specific workflow files, prompt starters, and local skills
- validation, integration, and example guidance for SDK consumers

This repository explicitly does not cover by default:

- protocol-core revisions
- adapters such as Codex or Gemini
- host daemon implementation
- Flutter mobile implementation
- relay or remote access implementation
- runtime-specific UI or product surfaces

If downstream SDK work exposes a genuine protocol ambiguity or defect:

- document the issue clearly
- point back to the parent ASCP protocol repository assets
- stop short of silently redefining protocol semantics in SDK code

## SDK Constraints

All work in this repository should preserve the ASCP protocol principles already defined upstream:

- session-first
- capability-based
- event-driven
- transport-neutral
- replay-safe
- auditable
- explicit and boring

For SDK work, that means:

- keep method and event names exactly aligned with ASCP
- keep transport replaceable
- keep parsing and validation schema-led
- preserve unknown extension fields unless strict behavior is explicitly requested
- avoid SDK behavior that invents protocol semantics not present upstream
- keep typed helpers thin enough that consumers can still reason about the underlying ASCP payloads

## Current Delivery Order

Follow this order unless a strong implementation reason requires a narrower refinement:

1. repository bootstrap and workflow files
2. TypeScript SDK foundation
3. TypeScript validation layer
4. TypeScript transport layer
5. TypeScript typed client surface
6. TypeScript replay helpers
7. TypeScript examples and integration tests
8. Dart SDK planning refresh if needed
9. Dart SDK implementation

Do not start Dart implementation before the TypeScript SDK establishes the first downstream reference package unless the user explicitly changes priorities.

## TypeScript SDK Boundary

The TypeScript SDK should provide:

- strongly typed ASCP models
- typed method request and response wrappers
- event envelope parsing
- JSON Schema-backed validation
- stdio and WebSocket transport support
- replay helpers
- auth header and metadata hooks
- integration examples against the parent mock server

The TypeScript SDK should not become:

- a runtime adapter
- a host daemon
- a product service
- a UI toolkit
- a giant abstraction over every implementation detail

## Dart SDK Boundary

The Dart SDK is planned after the TypeScript SDK.

When Dart work starts, keep it focused on:

- typed models
- method wrappers
- event subscriptions
- replay helpers
- transport abstraction
- validation and auth hooks
- Flutter-friendly async ergonomics

Do not pull Flutter UI concerns into the SDK package.

## New Conversation Bootstrap

When a brand new conversation starts in this repository, bootstrap in this order:

1. read `AGENTS.md`
2. read `plans.md` if it exists
3. read `docs/status.md` if it exists
4. read the upstream ASCP protocol sources listed above
5. read the relevant SDK implementation plan document for the active language
6. inspect recent git history if more context is needed
7. determine whether there is an active unfinished SDK task
8. continue the next logical task or create a new plan if no plan exists yet

If `plans.md` does not exist, create it before implementation work.

If `plans.md` does exist, the agent should:

- identify the current active feature
- find the next unfinished task
- continue that task instead of inventing a new direction
- warn the user if the request appears to be a different feature

## Planning First For New Work

Before writing SDK code, convert the active feature into a written plan in `plans.md`.

The first planning pass for a new SDK feature should include:

- feature name
- branch name
- active language target
- source inputs
- scope and out-of-scope notes
- task list with acceptance criteria
- validation plan

For TypeScript SDK work, break the implementation into slices such as:

- foundation and package scaffold
- generated or hand-authored model surface
- validation layer
- transport layer
- typed client methods
- replay helpers
- examples
- integration tests

## Feature Drift Detection

Agents must protect this repository from drift.

- If the request is a refinement or bugfix for the active SDK feature, continue on the same branch.
- If the request is a materially separate feature, warn the user and recommend a new branch.
- Do not silently mix TypeScript SDK work with Dart SDK work on one branch unless the branch is explicitly scoped to shared docs or repo workflow.
- Do not silently mix SDK work with adapter, daemon, or product-app work.

## Git Workflow Discipline

Agents working in this repository should use a strict feature workflow:

- fetch and pull the latest `main` before starting a new feature branch
- create one branch per SDK feature or materially separate refinement
- keep `plans.md` updated before implementation starts
- update documentation before commit
- add a concise checkpoint to `docs/status.md` after each completed task
- treat a completed task as a git checkpoint

Recommended branch sequence:

- `feature/sdk-repo-bootstrap`
- `feature/typescript-sdk-foundation`
- `feature/typescript-sdk-validation`
- `feature/typescript-sdk-transport`
- `feature/typescript-sdk-client`
- `feature/typescript-sdk-replay`
- `feature/typescript-sdk-examples-tests`
- `feature/dart-sdk`

## Documentation Before Commit

Documentation is required before commit in this repository.

Before claiming a task is complete:

- update the relevant docs
- keep workflow and rationale in dedicated markdown files where possible
- make sure examples and validation guidance reflect the actual SDK behavior
- leave enough written state that another session can resume without hidden context

Useful documentation locations:

- `README.md`
- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- `docs/`
- language package READMEs under `typescript/` and `dart/`

## Checkpointing

Every completed task should leave a recovery point:

- update `plans.md`
- add a short entry to `docs/status.md`
- record the branch, summary, documents updated, and next likely step

The goal is that a new session can recover the active SDK work from repository files alone.

## Expected Repository Growth

As this repository matures, prefer a structure close to:

```text
README.md
AGENTS.md
plans.md
docs/
  status.md
  prompts/
.agents/skills/
typescript/
dart/
```

The TypeScript and Dart package internals should follow their respective implementation plans instead of ad hoc structure changes.

## Definition Of Done For SDK Work

An SDK task is not done when the package merely compiles.

It is done when the relevant surface is:

- aligned with upstream ASCP contracts
- documented
- validated
- integration-ready
- scoped tightly enough that downstream consumers do not have to guess

For TypeScript SDK work, prefer concrete outputs such as:

- package scaffold
- typed models
- schema validation utilities
- transport adapters
- typed client methods
- replay helpers
- integration tests against the mock server
- usage examples

If a proposed change makes the SDK more convenient by hiding or changing ASCP semantics, it is probably the wrong change.
