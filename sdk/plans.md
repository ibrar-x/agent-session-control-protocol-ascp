# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Dart SDK foundation
- Branch: `feature/dart-sdk-foundation`
- Goal: scaffold the Dart package, lock the public library seams, establish the generated model and JSON codec workflow, and leave a documented foundation that the executable Dart branch can inherit without revisiting package structure
- Active language target: Dart SDK foundation
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `../schema/`
  - `../spec/`
  - `../examples/`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/branches/dart-sdk-planning.md`
  - `docs/branches/typescript-sdk-foundation.md`
  - `docs/branches/typescript-sdk-release-readiness.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `dart/README.md`
  - `../../ASCP_Dart_SDK_Implementation_Plan.md`
  - `../../ASCP_Next_Phase_Master_Roadmap.md`

## Scope

Included in this branch:

- scaffold the installable Dart package under `dart/` with `pubspec.yaml`, `analysis_options.yaml`, package docs, and a baseline development workflow
- create the root and secondary library entrypoints documented by the Dart planning branch while keeping later executable surfaces additive
- implement the first generated immutable model and JSON codec baseline for stable ASCP DTOs, shared envelopes, and selected example-backed payloads
- reserve the package directories for later `client`, `transport`, `validation`, `replay`, and `auth` slices without pulling their executable behavior into this branch
- document how to use the foundation branch, why the package and codec strategy were chosen, what alternatives were rejected, what was verified, and what the next Dart branch should inherit

Explicitly out of scope:

- protocol-core schema or spec changes
- live transport implementations or app-layer networking policy
- the full typed client method surface
- replay orchestration helpers beyond the types and layout they depend on
- Flutter UI work or app-level state management
- changing ASCP field names into Dart-specific aliases
- reopening the TypeScript package surface beyond what is needed to cite it as the reference package

## Planned Files

Files to add:

- `dart/pubspec.yaml`
- `dart/analysis_options.yaml`
- `dart/CHANGELOG.md`
- `dart/.gitignore`
- `dart/lib/ascp_sdk_dart.dart`
- `dart/lib/client.dart`
- `dart/lib/replay.dart`
- `dart/lib/transport.dart`
- `dart/lib/validation.dart`
- `dart/lib/models.dart`
- `dart/lib/methods.dart`
- `dart/lib/events.dart`
- `dart/lib/errors.dart`
- `dart/lib/src/`
- `dart/test/`
- `dart/example/`
- `dart/tool/`
- `docs/branches/dart-sdk-foundation.md`

Files expected to change:

- `plans.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/sdk-build-roadmap.md`
- `docs/status.md`
- `README.md`
- `dart/README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | replace the planning-branch active plan with a Dart foundation branch plan | `plans.md` scopes the branch to Dart foundation only, lists the source inputs, and names the executable Dart handoff branch |
| done | scaffold the Dart package baseline and public library seams | `dart/` contains installable package metadata, root and secondary libraries, reserved source directories, and baseline package docs without adding transport or full client behavior |
| done | establish the generated model and JSON codec workflow | the package uses the chosen `freezed` plus `json_serializable` toolchain for immutable DTOs, keeps ASCP field names unchanged, and proves the baseline against upstream examples |
| done | document the branch and refresh shared recovery docs | the branch reference, `dart/README.md`, and shared workspace docs explain usage, rationale, rejected alternatives, verification evidence, limitations, and the next likely branch |

## Acceptance Criteria

The task is done only when all of the following are true:

- the Dart package scope is explicit and stays free of Flutter UI or protocol-core drift
- the package metadata, library entrypoints, and reserved source layout exist and match the planning branch
- generated immutable models and JSON codecs are wired up for the foundation DTO set without translating ASCP field names
- example-backed tests prove the baseline codec path against upstream payloads
- the branch documentation states the chosen direction, rejected alternatives, verification evidence, deferred work, and what `feature/dart-sdk-client` should inherit

## Next Likely Step

Build `feature/dart-sdk-client` on top of this foundation by adding typed method wrappers, subscription lifecycle handling, replay helpers, validation helpers, and the first justified transport implementations without revisiting package structure or codec strategy.
