# Method Contracts Starter Prompt

Use this prompt to start the `method contracts` feature for ASCP.

```md
You are starting the ASCP `method contracts` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This feature defines exact request, response, and error contracts for every core ASCP method. Do not widen scope into unrelated protocol areas.

## Branch

- Use feature branch: `feature/method-contracts`
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

Then read the outputs from the schema foundation workstream if they exist:

- `protocol/schema/ascp-core.schema.json`
- `protocol/schema/ascp-capabilities.schema.json`
- `protocol/schema/ascp-errors.schema.json`
- any core examples under `protocol/examples/`
- any supporting docs created to explain schema assumptions

When reading the specs, focus first on:

- detailed spec sections 5, 6, 7, 11, 13, 14, 16, and 17
- PRD sections 7, 8, 11, 12, 14, 16, 17, 18, and 19

## Dependency Gate

This feature depends on schema foundation.

If the schema foundation outputs are missing or obviously incomplete, stop and report that the dependency gate is not met. Do not invent method shapes independently of the canonical schemas.

## Feature Boundary

Stay inside:

- request envelope handling
- success response envelope handling
- error response envelope handling
- exact params and result shapes for every core method
- allowed error-code mapping per method
- method examples and validation assets

Do not move ahead into:

- full event payload definition beyond method-triggered references
- replay stream behavior beyond method contract references
- auth implementation details beyond documented method-level requirements
- mock server behavior

## Required Deliverables

Create or update the assets needed to make method contracts explicit and implementation-ready:

- request and response contract material for:
  - `capabilities.get`
  - `hosts.get`
  - `runtimes.list`
  - `sessions.list`
  - `sessions.get`
  - `sessions.start`
  - `sessions.resume`
  - `sessions.stop`
  - `sessions.send_input`
  - `sessions.subscribe`
  - `sessions.unsubscribe`
  - `approvals.list`
  - `approvals.respond`
  - `artifacts.list`
  - `artifacts.get`
  - `diffs.get`
- examples for valid requests and responses
- examples for allowed error responses
- documentation tying the method surface back to the capability document and schema foundation

Prefer repository locations that keep normative material separate and explicit, such as:

- `protocol/spec/`
- `protocol/examples/requests/`
- `protocol/examples/responses/`
- `protocol/examples/errors/`

## Acceptance Criteria

The feature is done only when:

- every core method has exact params, result shape, and allowed error codes
- request `id` echo behavior is explicit and testable
- `result` and `error` exclusivity is preserved
- examples align with the canonical schemas and detailed spec
- no method contract mutates or redefines the core entity schemas

## Working Rules

- Treat the detailed spec as authoritative for exact method names and payload fields
- Reuse canonical schemas rather than duplicating object definitions loosely
- Keep compatibility claims explicit
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether schema foundation outputs are present and usable
2. which contract files and example directories you will create or modify
3. the scoped task list for this branch

Then implement only the method contracts slice.
```
