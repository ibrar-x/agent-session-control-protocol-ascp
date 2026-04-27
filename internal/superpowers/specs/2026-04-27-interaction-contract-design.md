# Interaction Contract Design

## Goal

Define one protocol-level contract for blocked agent interactions so mobile and other clients can receive actionable approval and input requests from any ASCP adapter without knowing runtime-specific blocked-state details.

This design keeps existing core method names:

- approvals continue to resolve through `approvals.respond`
- blocked questions continue to resolve through `sessions.send_input`

Adapters remain responsible for translating runtime-native blocked state into the protocol contract.

## Problem

Some runtimes expose coarse blocked state such as `waiting_approval` or `waiting_input` without exposing a first-class approval or input object. If ASCP surfaces only the raw status, clients can see that a session is blocked but cannot render a prompt, collect a response, or unblock the session.

The protocol needs a stable, adapter-agnostic contract for:

- blocked approval requests
- blocked user-input questions
- truthful provenance about whether the interaction object came from the runtime directly or was derived by the adapter from runtime-visible state

## Approach Options

### Option 1 — Extend the existing protocol minimally

- keep `ApprovalRequest`
- add `InputRequest`
- add `pending_inputs` to `sessions.get`
- add input lifecycle events
- keep `approvals.respond` and `sessions.send_input`

Pros:

- additive and compatible with current ASCP method names
- keeps approval and input control on existing method surfaces
- lets adapters implement translation independently

Cons:

- clients need to handle two blocked-interaction nouns instead of one union type

### Option 2 — Approval-only patch first

- patch approvals now
- defer blocked questions

Pros:

- smaller first patch

Cons:

- fails the product goal of consistent mobile interactions across runtimes
- leaves `waiting_input` unusable

### Option 3 — Introduce a new generic interaction union

- add a top-level `InteractionRequest`
- map approvals and questions into that new noun

Pros:

- elegant abstraction

Cons:

- larger protocol redesign
- conflicts with the existing method and noun surfaces

## Recommendation

Use Option 1.

It preserves ASCP naming discipline, keeps the method surface stable, and provides one reusable pattern for all adapters:

- approvals are exposed as `ApprovalRequest`
- blocked questions are exposed as `InputRequest`
- adapter translation remains runtime-specific
- host and client logic stay runtime-agnostic

## Protocol Changes

### 1. Extend `ApprovalRequest`

Keep the existing approval contract and add normative provenance metadata.

Expected additive metadata keys:

- `source`: `"runtime-native"` or `"host-derived"`
- `adapter_kind`: short runtime adapter identifier such as `codex`, `claude`, or `gemini`
- `derivation_reason`: short stable explanation of why the request was derived
- `native_status`: runtime-native blocked status string when the request is derived

These keys are expected contract metadata, not arbitrary free-form payload.

### 2. Actionability rule for approval provenance

Provenance is normative, not decorative.

Rules:

- `runtime-native` approvals are actionable.
- `host-derived` approvals are actionable only when the adapter has a verified response path that can route `approvals.respond` back into the live runtime session.
- if an adapter can derive a blocked approval request honestly but cannot route a response, it may expose the approval request as visible state, but it must advertise `approval_respond=false` and `approvals.respond` must return `UNSUPPORTED`.
- clients should render both runtime-native and host-derived approvals using the same primary approval UX, but may show a provenance badge.

### 3. Add `InputRequest`

Add a new canonical core noun:

- `id`
- `session_id`
- `run_id?`
- `question`
- `input_type`: `"text" | "choice" | "confirm"`
- `choices?`
- `status`: `"pending" | "answered" | "expired" | "cancelled"`
- `created_at`
- `metadata`

`run_id` remains optional and is populated only when the runtime exposes a stable run or turn identifier that the adapter can map honestly.

Clients must treat absent `run_id` as a normal opaque omission. They must not require it for rendering, response routing, or blocked-interaction handling.

Expected additive metadata keys for `InputRequest`:

- `source`
- `adapter_kind`
- `derivation_reason`
- `native_status`

No protocol-level inference rules are added for `input_type`. The protocol defines only valid values and payload shape.

### 4. Extend `sessions.get`

Add optional `pending_inputs` alongside `pending_approvals`.

Rules:

- `pending_inputs` is returned only when requested through a new include flag
- the field is an array of canonical `InputRequest`
- clients must not assume `pending_approvals` and `pending_inputs` are mutually exclusive

### 5. Add input lifecycle events

Add:

- `input.requested`
- `input.completed`
- `input.expired`

Do not add `input.updated` in this patch because no current adapter needs mid-lifecycle updates.

### 6. Keep existing response methods

No new core method names are introduced.

- approvals resolve through `approvals.respond`
- blocked questions resolve through `sessions.send_input`

That means `InputRequest` is descriptive state plus lifecycle events, while the response path remains session control.

## Adapter Boundary

The protocol does not define translation heuristics.

Adapters are responsible for:

- detecting blocked runtime state
- deciding whether enough runtime context exists to produce a truthful `ApprovalRequest` or `InputRequest`
- setting `metadata.source`
- populating `run_id` only when honest
- routing responses back into the live runtime

The protocol does not define:

- how a runtime’s raw status becomes `input_type`
- how the adapter extracts a blocked question
- how the adapter extracts pending-action context for approvals

Those rules belong in each adapter’s mapping implementation and adapter-specific documentation.

## Precedence Rules

When both runtime-native and adapter-derived interaction data could exist:

- runtime-native objects win
- host-derived objects may be used only when the runtime does not expose a first-class interaction object and the adapter can derive one honestly
- the host layer must not synthesize interactions independently of the adapter

## Capability Rules

Capability advertisement must reflect round-trip truth:

- `approval_requests=true` only when the adapter can surface approval request objects, whether runtime-native or host-derived
- `approval_respond=true` only when `approvals.respond` can actually route back into the live runtime and unblock it
- existing message-send capability continues to cover responding to blocked questions through `sessions.send_input`

No new approval or input capability flags are added in this patch.

## Error Handling

`approvals.respond`:

- returns `NOT_FOUND` when the approval id is unknown
- returns `CONFLICT` when the approval is no longer pending
- returns `UNSUPPORTED` when the adapter exposed visible approval state but has no verified response route

`sessions.send_input`:

- returns `NOT_FOUND` when the target session is gone
- returns `CONFLICT` when the target input request is no longer in `pending` status
- returns `UNSUPPORTED` when the adapter cannot route a blocked-question response back into the runtime

## Testing Strategy

The protocol patch must add:

- core schema validation for `InputRequest`
- method schema validation for `sessions.get.include_pending_inputs`
- event schema validation for input lifecycle events
- examples showing both runtime-native and host-derived approval provenance
- examples showing blocked question state and input completion
- a provenance actionability check proving that a host-derived approval with `approval_respond=false` causes `approvals.respond` to return `UNSUPPORTED`
- conformance checks proving adapters can implement the contract without inventing host-level translation semantics

## Follow-Up Branch

After this protocol branch merges, the Codex adapter branch should:

- translate `waiting_approval` into `ApprovalRequest`
- translate `waiting_input` into `InputRequest`
- route `approvals.respond` and `sessions.send_input` back into the live Codex session
- set approval capabilities to `true` only after the round-trip is verified end to end
