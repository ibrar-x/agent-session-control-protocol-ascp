# ASCP Status Log

Use this file as a session-to-session checkpoint log. Each completed task should add a concise entry.

## Entry Template

### YYYY-MM-DD - Short Task Name

- Branch:
- Commit:
- Summary:
- Documentation updated:
- Next likely step:

## Entries

### 2026-04-22 - Auth and approvals

- Branch: `feature/auth-approvals`
- Commit: `not committed`
- Summary: added the normative auth and approvals spec, documented the method scope matrix and audit-attribution hooks, created approval lifecycle fixtures for approved, rejected, and expired outcomes, expanded auth failure examples to distinguish `UNAUTHORIZED` from `FORBIDDEN`, and added a repeatable validator for auth-specific invariants against the frozen method and event contracts
- Documentation updated: `plans.md`, `docs/status.md`, `spec/auth.md`, `docs/superpowers/specs/2026-04-22-auth-approvals-design.md`, `docs/superpowers/plans/2026-04-22-auth-approvals.md`
- Next likely step: build `feature/extensions` or widen into the broader `conformance` slice using the auth and approval rules from this branch as fixed inputs

### 2026-04-22 - Replay semantics

- Branch: `feature/replay-semantics`
- Commit: `not committed`
- Summary: added the normative replay semantics spec, created replay-focused conformance fixtures for snapshot, from-seq, from-event-id, opaque-cursor, and retention-limited recovery paths, and added a repeatable validator that checks replay-specific ordering, boundary, and fallback rules against the frozen method and event contracts
- Documentation updated: `plans.md`, `docs/status.md`, `spec/replay.md`, `docs/superpowers/specs/2026-04-22-replay-semantics-design.md`, `docs/superpowers/plans/2026-04-22-replay-semantics.md`
- Next likely step: build `feature/auth-and-approvals` or widen into the broader `conformance` slice using the replay rules and replay fixtures as fixed inputs

### 2026-04-22 - Event contracts

- Branch: `feature/event-contracts`
- Commit: `not committed`
- Summary: added the ASCP event-contract schema, one schema-valid `EventEnvelope` fixture for every core event type, a normative event support spec, and a repeatable validator that confirms the full event surface against the frozen schema foundation
- Documentation updated: `plans.md`, `docs/status.md`, `spec/events.md`, `docs/superpowers/specs/2026-04-22-event-contracts-design.md`, `docs/superpowers/plans/2026-04-22-event-contracts.md`
- Next likely step: build `feature/replay-semantics` from the locked event stream surface, without redefining event payload shapes

### 2026-04-22 - Method contracts

- Branch: `feature/method-contracts`
- Commit: `not committed`
- Summary: added the ASCP method-contract schema, a normative method surface spec, and request/success/error example envelopes for every core method; documented capability gating and method-specific error mapping; and added a repeatable validator that confirms the full method-contract example set against the shared schema foundation
- Documentation updated: `plans.md`, `docs/status.md`, `spec/methods.md`
- Next likely step: build `feature/event-contracts` from the frozen method triggers and shared `EventEnvelope`, without widening back into method shape changes
### 2026-04-21 - Schema foundation

- Branch: `feature/schema-foundation`
- Commit: `a436ccc`
- Summary: added the canonical ASCP core, capability, and error schemas; added schema-valid examples for the required protocol nouns and shared envelope baseline; and documented the schema-foundation scope and versioning assumptions for later method-contract work
- Documentation updated: `plans.md`, `docs/status.md`, `docs/schema-foundation.md`
- Next likely step: build `feature/method-contracts` from these frozen nouns and shared envelopes, without widening into full event or replay work yet

### 2026-04-21 - Workstream prompt pack

- Branch: `main`
- Commit: `not committed`
- Summary: added reusable starter prompts for each ASCP workstream so new conversations can bootstrap the correct feature boundary, dependency reads, deliverables, and stop conditions from repository state
- Documentation updated: `plans.md`, `docs/status.md`, `docs/prompts/README.md`, `docs/prompts/schema-foundation.md`, `docs/prompts/method-contracts.md`, `docs/prompts/event-contracts.md`, `docs/prompts/replay-semantics.md`, `docs/prompts/auth-and-approvals.md`, `docs/prompts/extensions.md`, `docs/prompts/conformance.md`, `docs/prompts/mock-server.md`
- Next likely step: use one of the prompt files to start the next scoped feature branch, beginning with `docs/prompts/schema-foundation.md`

### 2026-04-21 - Protocol workstream plan

- Branch: `main`
- Commit: `not committed`
- Summary: bootstrapped from repository state, confirmed the previous feature is complete, and mapped the ASCP protocol workstreams, dependencies, branch boundaries, and first build slice
- Documentation updated: `plans.md`, `docs/status.md`
- Next likely step: create `feature/schema-foundation` from updated `main` and implement the schema foundation slice only

### 2026-04-21 - Repository operating system

- Branch: `feature/repo-operating-system`
- Commit: `5e2fb07`
- Summary: added explicit intake, planning, drift-control, and checkpoint workflow assets for the ASCP repository
- Documentation updated: `AGENTS.md`, `plans.md`, `docs/repo-operating-system.md`, `README.md`
- Next likely step: choose the next protocol feature and create a dedicated feature branch and scoped plan for it
