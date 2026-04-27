# Replay Semantics Starter Prompt

Use this prompt to start the `replay semantics` feature for ASCP.

```md
You are starting the ASCP `replay semantics` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This feature makes reconnect, snapshot, cursor, ordering, and retention behavior explicit and testable. Do not widen scope into general protocol implementation.

## Branch

- Use feature branch: `feature/replay-semantics`
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

Then read the upstream outputs if they exist:

- canonical schemas under `protocol/schema/`
- method contract material for `sessions.subscribe` and `sessions.resume`
- event contract material for `sync.snapshot`, `sync.replayed`, `sync.cursor_advanced`, and related connectivity events
- any existing event stream fixtures under `protocol/examples/` or `protocol/conformance/fixtures/`

When reading the specs, focus first on:

- detailed spec sections 7.7, 7.10, 8.8, 9, 11, 13, 14, 16, and 17
- PRD sections 7 (`Reconnect flow`), 9 (`Sync and connectivity`), 10, 11, 12, 16, 17, 18, and 19

## Dependency Gate

This feature depends on method contracts and event contracts.

If those outputs are missing or still unstable, stop and report that the dependency gate is not met. Do not invent replay behavior independently of the defined subscribe/resume contracts and sync event payloads.

## Feature Boundary

Stay inside:

- reconnect flow semantics
- snapshot rules
- replay ordering rules
- cursor semantics
- retention and replay-limit behavior
- replay fixtures and replay-focused conformance material

Do not move ahead into:

- auth policy design beyond replay-related error behavior
- broad conformance program design outside replay coverage
- mock server implementation

## Required Deliverables

Create or update the assets needed to make replay behavior implementation-ready:

- replay and sync documentation
- replay example streams
- snapshot example payloads
- cursor behavior notes for `from_seq`, `from_event_id`, and opaque cursors
- conformance fixtures and tests focused on ordering, snapshot boundaries, and reconnect behavior

Prefer repository locations such as:

- `docs/`
- `protocol/examples/events/`
- `protocol/conformance/fixtures/`
- `protocol/conformance/tests/`

## Acceptance Criteria

The feature is done only when:

- reconnect flow is explicit from subscribe or resume through replay and live continuation
- sequence monotonicity and cursor advancement rules are testable
- snapshots are clearly distinguished from historical replay
- retention-limit behavior and fallback errors are documented without ambiguity
- the work is enough for `ASCP Replay-Capable` claims to be validated later

## Working Rules

- Treat replay safety as a protocol guarantee, not a convenience
- Prefer exact sequence and cursor rules over narrative prose
- Do not pretend replay exists when upstream contracts cannot support it
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether method and event contract outputs are present and stable enough
2. which replay docs, fixtures, and tests you will add or modify
3. the scoped task list for this branch

Then implement only the replay semantics slice.
```
