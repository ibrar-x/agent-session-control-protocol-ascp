# Reference Client Starter Prompt

Use this prompt to start an optional downstream `reference client` feature for ASCP.

```md
You are starting the ASCP `reference client` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This is not new protocol design work. The ASCP protocol workspace is already closed out for the v0.1 contract set. This branch should consume the frozen schemas, examples, conformance assets, and mock server as a downstream proof client.

## Branch

- Use feature branch: `feature/reference-client`
- Start from the latest `main`

## Bootstrap From Repository State First

Read these files before planning or implementation:

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `ASCP_Protocol_Detailed_Spec_v0_1.md`
5. `ASCP_Protocol_PRD_and_Build_Guide.md`
6. `README.md`
7. `docs/repo-operating-system.md`
8. `docs/protocol-usage-and-dto-generation.md`
9. `mock-server/README.md`
10. `docs/prompts/reference-client.md`

Then read the frozen upstream implementation inputs this client must consume:

- canonical schemas under `schema/`
- protocol examples under `examples/`
- compatibility documentation and manifests under `spec/compatibility.md` and `conformance/fixtures/compatibility/`
- the mock-server implementation under `mock-server/`
- the mock validator and conformance harness under `mock-server/tests/`, `conformance/tests/`, and `scripts/`

When reading the specs, focus first on:

- detailed spec sections 7, 8, 9, 10, 13, 14, and 17
- PRD sections 7, 8, 9, 10, 16, 17, 18, and 19

## Dependency Gate

This branch depends on the completed upstream protocol workspace:

- canonical schemas
- method contracts
- event contracts
- replay semantics
- auth and approvals
- extensions
- conformance evidence
- mock server

If any of those are missing or unstable, stop and report the dependency gap. Do not redesign ASCP from the client branch.

## Feature Boundary

Stay inside:

- a small deterministic reference client that consumes the frozen ASCP method and event surface
- code that talks to the existing mock server rather than inventing a parallel runtime
- DTO or typed-model usage based on the published schema files where useful
- documentation that explains what the reference client proves and what it does not prove
- verification that the client can perform discovery, session inspection, subscription, replay recovery, and approval/artifact reads against the mock

Do not move ahead into:

- protocol redesign
- new methods, events, or schema fields
- vendor-specific UX
- production auth stacks
- broad SDK packaging for multiple languages

## Required Deliverables

Create or update the assets needed for a usable downstream proof client:

- `reference-client/`
- a minimal transport/client layer for the mock-server stdio JSON-RPC surface
- one or more example flows that exercise discovery, session reads, subscribe/replay, and approval/artifact access
- branch-specific docs explaining client scope and limitations
- a repeatable validator or demo script

The reference client should be useful for:

- proving that ASCP can be consumed without hidden assumptions
- demonstrating one clean client-side interpretation of the frozen schemas and examples
- helping future SDK or product teams start from a concrete consumer instead of only prose and fixtures

## Acceptance Criteria

The feature is done only when:

- the client can discover capabilities and runtimes from the mock
- the client can inspect sessions, approvals, artifacts, and diffs
- the client can subscribe and observe deterministic snapshot plus replay behavior
- the client stays strictly downstream of the published ASCP v0.1 contracts
- the client documents what it validates and what remains outside scope

## Working Rules

- Treat the protocol, schemas, examples, conformance assets, and mock server as frozen inputs
- If the client exposes a protocol ambiguity, stop and point at the exact upstream contract instead of silently choosing a new protocol rule
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether the upstream protocol and mock assets are stable enough
2. the exact `reference-client/` files you will add or modify
3. the scoped task list for the branch

Then implement only the reference-client slice.
```
