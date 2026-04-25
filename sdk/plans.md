# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: TypeScript release readiness
- Branch: `feature/typescript-sdk-release-readiness`
- Goal: tighten the TypeScript SDK package boundaries, release-facing metadata, documentation, and validation evidence so the package can act as the first sustained downstream reference for ASCP without widening feature scope
- Active language target: TypeScript SDK
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/README.md`
  - `docs/branches/typescript-sdk-client.md`
  - `docs/branches/typescript-sdk-replay.md`
  - `docs/branches/typescript-sdk-foundation.md`
  - `docs/branches/typescript-sdk-validation.md`
  - `docs/branches/typescript-sdk-transport.md`
  - `docs/branches/typescript-sdk-analytics.md`
  - `typescript/README.md`
  - `typescript/CHANGELOG.md` if created in this branch
  - `typescript/LICENSE` if created in this branch
  - `typescript/package.json`
  - `typescript/src/index.ts`
  - `typescript/src/metadata.ts`
  - `typescript/src/client/`
  - `typescript/src/replay/`
  - `typescript/src/transport/`
  - `typescript/src/validation/`
  - `typescript/test/`
  - `typescript/test-d/`
  - `typescript/test/`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Scope

Included in this branch:

- release-quality package-boundary cleanup for the root export surface and subpath export map without inventing new runtime capabilities
- a written versioning decision for the first downstream TypeScript package and its relationship to ASCP protocol `0.1.0`
- package metadata polish such as release notes, packaged-document coverage, and release-check commands suited to sustained downstream use
- README guidance that shows the intended consumer entry points, installation expectations, supported validation flows, and how to verify a release candidate
- branch documentation that explains the final package boundaries, the tradeoffs left in place, the evidence supporting release quality, and what the Dart SDK planning branch should treat as reference material

Explicitly out of scope:

- protocol-core schema or spec changes
- new transport protocols or deep transport refactors
- auth-hook implementation beyond clarifying what is still deferred
- runtime adapters, daemons, or product UI work
- changing ASCP field names into SDK-specific DTO aliases
- Dart SDK implementation work
- Dart SDK work

## Planned Files

Files to add:

- `docs/branches/typescript-sdk-release-readiness.md`
- `typescript/CHANGELOG.md`
- `typescript/LICENSE`
- optional release-check helper script under `typescript/scripts/` if package-verification automation is needed

Files expected to change:

- `plans.md`
- `docs/README.md`
- `docs/status.md`
- `typescript/README.md`
- `typescript/package.json`
- `typescript/src/index.ts`
- `typescript/src/metadata.ts`
- `typescript/test/`
- `typescript/test-d/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | write the release-readiness branch plan and lock the final scope | `plans.md` reflects the dedicated release-readiness branch, source inputs, acceptance criteria, and validation strategy without reopening completed feature slices |
| done | tighten package exports and release metadata | the package surface clearly distinguishes root happy-path exports from subpath-only helpers, packaged docs are intentional, and release metadata reflects the chosen first-release policy |
| done | polish release-facing documentation | `typescript/README.md` and release notes explain installation, public entry points, validation commands, remaining tradeoffs, and how downstream users should consume the package |
| done | leave a release-quality checkpoint and evidence trail | `docs/status.md` plus the branch reference record what changed, why the package boundaries were kept, what evidence supports release quality, and what the Dart planning branch should reuse |

## Acceptance Criteria

The task is done only when all of the following are true:

- the package boundaries are explicit enough that a downstream consumer can tell which imports belong at the root and which belong on subpaths
- the versioning policy for the first TypeScript release is documented and consistent with upstream ASCP `0.1.0` protocol status
- the packaged metadata and packaged documentation are coherent for downstream publication
- the README and branch docs explain how to consume the release-ready package, what tradeoffs remain, and what evidence supports the release-quality claim
- Dart planning has a clear reference point for package shape, validation strategy, and consumer-facing boundaries

## Next Likely Step

After this branch lands, use its package boundaries, release notes, and verification checklist as the baseline reference for Dart SDK planning rather than reopening the TypeScript SDK surface again.

## Completion Outcome

- Status: complete on `feature/typescript-sdk-release-readiness`
- Validation evidence:
  - `npm run build` in `typescript/`
  - `npm test` in `typescript/`
  - `npm run test:integration` in `typescript/`
  - `npm run test:types` in `typescript/`
  - `npm run test:package-types` in `typescript/`
  - `npm run check` in `typescript/`
  - `npm run check:release` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/README.md`
  - `docs/status.md`
  - `docs/branches/typescript-sdk-release-readiness.md`
  - `docs/prompts/dart-sdk-planning.md`
  - `typescript/README.md`
  - `typescript/CHANGELOG.md`
  - `typescript/package.json`
