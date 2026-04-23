# TypeScript SDK Analytics Branch Reference

This document captures the implementation context for `feature/typescript-sdk-analytics`.

Use it when you need to understand how the current analytics and production-hardening surface should be used, why it was designed this way, what it intentionally does not do yet, and what the typed client branch should preserve on top of it.

## Branch Identity

- Branch: `feature/typescript-sdk-analytics`
- Current repository state: implemented locally on the analytics branch

## What This Branch Added

The analytics branch added an opt-in observability layer and production metadata hardening to `sdk/typescript/`.

It introduced:

- an exported `ascp-sdk-typescript/analytics` entry point
- structured analytics event types plus a buffered in-memory recorder for tests and local debugging
- transport-level analytics hooks for connect, request, stream, and close lifecycle events
- remediation helpers for `AscpTransportError` and `AscpValidationError`
- baseline production package metadata for repository, homepage, bugs, and keywords
- AGENTS plus prompt-pack updates so future branches preserve observability and production-hardening concerns automatically
- focused runtime and type-level tests for analytics events, diagnostics, and package metadata

## What It Intentionally Did Not Add

This branch did not implement:

- bundled vendor analytics SDKs
- automatic remote telemetry
- client-method wrappers or replay helpers
- product-specific dashboards or alerting workflows
- protocol-core schema or spec changes

Those remain out of scope so the SDK stays vendor-neutral and downstream consumers stay in control of what leaves their process.

## Upstream Inputs That Shaped The Branch

The branch was built directly from these upstream inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`
- `../../spec/methods.md`
- `../../spec/events.md`
- `../../spec/replay.md`
- `../branches/typescript-sdk-transport.md`

These inputs were used for different purposes:

- the implementation plan justified production-oriented SDK ergonomics without widening into runtime adapters or product services
- the detailed spec kept the analytics layer from changing ASCP payload or transport semantics
- the method, event, and replay specs clarified that diagnostics should describe failures around the existing protocol surface rather than invent new protocol behavior
- the transport branch reference defined the stable runtime surface that analytics had to instrument instead of replacing

## How To Use The Current Analytics Surface

From `sdk/typescript/`:

```bash
npm install
npm run build
npm test -- analytics.test.ts
npm run test:types
```

Or run the full package verification:

```bash
npm run check
```

The analytics helpers are exported from:

- `ascp-sdk-typescript/analytics`

Representative usage against the transport surface:

```ts
import {
  createBufferedAnalyticsRecorder,
  describeTransportError
} from "ascp-sdk-typescript/analytics";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const recorder = createBufferedAnalyticsRecorder();
const transport = new AscpStdioTransport({
  command: ["python3", "../mock-server/src/mock_server/cli.py"],
  analytics: recorder
});

await transport.connect();
await transport.request("capabilities.get");
await transport.close();

console.log(recorder.events.map((event) => event.name));
```

Representative remediation usage:

```ts
import { describeValidationError } from "ascp-sdk-typescript/analytics";
import { parseCoreEntity } from "ascp-sdk-typescript/validation";

try {
  parseCoreEntity("Session", payload);
} catch (error) {
  const diagnostic = describeValidationError(error);
  console.error(diagnostic.location);
  console.error(diagnostic.actions);
}
```

Important behavior boundaries:

- analytics are opt-in and only emit when a recorder is explicitly supplied
- transport analytics avoid recording raw params, raw results, or arbitrary payload bodies by default
- protocol error responses are still normal ASCP responses; transport analytics report transport lifecycle and transport failures, not a new protocol layer
- remediation helpers do not replace error objects; they give downstream tooling a stable way to explain the likely fix

## Source Layout You Should Assume

The analytics branch adds implementation in place under a dedicated analytics directory:

```text
typescript/
  src/
    analytics/
      diagnostics.ts
      index.ts
      types.ts
  test/
    analytics.test.ts
  test-d/
    analytics-api.test-d.ts
```

Transport analytics are wired into the existing transport source files rather than hidden behind a wrapper transport.

## Thought Process Behind The Design

The main design goal was to make the SDK diagnosable in production without turning it into a telemetry product.

That led to four decisions:

1. keep analytics opt-in through an explicit recorder contract
2. instrument the existing transport lifecycle instead of inventing a second execution surface
3. expose remediation helpers for existing SDK errors instead of replacing those errors
4. harden package metadata because production packages need discoverable repository and issue-reporting paths

The branch stayed intentionally boring. It emits structured local events, not vendor-specific beacons, and it avoids capturing request or response bodies by default because debugging value does not require silent payload exfiltration.

## Why This Approach Was Chosen

### Opt-in recorder instead of automatic telemetry

Downstream consumers should stay in control of whether telemetry exists at all. An explicit recorder keeps the SDK safe by default and makes privacy and compliance review straightforward.

### Instrument existing transport classes instead of wrapping them externally

The transport branch already defines the runtime lifecycle that matters in production. Hooking that surface directly keeps analytics close to real failure boundaries and avoids forcing downstream consumers to remember an extra wrapper layer.

### Remediation helpers instead of a new error hierarchy

The existing validation and transport errors already carry the right protocol-facing identity. Adding helper diagnostics preserves that identity while making production debugging more actionable.

### Production package metadata in `package.json`

Once the package is becoming reusable outside the repo, repository, homepage, bug-reporting, and keyword metadata should be present so downstream consumers can identify the source of truth and report production issues cleanly.

## Alternatives Considered And Rejected

### Integrate a third-party analytics vendor directly

Rejected because this repository is SDK-only, vendor-neutral, and should not silently send user data anywhere.

### Emit analytics by default from every transport instance

Rejected because production-safe observability should be explicit, not ambient.

### Record raw request params, results, or streamed payloads

Rejected because that increases privacy and security risk and is unnecessary for the current debugging goals.

### Replace transport and validation errors with analytics-specific error classes

Rejected because it would blur the protocol-facing SDK surface and make existing code harder to reason about.

## Verification Evidence

This branch was verified with:

```bash
cd sdk/typescript
npm test -- analytics.test.ts
npm run test:types
npm run build
npm test
npm run check
```

And repository-level patch hygiene was checked with:

```bash
cd sdk
git diff --check
```

What these commands prove:

- `npm test -- analytics.test.ts` proved analytics remain opt-in, transport analytics emit the expected lifecycle events, diagnostics are actionable, and package metadata expectations are met
- `npm run test:types` proved the analytics recorder, diagnostics, and transport-option types compile cleanly
- `npm run build` proved the package compiles with the new analytics entry point and updated transport wiring
- `npm test` proved analytics coverage passes alongside the existing metadata, validation, and transport tests
- `npm run check` proved the combined build, runtime tests, and type tests all pass in one command
- `git diff --check` proves the branch diff is free of whitespace and patch-format issues

## Known Limitations And Deferred Work

The analytics branch still has deliberate limits:

- there is no persistent analytics backend or exporter in this package
- analytics hooks are currently concentrated on the transport surface, not future client-wrapper or replay helper surfaces
- payload bodies are intentionally not captured by default
- remediation guidance is heuristic and should stay advisory rather than pretending to guarantee a fix

These are expected limits, not regressions. They keep the package safe by default and leave downstream deployment choices to consumers.

## What The Next Branch Should Assume

The next branch is:

- `feature/typescript-sdk-client`

That branch can assume:

- `ascp-sdk-typescript/analytics` exists and is the canonical place for SDK analytics event types and remediation helpers
- transport constructors already accept an optional analytics recorder
- future runtime-facing code should preserve opt-in analytics behavior rather than adding silent telemetry
- production package metadata and issue-reporting links are already part of the package baseline

The typed client branch should build method-wrapper analytics on top of this surface rather than re-inventing a parallel observability model.
