# Extensions Design

## Summary

This design defines the `feature/extensions` branch for ASCP. The branch adds a normative extension document, namespaced extension examples for methods, events, fields, and capability advertisement, and a minimal conformance slice that makes additive extension behavior explicit and safely ignorable without reopening frozen core semantics.

## Motivation

The schema-foundation, method-contracts, event-contracts, replay-semantics, and auth-and-approvals branches froze the core nouns, method surface, event payloads, replay behavior, and auth hooks. The next protocol slice is to define exactly how vendors extend ASCP without mutating those core contracts or forcing clients to guess which unknown data is safe to ignore.

## Scope

Included in this branch:

- normative extension rules in `spec/extensions.md`
- concrete namespacing guidance for extension methods, events, fields, and capability flags
- examples showing extension capability advertisement and namespaced extension envelopes
- fixtures showing safe handling of unknown extension fields and unknown extension events
- minimal extension-focused conformance validation

Explicitly out of scope:

- vendor-specific feature design or policy logic
- reopening frozen core method params or exact core event payload contracts
- transport-specific extension negotiation
- mock-server behavior beyond fixtures needed to express extension handling
- broader compatibility or mock-server work beyond this slice

## Protocol Impact

The branch must preserve these rules from the source specs:

- extensions MAY add new methods
- extensions MAY add new event types
- extensions MAY add additional fields
- extensions MUST NOT redefine core field meanings
- extensions SHOULD use namespacing
- clients MUST ignore unknown extension fields and unknown extension events unless explicitly configured to fail

The branch also needs to make one repository-specific constraint explicit: some ASCP schema surfaces are open to additive fields, while the frozen method-contract params and exact core event payload definitions are intentionally closed. Extension guidance must respect both sides of that design.

## Architecture

The normative protocol write-up will live in `spec/extensions.md` to match the detailed spec's suggested repository shape. That document will define the allowed extension surfaces, required namespacing patterns, capability advertisement rules, and ignore-safe behavior, plus explain where additive fields are allowed and where closed schemas require a new namespaced method or event instead.

Illustrative extension material will live under `examples/extensions/` plus one dedicated capability document example under `examples/capabilities/`. Those fixtures will cover a namespaced method request and success response, a namespaced event envelope, and a core object carrying namespaced additive fields without changing core meaning.

Repeatable validation will use a small shell entrypoint backed by `python3` and `jsonschema`, reusing the frozen schema files. The validator will prove that extension examples stay schema-valid where they rely on open envelope/object surfaces, that namespaced method and event examples follow the documented prefixes, that capability advertisement stays aligned with the schema and namespacing rules, and that ignore-safe fixtures describe unknown extension handling without claiming that closed core param objects can accept arbitrary new fields.

## File Layout

Files to create:

- `spec/extensions.md`
- `examples/capabilities/capabilities-with-extensions.json`
- `examples/extensions/method-request.json`
- `examples/extensions/method-response.json`
- `examples/extensions/event-envelope.json`
- `examples/extensions/session-field-extension.json`
- `conformance/fixtures/extensions/extension-catalog.json`
- `conformance/fixtures/extensions/ignore-behavior.json`
- `conformance/tests/validate_extension_semantics.py`
- `scripts/validate_extension_semantics.sh`
- `docs/superpowers/specs/2026-04-22-extensions-design.md`
- `docs/superpowers/plans/2026-04-22-extensions.md`

Files to modify:

- `plans.md`
- `docs/status.md`

## Design Decisions

### Open versus closed extension surfaces

The branch will document that additive namespaced fields belong only on schema surfaces that are already open, such as `EventEnvelope`, core entities like `Session`, `Runtime`, and `ApprovalRequest`, capability documents, and flexible metadata containers. Closed method param schemas and exact core event payload contracts remain closed in v0.1 and must not be extended in place.

### Namespaced method and event examples

The branch will use `x.vendor.method_name` for namespaced methods and `x.vendor.event_name` for namespaced event types, matching the detailed spec. These examples will validate against the generic request, success-response, and event-envelope schemas rather than pretending to be part of the frozen core method or core event catalogs.

### Capability advertisement remains the discovery hook

The capability document already has an `extensions` array and open-ended capability flags. This branch will keep that structure and show how extension families and vendor-specific capability flags are advertised without redefining the core boolean capability map.

### Ignore-safe fixtures are declarative, not behavioral runtime code

Because this branch is still protocol-first, ignore behavior will be captured as fixtures and validator invariants instead of mock-server logic. That keeps the branch narrow while making later conformance work straightforward.

## Validation Strategy

Validation should prove the extension semantics rather than just file presence:

- `spec/extensions.md` must contain the required extension, namespacing, capability advertisement, unknown-handling, and open-versus-closed schema rules
- namespaced method request and success examples must validate against the generic request and success envelope schemas
- namespaced event examples and additive field examples must validate against the shared `EventEnvelope` or core entity schemas
- capability advertisement examples must validate against `schema/ascp-capabilities.schema.json`
- conformance fixtures must cover method, event, field, and capability extension patterns plus ignore-safe behavior
- ignore-safe fixtures must state that unknown extension fields and namespaced extension events are ignored safely, while closed core param objects require a new namespaced method instead of inline extra params

## Risks And Controls

Risk: the branch accidentally blesses extension fields inside frozen core method params.
Control: document closed schema boundaries explicitly and validate examples only against allowed open surfaces.

Risk: extension examples quietly redefine core meaning instead of adding optional detail.
Control: require fixture annotations that explain the preserved core meaning and validate namespaced field prefixes.

Risk: unknown extension behavior gets described loosely enough to create incompatible clients.
Control: add a dedicated ignore-behavior fixture and validator checks for field and event handling expectations.

## Follow-Up

After this branch lands, the next protocol slice should be the broader `conformance` workstream or the mock server. Both can build on the frozen extension model instead of rediscovering namespacing and ignore-safe rules later.
