# TypeScript SDK Foundation Branch Reference

This document captures the detailed implementation context for the completed `feature/typescript-sdk-foundation` branch.

Use it when you need to understand how the current TypeScript foundation should be used, why it was designed this way, what it intentionally does not do yet, and what the next branch should build on top of it.

## Branch Identity

- Branch: `feature/typescript-sdk-foundation`
- Feature commit: `a6dac54`
- Merge commit on `main`: `b27d619`
- Current repository state: merged into `main`

## What This Branch Added

The foundation branch established the first real TypeScript package shape under `sdk/typescript/`.

It added:

- an installable package baseline in `typescript/package.json`
- TypeScript compiler baselines in `typescript/tsconfig*.json`
- Vitest and typecheck verification baselines
- explicit package root and subpath exports
- authored model, method, event, and error type surfaces
- reserved directories for future `client`, `transport`, `validation`, `replay`, and `auth` work
- package-level documentation that explains the foundation scope

## What It Intentionally Did Not Add

This branch did not implement:

- runtime schema validation
- stdio transport
- WebSocket transport
- typed method-call execution helpers
- replay helpers
- mock-server integration tests

Those belong to later branches and were intentionally kept out so the package shape could stabilize first.

## Upstream Inputs That Shaped The Branch

The branch was built directly from these upstream inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../schema/`
- `../../examples/`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`

These inputs were used for different purposes:

- the implementation plan defined the intended package layering and sequencing
- the schemas defined the core ASCP nouns, enums, and envelope contracts
- the examples anchored method names, request/response shapes, and event naming
- the detailed spec kept the exported protocol names aligned with ASCP rather than SDK-specific abstractions

## How To Use The Current Foundation

From `sdk/typescript/`:

```bash
npm install
npm run build
npm test
npm run test:types
```

Or run the full foundation verification:

```bash
npm run check
```

The current public surface is type-first. It is meant to be imported by later validation and transport work, not used yet as a full executable client.

Current import points:

- package root: `ascp-sdk-typescript`
- models: `ascp-sdk-typescript/models`
- methods: `ascp-sdk-typescript/methods`
- events: `ascp-sdk-typescript/events`
- errors: `ascp-sdk-typescript/errors`

Representative usage from the current branch shape:

```ts
import type { Session, EventEnvelope } from "ascp-sdk-typescript";
import type { SessionsListParams } from "ascp-sdk-typescript/methods";

const params: SessionsListParams = {
  status: "running",
  limit: 10
};

const session: Session = {
  id: "sess_123",
  runtime_id: "runtime_01",
  status: "running",
  created_at: "2026-04-23T00:00:00Z",
  updated_at: "2026-04-23T00:00:00Z"
};

const event: EventEnvelope = {
  id: "evt_1",
  type: "message.assistant.delta",
  ts: "2026-04-23T00:00:00Z",
  session_id: session.id,
  payload: { message_id: "msg_1", delta: "hello" }
};
```

## Source Layout You Should Assume

The branch intentionally locked in this package layout:

```text
typescript/
  src/
    models/
    methods/
    events/
    errors/
    client/
    transport/
    validation/
    replay/
    auth/
  test/
  test-d/
```

The reserved directories are important. Later branches should add implementation inside them rather than introducing a different top-level package structure.

## Thought Process Behind The Design

The main design goal was to make later work additive.

That led to four decisions:

1. stabilize the package layout before adding execution behavior
2. make the public surface explicit through root and subpath exports
3. keep the exported types close to upstream ASCP nouns
4. reserve future implementation directories now so later branches do not need to restructure the package

The branch was deliberately biased toward boring, explicit packaging choices over clever shortcuts. That matches the ASCP protocol constraints and reduces drift risk for the validation and transport phases.

## Why This Approach Was Chosen

### Authored schema-indexed types instead of early code generation

This branch originally explored generation as the model strategy, but the upstream schemas include patterns that were a poor fit for the first chosen generator. Rather than committing the package to a brittle generation path early, the branch settled on authored types indexed directly against the upstream schemas and examples.

That choice was preferred because:

- it kept the public surface explicit
- it avoided generator lock-in before the validation layer existed
- it let the foundation branch complete without inventing schema semantics
- it preserved the option to introduce generation later behind stable barrels

### Explicit export map instead of broad internal exposure

The branch exports only the package root plus `./models`, `./methods`, `./events`, and `./errors`.

That was chosen so later branches can implement internals without making every folder part of the long-term public API by accident.

### Reserved directories instead of a minimal current-only tree

The branch created `client`, `transport`, `validation`, `replay`, and `auth` directories even though they only contain placeholders at this stage.

That was chosen because the implementation plan already fixed those layers. Creating them early removes future restructuring pressure and makes downstream sequencing obvious.

### Vitest plus type-level checks instead of runtime-only verification

The branch added:

- `test/metadata.test.ts` for runtime metadata assertions
- `test-d/public-api.test-d.ts` for public API compilation checks

That combination was chosen because the branch is mostly about package shape and type surface, not runtime transport behavior.

## Alternatives Considered And Rejected

### Generate all types immediately from schema files

Rejected in this branch because the first attempted generator path was not stable against the current upstream schema structure. For the foundation slice, documentation clarity and stable exports mattered more than forcing generation prematurely.

### Build transport and client helpers in the same branch

Rejected because it would have mixed package-shape decisions with executable behavior, making it harder to tell whether later problems came from layout mistakes or transport/client logic.

### Export every internal module directly

Rejected because it would have frozen too much of the internal package layout into the public API before the later layers existed.

### Defer package-level tests until validation or transport

Rejected because the foundation still needed proof that the package metadata, exports, and type surface compiled and behaved as intended.

## Verification Evidence

The foundation branch was verified with:

```bash
cd sdk/typescript
npm run build
npm test
npm run test:types
```

And repository-level whitespace/conflict safety was checked with:

```bash
cd sdk
git diff --check
```

What these commands proved:

- `npm run build` proved the package compiled into `dist/`
- `npm test` proved the runtime foundation metadata stayed pinned and discoverable
- `npm run test:types` proved the public type surface compiled as intended
- `git diff --check` proved the branch changes were free of whitespace and patch-format issues

## Known Limitations And Deferred Work

The current foundation has important limits:

- payload parsing is not validated at runtime yet
- no transport implementation exists yet
- no request/response execution client exists yet
- replay helpers do not exist yet
- the authored types are intentionally thin and do not try to hide ASCP semantics

These are expected limitations, not regressions. They are the reason the next branch should be validation-only rather than mixing in transport behavior.

## What The Next Branch Should Assume

The next branch is:

- `feature/typescript-sdk-validation`

That branch should assume:

- the package root and export map are stable
- `src/models`, `src/methods`, `src/events`, and `src/errors` are the foundation barrels to preserve
- validation can add runtime helpers under `src/validation` without moving the public type imports
- future transport and client work should build on the existing type surface rather than replace it

The validation branch should not revisit the foundation package shape unless a genuine upstream protocol issue forces it.

## Files Most Relevant To This Branch

- `typescript/package.json`
- `typescript/src/index.ts`
- `typescript/src/metadata.ts`
- `typescript/src/models/types.ts`
- `typescript/src/methods/types.ts`
- `typescript/src/events/types.ts`
- `typescript/src/errors/types.ts`
- `typescript/test/metadata.test.ts`
- `typescript/test-d/public-api.test-d.ts`
- `typescript/README.md`

## Continuation Guidance

If you are starting from current `main`, treat this document as the rationale handoff for the foundation layer.

Read in this order:

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `docs/branches/typescript-sdk-foundation.md`
5. `docs/prompts/typescript-sdk-validation.md`
6. upstream `schema/`, `spec/`, `examples/`, and `conformance/`

That gives enough context to continue the TypeScript SDK without needing hidden chat history.
