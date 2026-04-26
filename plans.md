# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex adapter remaining ASCP surfaces
- Branch: `branch-codex-adapter-remaining-surfaces`
- Goal: implement the missing Codex adapter surfaces for `sessions.subscribe`, `approvals.respond`, `diffs.get`, `artifacts.list|get`, and replay behavior with truthful fallback where Codex runtime support is absent
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `adapters/codex/README.md`
  - `adapters/codex/src/service.ts`
  - `adapters/codex/src/app-server-client.ts`
  - `adapters/codex/src/events.ts`
  - `adapters/codex/src/approvals.ts`
  - `adapters/codex/tests/service.test.ts`
  - `adapters/codex/tests/capabilities.test.ts`
  - `sdks/typescript/src/methods/types.ts`
  - `sdks/typescript/src/replay/index.ts`

## Scope

Included in this branch:

- add `sessions.subscribe` and `sessions.unsubscribe` in the adapter service
- add in-memory streaming queue plumbing for normalized ASCP events per subscription
- add replay behavior for `from_seq` and `from_event_id` using retained sequenced events
- add `approvals.list` and `approvals.respond` with truthful unsupported fallback when Codex approval response methods are unavailable
- add `diffs.get` derived from Codex `fileChange` turn items
- add `artifacts.list` and `artifacts.get` derived from Codex `fileChange` turn items
- update capability resolution to reflect implemented adapter surfaces
- update tests and docs for the new behavior

Explicitly out of scope:

- protocol/schema changes
- fake artifact payload content retrieval beyond metadata
- replay persistence across process restarts
- any non-Codex adapter work

## Planned Files

Files to modify:

- `adapters/codex/src/service.ts`
- `adapters/codex/src/app-server-client.ts`
- `adapters/codex/src/capabilities.ts`
- `adapters/codex/tests/service.test.ts`
- `adapters/codex/tests/capabilities.test.ts`
- `adapters/codex/README.md`
- `plans.md`
- `docs/status.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | add adapter service methods for subscribe, approvals, diffs, and artifacts | service exposes the requested ASCP methods and handles unsupported runtime behavior via explicit ASCP errors |
| completed | add streaming and replay queue behavior | `sessions.subscribe` yields snapshot/replay/live events with deterministic per-session sequencing and `sessions.unsubscribe` tears subscriptions down |
| completed | add focused regression tests for new surfaces | service tests cover subscribe/replay, approvals list/respond, and diff/artifact derivation paths |
| completed | update docs and run full adapter verification | README and status log reflect current support and `npm --workspace @ascp/adapter-codex run check` plus adapter validator pass |

## Acceptance Criteria

The task is done only when all of the following are true:

- `sessions.subscribe` and `sessions.unsubscribe` are implemented in the adapter service
- replay requests (`from_seq` and `from_event_id`) produce `sync.replayed` behavior on sequenced event history
- `approvals.respond` succeeds only when a runtime response method is actually available and returns `UNSUPPORTED` otherwise
- `diffs.get` and `artifacts.list|get` return ASCP-shaped metadata derived from real Codex turn data
- adapter capability resolution reflects implemented surfaces truthfully
- focused tests and full adapter checks pass

## Next Likely Step

Commit and push this branch, then merge into `main` if review is accepted.
