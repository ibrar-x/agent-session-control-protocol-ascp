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

### 2026-04-26 - Host console live browser validation fixes

- Branch: `branch-ascp-host-service`
- Commit: `not committed`
- Summary: validated the local host and Codex-first browser console through the in-app browser, fixed the host console TSX compilation configuration so the React app renders under Vite during live testing, and fixed `sessions.get(include_runs=true)` to skip incomplete Codex turns instead of failing the whole session read after browser-driven send-input refreshes
- Documentation updated: `docs/status.md`
- Next likely step: commit the browser-validation fixes on the current branch, then continue with merge review or broader multi-runtime host follow-up work

### 2026-04-26 - Reusable ASCP host service with Codex-first web console

- Branch: `branch-ascp-host-service`
- Commit: `not committed`
- Summary: added a reusable local WebSocket ASCP host service package with push-style event delivery, connected the host to the existing Codex adapter through a truthful runtime binding plus launch script, made the TypeScript SDK browser-safe for the host console path by loading validation schemas without `node:fs` and exporting a browser transport entrypoint, and added a separate Codex-first browser console for real-time session inspection, live event streaming, input, approvals, artifacts, and diffs without touching the user’s existing `apps/web` work
- Documentation updated: `plans.md`, `docs/status.md`, `packages/host-service/README.md`, `apps/host-console/README.md`, `adapters/codex/README.md`
- Next likely step: run the Codex host and browser console together against a live session, then decide whether the next branch should add auth/multi-client boundaries or widen the host registration surface for additional runtimes

### 2026-04-26 - Codex live smoke coverage for remaining adapter surfaces

- Branch: `branch-codex-live-smoke-surfaces`
- Commit: `not committed`
- Summary: expanded the live-smoke tool to support `sessions.subscribe|unsubscribe`, `approvals.list|respond`, `artifacts.list|get`, and `diffs.get`, added interactive session actions for subscribe+drain replay validation plus approvals/artifacts/diff checks, added a continuous `watch` stream mode that subscribes, drains events until idle timeout, and unsubscribes in one process, and wired the executable script to the corresponding adapter service methods
- Documentation updated: `plans.md`, `docs/status.md`, `adapters/codex/README.md`
- Next likely step: commit the branch and merge to `main` if the new smoke-testing flow is accepted

### 2026-04-26 - Codex adapter remaining ASCP surfaces

- Branch: `branch-codex-adapter-remaining-surfaces`
- Commit: `not committed`
- Summary: implemented the remaining Codex adapter service surfaces by adding `sessions.subscribe` and `sessions.unsubscribe` with sequenced event queues and replay behavior, adding `approvals.list` plus truthful `approvals.respond` fallback handling, deriving `diffs.get` and `artifacts.list|get` from Codex `fileChange` turn items, wiring notification listeners from the app-server client, and updating capability resolution to reflect the new surfaces
- Documentation updated: `plans.md`, `docs/status.md`, `adapters/codex/README.md`
- Next likely step: review the branch, then commit, push, and merge into `main` if accepted

### 2026-04-26 - Codex live smoke script task 2

- Branch: `feature/codex-live-smoke-script`
- Commit: `dc00d3d`
- Summary: completed the first implementation slice for the Codex live smoke script by adding typed command parsing and validation helpers, covering interactive default plus core list/get/send-input parsing behavior, and tightening parser invariants so option tokens are not misread as session IDs and send-input text is preserved verbatim
- Documentation updated: `plans.md`, `docs/status.md`
- Next likely step: add command dispatch over the existing adapter service, then wire the executable wrapper and interactive flow

### 2026-04-26 - Codex live smoke script task 3

- Branch: `feature/codex-live-smoke-script`
- Commit: `a0cd8d3`
- Summary: completed the dispatch slice for the Codex live smoke script by adding typed dependency-based command dispatch for discovery, list, get, resume, and send-input, tightening the dependency contract so branch-specific dispatch stays testable, and extending focused coverage to the interactive early return plus all supported command branches
- Documentation updated: `plans.md`, `docs/status.md`
- Next likely step: add the executable wrapper, package script alias, and interactive terminal flow on top of the tested `live-smoke.ts` module

### 2026-04-26 - Codex live smoke script task 4 and task 5

- Branch: `feature/codex-live-smoke-script`
- Commit: `0d731cc`
- Summary: completed the checked-in live smoke entrypoint for the Codex adapter by adding a dual-mode executable wrapper plus interactive terminal flow, fixing the launch path so `npm --workspace @ascp/adapter-codex run live` rebuilds before executing, rejecting malformed command-line usage instead of silently running, keeping the interactive menu alive after action failures, documenting direct and interactive usage in the adapter README, and re-running focused tests, the full adapter check, the repository validator, and real `discover` plus `list` smoke commands against the live Codex runtime
- Documentation updated: `plans.md`, `docs/status.md`, `adapters/codex/README.md`
- Next likely step: review the finished branch, push it, and merge it into `main` if the live smoke workflow is accepted

### 2026-04-26 - Codex live smoke dormant-thread send-input fix

- Branch: `feature/codex-live-smoke-script`
- Commit: `not committed`
- Summary: fixed the live smoke `send-input` path for persisted Codex sessions by confirming that `thread/read` succeeds while `turn/start` fails until `thread/resume` reattaches the thread in the current app-server process, then updating `sessions.send_input` to resume dormant threads before starting a new turn and locking the regression with focused service tests plus a real live send-input probe against a historical session
- Documentation updated: `plans.md`, `docs/status.md`, `adapters/codex/README.md`
- Next likely step: commit the dormant-thread fix, then push and merge the updated live smoke branch if the historical-session flow is accepted

### 2026-04-26 - Codex adapter initialization hotfix

- Branch: `feature/codex-adapter-init-fix`
- Commit: `not committed`
- Summary: fixed the live Codex adapter usability regression where service calls failed with `Not initialized` unless downstream code called `client.initialize()` manually first, by adding lazy one-time app-server initialization in the Codex client, extending the client regression tests to model a runtime that rejects pre-initialize requests, and re-running both adapter verification and real runtime smoke checks without manual initialization
- Documentation updated: `plans.md`, `docs/status.md`, `adapters/codex/README.md`
- Next likely step: push the hotfix branch, fast-forward `main`, and continue future adapter work from updated `main`

### 2026-04-26 - Codex adapter task 7 and task 8

- Branch: `feature/codex-adapter`
- Commit: `not committed`
- Summary: completed the remaining Codex adapter slice by adding deterministic normalization for official Codex turn, delta, diff, and approval-request surfaces into ASCP `EventEnvelope` and `ApprovalRequest` shapes, documenting the truthful capability fallbacks in the adapter README, extending the repository validator to require the new mapping files and fallback claims, and validating the finished TypeScript adapter package with the full adapter test suite plus build and validator checks
- Documentation updated: `plans.md`, `docs/status.md`, `docs/superpowers/plans/2026-04-26-codex-adapter.md`, `adapters/codex/README.md`
- Next likely step: run merge-readiness review for `feature/codex-adapter`, then integrate the branch if the current truthful v1 scope is accepted

### 2026-04-26 - Codex adapter task 4

- Branch: `feature/codex-adapter`
- Commit: `6eadc8a`
- Summary: completed the Codex adapter runtime-discovery slice by adding the app-server stdio JSON-RPC client, truthful runtime discovery, conservative capability resolution, and focused transport/discovery/capability tests; the ASCP-facing capability surface now stays intentionally strict for Task 4, with `stream_events`, approvals, diffs, artifacts, and replay all held false until later tasks implement those contracts honestly
- Documentation updated: `plans.md`, `docs/status.md`, `docs/superpowers/plans/2026-04-26-codex-adapter.md`
- Next likely step: implement Task 5 deterministic ID helpers and thread/turn-to-session/run normalization under `adapters/codex/src/`

### 2026-04-26 - Codex adapter task 5

- Branch: `feature/codex-adapter`
- Commit: `d90c675`
- Summary: completed deterministic Codex ID helpers plus conservative thread and turn normalization into ASCP `Session` and `Run` shapes, aligned the mapper to the real Codex runtime schema, converted Unix-second timestamps into ASCP UTC strings, removed the unproven `active_run_id` mapping, and locked the slice with focused mapper tests
- Documentation updated: `plans.md`, `docs/status.md`, `docs/superpowers/plans/2026-04-26-codex-adapter.md`
- Next likely step: implement Task 6 service methods for `sessions.list`, `sessions.get`, `sessions.resume`, and `sessions.send_input` on top of the existing discovery and mapping layers

### 2026-04-26 - Codex adapter task 6

- Branch: `feature/codex-adapter`
- Commit: `921c74c`
- Summary: completed the first ASCP service layer for the Codex adapter by adding honest `sessions.list`, `sessions.get`, `sessions.resume`, and `sessions.send_input` methods over the existing Codex client and mapper stack, using real `thread.read(includeTurns: true)` state to choose between `turn/steer` and `turn/start`, and validating the combined Task 4-6 slice with adapter build plus five focused test files
- Documentation updated: `plans.md`, `docs/status.md`, `docs/superpowers/plans/2026-04-26-codex-adapter.md`
- Next likely step: implement Task 7 event normalization, approval mapping, and any truthful diff support without widening into replay or artifact claims

### 2026-04-26 - Production-grade monorepo restructure

- Branch: `branch-ascp-monorepo-structure`
- Commit: `c0a8732`
- Summary: converted the repository into the requested monorepo layout by moving protocol truth into `protocol/`, SDKs into `sdks/`, the reference client into `apps/reference-client/`, the mock server into `services/mock-server/`, adding root workspace scaffolding, adding placeholder package and adapter boundaries, updating scripts/tests/docs to execute from the new structure, and merging the feature branch back into `main`
- Documentation updated: `plans.md`, `README.md`, `AGENTS.md`, `docs/status.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/architecture/system-design.md`, `docs/architecture/dependency-graph.md`, `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`, `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`, `packages/README.md`, `adapters/README.md`, `apps/README.md`, `services/README.md`, `tooling/README.md`
- Next likely step: continue future shared-package, adapter, app, or service work from updated `main` using the monorepo baseline

### 2026-04-26 - Codex adapter planning pack

- Branch: `feature/codex-adapter-planning`
- Commit: `not committed`
- Summary: translated the external Codex adapter implementation brief into repository-native planning assets by scoping a dedicated planning branch, adding a reusable Codex adapter starter prompt, adding a detailed superpowers implementation plan, and wiring those assets into the docs index and context reference
- Documentation updated: `plans.md`, `README.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/prompts/README.md`, `docs/prompts/codex-adapter.md`, `docs/superpowers/plans/2026-04-26-codex-adapter.md`, `docs/status.md`
- Next likely step: create `feature/codex-adapter` from updated `main` and use the new prompt plus plan to implement the adapter as optional downstream runtime integration work

### 2026-04-22 - Project context reference

- Branch: `feature/project-context-reference`
- Commit: `not committed`
- Summary: added a repository-wide ASCP context reference that explains the purpose, protocol scope, completed workstreams, directory layout, validation commands, and safe continuation model for future contributors
- Documentation updated: `plans.md`, `docs/project-context-reference.md`, `docs/README.md`, `docs/status.md`
- Next likely step: merge the documentation branch into `main` so future sessions can bootstrap from the new reference file directly

### 2026-04-22 - Reference client

- Branch: `feature/reference-client`
- Commit: `not committed`
- Summary: added a deterministic downstream ASCP reference client over the existing stdio mock surface, with schema-validated discovery, session inspection, subscribe/replay, approval/artifact/diff reads, a repeatable demo summary, and a branch-specific validator
- Documentation updated: `plans.md`, `docs/status.md`, `README.md`, `docs/README.md`, `apps/reference-client/README.md`
- Next likely step: merge the finished downstream proof client into `main` and leave the repository clean on updated `main`

### 2026-04-22 - Repository close-out

- Branch: `main`
- Commit: `not committed`
- Summary: added an optional downstream `feature/reference-client` starter prompt and rewrote the repository planning and README state so `main` now reads as a closed-out ASCP v0.1 protocol workspace rather than an unfinished protocol branch
- Documentation updated: `plans.md`, `README.md`, `docs/status.md`, `docs/README.md`, `docs/prompts/README.md`, `docs/prompts/reference-client.md`
- Next likely step: either leave the repository on `main` as the completed protocol workspace or start `feature/reference-client` from updated `main`

### 2026-04-22 - Mock server

- Branch: `feature/mock-server`
- Commit: `bd4472a`
- Summary: added a deterministic fixture-backed ASCP mock server over line-oriented stdio JSON-RPC, seeded host/runtime/session/approval/artifact/diff data, replay-aware sample event streams, a repeatable mock validator, a docs index, and a protocol usage plus DTO-generation guide
- Documentation updated: `plans.md`, `docs/status.md`, `README.md`, `docs/README.md`, `docs/protocol-usage-and-dto-generation.md`, `services/mock-server/README.md`
- Next likely step: build a protocol-consumer reference or deeper interoperability checks on top of the mock without reopening the frozen ASCP v0.1 contracts

### 2026-04-22 - Conformance

- Branch: `feature/conformance`
- Commit: `not committed`
- Summary: added a normative compatibility spec, a machine-readable compatibility matrix, golden example manifests spanning requests, responses, events, replay flows, auth failures, and extension handling, and a repeatable top-level conformance harness that composes the existing method, event, replay, auth, and extension validators into evidence-backed ASCP compatibility claims
- Documentation updated: `plans.md`, `docs/status.md`, `protocol/spec/compatibility.md`
- Next likely step: build `feature/mock-server` against the frozen compatibility matrix and golden conformance fixtures instead of redefining protocol behavior in the mock

### 2026-04-22 - Extensions

- Branch: `feature/extensions`
- Commit: `not committed`
- Summary: added the normative extensions spec, documented namespacing and capability advertisement rules, created namespaced method, event, field, and capability examples, and added a repeatable validator plus ignore-behavior fixtures that make the open-versus-closed schema boundary explicit for later conformance work
- Documentation updated: `plans.md`, `docs/status.md`, `protocol/spec/extensions.md`, `docs/superpowers/specs/2026-04-22-extensions-design.md`, `docs/superpowers/plans/2026-04-22-extensions.md`
- Next likely step: build `feature/conformance` or `feature/mock-server` using the frozen extension rules instead of reopening namespacing semantics

### 2026-04-22 - Auth and approvals

- Branch: `feature/auth-approvals`
- Commit: `not committed`
- Summary: added the normative auth and approvals spec, documented the method scope matrix and audit-attribution hooks, created approval lifecycle fixtures for approved, rejected, and expired outcomes, expanded auth failure examples to distinguish `UNAUTHORIZED` from `FORBIDDEN`, and added a repeatable validator for auth-specific invariants against the frozen method and event contracts
- Documentation updated: `plans.md`, `docs/status.md`, `protocol/spec/auth.md`, `docs/superpowers/specs/2026-04-22-auth-approvals-design.md`, `docs/superpowers/plans/2026-04-22-auth-approvals.md`
- Next likely step: build `feature/extensions` or widen into the broader `conformance` slice using the auth and approval rules from this branch as fixed inputs

### 2026-04-22 - Replay semantics

- Branch: `feature/replay-semantics`
- Commit: `not committed`
- Summary: added the normative replay semantics spec, created replay-focused conformance fixtures for snapshot, from-seq, from-event-id, opaque-cursor, and retention-limited recovery paths, and added a repeatable validator that checks replay-specific ordering, boundary, and fallback rules against the frozen method and event contracts
- Documentation updated: `plans.md`, `docs/status.md`, `protocol/spec/replay.md`, `docs/superpowers/specs/2026-04-22-replay-semantics-design.md`, `docs/superpowers/plans/2026-04-22-replay-semantics.md`
- Next likely step: build `feature/auth-and-approvals` or widen into the broader `conformance` slice using the replay rules and replay fixtures as fixed inputs

### 2026-04-22 - Event contracts

- Branch: `feature/event-contracts`
- Commit: `not committed`
- Summary: added the ASCP event-contract schema, one schema-valid `EventEnvelope` fixture for every core event type, a normative event support spec, and a repeatable validator that confirms the full event surface against the frozen schema foundation
- Documentation updated: `plans.md`, `docs/status.md`, `protocol/spec/events.md`, `docs/superpowers/specs/2026-04-22-event-contracts-design.md`, `docs/superpowers/plans/2026-04-22-event-contracts.md`
- Next likely step: build `feature/replay-semantics` from the locked event stream surface, without redefining event payload shapes

### 2026-04-22 - Method contracts

- Branch: `feature/method-contracts`
- Commit: `not committed`
- Summary: added the ASCP method-contract schema, a normative method surface spec, and request/success/error example envelopes for every core method; documented capability gating and method-specific error mapping; and added a repeatable validator that confirms the full method-contract example set against the shared schema foundation
- Documentation updated: `plans.md`, `docs/status.md`, `protocol/spec/methods.md`
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
