# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex live smoke coverage for remaining adapter surfaces
- Branch: `branch-codex-live-smoke-surfaces`
- Goal: expose and document live-smoke testing for `sessions.subscribe|unsubscribe`, `approvals.list|respond`, `artifacts.list|get`, and `diffs.get`, including interactive replay/stream validation flow
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `adapters/codex/scripts/live-smoke.mjs`
  - `adapters/codex/src/live-smoke.ts`
  - `adapters/codex/tests/live-smoke.test.ts`
  - `adapters/codex/README.md`
  - `adapters/codex/src/service.ts`
  - `sdks/typescript/src/methods/types.ts`
  - `sdks/typescript/src/events/types.ts`

## Scope

Included in this branch:

- extend live-smoke command parsing/validation/dispatch to cover the remaining adapter surfaces
- add interactive menu actions to exercise subscribe/replay/drain, approvals, artifacts, and diffs in one session
- wire executable dependencies to service methods for all new live-smoke commands
- update live-smoke tests to cover parser, validation, dispatch, and interactive paths
- update README usage and caveats for truthful stream/replay smoke behavior

Explicitly out of scope:

- protocol/schema or adapter service contract changes
- replay or subscription persistence across separate CLI processes
- non-Codex adapter work

## Planned Files

Files to modify:

- `adapters/codex/src/live-smoke.ts`
- `adapters/codex/tests/live-smoke.test.ts`
- `adapters/codex/scripts/live-smoke.mjs`
- `adapters/codex/README.md`
- `plans.md`
- `docs/status.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | extend live-smoke command surface for remaining adapter methods | parser/validator/dispatcher supports subscribe, unsubscribe, approvals list/respond, artifacts list/get, and diffs get |
| completed | add interactive smoke actions for streaming and replay checks | session menu supports subscribe+drain flow with optional unsubscribe and exposes approvals/artifacts/diff actions |
| completed | wire executable dependencies for new smoke commands | `scripts/live-smoke.mjs` maps command handlers to real service methods including drain helper |
| completed | update docs and verification for new smoke flows | README usage is accurate and `npm --workspace @ascp/adapter-codex run check` plus adapter validator pass |

## Acceptance Criteria

The task is done only when all of the following are true:

- live-smoke parser and dispatcher handle all newly implemented adapter surfaces
- interactive smoke mode provides a usable flow to test replay and stream handling in one process
- script dependency wiring calls real service methods for the new commands
- tests cover new parsing/validation/dispatch/interactive behavior
- adapter checks and validator pass

## Next Likely Step

Commit and push this branch, then merge into `main` if accepted.
