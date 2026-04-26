# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex adapter
- Branch: `feature/codex-adapter`
- Goal: implement a truthful downstream TypeScript adapter under `adapters/codex/` that maps the official Codex app-server runtime surface onto the frozen ASCP v0.1 contracts while reusing the existing TypeScript SDK only for small generic ASCP helpers
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/prompts/codex-adapter.md`
  - `docs/superpowers/specs/2026-04-26-codex-adapter-design.md`
  - `docs/superpowers/plans/2026-04-26-codex-adapter.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - `protocol/schema/`
  - `protocol/spec/`
  - `protocol/examples/`
  - `protocol/conformance/`
  - `apps/reference-client/README.md`
  - `services/mock-server/README.md`
  - `sdks/typescript/`
  - observed `codex app-server` schemas and live runtime probes

## Scope

Included in this branch:

- build a TypeScript workspace package under `adapters/codex/`
- integrate with the official `codex app-server` stdio JSON-RPC surface
- implement truthful runtime discovery and capability resolution for Codex
- normalize Codex threads, turns, notifications, approvals, and turn diffs into ASCP-shaped outputs
- support `sessions.list`, `sessions.get`, `sessions.resume`, `sessions.send_input`, and event subscription behavior where the runtime supports them honestly
- add best-effort approval and diff support with explicit unsupported fallback for unresolved surfaces
- add small generic TypeScript SDK helpers only where they are clearly reusable and Codex-agnostic
- add adapter tests, validation commands, and adapter documentation

Explicitly out of scope:

- changing ASCP core method, event, schema, replay, auth, extension, or compatibility semantics
- adding new ASCP methods, events, or compatibility levels for Codex
- claiming replay support without an official Codex replay surface
- claiming artifact support without an official Codex artifact metadata surface
- widening the TypeScript SDK with Codex-specific transport or mapping behavior
- product UX, daemon work, or app surfaces

## Planned Files

Files to add:

- `adapters/codex/tsconfig.json`
- `adapters/codex/vitest.config.ts`
- `adapters/codex/src/index.ts`
- `adapters/codex/src/app-server-client.ts`
- `adapters/codex/src/discovery.ts`
- `adapters/codex/src/capabilities.ts`
- `adapters/codex/src/ids.ts`
- `adapters/codex/src/session-mapper.ts`
- `adapters/codex/src/events.ts`
- `adapters/codex/src/approvals.ts`
- `adapters/codex/src/service.ts`
- `adapters/codex/tests/discovery.test.ts`
- `adapters/codex/tests/capabilities.test.ts`
- `adapters/codex/tests/ids.test.ts`
- `adapters/codex/tests/session-mapper.test.ts`
- `adapters/codex/tests/service.test.ts`
- `adapters/codex/tests/events.test.ts`
- `adapters/codex/tests/approvals.test.ts`
- `adapters/codex/tests/validate-codex-adapter.mjs`
- `tooling/scripts/validate_codex_adapter.sh`

Files to modify:

- `adapters/codex/package.json`
- `adapters/codex/README.md`
- `sdks/typescript/src/index.ts`
- `sdks/typescript/src/methods/index.ts`
- `sdks/typescript/src/events/index.ts`
- small generic helper files under `sdks/typescript/src/` if needed by the final implementation plan

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | rewrite the branch plan and implementation plan for the TypeScript adapter boundary | `plans.md` and `docs/superpowers/plans/2026-04-26-codex-adapter.md` both target a TypeScript adapter over `codex app-server` with only small generic SDK extractions |
| completed | scaffold the adapter workspace and validation entrypoint | `adapters/codex/` has package metadata, TypeScript config, Vitest config, exports, and a validator script that can fail red before implementation is complete |
| completed | implement Codex app-server transport, discovery, and truthful capability mapping | the adapter can probe the runtime, derive `codex_local`, and advertise only capabilities supported by observed official surfaces |
| in_progress | implement ASCP ID, session, run, event, approval, and diff normalization | Codex threads, turns, notifications, approvals, and turn diffs map into exact ASCP field names and deterministic IDs without redefining protocol semantics |
| pending | implement the ASCP service surface for the supported methods | the adapter exposes honest `sessions.list`, `sessions.get`, `sessions.resume`, `sessions.send_input`, subscribe-like event streaming, and any supported approval or diff reads with correct error fallback |
| pending | document, validate, and checkpoint the adapter branch | adapter docs, tests, and validator pass; `docs/status.md` records the completed feature; and the branch is ready for implementation close-out |

## Acceptance Criteria

The task is done only when all of the following are true:

- the adapter is implemented in TypeScript under `adapters/codex/`
- the adapter uses the official `codex app-server` surface as its primary runtime integration seam
- capability advertisement is truthful and conservative
- `sessions.list`, `sessions.get`, `sessions.resume`, and `sessions.send_input` produce ASCP-shaped outputs
- event streaming normalizes official Codex notifications into ASCP `EventEnvelope` objects
- approval support is exposed only where the official surface supports it honestly
- replay and artifacts stay unsupported unless proven by an official Codex surface
- any SDK additions remain generic and Codex-agnostic
- adapter-specific validation commands and tests exist in-repo

## Next Likely Step

Implement Task 6 on `feature/codex-adapter`: the supported ASCP session method surface using the completed discovery, capability, ID, and mapper layers, without widening into event normalization or approval service behavior that is not yet proven.
