# TypeScript SDK Release Readiness Branch Reference

This document captures the implementation context for `feature/typescript-sdk-release-readiness`.

Use it when you need to understand how the TypeScript SDK package was tightened for sustained downstream use, why the final package boundary looks the way it does, what tradeoffs remain after the first release-ready pass, and what the Dart planning branch should reuse instead of rediscovering.

## Branch Identity

- Branch: `feature/typescript-sdk-release-readiness`
- Current repository state: implemented locally on the release-readiness branch

## What This Branch Added

The release-readiness branch tightened the TypeScript SDK as a publishable downstream reference package without widening runtime scope.

It introduced:

- a documented versioning decision that keeps the first downstream release at `0.1.0`
- a clearer root-versus-subpath export boundary for the package
- packaged release documents through `typescript/CHANGELOG.md` and `typescript/LICENSE`
- `publishConfig`, `prepack`, and release-check commands in `typescript/package.json`
- release-specific type-resolution and runtime export smoke checks
- README guidance that explains how downstream consumers should install, import, validate, and verify the package

## What It Intentionally Did Not Add

This branch did not implement:

- new ASCP protocol behavior
- auth-hook runtime helpers
- new transport adapters
- DTO aliases that rename upstream ASCP fields
- package publishing automation or CI release pipelines
- Dart SDK implementation work

Those remain out of scope so the branch stays about release quality and package clarity rather than opening another feature slice.

## Upstream Inputs That Shaped The Branch

The branch was built from these inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`
- `../../ASCP_Protocol_PRD_and_Build_Guide.md`
- `../branches/typescript-sdk-foundation.md`
- `../branches/typescript-sdk-validation.md`
- `../branches/typescript-sdk-transport.md`
- `../branches/typescript-sdk-analytics.md`
- `../branches/typescript-sdk-client.md`
- `../branches/typescript-sdk-replay.md`
- `../branches/typescript-sdk-examples-tests.md`

These inputs fixed the branch boundary:

- the TypeScript implementation plan established that the package should stay schema-led, thin, and transport-replaceable
- the detailed spec and PRD kept the release pass aligned with ASCP `0.1.0` semantics, replay rules, auth/error expectations, and additive compatibility guidance
- the completed TypeScript branch docs defined the existing runtime surfaces so this branch could tighten packaging and documentation without inventing new abstractions

## Versioning Decision

The first release-ready package remains at `0.1.0`.

That choice was made for three reasons:

1. the package is the first downstream reference for ASCP protocol `0.1.0`, so matching the protocol baseline reduces ambiguity for consumers
2. the package is ready for sustained downstream use, but both protocol and SDK semantics are still intentionally pre-`1.0`
3. pre-`1.0` SemVer leaves room to tighten ambiguous SDK edges in minor releases if the first reference package reveals a better boundary

Working expectations after this branch:

- patch releases should preserve the documented package boundary
- additive helpers should prefer additive exports or new subpaths
- any breaking package cleanup before `1.0.0` should still preserve upstream ASCP naming and semantics unless the protocol itself changes upstream

## Final Package Boundary

The release-ready package boundary is:

- root package: metadata, `AscpClient`, replay helpers, and core protocol types
- `ascp-sdk-typescript/transport`: transport classes and transport error types
- `ascp-sdk-typescript/validation`: schema-backed runtime parsing and assertion helpers
- `ascp-sdk-typescript/analytics`: opt-in recorder and diagnostic helpers
- `ascp-sdk-typescript/client`: direct client-layer imports for consumers that want that seam explicitly
- `ascp-sdk-typescript/replay`: direct replay-layer imports for consumers that want that seam explicitly

Why this boundary was chosen:

- the root keeps the common consumer path short without flattening every implementation seam into one namespace
- transport, validation, and analytics are lower-level or optional concerns and should stay explicit subpaths
- protocol types remain visible and thin so consumers can still compare their code with upstream schemas, examples, and conformance fixtures
- the package remains explicit and boring: it helps consumers use ASCP, but it does not try to hide ASCP

## How To Consume The Release-Ready Package

From a downstream Node.js consumer:

```bash
npm install ascp-sdk-typescript
```

Recommended import pattern:

```ts
import { AscpClient } from "ascp-sdk-typescript";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";
import { subscribeWithReplay } from "ascp-sdk-typescript/replay";
```

Use the root for the common client-plus-replay happy path.

Use subpaths when you explicitly need:

- runtime schema validation
- replaceable transport wiring
- opt-in diagnostics and analytics
- direct control over the client or replay seam

Avoid introducing a second DTO layer over ASCP field names. The package is intentionally thin so payloads, validation failures, and replay behavior stay comparable to the upstream protocol assets.

## Alternatives Rejected

### Re-export every runtime helper from the package root

Rejected because it would blur the difference between the common client flow and the lower-level transport, validation, and analytics seams.

### Bump the package to `1.0.0` immediately

Rejected because the protocol baseline is still `0.1.0` and the first downstream reference package should stay explicit about that maturity level.

### Add release automation or registry publishing in this branch

Rejected because that is release engineering work, not SDK-surface definition. This branch focuses on package clarity and reproducible validation evidence.

### Add auth helper APIs now because auth is part of the spec

Rejected because the upstream protocol defines auth expectations, scopes, and error semantics, but this package branch is not the place to invent higher-level auth ergonomics without a dedicated feature slice.

## Final Tradeoffs

Deliberate tradeoffs still in place after this branch:

- auth remains deferred, so consumers wire credentials at the transport boundary and rely on upstream ASCP error semantics for authorization failures
- streamed extension events remain envelope-first unless consumers opt into stricter core-event validation themselves
- the package favors explicit subpaths over one large convenience namespace, so some imports are longer in exchange for clearer layer boundaries
- release validation is documented and scriptable locally, but end-to-end publishing automation is still outside this branch

These tradeoffs are acceptable because they keep the first reference package predictable and close to the protocol instead of optimizing too early for convenience abstractions.

## Verification Evidence

The release-readiness branch is intended to be verified with:

- `npm run build`
- `npm test`
- `npm run test:integration`
- `npm run test:types`
- `npm run test:package-types`
- `npm run check`
- `npm run check:release`
- `git diff --check`

What the added release checks prove:

- `npm run test:package-types` proves package self-reference type imports resolve through the published export map
- `node ./scripts/check-package-exports.mjs` proves the runtime export boundary resolves as documented, with lower-level helpers staying on subpaths
- `npm pack --dry-run` proves the tarball includes the intended distributable files and release-facing documentation

## Dart Planning Handoff

The Dart planning branch should treat these TypeScript assets as the downstream reference set:

- `typescript/README.md`
- `typescript/CHANGELOG.md`
- `typescript/package.json`
- `typescript/src/index.ts`
- `typescript/src/client/`
- `typescript/src/replay/`
- `typescript/src/transport/`
- `typescript/src/validation/`
- `docs/branches/typescript-sdk-release-readiness.md`
- the completed TypeScript branch references that explain how each lower-level slice arrived at the current package shape

What Dart planning should copy conceptually:

- root happy-path imports plus explicit subpaths for lower-level seams
- schema-led validation as a first-class package layer
- replay helpers layered on the typed client instead of baked into transport
- opt-in diagnostics rather than silent telemetry
- explicit release checks that validate both package boundaries and downstream consumability

What Dart planning should not copy blindly:

- Node-specific transport and packaging choices such as stdio process management, npm scripts, or `prepack`
- any assumption that auth ergonomics must stay deferred forever; Dart can plan a dedicated auth slice later if the repository roadmap chooses it explicitly
