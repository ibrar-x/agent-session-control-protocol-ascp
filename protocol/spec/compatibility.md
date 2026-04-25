# ASCP Compatibility And Conformance Evidence

This document freezes the `feature/conformance` branch. It turns the frozen ASCP v0.1 contracts into evidence-backed compatibility claims without reopening schema, method, event, replay, auth, or extension design.

## Scope And Dependency

Compatibility evidence depends on the already-frozen upstream outputs:

- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-errors.schema.json`
- `schema/ascp-methods.schema.json`
- `schema/ascp-events.schema.json`
- `spec/methods.md`
- `spec/events.md`
- `spec/replay.md`
- `spec/auth.md`
- `spec/extensions.md`
- request, response, event, error, approval, and capability examples under `examples/`
- replay, auth, and extension fixtures under `conformance/fixtures/`

This branch does not define new protocol behavior. It defines how this repository proves compatibility claims against the frozen v0.1 protocol surface.

## Evidence Model

A compatibility claim in this repository is valid only when all of the following are true:

- the claim is listed in `conformance/fixtures/compatibility/compatibility-matrix.json`
- the referenced golden examples exist in `conformance/fixtures/compatibility/golden-examples.json`
- every schema-backed example in those manifests validates against the frozen schemas
- every referenced validator script passes without modifying the evidence set

Compatibility levels are cumulative in this branch. Higher levels inherit lower levels rather than redefining them.

## Cross-Cutting Evidence

Some conformance evidence applies to every ASCP v0.1 claim rather than to only one compatibility level.

| Evidence | Why it is cross-cutting | Repository proof |
| --- | --- | --- |
| schema and contract validation | compatibility claims are not meaningful if the published request, response, and event examples drift from the frozen schemas | `../tooling/scripts/validate_method_contracts.sh`, `../tooling/scripts/validate_event_contracts.sh` |
| auth failure handling | callers need a stable distinction between `UNAUTHORIZED` and `FORBIDDEN` across the protocol surface | `../tooling/scripts/validate_auth_semantics.sh`, golden scenario `auth-failure-classification` |
| extension ignore behavior | unknown extension detail must remain additive and ignorable so core-compatible clients do not break | `../tooling/scripts/validate_extension_semantics.sh`, golden scenario `extension-ignore-safe` |

The top-level conformance harness composes those checks instead of treating them as optional side tests.

## Compatibility Matrix

| Compatibility Level | Inherits | Required Methods | Additional Required Evidence | Golden Scenario |
| --- | --- | --- | --- | --- |
| `ASCP Core Compatible` | none | `capabilities.get`, `runtimes.list`, `sessions.list`, `sessions.get` | capability document, `EventEnvelope`, and core observation evidence | `core-discovery-and-session-read` |
| `ASCP Interactive` | `ASCP Core Compatible` | `sessions.send_input`, `sessions.subscribe`, `sessions.unsubscribe`, and at least one of `sessions.start` or `sessions.resume` | interactive transcript and control evidence | `interactive-session-control` |
| `ASCP Approval-Aware` | `ASCP Interactive` | `approvals.list`, `approvals.respond` | `approval.requested`, `approval.updated`, `approval.approved`, `approval.rejected`, `approval.expired` | `approval-resolution` |
| `ASCP Artifact-Aware` | `ASCP Approval-Aware` | `artifacts.list` and at least one of `artifacts.get` or `diffs.get` | `artifact.created`, `artifact.updated`, `diff.ready`, `diff.updated` | `artifact-access` |
| `ASCP Replay-Capable` | `ASCP Artifact-Aware` | `sessions.subscribe` plus the replay entry points already frozen in the method contracts | `capabilities.replay=true`, replay ordering evidence, `sync.snapshot`, `sync.replayed`, and replay boundary notes | `replay-recovery` |

The matrix above is intentionally narrow. It follows the compatibility ladder from the detailed spec and PRD instead of promoting vendor-specific features into core compatibility requirements.

## Golden Example Rules

The golden example manifests in this branch are repository-facing proof bundles.

Rules:

- a golden scenario may reference existing upstream examples rather than duplicate them
- schema-backed files must declare the exact schema name used for validation
- replay, auth, and extension fixture bundles may be referenced through fixture manifests when the detailed checks already live in their dedicated validators
- if a compatibility claim needs new evidence, add that evidence explicitly rather than silently broadening an older scenario

The required golden coverage for this branch is:

- requests and responses for the relevant methods
- representative event examples for the relevant compatibility claim
- replay flow fixtures
- auth failure examples
- extension handling examples and ignore-behavior fixtures

## Validator Composition

The top-level conformance harness in this branch runs two kinds of checks:

1. direct schema validation for the golden request, response, event, capability, and entity examples referenced by the manifests
2. composed validator execution for the existing method, event, replay, auth, and extension validation suites

That split keeps the conformance layer additive. It does not duplicate the deeper replay, auth, or extension logic that already exists in dedicated validators.

## Repository Outputs In This Branch

This branch adds:

- `spec/compatibility.md`
- `conformance/fixtures/compatibility/compatibility-matrix.json`
- `conformance/fixtures/compatibility/golden-examples.json`
- `conformance/validators/compatibility.py`
- `conformance/tests/validate_conformance.py`
- `../tooling/scripts/validate_conformance.sh`

Together these files make the compatibility ladder executable and auditable instead of leaving it as prose only.
