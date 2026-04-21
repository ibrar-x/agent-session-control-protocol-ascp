# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Auth and approvals
- Branch: `feature/auth-approvals`
- Goal: make ASCP auth hooks, scope expectations, approval lifecycle behavior, and audit attribution explicit and testable on top of the frozen method, event, and replay contracts without widening into vendor auth providers or transport-specific token exchange
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/auth-and-approvals.md`
  - `docs/superpowers/specs/2026-04-22-auth-approvals-design.md`
  - `spec/methods.md`
  - `spec/events.md`
  - `spec/replay.md`
  - `schema/ascp-core.schema.json`
  - `schema/ascp-methods.schema.json`
  - `schema/ascp-events.schema.json`
  - approval-, artifact-, and error-related examples under `examples/`
  - current chat requirements for the auth-and-approvals slice only

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for auth and approvals is met: schema foundation, method contracts, event contracts, and replay semantics are present and merged on `main`.
- Frozen upstream contracts already cover the approval nouns, approval events, method-specific error codes, replay-side pending approvals, and correlation IDs needed for this branch.
- No dedicated auth hooks spec, scope matrix, approval-lifecycle fixture set, or auth-focused conformance validation is present yet.
- This branch starts from up-to-date `main` at commit `a99a557`.

## Feature Boundary

Included in this branch:

- normative auth and approval semantics in `spec/auth.md`
- recommended scope expectations for the core method surface
- `UNAUTHORIZED` versus `FORBIDDEN` classification rules tied to method behavior
- actor, device, and correlation attribution guidance for control actions and approvals
- approval lifecycle rules from `approval.requested` through resolve, expire, and conflict outcomes
- auth- and approval-focused examples and minimal conformance validation

Explicitly out of scope:

- vendor-specific auth providers, token formats, or identity systems
- transport-specific authentication handshakes or refresh flows
- product UI behavior for approval prompts
- mock-server runtime logic beyond what is needed to express fixtures
- reopening frozen method or event payload contracts unless a contradiction is discovered

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for auth and approvals | `plans.md` records the auth branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| done | add the normative auth and approvals document | `spec/auth.md` defines scope expectations, sensitive-method rules, approval lifecycle behavior, artifact-access guidance, audit attribution, and `UNAUTHORIZED` versus `FORBIDDEN` handling |
| done | add auth and approval examples | `examples/approvals/` and `examples/errors/` contain concrete approval lifecycle and auth failure examples aligned with the frozen schemas |
| done | add repeatable auth and approval validation | `scripts/validate_auth_semantics.sh` and `conformance/tests/validate_auth_semantics.py` validate the auth fixture set and auth-specific invariants |
| done | verify auth assets and checkpoint the branch | fresh auth validation passes, `plans.md` is updated to reflect completion, and `docs/status.md` records the auth-and-approvals checkpoint |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- sensitive methods have explicit control-scope expectations
- read methods that expose sessions, approvals, artifacts, or diffs have explicit read-scope expectations
- `UNAUTHORIZED` and `FORBIDDEN` are distinguishable and mapped consistently
- approval lifecycle behavior is explicit across request, response, event, and conflict outcomes
- actor attribution for approval decisions is documented as part of the core protocol surface
- device identity and correlation IDs are documented as audit hooks without reopening frozen payload contracts
- resulting docs, examples, and fixtures are sufficient for later `ASCP Approval-Aware` and broader conformance work

## Next Likely Step

After this branch is complete, the next feature should be `extensions` or the broader `conformance` slice, using the auth and approval rules from this branch as stable inputs rather than reopening auth semantics.

## Completion Outcome

- Status: complete on `feature/auth-approvals`
- Validation evidence: `./scripts/validate_auth_semantics.sh` completed successfully and validated 3 approval lifecycle fixtures, 1 scope matrix, and 8 auth/error examples
- Merge target: `main`
- Recommended next branch after completion: `feature/extensions` or `feature/conformance`
- Recommended current scope:
  - auth hooks and method scope expectations built on the frozen method and event contracts
  - approval lifecycle and audit attribution guidance without reopening payload shapes
  - auth-focused examples and conformance validation for later approval-aware work
