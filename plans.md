# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Replay semantics
- Branch: `feature/replay-semantics`
- Goal: make reconnect, snapshot, cursor, ordering, and retention-limit behavior explicit and testable on top of the frozen method and event contracts without widening into auth policy design or mock-server implementation
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/replay-semantics.md`
  - `docs/superpowers/specs/2026-04-22-replay-semantics-design.md`
  - `spec/methods.md`
  - `spec/events.md`
  - `schema/ascp-methods.schema.json`
  - `schema/ascp-events.schema.json`
  - sync and replay-related examples under `examples/`
  - current chat requirements for the replay-semantics slice only

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for replay semantics is met: method contracts and event contracts are present and merged on `main`.
- Replay-relevant method and event inputs already exist under `schema/`, `spec/`, and `examples/`, including `sessions.resume`, `sessions.subscribe`, `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced`.
- No dedicated replay spec, replay fixture streams, or replay-focused conformance validation is present yet.
- This branch starts from up-to-date `main` at commit `de3e04b`.

## Feature Boundary

Included in this branch:

- normative replay and sync documentation in `spec/replay.md`
- reconnect flow semantics from subscribe or resume through replay and live continuation
- cursor semantics for `from_seq`, `from_event_id`, and opaque cursors
- retention-limit behavior and replay-fallback outcomes
- replay-focused fixture streams and minimal conformance validation under `conformance/`

Explicitly out of scope:

- auth policy design beyond replay-related error behavior
- broad conformance program design outside replay coverage
- mock-server transport or storage implementation
- reopening event payload definitions or adding new core event types
- retention duration or backend storage internals

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for replay semantics | `plans.md` records the replay branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| done | add the normative replay semantics document | `spec/replay.md` defines reconnect flow, ordering rules, snapshot boundaries, cursor semantics, retention-limit behavior, and replay-capable expectations |
| done | add replay-focused fixture streams under `conformance/` | `conformance/fixtures/replay/` contains concrete replay examples for snapshot-plus-replay, from-seq recovery, from-event-id recovery, opaque cursors, and retention-limited fallback |
| done | add repeatable replay validation | `scripts/validate_replay_semantics.sh` and `conformance/tests/validate_replay_semantics.py` validate the replay fixture set and replay-specific invariants |
| done | verify replay assets and checkpoint the branch | fresh replay validation passes, `plans.md` is updated to reflect completion, and `docs/status.md` records the replay-semantics checkpoint |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- reconnect flow is explicit from `sessions.resume` or `sessions.subscribe` through replay and live continuation
- replay ordering rules are documented and testable against ordered fixtures
- snapshots are clearly distinguished from historical replay in both docs and fixtures
- cursor semantics for `from_seq`, `from_event_id`, and opaque cursors are explicit without inventing new core nouns
- retention-limit behavior and allowed fallback errors are documented without ambiguity
- the resulting materials are sufficient for later `ASCP Replay-Capable` validation and broader conformance work

## Next Likely Step

After this branch is complete, the next feature should be `auth and approvals` or the broader `conformance` slice, using the replay rules and replay fixtures as stable inputs rather than reopening replay behavior.

## Completion Outcome

- Status: complete on `feature/replay-semantics`
- Validation evidence: `./scripts/validate_replay_semantics.sh` completed successfully and validated 5 replay semantics fixtures
- Merge target: `main`
- Recommended next branch after completion: `feature/auth-and-approvals` or `feature/conformance`
- Recommended current scope:
  - replay flow and ordering rules built on the frozen method and event contracts
  - snapshot, cursor, and retention-limit behavior
  - replay-focused conformance fixtures and validation without reopening payload shapes
