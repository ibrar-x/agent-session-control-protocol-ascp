# Mock Server Starter Prompt

Use this prompt to start the `mock server` feature for ASCP.

```md
You are starting the ASCP `mock server` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This feature creates a deterministic proof implementation of the protocol. The mock must stay protocol-first and vendor-neutral. Do not invent product behavior.

## Branch

- Use feature branch: `feature/mock-server`
- Start from the latest `main`

## Bootstrap From Repository State First

Read these files before planning or implementation:

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
5. `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
6. `README.md`
7. `docs/repo-operating-system.md`

Then read all upstream outputs that define the protocol behavior the mock must implement:

- canonical schemas under `protocol/schema/`
- request and response examples under `protocol/examples/`
- event fixtures
- replay docs and fixtures
- auth and approval docs and fixtures
- conformance fixtures and tests

When reading the specs, focus first on:

- detailed spec sections 7, 8, 9, 10, 11, 13, 14, 15, 16, and 17
- PRD sections 7, 8, 9, 10, 14, 16, 17, 18, and 19

## Dependency Gate

This feature depends on schema foundation, method contracts, event contracts, replay semantics, auth and approvals, and a minimal conformance baseline.

If those outputs are missing or unstable, stop and report that the dependency gate is not met. Do not build a mock that guesses at protocol behavior.

## Feature Boundary

Stay inside:

- deterministic mock host and runtime data
- deterministic session, approval, artifact, and diff fixtures
- schema-valid responses and event streams
- replay-aware and approval-aware sample behavior needed for protocol consumers
- documentation explaining what the mock covers and what it does not cover

Do not move ahead into:

- product UI
- vendor-specific runtime behavior
- non-deterministic or speculative protocol extensions

## Required Deliverables

Create or update the assets needed for a usable protocol mock:

- `services/mock-server/`
- sample event streams
- deterministic fixture data for host, runtime, session, approval, artifact, and diff cases
- basic compatibility notes for the supported mock behavior

The mock should be useful for:

- client discovery flow testing
- session inspection and basic control-flow testing
- live subscription and replay testing
- approval and artifact workflow testing

## Acceptance Criteria

The feature is done only when:

- a client can discover capabilities and inspect sessions without guessing
- emitted responses and events are schema-valid
- replay-related behavior follows the defined upstream replay rules
- approval and artifact behavior match the documented protocol contracts
- the mock stays deterministic enough for conformance debugging

## Working Rules

- Reuse upstream fixtures and validators wherever possible
- If the mock exposes a protocol gap, stop and point at the upstream contract that needs clarification
- Do not let the mock become the source of truth; it must implement the written protocol, not replace it
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether upstream protocol outputs and conformance assets are present and stable enough
2. the exact mock-server directories and files you will add or modify
3. the scoped branch task list

Then implement only the mock server slice.
```
