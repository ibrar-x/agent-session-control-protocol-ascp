# Conformance Starter Prompt

Use this prompt to start the `conformance` feature for ASCP.

```md
You are starting the ASCP `conformance` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This feature turns the written protocol into verifiable compatibility claims. Do not widen scope into new protocol design unless a validation gap forces a narrowly scoped contract clarification.

## Branch

- Use feature branch: `feature/conformance`
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

Then read all upstream protocol outputs that already exist:

- `schema/`
- `examples/`
- `docs/` protocol notes related to replay, auth, extensions, and compatibility
- any prior compatibility documentation

When reading the specs, focus first on:

- detailed spec sections 11, 13, 14, 15, 16, and 17
- PRD sections 11, 12, 14, 16, 17, 18, and 19

## Dependency Gate

This feature depends on schema foundation, method contracts, event contracts, replay semantics, auth and approvals, and extension rules.

If those outputs are missing or still shifting, stop and report that the dependency gate is not met. Do not start a conformance layer against unstable upstream contracts.

## Feature Boundary

Stay inside:

- conformance fixtures
- validators
- contract tests
- compatibility matrix
- golden examples tied to explicit compatibility claims

Do not move ahead into:

- mock server implementation beyond what is strictly needed as a test target
- product client code
- new protocol surface area

## Required Deliverables

Create or update the assets needed to make compatibility claims verifiable:

- `conformance/fixtures/`
- `conformance/validators/`
- `conformance/tests/`
- compatibility matrix for:
  - `ASCP Core Compatible`
  - `ASCP Interactive`
  - `ASCP Approval-Aware`
  - `ASCP Artifact-Aware`
  - `ASCP Replay-Capable`
- golden examples for requests, responses, events, replay flows, auth failures, and extension handling

## Acceptance Criteria

The feature is done only when:

- schema validity is testable
- method request and response validation is testable
- event payload validation is testable
- replay ordering and snapshot boundaries are testable
- auth failure handling is testable
- unknown extension ignore behavior is testable
- compatibility levels are backed by fixtures and tests rather than prose only

## Working Rules

- Treat compatibility claims as evidence-backed
- Prefer deterministic fixtures over broad prose
- If a validation gap reveals an unclear upstream contract, stop and isolate that gap instead of silently redefining behavior here
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether all upstream contract outputs are present and stable enough
2. the exact conformance directories and validator/test files you will add or modify
3. the scoped task list for this branch

Then implement only the conformance slice.
```
