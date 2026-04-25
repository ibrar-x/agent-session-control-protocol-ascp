# TypeScript SDK Examples And Integration Tests Branch Reference

This document captures the implementation context for `feature/typescript-sdk-examples-tests`.

Use it when you need to understand how the TypeScript SDK is proven end to end against the upstream mock server, why the examples stay thin and protocol-faithful, and what the release-readiness branch should tighten next.

## Branch Identity

- Branch: `feature/typescript-sdk-examples-tests`
- Current repository state: implemented locally on the examples/tests branch

## What This Branch Added

The examples/tests branch finished the first end-to-end proof layer for `sdk/typescript/`.

It introduced:

- `typescript/test/examples.integration.test.ts`
- `typescript/examples/subscribe-replay.ts`
- `typescript/examples/approval-flow.ts`
- `typescript/examples/artifact-diff.ts`
- `typescript/examples/_shared.ts`
- package scripts for the three examples plus the integration suite
- package README guidance for running the examples and understanding what is verified end to end

## What It Intentionally Did Not Add

This branch did not implement:

- protocol-core changes
- new transport adapters
- SDK-specific DTO aliases over ASCP field names
- auth-hook behavior beyond the existing client and transport surfaces
- package publishing or release automation
- Dart SDK work

Those remain out of scope so this slice stays focused on executable downstream proof instead of widening into release engineering or protocol design.

## Upstream Inputs That Shaped The Branch

The branch was built from these inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../mock-server/README.md`
- `../../reference-client/README.md`
- `../../examples/`
- `../../conformance/`
- `../branches/typescript-sdk-client.md`
- `../branches/typescript-sdk-replay.md`

These inputs fixed the branch boundary:

- the TypeScript implementation plan named end-to-end examples and integration tests as the phase deliverables
- the mock-server README defined the deterministic stdio proof target
- the reference-client README showed the minimal downstream proof shape to match in another language
- the upstream examples and conformance fixtures anchored request, response, and replay expectations
- the client and replay branch docs established that end-to-end proof should reuse the existing typed client and replay helpers instead of inventing a new convenience layer

## How To Use The Branch Output

From `sdk/typescript/`:

```bash
npm install
npm run build
npm run test:integration
npm run example:subscribe-replay
npm run example:approval
npm run example:artifact-diff
```

What each example proves:

- `subscribe-replay.ts`: current snapshot material, replayed historical events, replay boundary, cursor advancement, and live continuation after `sendInput(...)`
- `approval-flow.ts`: reading pending approvals, resolving the seeded approval, and observing the emitted approval lifecycle events
- `artifact-diff.ts`: artifact listing, artifact lookup, and diff-summary lookup without hand-written response DTOs

The integration suite verifies those entrypoints and also proves the typed client surface directly for:

- discovery
- session reads
- approval reads
- artifact reads
- diff reads
- replay-aware subscriptions
- live input continuation

## Why The Examples Are Structured This Way

The examples are intentionally thin wrappers around the published package entry points.

They keep:

- `AscpClient` as the main method surface
- `subscribeWithReplay(...)` as the replay orchestration layer
- ASCP request field names unchanged
- result objects and event envelopes visible instead of remapped into alternate consumer DTOs

That design was chosen so downstream TypeScript users can copy a short working flow directly into real integrations and still reason about the underlying ASCP protocol objects.

## Alternatives Rejected

### Add a new high-level workflow facade just for examples

Rejected because the goal of this branch is proof, not a second abstraction layer. The examples should demonstrate the package consumers will actually use.

### Recreate response and event types locally inside the example code

Rejected because it would defeat the branch goal. The SDK package itself must supply the usable typed surface.

### Hide replay boundaries behind one merged "subscription summary" callback

Rejected because it would make the example easier to read at the cost of obscuring `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced`, which are first-class ASCP semantics.

## Verification Evidence

The branch was verified with:

- `npm test -- examples.integration.test.ts`
- `npm run build`
- `npm run test:integration`
- `npm test`
- `npm run test:types`
- `npm run check`
- `git diff --check`

The integration evidence proves:

- the TypeScript SDK talks to the parent mock server over stdio without hand-written protocol glue
- subscribe/replay flows remain aligned with the deterministic replay stream
- approvals, artifacts, and diffs can be consumed through typed client wrappers
- the standalone example entrypoints run successfully and emit deterministic summaries

## Limits And Handoff

Known limits:

- the example scripts depend on the built package output, so `npm run build` is part of the documented flow
- the approval example uses the seeded deterministic approval state and does not attempt to cover every approval decision branch
- release-facing package polish such as publish-time validation and long-form consumer docs is still deferred

The release-readiness branch should build on:

- the three example entrypoints
- `test/examples.integration.test.ts`
- the current README commands and usage guidance

It should tighten:

- release documentation and package presentation
- any remaining packaging assumptions around built examples
- final production-facing validation and publishing workflow details
