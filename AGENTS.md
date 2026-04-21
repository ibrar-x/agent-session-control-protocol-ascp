# AGENTS.md

## Purpose

This repository is a protocol-first workspace for the **Agent Session & Control Protocol (ASCP)**.

Treat these two files as the current source material:

1. `ASCP_Protocol_Detailed_Spec_v0_1.md`
2. `ASCP_Protocol_PRD_and_Build_Guide.md`

If they disagree, prefer:

1. `ASCP_Protocol_Detailed_Spec_v0_1.md` for exact contracts, payloads, schemas, and compliance behavior
2. `ASCP_Protocol_PRD_and_Build_Guide.md` for scope, sequencing, design intent, and repository shape

ASCP is not a product UI spec. It is not a model API. It is not an agent-planning spec. It is a vendor-neutral control plane for discovering, observing, resuming, steering, and approving long-running agent sessions.

## Protocol Constraints

All work in this repository should preserve the protocol principles defined in the source docs:

- Session-first
- Capability-based
- Event-driven
- Transport-neutral
- Replay-safe
- Auditable
- Explicit and boring

That means:

- prefer explicit JSON objects and stable field names
- use JSON Schema for protocol objects
- evolve additively
- ignore unknown fields safely
- do not redefine core semantics through extensions
- keep method and event names exactly aligned with the spec

## Current Scope

ASCP currently covers:

- host discovery
- runtime discovery
- capability advertisement
- session list, get, start, resume, stop
- input submission
- event subscriptions
- replay after reconnect
- approvals
- artifact metadata
- diff metadata
- error semantics
- auth hooks
- versioning
- conformance

ASCP explicitly does not standardize:

- model inference APIs
- prompt formats
- tool schemas
- memory formats
- UI systems
- agent planning internals
- vendor billing

Do not expand scope casually. If a change drifts into product behavior or vendor-specific runtime internals, stop and treat it as out of scope unless the spec is being intentionally revised.

## Source-Of-Truth Names

Keep these names exact unless the spec is deliberately version-bumped:

### Core methods

- `capabilities.get`
- `hosts.get`
- `runtimes.list`
- `sessions.list`
- `sessions.get`
- `sessions.start`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `sessions.subscribe`
- `sessions.unsubscribe`
- `approvals.list`
- `approvals.respond`
- `artifacts.list`
- `artifacts.get`
- `diffs.get`

### Core session statuses

- `idle`
- `running`
- `waiting_input`
- `waiting_approval`
- `completed`
- `failed`
- `stopped`
- `disconnected`

### Core event families

- session lifecycle
- run lifecycle
- transcript
- tool activity
- terminal fallback
- approvals
- artifacts and diffs
- sync and connectivity
- errors

### Compatibility levels

- `ASCP Core Compatible`
- `ASCP Interactive`
- `ASCP Approval-Aware`
- `ASCP Artifact-Aware`
- `ASCP Replay-Capable`

## Implementation Order

When building the protocol, follow this order unless there is a strong reason not to:

1. Canonical schemas
2. Capability document
3. Error schema and catalog
4. Method request and response contracts
5. Event payload definitions
6. Replay semantics
7. Auth hooks and approval behavior
8. Extensions model
9. Conformance fixtures and validators
10. Mock server

Do not start with a mobile app, dashboard, or runtime-specific UI. The first proof of ASCP should be schemas, examples, validation, and conformance.

## Working Rules For Agents

- Read the detailed spec before changing protocol nouns, method shapes, or event payloads.
- Keep examples schema-valid.
- Prefer additive evolution over breaking shape changes.
- When introducing extensions, namespace them and keep them outside core semantics.
- If a runtime cannot support replay safely, advertise `replay=false` rather than guessing.
- If a runtime cannot provide stable sequence numbers, the host should synthesize them or disable replay support.
- Treat audit fields, actor attribution, and approval history as first-class protocol concerns.
- Keep repository additions aligned with the suggested layouts from the source documents.

## Expected Repository Growth

As this repository matures, prefer a structure close to:

```text
README.md
AGENTS.md
docs/
spec/ or schema/
examples/
conformance/
mock-server/ or mock/
.agents/skills/
```

## Definition Of Done For Protocol Work

A protocol task is not done just because prose exists. It is done when the relevant behavior is explicit, testable, and implementation-ready. Prefer outputs that reduce guessing:

- schema files
- exact request and response examples
- exact event payloads
- compatibility notes
- replay rules
- auth scope notes
- conformance fixtures

If a proposed change makes ASCP less precise, less replay-safe, or harder to validate, it is probably the wrong change.
