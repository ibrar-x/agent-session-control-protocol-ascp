# Auth And Approvals Starter Prompt

Use this prompt to start the `auth and approvals` feature for ASCP.

```md
You are starting the ASCP `auth and approvals` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This feature defines auth hooks, method-level scope expectations, actor attribution, and approval lifecycle behavior for sensitive control actions. Keep the work protocol-first and vendor-neutral.

## Branch

- Use feature branch: `feature/auth-approvals`
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

Then read upstream outputs if they exist:

- canonical schemas under `protocol/schema/`
- method contract outputs for:
  - `sessions.start`
  - `sessions.resume`
  - `sessions.stop`
  - `sessions.send_input`
  - `approvals.list`
  - `approvals.respond`
  - `artifacts.list`
  - `artifacts.get`
  - `diffs.get`
- event contract outputs for approval and error events
- any replay notes that affect auth failure behavior during reconnect

When reading the specs, focus first on:

- detailed spec sections 4.5, 7.12, 7.13, 8.6, 8.9, 10, 11, 13, 14, 16, and 17
- PRD sections 7 (`Approval flow`), 14, 15, 16, 17, 18, and 19

## Dependency Gate

This feature depends on schema foundation, method contracts, and event contracts.

If those outputs are missing or obviously unstable, stop and report that the dependency gate is not met. Do not invent auth or approval behavior disconnected from the method and event surfaces.

## Feature Boundary

Stay inside:

- auth hooks documentation
- scope matrix and sensitive-method rules
- actor, device, and correlation attribution
- approval request and response lifecycle rules
- auth failure and approval-related fixtures

Do not move ahead into:

- vendor-specific auth providers
- transport-specific token exchange mechanics
- product UI approval flows
- mock server behavior beyond what is needed to document fixtures

## Required Deliverables

Create or update the assets needed to make auth and approvals implementation-ready:

- auth hooks documentation
- scope matrix covering read and write methods
- approval request and approval event fixtures
- auth failure examples showing `UNAUTHORIZED` versus `FORBIDDEN`
- actor and audit attribution notes tied to protocol fields

Prefer repository locations such as:

- `docs/`
- `protocol/examples/approvals/`
- `protocol/examples/errors/`
- `protocol/conformance/fixtures/` if you add approval or auth validation inputs

## Acceptance Criteria

The feature is done only when:

- sensitive methods have explicit control-scope expectations
- read methods have explicit read-scope expectations
- approval lifecycle behavior is consistent across methods, entities, and events
- auth failures are distinguishable and auditable
- approval history and actor attribution are documented as first-class protocol concerns

## Working Rules

- Keep the work vendor-neutral
- Use exact protocol names from the detailed spec
- Separate normative auth rules from optional implementation guidance
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether upstream contract outputs are present and stable enough
2. which auth, approval, and example files you will add or modify
3. the scoped task list for this branch

Then implement only the auth and approvals slice.
```
