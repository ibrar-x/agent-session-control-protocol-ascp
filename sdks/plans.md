# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Dart SDK release readiness
- Branch: `feature/dart-sdk-release-readiness`
- Goal: tighten the current Dart package for sustained downstream use after the client/replay branch by polishing release metadata, changelog/version guidance, public package boundaries, verification commands, README guidance, and branch documentation without adding SDK behavior or widening into protocol-core, UI, caching, or new transport scope
- Active language target: Dart SDK release-facing package surface
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - `../protocol/schema/`
  - `../protocol/spec/`
  - `../protocol/examples/`
  - `../services/mock-server/README.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/branches/dart-sdk-client.md`
  - `docs/branches/typescript-sdk-release-readiness.md`
  - `typescript/README.md`
  - `typescript/CHANGELOG.md`
  - `typescript/package.json`
  - `dart/README.md`
  - `dart/CHANGELOG.md`
  - `../../ASCP_Dart_SDK_Implementation_Plan.md`
  - `../../ASCP_Next_Phase_Master_Roadmap.md`

## Scope

Included in this branch:

- polish `dart/pubspec.yaml` for the current executable package surface and downstream package discovery
- update Dart changelog and versioning guidance for the `0.1.0` release-ready package
- add release-facing package boundary verification that proves the public root and secondary libraries stay explicit and examples avoid private `src` imports
- refresh `dart/README.md`, branch docs, roadmap, plans, and status with release-ready usage, verification, limitations, and handoff guidance
- document why the Dart package/release shape mirrors TypeScript release-readiness conceptually without copying npm-specific mechanics

Explicitly out of scope:

- protocol-core schema, spec, or compatibility changes
- new HTTP, SSE, relay, daemon-specific, or app-specific transport work
- Flutter UI work, app-level state management, or local caching policy
- vendor-specific auth protocols, token refresh flows, or product telemetry
- changing ASCP field names into Dart-specific aliases
- new typed methods, replay semantics, validation runtime behavior, or protocol conveniences
- broadening the TypeScript package surface beyond using it as a downstream reference

## Planned Files

Files to add:

- `dart/LICENSE`
- `dart/tool/check_package_boundary.dart`
- `docs/branches/dart-sdk-release-readiness.md`

Files expected to change:

- `plans.md`
- `docs/sdk-build-roadmap.md`
- `docs/status.md`
- `dart/README.md`
- `dart/CHANGELOG.md`
- `dart/pubspec.yaml`
- `dart/tool/README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | replace the completed client/replay plan with the Dart release-readiness plan | `plans.md` scopes the branch to release-facing Dart package polish only and cites the exact upstream inputs that drive it |
| done | polish Dart package metadata and changelog | `dart/pubspec.yaml`, `dart/CHANGELOG.md`, and `dart/LICENSE` describe the current executable `0.1.0` package accurately and avoid foundation-only or unreleased behavior claims |
| done | add public package-boundary verification | a runnable Dart tool verifies root and secondary library boundaries, expected public entrypoints, release docs, and absence of private `src` imports in examples |
| done | refresh Dart release docs and roadmap handoff | `dart/README.md`, `dart/tool/README.md`, `docs/sdk-build-roadmap.md`, and a new branch doc explain usage, rationale, alternatives, verification evidence, current limits, and post-Dart shared maintenance work |
| done | run focused release-readiness checks | build generation, format/analyze/test/example, package-boundary tool, `dart pub publish --dry-run`, and `git diff --check` are run or any blocker is documented |
| done | checkpoint the completed branch | `plans.md` and `docs/status.md` record completion state, documents updated, verification evidence, and the next likely shared SDK maintenance step |

## Acceptance Criteria

The task is done only when all of the following are true:

- the Dart package remains SDK-only and does not pull in Flutter UI or protocol-core drift
- package metadata, changelog, license, README, and branch docs describe the current Dart release surface accurately
- the root and secondary public libraries are explicit and verified without private `src` imports in downstream examples
- verification commands for build, analysis, tests, example execution, package-boundary checks, and publish dry-run are documented and executed where possible
- release-facing gaps are closed without adding new transports, UI behavior, caching, or protocol-core semantics
- the branch documentation states the chosen release shape, rejected alternatives, verification evidence, deferred work, and what shared SDK maintenance should follow

## Next Likely Step

After this branch, shift the repository back to shared SDK maintenance: keep TypeScript and Dart package docs/checks aligned, add CI or release automation only as a dedicated workflow task, and document any upstream protocol ambiguities without silently redefining ASCP semantics in SDK code.
