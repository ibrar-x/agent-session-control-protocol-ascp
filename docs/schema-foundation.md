# ASCP Schema Foundation

## Summary

This document anchors the `feature/schema-foundation` branch. It freezes the canonical ASCP nouns, shared envelope material, capability document shape, and error object shape needed before method contracts and full event fixtures are added.

## Motivation

Later ASCP work depends on stable nouns and validation rules. Method contracts, event payload definitions, replay fixtures, auth behavior, and conformance assets all become guesswork if the core entities are not frozen first.

## Scope

Included in this slice:

- `Host`
- `Runtime`
- `Session`
- `Run`
- `ApprovalRequest`
- `Artifact`
- `DiffSummary`
- `EventEnvelope`
- shared JSON-RPC-style request and response envelope material
- capability documents
- error objects
- schema-valid examples for the core nouns above

Out of scope for this slice:

- per-method params and result contracts
- exact event payload schemas beyond `EventEnvelope`
- replay flow fixtures
- auth hook behavior
- conformance harnesses
- mock server implementation

## Protocol Impact

The schema foundation assets live under:

- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-errors.schema.json`
- `examples/core/`
- `examples/capabilities/`
- `examples/errors/`
- `examples/events/`

These files are the contract base for the next feature branch, `method contracts`.

## Source And Precedence

These assets follow the repository source-of-truth rules:

1. `ASCP_Protocol_Detailed_Spec_v0_1.md` defines the exact field names, required and optional fields, enums, and compatibility behavior.
2. `ASCP_Protocol_PRD_and_Build_Guide.md` defines the repository shape, design-principle framing, and versioning intent.

Where the detailed spec shows both prose examples and inline schema fragments, the branch keeps the shapes schema-valid against the canonical examples instead of narrowing them beyond what the examples allow.

## Implementation Notes

### Additive evolution and unknown fields

Core protocol objects keep `additionalProperties: true`. This matches the ASCP design rules that additive fields are preferred, unknown fields must be ignored safely, and extensions must not redefine core meanings.

### Timestamp rule

All canonical timestamps in the schemas use JSON Schema `date-time` format plus a trailing `Z` requirement. This keeps them aligned with the detailed spec rule that canonical event and entity timestamps are RFC3339 UTC values.

### Nullability carried from canonical examples

The detailed spec's canonical object examples use `null` for:

- `Run.ended_at`
- `ApprovalRequest.resolved_at`

The schema foundation preserves that behavior explicitly so the example fixtures validate and later method work can distinguish unresolved or still-running states from populated timestamps.

### Shared envelope material only

`schema/ascp-core.schema.json` includes generic request and response envelope definitions so later work can reuse stable JSON-RPC-style wrappers. The schemas deliberately do not encode method-specific `params` or `result` shapes in this branch.

### Versioning assumption

Capability documents keep `protocol_version` as a string in the schema. The semver policy comes from the PRD versioning section, but this branch does not narrow the field beyond the detailed spec's declared shape.

## Examples And Fixtures

This branch adds schema-valid examples for:

- each required canonical object
- one capability document
- one error object
- one minimal `EventEnvelope`

The examples are intended to be reused by later method-contract and event-contract branches rather than rewritten from scratch.

## Validation

Validation for this slice means:

- each core object example validates against its exact schema definition
- the capability document example validates against `schema/ascp-capabilities.schema.json`
- the error example validates against `schema/ascp-errors.schema.json`

The validation step should be rerun before any completion claim or commit.

## Follow-Up

The next branch should define exact request and response contracts for the ASCP core methods using these frozen nouns and shared envelopes as the only allowed base shapes.
