# ASCP SDK Project Context Reference

This document is the repository-wide context reference for the ASCP SDK workspace. It is meant to give a future contributor enough context to understand what this project is, what source material it depends on, what has been bootstrapped locally, and how to continue without hidden chat history.

## Summary

This repository is a downstream ASCP workspace for SDK creation only.

The parent ASCP repository already contains the finished protocol-core assets:

- source-of-truth protocol documents
- canonical schemas
- request, response, error, and event examples
- replay, auth, extension, and compatibility specs
- conformance fixtures and validators
- a deterministic mock server
- a downstream reference client

This workspace exists to convert those assets into reusable SDK packages, starting with TypeScript and later Dart.

## What This Repository Is

This repository is:

- an SDK workspace
- TypeScript-first
- downstream from the finished protocol-core repository
- schema-led
- validation-oriented
- expected to integrate against the parent mock server

This repository is not:

- a protocol-core repo
- a runtime adapter repo
- a daemon repo
- a Flutter app repo
- a relay or remote-access repo

## Source Of Truth

Read these first when exact SDK behavior or scope matters:

1. `../AGENTS.md`
2. `../../ASCP_Protocol_Detailed_Spec_v0_1.md`
3. `../../schema/`
4. `../../spec/`
5. `../../examples/`
6. `../../conformance/`
7. `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
8. `../../../ASCP_Next_Phase_Master_Roadmap.md`
9. `../../../ASCP_Dart_SDK_Implementation_Plan.md`

Conflict rule:

- use the detailed spec, schemas, specs, examples, and conformance assets for exact protocol truth
- use the TypeScript implementation plan for the first SDK package shape and phased order
- use the roadmap for sequencing across workstreams
- use the Dart plan only for future Dart work

## Current Status

The workspace is bootstrapped for SDK development and now contains the full TypeScript reference package plus a dedicated Dart planning handoff.

Completed local outputs currently include:

- repository operating rules in `AGENTS.md`
- active task planning in `plans.md`
- checkpoint logging in `docs/status.md`
- a docs index and continuation reference under `docs/`
- a growing set of branch-reference documents for completed SDK work
- prompt starters for the first SDK workstreams
- a local skill pack for SDK workflow and TypeScript-first implementation
- a TypeScript package scaffold with package metadata, compiler/test baselines, authored protocol model barrels, and reserved directories for later client, replay, and auth work
- a validation entry point with AJV-backed schema validation, vendored schema snapshots, and focused runtime plus type-level tests
- a transport entry point with replaceable stdio and WebSocket adapters, shared request/subscription contracts, and normalized transport errors
- an analytics entry point with opt-in recorder contracts, remediation helpers, and baseline production package metadata
- a typed client entry point with wrappers for every ASCP core method and normalized protocol-error mapping
- a replay entry point with replay request builders, snapshot-versus-replay stream classification, opaque cursor pass-through, and focused fixture-driven replay tests
- end-to-end examples and integration tests against the upstream mock server
- release-readiness documentation that locks the TypeScript package boundary as the first downstream reference package
- a Dart planning branch reference that defines the Dart package scope, layout, model and codec strategy, and replay-aware implementation handoff

## Planned Workstreams

### 1. Repository bootstrap

Purpose:
- make the SDK workspace resumable and predictable before package code exists

Main outputs:
- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/repo-operating-system.md`
- `docs/prompts/`
- `.agents/skills/`

### 2. TypeScript SDK foundation

Purpose:
- establish the package scaffold, public exports, and model strategy

Expected outputs:
- initial package structure under `typescript/`
- documented generation or authoring strategy for typed models
- public export surface for protocol nouns and method DTOs

Status:
- complete

### 3. TypeScript validation

Purpose:
- make incoming responses and events safe to parse and use

Expected outputs:
- schema loading strategy
- AJV-backed validators
- clear validation error formatting
- tests for validation success and failure paths

Status:
- complete on `feature/typescript-sdk-validation`

### 4. TypeScript transport

Purpose:
- make the SDK executable against real ASCP surfaces

Expected outputs:
- stdio transport for mock-server integration
- WebSocket transport for future host use
- shared request and subscription contracts
- normalized transport error handling

Status:
- complete on `feature/typescript-sdk-transport`

### 5. TypeScript typed client

Purpose:
- expose the ASCP core method surface through typed wrappers on top of validation plus transport

Expected outputs:
- typed wrappers for core methods
- preservation of the existing analytics and remediation surface across client methods
- protocol-error handling guidance on top of the transport layer
- tests for wrapper request and response flow

Status:
- complete on `feature/typescript-sdk-client`

### 6. TypeScript replay

Purpose:
- make the event and replay surface usable downstream without hiding protocol meaning

Expected outputs:
- replay helpers
- request builders for `from_seq`, `from_event_id`, and opaque cursor pass-through
- snapshot-versus-replay event classification
- focused replay tests against upstream fixtures

Status:
- complete on `feature/typescript-sdk-replay`

### 7. TypeScript examples and integration tests

Purpose:
- prove the typed client plus replay surface end to end against executable ASCP hosts

Expected outputs:
- subscribe and reconnect examples
- integration tests against the mock server

Status:
- complete on `feature/typescript-sdk-examples-tests`

### 8. TypeScript release readiness

Purpose:
- lock the TypeScript package boundary, release policy, and downstream-consumer guidance before Dart starts

Expected outputs:
- documented root-versus-subpath package boundary
- release notes and packaged docs
- release-check evidence

Status:
- complete on `feature/typescript-sdk-release-readiness`

### 9. Dart SDK planning

Purpose:
- start Dart intentionally after the TypeScript package proves the first downstream boundary

Expected outputs:
- package scope confirmation
- package layout decision
- model and codec strategy
- validation, subscription, and replay plan
- first implementation branch handoff

Status:
- complete on `feature/dart-sdk-planning`

### 10. Dart SDK

Purpose:
- create a second consumer package after TypeScript proves the downstream shape

Expected outputs:
- Dart package scaffold and typed API
- stream-friendly subscription surface
- replay helpers
- integration guidance for Flutter consumers

Status:
- next likely implementation slice is `feature/dart-sdk-foundation`

## Local Directory Layout

The intended local structure is:

```text
sdk/
  README.md
  AGENTS.md
  plans.md
  docs/
  .agents/skills/
  typescript/
  dart/
```

The parent repository remains the source of protocol truth. This workspace should consume those assets rather than duplicate them casually.

## Local Skill Pack

The local skill pack is focused on SDK workstreams:

- `ascp-sdk-task-operating-system`
- `ascp-sdk-documentation-discipline`
- `ascp-typescript-sdk-foundation`
- `ascp-typescript-sdk-transport-client`
- `ascp-typescript-sdk-validation-replay`
- `ascp-dart-sdk-planning`

These skills are meant to keep future sessions aligned with the TypeScript-first downstream roadmap instead of drifting back into protocol-core work.

## Suggested Reading Order For A New Session

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. the relevant completed branch reference under `docs/branches/` if the active feature builds on one
5. upstream detailed spec and schema/spec/example assets
6. the relevant SDK implementation plan
7. the prompt starter for the active feature

## Safe Continuation Model

When continuing work here:

- keep one feature per branch
- keep work SDK-only
- prefer the TypeScript SDK unless the active plan says otherwise
- validate against the parent mock server and examples whenever practical
- document before commit
- leave a checkpoint in `docs/status.md`

If a new request appears to belong to adapters, daemon work, or product surfaces, treat that as drift and recommend a separate branch or repository context.
