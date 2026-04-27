# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex interaction translation and blocked-session routing
- Branch: `branch-codex-interaction-translation`
- Goal: implement the frozen blocked-interaction contract in the Codex adapter by translating `waiting_approval` and `waiting_input` into actionable ASCP objects, routing responses back into the live Codex session honestly, and fixing overstated `sessions.start` capability behavior on the host path
- Source inputs:
  - `AGENTS.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - `protocol/spec/auth.md`
  - `protocol/spec/methods.md`
  - `protocol/spec/events.md`
  - `protocol/spec/compatibility.md`
  - `plans.md`
  - `internal/status.md`
  - `adapters/codex/src/service.ts`
  - `adapters/codex/src/approvals.ts`
  - `adapters/codex/src/events.ts`
  - `adapters/codex/src/host-runtime.ts`

## Scope

Included in this branch:

- derive host-visible `ApprovalRequest` and `InputRequest` objects from Codex blocked session state when the runtime does not emit native objects
- preserve native approval notifications when they exist and prefer them over derived objects
- route approval and input responses back into the live Codex session through truthful adapter-owned translation paths
- surface pending inputs in `sessions.get` and `sync.snapshot`
- emit input lifecycle events and any needed derived approval events from the adapter
- implement `sessions.start` or degrade the advertised host capability so the capability document matches reality
- update adapter tests and docs for the new interaction behavior

Explicitly out of scope:

- protocol redesign
- host-service auth or multi-client work
- mobile or browser UI redesign
- non-Codex adapters
- speculative capability claims unsupported by observed Codex runtime behavior

## Planned Files

Files to add or modify:

- `plans.md`
- `internal/status.md`
- `adapters/codex/src/service.ts`
- `adapters/codex/src/approvals.ts`
- `adapters/codex/src/events.ts`
- `adapters/codex/src/capabilities.ts`
- `adapters/codex/src/discovery.ts`
- `adapters/codex/src/host-runtime.ts`
- `adapters/codex/src/app-server-client.ts`
- `adapters/codex/tests/service.test.ts`
- `adapters/codex/tests/approvals.test.ts`
- `adapters/codex/tests/events.test.ts`
- `adapters/codex/tests/capabilities.test.ts`
- `adapters/codex/tests/host-runtime.test.ts`
- `adapters/codex/README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| in_progress | add Codex blocked-interaction translation | `sessions.get` and adapter state can surface pending approvals and pending inputs from either native Codex signals or truthful derived blocked state |
| pending | add response routing and lifecycle events | `approvals.respond` and `sessions.send_input` resolve live blocked requests through adapter-owned routing, with `CONFLICT` and `UNSUPPORTED` behavior matching the frozen protocol |
| pending | fix host capability truthfulness | `sessions.start` is either implemented or advertised false, and approval capability flags match the actual response path the adapter exposes |
| pending | update adapter docs, tests, and checkpointing | adapter docs explain native vs host-derived interaction behavior, tests cover the blocked-session paths, and status log captures the branch outcome |

## Acceptance Criteria

The task is done only when all of the following are true:

- loading a Codex session in `waiting_approval` yields a populated approval object instead of raw status only
- loading a Codex session in `waiting_input` yields a populated input request instead of raw status only
- native approval objects win over derived ones when both are available
- blocked interaction responses either unblock through a truthful adapter route or return `UNSUPPORTED`/`CONFLICT` explicitly
- `sessions.start` capability no longer overstates unsupported behavior
- adapter tests prove the implementation stays downstream of the frozen protocol contract

## Next Likely Step

Commit the Codex adapter interaction translation branch, merge it into `main`, and then resume live browser and mobile-path validation against a session that exercises both host-derived and runtime-native blocked interactions.
