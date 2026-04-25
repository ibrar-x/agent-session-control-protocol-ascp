# Codex Adapter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a truthful downstream Codex runtime adapter for ASCP that proves the frozen v0.1 session-control surface can map onto a real runtime without collapsing into raw PTY passthrough.

**Architecture:** Build the adapter under `adapters/codex/` as a focused Python package that separates runtime discovery, ASCP ID generation, session and event mapping, method handlers, approval handling, and integration validation. Treat the frozen ASCP specs, examples, conformance assets, and the Codex adapter brief as authoritative inputs, and advertise unsupported capabilities as `false` rather than synthesizing protocol behavior.

**Tech Stack:** Python 3, Markdown, JSON, Bash, Git

---

### Task 1: Scope The Adapter Branch In Repository State

**Files:**
- Modify: `plans.md`

- [ ] **Step 1: Rewrite the active feature block for `feature/codex-adapter`**

Set the active branch, source inputs, adapter dependency gate, feature boundary, task list, and acceptance criteria in `plans.md`.

- [ ] **Step 2: Verify the active block matches the adapter branch**

Run: `sed -n '1,260p' plans.md`
Expected: the active feature is `Codex adapter` on `feature/codex-adapter` and the next likely step points to adapter implementation follow-through rather than protocol-core work

### Task 2: Scaffold The Adapter Package And Red-State Validator

**Files:**
- Create: `adapters/codex/README.md`
- Create: `adapters/codex/src/codex_adapter/__init__.py`
- Create: `adapters/codex/tests/__init__.py`
- Create: `adapters/codex/tests/validate_codex_adapter.py`
- Create: `scripts/validate_codex_adapter.sh`

- [ ] **Step 1: Create the adapter directory layout and package entrypoints**

Add the top-level adapter README, the Python package root, a test package marker, and a shell validator entrypoint that future tasks can extend.

- [ ] **Step 2: Add a validator that fails while core adapter assets are missing**

Make `validate_codex_adapter.py` require the planned discovery, mapping, service, and test files to exist before deeper checks run.

- [ ] **Step 3: Run the validator and confirm the red state**

Run: `./scripts/validate_codex_adapter.sh`
Expected: FAIL with missing adapter asset paths because the runtime-discovery, mapping, and method files do not exist yet

### Task 3: Implement Runtime Discovery And Truthful Capability Resolution

**Files:**
- Create: `adapters/codex/src/codex_adapter/discovery.py`
- Create: `adapters/codex/src/codex_adapter/capabilities.py`
- Create: `adapters/codex/tests/test_discovery.py`
- Create: `adapters/codex/tests/test_capabilities.py`

- [ ] **Step 1: Add failing tests for runtime detection and capability truthfulness**

Cover runtime-availability detection, version extraction, and capability fallback when replay, approvals, artifacts, or diffs cannot be observed safely enough to claim support.

- [ ] **Step 2: Implement Codex runtime probing**

Detect whether the local Codex runtime surface needed by the adapter is available, capture version or endpoint identity where possible, and return explicit discovery results instead of implicit global state.

- [ ] **Step 3: Implement capability resolution**

Map discovery findings into a truthful ASCP capability document, ensuring unsupported or ambiguous capabilities resolve to `false`.

- [ ] **Step 4: Run the focused discovery tests**

Run: `python3 -m pytest adapters/codex/tests/test_discovery.py adapters/codex/tests/test_capabilities.py -q`
Expected: PASS with coverage of runtime detection and truthful capability behavior

### Task 4: Implement Stable ASCP ID Generation And Session Mapping

**Files:**
- Create: `adapters/codex/src/codex_adapter/ids.py`
- Create: `adapters/codex/src/codex_adapter/session_mapper.py`
- Create: `adapters/codex/tests/test_ids.py`
- Create: `adapters/codex/tests/test_session_mapper.py`

- [ ] **Step 1: Add failing tests for runtime, session, run, and approval IDs**

Cover the recommended formats from the Codex adapter brief:
- `runtime_id = codex_local`
- `session_id = codex:<thread_id>`
- `run_id = codex:<thread_id>:<turn_id>`
- `approval_id = codex:<approval_id>`

- [ ] **Step 2: Add failing tests for session and run normalization**

Cover mapping from Codex thread state into ASCP `Session` and `Run` objects, preserving exact ASCP field names and defaulting unknown-but-required data honestly.

- [ ] **Step 3: Implement ID helpers and session mapping**

Build the helper functions that normalize Codex runtime objects into ASCP IDs, `Session`, and `Run` outputs without embedding transport or method logic.

- [ ] **Step 4: Run the focused mapping tests**

Run: `python3 -m pytest adapters/codex/tests/test_ids.py adapters/codex/tests/test_session_mapper.py -q`
Expected: PASS with deterministic IDs and stable session mapping

### Task 5: Implement The Session Method Surface

**Files:**
- Create: `adapters/codex/src/codex_adapter/service.py`
- Create: `adapters/codex/src/codex_adapter/runtime_client.py`
- Create: `adapters/codex/tests/test_service_sessions.py`

- [ ] **Step 1: Add failing tests for `sessions.list`, `sessions.get`, and `sessions.resume`**

Cover successful responses, `NOT_FOUND`, and honest behavior when resume or listing data is unavailable from the runtime.

- [ ] **Step 2: Implement a minimal runtime client seam**

Create a small runtime-facing abstraction that isolates Codex-specific session reads from ASCP method-response shaping.

- [ ] **Step 3: Implement the ASCP session methods**

Return ASCP-shaped method results for listing, reading, and resuming sessions while preserving frozen field names and protocol error expectations.

- [ ] **Step 4: Run the focused session-method tests**

Run: `python3 -m pytest adapters/codex/tests/test_service_sessions.py -q`
Expected: PASS with ASCP-shaped session results and explicit error behavior

### Task 6: Implement Input Sending, Event Streaming, And Event Normalization

**Files:**
- Create: `adapters/codex/src/codex_adapter/events.py`
- Create: `adapters/codex/src/codex_adapter/subscription.py`
- Create: `adapters/codex/tests/test_events.py`
- Create: `adapters/codex/tests/test_subscription.py`

- [ ] **Step 1: Add failing tests for `sessions.send_input` and `sessions.subscribe`**

Cover input forwarding, subscription acceptance, and event-stream behavior.

- [ ] **Step 2: Add failing tests for event normalization**

Cover at minimum:
- assistant incremental output -> `message.assistant.delta`
- assistant completion -> `message.assistant.completed`
- active execution starts -> `run.started`
- active execution ends -> `run.completed` or `run.failed`
- tool activity -> `tool.started` and `tool.completed`

- [ ] **Step 3: Implement event mapping and subscription handling**

Normalize observable Codex runtime events into exact ASCP `EventEnvelope` objects, preserving any unmapped runtime detail inside extension-safe metadata rather than changing core meanings.

- [ ] **Step 4: Implement input sending on top of the runtime client seam**

Forward user input to Codex through the runtime client and shape the ASCP method result without turning the adapter into a product-specific conversation layer.

- [ ] **Step 5: Run the focused event and subscription tests**

Run: `python3 -m pytest adapters/codex/tests/test_events.py adapters/codex/tests/test_subscription.py -q`
Expected: PASS with normalized ASCP event envelopes and stable subscription behavior

### Task 7: Implement Approval Mapping And Approval Methods

**Files:**
- Create: `adapters/codex/src/codex_adapter/approvals.py`
- Create: `adapters/codex/tests/test_approvals.py`

- [ ] **Step 1: Add failing tests for approval request mapping and `approvals.respond`**

Cover pending approval mapping, approval lifecycle events, successful response handling, and honest capability fallback when Codex approval surfaces are absent.

- [ ] **Step 2: Implement approval normalization**

Map Codex approval gates into ASCP `ApprovalRequest` objects and approval lifecycle events without redefining the upstream approval semantics.

- [ ] **Step 3: Implement `approvals.list` and `approvals.respond`**

Return ASCP-shaped method results, error handling, and lifecycle behavior for approvals.

- [ ] **Step 4: Run the focused approval tests**

Run: `python3 -m pytest adapters/codex/tests/test_approvals.py -q`
Expected: PASS with truthful approval behavior and ASCP-shaped method results

### Task 8: Add Best-Effort Artifact And Diff Mapping With Honest Fallback

**Files:**
- Create: `adapters/codex/src/codex_adapter/artifacts.py`
- Create: `adapters/codex/tests/test_artifacts.py`

- [ ] **Step 1: Add failing tests for artifact and diff capability fallback**

Cover the case where Codex cannot provide artifact or diff data reliably enough to claim support.

- [ ] **Step 2: Add failing tests for best-effort artifact and diff mapping**

If Codex exposes usable artifact or patch outputs, cover mapping into ASCP `Artifact` and `DiffSummary` objects without requiring perfect reconstruction.

- [ ] **Step 3: Implement truthful artifact and diff behavior**

Map artifacts and diffs when evidence is reliable; otherwise return unsupported capability flags and protocol-consistent errors rather than fabricating outputs.

- [ ] **Step 4: Run the focused artifact tests**

Run: `python3 -m pytest adapters/codex/tests/test_artifacts.py -q`
Expected: PASS with truthful support and fallback behavior

### Task 9: Document The Adapter And Make The Validator Green

**Files:**
- Modify: `adapters/codex/README.md`
- Modify: `adapters/codex/tests/validate_codex_adapter.py`
- Modify: `scripts/validate_codex_adapter.sh`

- [ ] **Step 1: Document adapter scope, runtime assumptions, validation commands, and limits**

Explain what the adapter supports, what it intentionally does not support yet, how capabilities are advertised truthfully, and how to run its tests.

- [ ] **Step 2: Extend the validator to check the finished adapter shape**

Validate required adapter files, focused test coverage, and the presence of adapter documentation and validation commands.

- [ ] **Step 3: Run the adapter validator to green**

Run: `./scripts/validate_codex_adapter.sh`
Expected: PASS with a summary of validated adapter assets

### Task 10: Checkpoint The Branch

**Files:**
- Modify: `docs/status.md`
- Modify: `plans.md`

- [ ] **Step 1: Mark the adapter tasks complete in `plans.md`**

Update task status rows and completion outcome after the adapter tests and validator pass.

- [ ] **Step 2: Add a Codex-adapter checkpoint entry**

Record the branch name, summary, documentation updated, and next likely step in `docs/status.md`.
