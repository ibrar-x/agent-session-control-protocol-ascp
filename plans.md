# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Reusable ASCP host service with Codex-first web console
- Branch: `branch-ascp-host-service`
- Goal: expose the existing Codex adapter through a persistent local ASCP WebSocket host service and add a separate Codex-first browser console for real-time operator testing without modifying the user’s existing `apps/web` work
- Source inputs:
  - `AGENTS.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - `plans.md`
  - `docs/status.md`
  - `adapters/codex/src/service.ts`
  - `adapters/codex/src/app-server-client.ts`
  - `adapters/codex/README.md`
  - `sdks/typescript/src/client/index.ts`
  - `sdks/typescript/src/transport/websocket.ts`

## Scope

Included in this branch:

- add a reusable local host service package that exposes ASCP JSON-RPC over WebSocket
- adapt the existing Codex adapter service into the host through a runtime registration boundary that can support other runtimes later
- provide real-time pushed event delivery for ASCP subscriptions without the smoke-tool polling loop
- add a separate Codex-first browser console for session inspection, operator actions, and live event streaming
- document local setup, truthful scope, and validation commands for the host service and console

Explicitly out of scope:

- multi-user auth, tenancy, or remote-host hardening
- protocol changes or new ASCP semantics
- changes to the user’s existing `apps/web` tree beyond preserving it untouched
- mobile app integration
- non-Codex runtime implementations beyond the reusable host boundary

## Planned Files

Files to add or modify:

- `package.json`
- `.gitignore`
- `packages/host-service/`
- `packages/host-service/package.json`
- `packages/host-service/tsconfig.json`
- `packages/host-service/src/`
- `packages/host-service/tests/`
- `packages/host-service/README.md`
- `apps/host-console/`
- `apps/host-console/package.json`
- `apps/host-console/tsconfig.json`
- `apps/host-console/src/`
- `apps/host-console/README.md`
- `sdks/typescript/package.json`
- `sdks/typescript/src/methods/index.ts`
- `sdks/typescript/src/transport/`
- `sdks/typescript/src/validation/schema-registry.ts`
- `sdks/typescript/test/transport.test.ts`
- `adapters/codex/package.json`
- `adapters/codex/scripts/host.mjs`
- `adapters/codex/src/host-runtime.ts`
- `adapters/codex/src/index.ts`
- `adapters/codex/src/service.ts`
- `adapters/codex/tests/host-runtime.test.ts`
- `adapters/codex/README.md`
- `docs/status.md`
- `plans.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | build reusable WebSocket host service package | package accepts runtime handlers, serves ASCP JSON-RPC over WebSocket, and pushes subscription events without polling |
| completed | connect host service to Codex adapter | host can serve truthful `capabilities.get`, `hosts.get`, session methods, approvals, artifacts, diffs, and subscription traffic through the existing Codex adapter |
| completed | add focused host service tests | tests cover request routing, subscription push delivery, unsubscribe cleanup, and Codex adapter integration seams |
| completed | build separate Codex-first browser console | browser app can connect to the host, list/select sessions, stream live events, send input, and exercise approvals/artifacts/diffs |
| completed | document and verify the new slice | package/app READMEs and status log are updated and the new host service plus console checks pass |

## Acceptance Criteria

The task is done only when all of the following are true:

- the host service exposes ASCP over WebSocket with push-style event delivery
- the service boundary is reusable for future runtimes instead of being Codex-only in shape
- the Codex adapter is usable through the host without inventing new protocol behavior
- the separate browser console provides a practical real-time operator workflow for Codex sessions
- documentation explains truthful scope, local-only assumptions, and validation commands

## Next Likely Step

Run the Codex-backed host and the browser console together against a live session, then decide whether the next branch should add auth/multi-client boundaries or widen the host registration surface for additional runtimes.
