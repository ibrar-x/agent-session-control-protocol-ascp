# Interaction Contract Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add protocol-level blocked interaction support by extending approval provenance, introducing `InputRequest`, surfacing `pending_inputs`, and defining input lifecycle events without changing existing core method names.

**Architecture:** The protocol patch is additive. Core schemas define the nouns and envelopes, method contracts surface pending blocked inputs through `sessions.get`, and event contracts expose input lifecycle state. SDK types mirror the frozen protocol, while adapter translation remains out of scope for this branch.

**Tech Stack:** JSON Schema, Markdown protocol specs, TypeScript SDK types, Python and shell-based protocol validators.

---

### Task 1: Patch core protocol nouns

**Files:**
- Modify: `protocol/schema/ascp-core.schema.json`
- Modify: `sdks/typescript/src/validation/schemas/ascp-core.schema.json`
- Modify: `sdks/typescript/src/models/types.ts`

- [ ] **Step 1: Write the failing schema/type expectations**

Target additions:

```json
{
  "$defs": {
    "InputRequest": {
      "type": "object",
      "required": ["id", "session_id", "question", "input_type", "status", "created_at", "metadata"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "session_id": { "$ref": "#/$defs/Id" },
        "run_id": { "$ref": "#/$defs/Id" },
        "question": { "type": "string", "minLength": 1 },
        "input_type": { "enum": ["text", "choice", "confirm"] },
        "choices": {
          "type": "array",
          "items": { "type": "string", "minLength": 1 },
          "minItems": 1
        },
        "status": { "enum": ["pending", "answered", "expired", "cancelled"] },
        "created_at": { "$ref": "#/$defs/Timestamp" },
        "metadata": {
          "type": "object",
          "required": ["source", "adapter_kind", "derivation_reason", "native_status"],
          "properties": {
            "source": { "enum": ["runtime-native", "host-derived"] },
            "adapter_kind": { "type": "string", "minLength": 1 },
            "derivation_reason": { "type": "string", "minLength": 1 },
            "native_status": { "type": "string", "minLength": 1 }
          },
          "additionalProperties": true
        }
      },
      "additionalProperties": false,
      "allOf": [
        {
          "if": { "properties": { "input_type": { "const": "choice" } }, "required": ["input_type"] },
          "then": { "required": ["choices"] }
        }
      ]
    }
  }
}
```

- [ ] **Step 2: Run the protocol validators to verify the current branch fails the new expectations**

Run: `bash tooling/scripts/validate_conformance.sh`
Expected: FAIL later when examples/types do not yet satisfy the new `InputRequest` and metadata requirements

- [ ] **Step 3: Implement the minimal schema and SDK type changes**

Add:

- `InputRequest` to the core schema and SDK model types
- approval metadata rule documentation through schema descriptions
- client-facing type note that absent `run_id` is valid and must not be required

- [ ] **Step 4: Run targeted checks**

Run: `npm --workspace sdks/typescript run build`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add protocol/schema/ascp-core.schema.json sdks/typescript/src/validation/schemas/ascp-core.schema.json sdks/typescript/src/models/types.ts
git commit -m "feat(protocol): add input request core noun"
```

### Task 2: Patch method contracts for pending inputs

**Files:**
- Modify: `protocol/schema/ascp-methods.schema.json`
- Modify: `protocol/spec/methods.md`
- Modify: `protocol/examples/requests/sessions-get.json`
- Modify: `protocol/examples/responses/sessions-get.json`
- Modify: `sdks/typescript/src/methods/types.ts`
- Modify: `sdks/typescript/src/validation/schemas/ascp-methods.schema.json`
- Modify: `sdks/typescript/src/validation/types.ts`

- [ ] **Step 1: Write the failing request/response shape**

Target additions:

```json
{
  "params": {
    "session_id": "sess_01",
    "include_pending_approvals": true,
    "include_pending_inputs": true
  }
}
```

```json
{
  "result": {
    "session": {},
    "runs": [],
    "pending_approvals": [],
    "pending_inputs": [
      {
        "id": "inp_01",
        "session_id": "sess_01",
        "question": "Proceed?",
        "input_type": "confirm",
        "status": "pending",
        "created_at": "2026-04-27T10:00:00Z",
        "metadata": {
          "source": "host-derived",
          "adapter_kind": "codex",
          "derivation_reason": "blocked_session_status",
          "native_status": "waiting_input"
        }
      }
    ]
  }
}
```

- [ ] **Step 2: Run method validation to verify failure**

Run: `bash tooling/scripts/validate_method_contracts.sh`
Expected: FAIL because `include_pending_inputs` and `pending_inputs` are not yet defined

- [ ] **Step 3: Implement the method schema, examples, and SDK method/result types**

Add:

- `include_pending_inputs?: boolean` to `sessions.get`
- optional `pending_inputs?: InputRequest[]` to the success result
- explicit method note that `approvals.respond` remains the approval response path and `sessions.send_input` remains the blocked-input response path

- [ ] **Step 4: Re-run targeted validation**

Run: `bash tooling/scripts/validate_method_contracts.sh`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add protocol/schema/ascp-methods.schema.json protocol/spec/methods.md protocol/examples/requests/sessions-get.json protocol/examples/responses/sessions-get.json sdks/typescript/src/methods/types.ts sdks/typescript/src/validation/schemas/ascp-methods.schema.json sdks/typescript/src/validation/types.ts
git commit -m "feat(protocol): add pending input session surfaces"
```

### Task 3: Patch event contracts for input lifecycle

**Files:**
- Modify: `protocol/schema/ascp-events.schema.json`
- Modify: `protocol/spec/events.md`
- Add: `protocol/examples/events/input-requested.json`
- Add: `protocol/examples/events/input-completed.json`
- Add: `protocol/examples/events/input-expired.json`
- Modify: `sdks/typescript/src/events/types.ts`
- Modify: `sdks/typescript/src/validation/schemas/ascp-events.schema.json`

- [ ] **Step 1: Write the failing event expectations**

Target event kinds:

```json
{ "type": "input.requested" }
{ "type": "input.completed" }
{ "type": "input.expired" }
```

Target requested payload:

```json
{
  "input": {
    "id": "inp_01",
    "session_id": "sess_01",
    "question": "Choose deploy target",
    "input_type": "choice",
    "choices": ["staging", "production"],
    "status": "pending",
    "created_at": "2026-04-27T10:00:00Z",
    "metadata": {
      "source": "host-derived",
      "adapter_kind": "codex",
      "derivation_reason": "blocked_session_status",
      "native_status": "waiting_input"
    }
  }
}
```

- [ ] **Step 2: Run event validation to verify failure**

Run: `bash tooling/scripts/validate_event_contracts.sh`
Expected: FAIL because the input event family does not exist yet

- [ ] **Step 3: Implement event schema, examples, and SDK event unions**

Add:

- input payload defs
- `input.requested`, `input.completed`, and `input.expired` event envelope variants
- event documentation stating that `input.updated` is intentionally omitted in this patch

- [ ] **Step 4: Re-run event validation**

Run: `bash tooling/scripts/validate_event_contracts.sh`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add protocol/schema/ascp-events.schema.json protocol/spec/events.md protocol/examples/events/input-requested.json protocol/examples/events/input-completed.json protocol/examples/events/input-expired.json sdks/typescript/src/events/types.ts sdks/typescript/src/validation/schemas/ascp-events.schema.json
git commit -m "feat(protocol): add input lifecycle events"
```

### Task 4: Patch auth, compatibility, and conformance rules

**Files:**
- Modify: `protocol/spec/auth.md`
- Modify: `protocol/spec/compatibility.md`
- Modify: `protocol/examples/errors/approvals-list.json`
- Modify: `protocol/conformance/fixtures/`
- Modify: `protocol/conformance/tests/`

- [ ] **Step 1: Write the failing provenance/actionability case**

Target behavioral fixture:

```json
{
  "approval": {
    "metadata": {
      "source": "host-derived",
      "adapter_kind": "codex",
      "derivation_reason": "blocked_session_status",
      "native_status": "waiting_approval"
    }
  },
  "capabilities": {
    "approval_requests": true,
    "approval_respond": false
  },
  "expected_error": {
    "code": "UNSUPPORTED",
    "method": "approvals.respond"
  }
}
```

- [ ] **Step 2: Run auth/conformance validation to verify failure**

Run: `bash tooling/scripts/validate_auth_semantics.sh && bash tooling/scripts/validate_conformance.sh`
Expected: FAIL because the new provenance actionability behavior is not yet represented

- [ ] **Step 3: Implement the normative rules and fixtures**

Add:

- auth-spec text for host-derived actionable vs display-only approvals
- compatibility notes for blocked-input support on interactive hosts
- conformance fixture proving `approval_respond=false` + host-derived approval yields `UNSUPPORTED`

- [ ] **Step 4: Re-run validation**

Run: `bash tooling/scripts/validate_auth_semantics.sh && bash tooling/scripts/validate_conformance.sh`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add protocol/spec/auth.md protocol/spec/compatibility.md protocol/examples/errors/approvals-list.json protocol/conformance
git commit -m "feat(protocol): add interaction actionability rules"
```

### Task 5: Verify repo-level protocol and SDK integrity

**Files:**
- Modify: `docs/status.md`
- Modify: `plans.md`

- [ ] **Step 1: Run the full relevant verification suite**

Run: `npm --workspace sdks/typescript run check`
Expected: PASS

Run: `bash tooling/scripts/validate_method_contracts.sh`
Expected: PASS

Run: `bash tooling/scripts/validate_event_contracts.sh`
Expected: PASS

Run: `bash tooling/scripts/validate_auth_semantics.sh`
Expected: PASS

Run: `bash tooling/scripts/validate_conformance.sh`
Expected: PASS

- [ ] **Step 2: Update recovery docs**

Add a `docs/status.md` entry describing:

- branch name
- commit checkpoint
- protocol nouns and events added
- next likely step: Codex adapter translation branch from updated `main`

Mark `plans.md` task statuses complete.

- [ ] **Step 3: Commit**

```bash
git add docs/status.md plans.md
git commit -m "docs(protocol): checkpoint interaction contract patch"
```
