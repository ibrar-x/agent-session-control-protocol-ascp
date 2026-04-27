# Event Contracts Starter Prompt

Use this prompt to start the `event contracts` feature for ASCP.

```md
You are starting the ASCP `event contracts` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This feature defines the exact payload contracts for all core ASCP event families. Stay strictly inside event contracts.

## Branch

- Use feature branch: `feature/event-contracts`
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

- `protocol/schema/ascp-core.schema.json`
- any capability and error schemas needed by event references
- method and example docs only where they constrain event-related fields
- prior example fixtures under `protocol/examples/`

When reading the specs, focus first on:

- detailed spec sections 4.8, 5, 8, 9, 11, 13, 14, 16, and 17
- PRD sections 6 (`EventEnvelope`), 9, 11, 16, 17, 18, and 19

## Dependency Gate

This feature depends on schema foundation.

If canonical schema outputs are missing or unstable, stop and report that the dependency gate is not met. Do not define event payloads against guessed core object shapes.

## Feature Boundary

Stay inside:

- `EventEnvelope`
- exact payloads for all core event types
- event fixtures and validators
- compatibility notes for event support

Do not move ahead into:

- replay sequencing implementation beyond what is required to keep event contracts replay-safe
- auth decisions beyond fields explicitly required by approval and audit events
- mock server logic

## Required Deliverables

Create or update the assets needed to define event contracts precisely:

- `protocol/schema/ascp-events.schema.json`
- event fixtures for:
  - session lifecycle events
  - run lifecycle events
  - transcript events
  - tool activity events
  - terminal fallback events
  - approval events
  - artifact and diff events
  - sync and connectivity events
  - error events
- event support documentation tied to compatibility claims

Prefer repository locations such as:

- `protocol/schema/`
- `protocol/examples/events/`
- `protocol/spec/` or `docs/` for explanatory event notes

## Acceptance Criteria

The feature is done only when:

- every event type listed in the detailed spec has an explicit payload definition
- event examples validate inside `EventEnvelope`
- event family names and payload field names exactly match the spec
- event contracts remain replay-safe and additive
- fixtures are concrete enough for later replay and conformance work to build on

## Working Rules

- Treat the detailed spec as authoritative for event names and payload shapes
- Reuse canonical schemas instead of restating shared objects loosely
- Keep event support claims explicit
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether schema foundation outputs are present and stable
2. the exact event-schema, fixture, and documentation files you will add or modify
3. the scoped branch task list

Then implement only the event contracts slice.
```
