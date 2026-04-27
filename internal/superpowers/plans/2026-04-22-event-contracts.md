# Event Contracts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a canonical ASCP event-contract schema, schema-valid fixtures for every core event type, normative event support documentation, and repeatable validation without widening into replay implementation or mock-server behavior.

**Architecture:** Reuse the shared `EventEnvelope` and canonical nouns from `schema/ascp-core.schema.json`, then narrow `type` plus `payload` in a new `schema/ascp-events.schema.json`. Validate one concrete `EventEnvelope` fixture per spec-defined event under `examples/events/`, and document family support plus replay-safe boundaries in `spec/events.md`.

**Tech Stack:** JSON Schema Draft 2020-12, `python3`, `jsonschema`, Bash, Markdown, Git

---

### Task 1: Activate Branch Scope In Repository State

**Files:**
- Modify: `plans.md`

- [ ] **Step 1: Rewrite the active feature block for `feature/event-contracts`**

Replace the current active feature section with:

```md
## Active Feature

- Feature name: Event contracts
- Branch: `feature/event-contracts`
- Goal: freeze exact `EventEnvelope` payload contracts for every core ASCP event type using the canonical schema-foundation nouns and frozen method triggers without widening into replay implementation, auth middleware behavior, or mock-server logic
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/event-contracts.md`
  - `docs/superpowers/specs/2026-04-22-event-contracts-design.md`
  - `docs/schema-foundation.md`
  - `schema/ascp-core.schema.json`
  - `schema/ascp-capabilities.schema.json`
  - `schema/ascp-errors.schema.json`
  - `schema/ascp-methods.schema.json`
  - `spec/methods.md`
  - existing core examples under `examples/`
  - current chat requirements for the event-contracts slice only
```

- [ ] **Step 2: Replace the bootstrap, boundary, tasks, acceptance, and next-step sections with event-contract scope**

The rewritten plan must include:

```md
## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for event contracts is met: schema foundation, method contracts, and the seed `EventEnvelope` example are present under `schema/`, `spec/`, and `examples/`.
- No dedicated event-contract schema, full event fixture set, or event support spec is present yet.
- This branch starts from up-to-date `main` at commit `3f76faf`.
```

```md
## Feature Boundary

Included in this branch:

- exact `EventEnvelope` payload contracts for every core event type named in the detailed spec
- event-family and event-type schema material under `schema/`
- one schema-valid example fixture per core event type under `examples/events/`
- event support and compatibility notes that distinguish live events, snapshots, and replay markers
- validation commands or scripts needed to verify the event-contract assets

Explicitly out of scope:

- replay retention rules or storage implementation
- sequence generation implementation beyond schema-level replay-safe constraints
- auth middleware behavior beyond fields already required by approval or audit-related events
- mock-server streaming behavior
- conformance harness expansion beyond validating the event-contract fixtures
```

- [ ] **Step 3: Add event-contract task rows and completion outcome**

Use six tasks:

```md
| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| pending | rewrite the active branch plan for event contracts | `plans.md` records the event-contract branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| pending | create canonical event-contract schema material under `schema/` | `schema/ascp-events.schema.json` defines exact envelope and payload contracts for every core event type while reusing the schema-foundation nouns and shared envelope |
| pending | add schema-valid event fixtures for every core event type | `examples/events/` contains one concrete `EventEnvelope` fixture for each spec-defined event type |
| pending | document event support, compatibility expectations, and replay-safe boundaries | `spec/events.md` explains the event families, exact payload support, compatibility notes, and the difference between snapshots and replay markers |
| pending | add repeatable validation for event-contract assets | `scripts/validate_event_contracts.sh` validates the event schema plus the event fixture set |
| pending | verify all event-contract assets and checkpoint the branch | fresh validation passes, `docs/status.md` records the checkpoint, and the branch is ready for commit without widening scope |
```

- [ ] **Step 4: Save and inspect the rewritten plan**

Run: `sed -n '1,260p' plans.md`
Expected: the active feature is `Event contracts` on `feature/event-contracts`, with no remaining method-contract task text in the active block

- [ ] **Step 5: Commit the plan rewrite**

Run:

```bash
git add plans.md
git commit -m "docs: scope event contracts branch"
```

Expected: one commit updates only the active branch plan for the event-contract slice

### Task 2: Write The Failing Event-Contract Validator First

**Files:**
- Create: `scripts/validate_event_contracts.sh`

- [ ] **Step 1: Create the validator entrypoint before the schema exists**

Create `scripts/validate_event_contracts.sh` with:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 <<'PY'
from pathlib import Path

required = [
    Path("schema/ascp-events.schema.json"),
    Path("spec/events.md"),
    Path("examples/events/session-created.json"),
    Path("examples/events/error-fatal.json"),
]

missing = [str(path) for path in required if not path.exists()]
if missing:
    raise SystemExit("Missing event-contract assets:\n- " + "\n- ".join(missing))
PY
```

- [ ] **Step 2: Run the validator to verify the red state**

Run: `./scripts/validate_event_contracts.sh`
Expected: FAIL with a missing-file message for `schema/ascp-events.schema.json`, `spec/events.md`, and the new event fixtures

- [ ] **Step 3: Commit the failing test harness**

Run:

```bash
chmod +x scripts/validate_event_contracts.sh
git add scripts/validate_event_contracts.sh
git commit -m "test: add event contract validator harness"
```

Expected: one commit adds the failing validator entrypoint only

### Task 3: Implement The Canonical Event Schema

**Files:**
- Create: `schema/ascp-events.schema.json`

- [ ] **Step 1: Define shared event helper defs and family-specific payload defs**

Create `schema/ascp-events.schema.json` with:

```json
{
  "$id": "https://ascp.dev/schema/v0.1/ascp-events.schema.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ASCP Event Contracts",
  "description": "Exact EventEnvelope payload contracts for every ASCP core event type.",
  "$defs": {
    "ChangedFields": {
      "type": "array",
      "items": { "type": "string", "minLength": 1 }
    },
    "ConnectionState": {
      "type": "string",
      "enum": ["connected", "disconnected", "reconnecting", "reconnected"]
    },
    "BaseEnvelope": {
      "$ref": "ascp-core.schema.json#/$defs/EventEnvelope"
    },
    "SessionCreatedPayload": {
      "type": "object",
      "required": ["session"],
      "properties": {
        "session": { "$ref": "ascp-core.schema.json#/$defs/Session" }
      },
      "additionalProperties": false
    },
    "SessionUpdatedPayload": {
      "type": "object",
      "required": ["session", "changed_fields"],
      "properties": {
        "session": { "$ref": "ascp-core.schema.json#/$defs/Session" },
        "changed_fields": { "$ref": "#/$defs/ChangedFields" }
      },
      "additionalProperties": false
    }
  }
}
```

- [ ] **Step 2: Add the remaining payload defs and one envelope def per event type**

Extend the schema with:

```json
{
  "$defs": {
    "SessionStatusChangedPayload": {
      "type": "object",
      "required": ["from", "to"],
      "properties": {
        "from": { "$ref": "ascp-core.schema.json#/$defs/SessionStatus" },
        "to": { "$ref": "ascp-core.schema.json#/$defs/SessionStatus" }
      },
      "additionalProperties": false
    },
    "RunStartedPayload": {
      "type": "object",
      "required": ["run"],
      "properties": {
        "run": { "$ref": "ascp-core.schema.json#/$defs/Run" }
      },
      "additionalProperties": false
    },
    "SyncSnapshotPayload": {
      "type": "object",
      "required": ["session", "pending_approvals"],
      "properties": {
        "session": { "$ref": "ascp-core.schema.json#/$defs/Session" },
        "active_run": { "$ref": "ascp-core.schema.json#/$defs/Run" },
        "pending_approvals": {
          "type": "array",
          "items": { "$ref": "ascp-core.schema.json#/$defs/ApprovalRequest" }
        },
        "summary": { "$ref": "ascp-core.schema.json#/$defs/FlexibleObject" }
      },
      "additionalProperties": false
    },
    "ErrorFatalPayload": {
      "type": "object",
      "required": ["code", "message"],
      "properties": {
        "code": {
          "$ref": "ascp-errors.schema.json#/$defs/ErrorCode"
        },
        "message": { "type": "string" }
      },
      "additionalProperties": false
    }
  }
}
```

Each concrete envelope definition must:

- lock `type` to the exact event name with `"const"`
- require `id`, `type`, `ts`, `session_id`, and `payload`
- allow `run_id` where the event family uses it
- allow `seq` as an integer
- set `payload` to the matching payload definition
- set `additionalProperties` to `true` at the envelope level so the shared envelope remains additive

- [ ] **Step 3: Run a schema sanity check**

Run:

```bash
python3 - <<'PY'
import json
from pathlib import Path

schema = json.loads(Path("schema/ascp-events.schema.json").read_text())
required_defs = [
    "SessionCreatedEvent",
    "RunFailedEvent",
    "MessageAssistantDeltaEvent",
    "ApprovalRequestedEvent",
    "DiffReadyEvent",
    "SyncSnapshotEvent",
    "SyncReplayedEvent",
    "ErrorFatalEvent",
]
missing = [name for name in required_defs if name not in schema["$defs"]]
if missing:
    raise SystemExit("Missing event defs: " + ", ".join(missing))
print("event schema defs present")
PY
```

Expected: PASS with `event schema defs present`

- [ ] **Step 4: Commit the canonical event schema**

Run:

```bash
git add schema/ascp-events.schema.json
git commit -m "schema: add ASCP event contracts"
```

Expected: one commit adds the canonical event schema only

### Task 4: Add Concrete Event Fixtures

**Files:**
- Create: `examples/events/*.json`

- [ ] **Step 1: Add one concrete `EventEnvelope` fixture per spec-defined event**

Each fixture must follow this pattern:

```json
{
  "id": "evt_9001",
  "type": "message.assistant.delta",
  "ts": "2026-04-21T10:07:00Z",
  "session_id": "sess_abc123",
  "run_id": "run_9",
  "seq": 45,
  "payload": {
    "message_id": "msg_a_1",
    "delta": "I found the source of the failure..."
  }
}
```

Use spec-matching payload shapes for all of these filenames:

```text
session-created.json
session-updated.json
session-status-changed.json
session-deleted.json
run-started.json
run-paused.json
run-resumed.json
run-completed.json
run-failed.json
run-cancelled.json
message-user.json
message-assistant-started.json
message-assistant-delta.json
message-assistant-completed.json
message-system.json
tool-started.json
tool-stdout.json
tool-stderr.json
tool-completed.json
tool-failed.json
terminal-opened.json
terminal-output.json
terminal-closed.json
terminal-resize-requested.json
approval-requested.json
approval-updated.json
approval-approved.json
approval-rejected.json
approval-expired.json
artifact-created.json
artifact-updated.json
diff-ready.json
diff-updated.json
connection-state-changed.json
sync-snapshot.json
sync-replayed.json
sync-cursor-advanced.json
error-transient.json
error-fatal.json
```

- [ ] **Step 2: Run the validator and keep it red until docs are added**

Run: `./scripts/validate_event_contracts.sh`
Expected: FAIL because `spec/events.md` does not exist yet, even if the schema and fixtures are present

- [ ] **Step 3: Commit the event fixtures**

Run:

```bash
git add examples/events
git commit -m "test: add ASCP event fixtures"
```

Expected: one commit adds only the concrete event examples

### Task 5: Document Event Support And Finish The Validator

**Files:**
- Create: `spec/events.md`
- Modify: `scripts/validate_event_contracts.sh`

- [ ] **Step 1: Write the normative event document**

Create `spec/events.md` with sections covering:

```md
# ASCP Event Contracts

## Scope And Dependency

This document freezes the `feature/event-contracts` branch. It defines the exact `EventEnvelope` payload contracts for every core ASCP event type without widening into replay implementation, auth middleware behavior, or mock-server logic.

## Event Families

- session lifecycle
- run lifecycle
- transcript
- tool activity
- terminal fallback
- approvals
- artifacts and diffs
- sync and connectivity
- errors

## Contract Rules

- every streamed event MUST be an `EventEnvelope`
- `type` values MUST exactly match the detailed spec
- `payload` shapes are exact at the wrapper level
- shared canonical nouns remain additive
- snapshots describe current state and MUST NOT masquerade as replayed history
- replay markers describe stream progress and do not replace historical event envelopes
```

The document must also include:

- a table mapping every event type to its schema def and example file
- compatibility notes for `ASCP Core Compatible`, `ASCP Interactive`, `ASCP Approval-Aware`, `ASCP Artifact-Aware`, and `ASCP Replay-Capable`
- notes for `connection.state_changed`, `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced`

- [ ] **Step 2: Replace the validator stub with full schema validation**

Update `scripts/validate_event_contracts.sh` to:

```python
import json
from pathlib import Path
import warnings

warnings.filterwarnings("ignore", category=DeprecationWarning)

from jsonschema import Draft202012Validator, RefResolver

root = Path.cwd()

def read_json(relative_path: str):
    return json.loads((root / relative_path).read_text())
```

Load these schemas into the resolver store:

```python
core_schema = read_json("schema/ascp-core.schema.json")
capabilities_schema = read_json("schema/ascp-capabilities.schema.json")
errors_schema = read_json("schema/ascp-errors.schema.json")
methods_schema = read_json("schema/ascp-methods.schema.json")
events_schema = read_json("schema/ascp-events.schema.json")
```

Validate each event fixture against its matching event definition, for example:

```python
events = [
    ("session-created", "SessionCreatedEvent"),
    ("message-assistant-delta", "MessageAssistantDeltaEvent"),
    ("approval-requested", "ApprovalRequestedEvent"),
    ("sync-snapshot", "SyncSnapshotEvent"),
    ("error-fatal", "ErrorFatalEvent"),
]
```

Expected behavior:

- the script exits non-zero on any schema failure
- the script prints the failing file and JSON path for each error
- the script prints the total number of validated event fixture files on success

- [ ] **Step 3: Run the validator to verify the green state**

Run: `./scripts/validate_event_contracts.sh`
Expected: PASS with the total number of validated event fixture files

- [ ] **Step 4: Commit docs plus final validator**

Run:

```bash
git add spec/events.md scripts/validate_event_contracts.sh
git commit -m "docs: define ASCP event support"
```

Expected: one commit adds the event spec and the full event validator

### Task 6: Checkpoint The Branch

**Files:**
- Modify: `plans.md`
- Modify: `docs/status.md`

- [ ] **Step 1: Mark all task rows done and add completion outcome in `plans.md`**

The completed plan must record:

```md
## Completion Outcome

- Status: complete on `feature/event-contracts`
- Validation evidence: `./scripts/validate_event_contracts.sh` completed successfully and validated 39 event example files
- Merge target: `main`
- Recommended next branch: `feature/replay-semantics`
- Recommended next scope:
  - cursor and replay resumption rules built on the frozen event contracts
  - sequence handling expectations and retention notes
  - replay conformance tests without reopening event payload shapes
```

- [ ] **Step 2: Add the status checkpoint entry**

Append this shape to `docs/status.md`:

```md
### 2026-04-22 - Event contracts

- Branch: `feature/event-contracts`
- Commit: `not committed`
- Summary: added the ASCP event-contract schema, one schema-valid `EventEnvelope` fixture for every core event type, a normative event support spec, and a repeatable validator that confirms the full event surface against the frozen schema foundation
- Documentation updated: `plans.md`, `docs/status.md`, `spec/events.md`, `docs/superpowers/specs/2026-04-22-event-contracts-design.md`, `docs/superpowers/plans/2026-04-22-event-contracts.md`
- Next likely step: build `feature/replay-semantics` from the locked event stream surface, without redefining event payload shapes
```

- [ ] **Step 3: Run the full verification set**

Run:

```bash
./scripts/validate_method_contracts.sh
./scripts/validate_event_contracts.sh
git status --short
```

Expected:

- method-contract validation still passes
- event-contract validation passes and reports 39 validated event fixture files
- git status shows only the intended branch files modified

- [ ] **Step 4: Commit the branch checkpoint**

Run:

```bash
git add plans.md docs/status.md docs/superpowers/plans/2026-04-22-event-contracts.md
git commit -m "docs: checkpoint event contracts branch"
```

Expected: one commit records the final branch plan state and status log
