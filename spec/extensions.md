# ASCP Extension Semantics

This document freezes the `feature/extensions` branch. It defines the extension rules, namespacing expectations, capability advertisement, and ignore-safe behavior that sit on top of the frozen schema, method, event, replay, and auth contracts without reopening vendor-specific feature design, transport negotiation, or mock-server behavior.

## Scope And Dependency

Extension semantics depend on the frozen schema, method, and event outputs:

- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-methods.schema.json`
- `schema/ascp-events.schema.json`
- `spec/methods.md`
- `spec/events.md`
- `spec/replay.md`
- `spec/auth.md`
- capability-, method-, event-, and error-related examples under `examples/`

This branch does not redefine the core method surface or the exact core event catalog. Instead it makes extension handling explicit and testable on top of the already-frozen contracts.

## Extension Model Boundary

- ASCP remains vendor-neutral. It defines how implementations extend the protocol, not which vendor-specific features they should expose.
- Extensions MAY add new methods, new event types, and additive fields on open schema surfaces.
- Extensions MUST NOT redefine core field meanings.
- Extensions MUST NOT silently widen frozen core method params or exact core event payload contracts that were intentionally closed in earlier branches.
- Provider-specific auth, policy, or product behavior MAY be expressed through extensions, but core semantics such as session statuses, approval statuses, core method meanings, and core event meanings remain unchanged.

## Allowed Extension Surfaces

Extensions are allowed on these surfaces:

- namespaced request and response envelopes using the shared `RequestEnvelope` and `SuccessResponseEnvelope`
- namespaced event envelopes using the shared `EventEnvelope`
- namespaced additive fields on open core entities such as `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, and `DiffSummary`
- namespaced additive fields inside already-flexible containers such as `metadata`, `payload`, and error `details`
- capability documents through the `extensions` array and namespaced capability flags

Rules:

- use a new namespaced method when the extension introduces a new control or read operation
- use a new namespaced event type when the extension introduces a new event meaning
- use namespaced additive fields only when the base object already permits additive fields without changing core meaning
- preserve the original meaning of all required core fields even when additive namespaced detail is present

## Namespacing Rules

Recommended namespacing is normative for this repository branch:

- methods use `x.vendor.method_name`
- event types use `x.vendor.event_name`
- additive field names use `x_vendor_feature`
- capability flags use `x_vendor_feature`
- extension family identifiers use `x.vendor` or `x.vendor.family`

Examples:

- `x.codex.checkpoint.create`
- `x.enterprise.policy_violation`
- `x_codex_checkpointing`
- `x_enterprise_retention_class`
- `x.enterprise.audit`

Rules:

- the `x` prefix marks the surface as extension-owned rather than core
- the vendor segment SHOULD stay stable across that vendor's extension family
- extension names SHOULD be specific enough that later conformance work can distinguish one feature from another
- extension names MUST remain additive and MUST NOT shadow a core method, event, or field name

The detailed spec examples remain valid:

- `x.vendor.method_name`
- `x.vendor.event_name`
- `x_vendor_feature`

## Capability Advertisement

Capability documents are the discovery surface for active extensions.

Rules:

- implementations SHOULD list active extension families in `extensions`
- implementations MAY expose extension-specific booleans in `capabilities` using namespaced capability flags
- extension capability flags do not replace the core capability booleans; they add vendor-specific discovery detail
- clients SHOULD discover extension support from capability advertisement before relying on a namespaced method or event family

This branch does not define a new schema for extension capability details. The existing capability document remains sufficient because it already exposes an `extensions` array and an open-ended capability map.

## Unknown Extension Behavior

Unknown extension behavior is intentionally boring and safe by default.

Rules:

- clients MUST ignore unknown extension fields on open schema surfaces unless explicitly configured to fail
- clients MUST ignore unknown namespaced extension events unless explicitly configured to fail
- clients SHOULD preserve unknown extension fields when forwarding or replaying protocol objects if the implementation supports lossless passthrough
- clients MAY render extension detail when recognized, but unrecognized detail must not block core session observation or control
- hosts SHOULD continue to emit core fields and core events even when extension fields or extension events are also present

The safety goal is that an implementation can add vendor-specific detail without breaking a client that only understands the frozen core protocol.

## Closed Core Schemas

Some ASCP schema surfaces are open, but others are deliberately closed.

Closed surfaces in the current repository include:

- core method parameter objects under `schema/ascp-methods.schema.json`, such as `SessionsStartParams`, `SessionsSubscribeParams`, and `ApprovalsRespondParams`
- exact core event payload definitions under `schema/ascp-events.schema.json`, such as `SessionUpdatedPayload`, `ApprovalRequestedPayload`, and `SyncReplayedPayload`

Rules:

- do not add inline extension fields to a closed core method params object
- do not add inline extension fields to an exact core event payload definition
- when a new input shape is needed, define a new namespaced method instead of widening a closed core method
- when a new event meaning is needed, define a new namespaced event instead of widening a closed core event payload
- additive namespaced fields remain valid on the shared open envelopes and on open core entities that already allow additional properties

This distinction is normative for v0.1 because the schemas already encode it. Extension guidance must follow the frozen validation surface rather than contradict it in prose.

## Compatibility Notes

This branch does not add a new compatibility level.

It makes the following compatibility expectations explicit for later conformance work:

- `ASCP Core Compatible` implementations ignore unknown extension fields and namespaced events safely while preserving core behavior
- richer implementations may advertise extension families and namespaced capability flags
- later conformance work can validate extension declarations and extension ignore behavior without reopening core method or event semantics

## Conformance Material In This Branch

This branch adds:

- namespaced capability advertisement examples under `examples/capabilities/`
- namespaced method, event, and additive field examples under `examples/extensions/`
- extension catalog and ignore-behavior fixtures under `conformance/fixtures/extensions/`
- extension-specific validation in `conformance/tests/validate_extension_semantics.py`
- a shell entrypoint at `scripts/validate_extension_semantics.sh`

Those assets make the extension rules executable without widening into vendor-specific runtime features or mock-server implementation logic.
