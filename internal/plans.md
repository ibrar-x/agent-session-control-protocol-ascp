# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Host console chat refresh
- Branch: `branch-host-console-chat-refresh`
- Goal: turn `apps/host-console` into a multi-session chat-first operator workspace that proves the ASCP host, Codex adapter, and browser SDK flow together with truthful live-state handling
- Source inputs:
  - `AGENTS.md`
  - `internal/plans.md`
  - `internal/status.md`
  - `apps/host-console/README.md`
  - `apps/host-console/src/App.tsx`
  - `apps/host-console/src/styles.css`
  - `docs/superpowers/specs/2026-04-27-host-console-chat-refresh-design.md`
  - `docs/superpowers/plans/2026-04-27-host-console-chat-refresh.md`
  - `adapters/codex/src/service.ts`
  - `adapters/codex/tests/service.test.ts`

## Scope

Included in this branch:

- replace the old grid console with a multi-session messenger-style workspace
- keep chat and operator rail backed by one selected-session state model
- show truthful `loading`, `live`, `snapshot-only`, and `error` modes
- render approvals and blocked inputs inline in the chat timeline and in the operator rail
- lazy-load artifacts and diffs only on explicit operator actions
- support starting a new session from the UI and handle pre-materialized Codex threads truthfully
- update docs and focused tests for the new browser flow

Explicitly out of scope:

- protocol redesign
- host-service auth or multi-client work
- non-Codex adapters
- mobile-specific surfaces
- broad host-console visual polish unrelated to the ASCP flow

## Planned Files

Files to add or modify:

- `internal/status.md`
- `internal/plans.md`
- `apps/host-console/README.md`
- `apps/host-console/package.json`
- `apps/host-console/vitest.config.ts`
- `apps/host-console/src/App.tsx`
- `apps/host-console/src/styles.css`
- `apps/host-console/src/model.ts`
- `apps/host-console/src/model.test.ts`
- `apps/host-console/src/components/SessionSwitcher.tsx`
- `apps/host-console/src/components/ChatPane.tsx`
- `apps/host-console/src/components/OperatorRail.tsx`
- `apps/host-console/src/components/JsonDisclosure.tsx`
- `adapters/codex/src/service.ts`
- `adapters/codex/tests/service.test.ts`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | add host-console model and focused tests | selected-session loading, snapshot-only, and resolved-interaction retention rules are covered by Vitest |
| completed | split the UI into session switcher, chat pane, and layered operator rail | the browser console uses a multi-session layout with inline interaction cards and expandable JSON detail |
| completed | wire truthful live-state and lazy secondary loading | session switching clears stale detail immediately, subscribe failure degrades to `snapshot-only`, and artifacts/diffs load on explicit operator actions |
| completed | harden new-session startup flow | starting a session from the browser works before first turn materialization, and the adapter falls back cleanly when `includeTurns` is not yet available |
| completed | restore replayed transcript history for reopened sessions | the host console requests replay on subscribe, Codex historical `userMessage.content[].text` is mapped into transcript events, and browser validation shows reopened sessions with real chat bubbles instead of only `sync.snapshot` |
| completed | polish reconnect recovery and delta timeline coverage | reconnect restores the selected session and live attach after transport restart, and assistant delta assembly is covered by focused timeline tests |
| completed | update checkpoint docs and final verification | focused tests, build, and live browser validation are recorded before branch review |

## Acceptance Criteria

The task is done only when all of the following are true:

- the browser console renders a multi-session chat-first workspace rather than the old panel grid
- the selected chat pane and operator rail share one coherent selected-session state model
- `snapshot-only` is visible and explicit when snapshot succeeds but live subscribe fails
- approvals and blocked inputs render inline in the conversation instead of only in side panels
- artifacts and diff detail stay lazy and load only from explicit operator actions
- starting a new session from the UI works even when Codex has not materialized turns yet
- reopened sessions replay truthful historical transcript into the chat timeline when Codex exposes stored turn items
- reconnecting the host preserves the selected session and resumes a truthful live timeline after recovery
- focused tests and live browser validation prove the demo flow end to end

## Next Likely Step

Review the host-console refresh branch, merge it to `main` if accepted, and then continue with broader productionization work such as auth/multi-client boundaries or a second runtime integration.
