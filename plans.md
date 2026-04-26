# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex adapter initialization fix
- Branch: `feature/codex-adapter-init-fix`
- Goal: remove the live-runtime requirement for downstream callers to manually invoke `client.initialize()` before using the Codex adapter service by adding one-time lazy app-server initialization inside the Codex client layer
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `adapters/codex/src/app-server-client.ts`
  - `adapters/codex/src/service.ts`
  - `adapters/codex/tests/discovery.test.ts`
  - `adapters/codex/tests/service.test.ts`
  - `adapters/codex/README.md`
  - `docs/superpowers/plans/2026-04-26-codex-adapter.md`
  - live smoke evidence from `main` showing `sessions.list` failed with `Not initialized` until `client.initialize()` was called explicitly

## Scope

Included in this branch:

- add lazy one-time `initialize` behavior to the Codex app-server client before operational RPC calls
- prove the fix with a failing-then-passing regression test that models a runtime rejecting pre-initialize requests
- document and checkpoint the live smoke fix

Explicitly out of scope:

- widening the adapter surface beyond the already merged v1 Codex adapter
- changing ASCP method or event semantics
- subscribe, replay, artifact, approval-response, or diff capability work
- product UX or CLI/demo scaffolding

## Planned Files

Files to modify:

- `adapters/codex/src/app-server-client.ts`
- `adapters/codex/tests/discovery.test.ts`
- `adapters/codex/README.md`
- `plans.md`
- `docs/status.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | add a failing regression test for pre-initialize operational RPCs | the test reproduces the live `Not initialized` failure when `thread/list` is sent before the app-server handshake |
| completed | implement lazy one-time initialization inside the Codex client | downstream callers can use `thread/*` and `turn/*` methods without manually calling `client.initialize()`, and initialization is not redundantly repeated on every request |
| completed | validate and checkpoint the hotfix | focused and full adapter verification pass, the README notes the runtime behavior, and `docs/status.md` records the fix branch outcome |

## Acceptance Criteria

The task is done only when all of the following are true:

- `CodexAppServerClient` automatically performs the official initialize handshake before the first operational request
- repeated operational requests reuse the initialized state instead of forcing callers to initialize manually
- the regression is covered by an automated adapter test
- adapter build, tests, and validator all pass after the fix

## Next Likely Step

Push `feature/codex-adapter-init-fix`, fast-forward `main`, and leave the repository back on updated `main` once the hotfix commit is merged.
