# Extensions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the normative ASCP extension rules, namespaced extension examples, ignore-safe fixtures, and repeatable validation for additive extension behavior without reopening frozen core contracts.

**Architecture:** Keep the frozen method and event contracts unchanged, then layer extension semantics in `spec/extensions.md` plus focused examples under `examples/` and declarative fixtures under `conformance/fixtures/extensions/`. Use a Python-backed validator to prove namespacing, capability advertisement, ignore-safe handling, and the open-versus-closed schema boundary rather than inventing new core schema shapes.

**Tech Stack:** Markdown, JSON, Bash, `python3`, `jsonschema`, Git

---

### Task 1: Scope The Extensions Branch In Repository State

**Files:**
- Modify: `plans.md`

- [ ] **Step 1: Rewrite the active feature block for `feature/extensions`**

Set the active branch, source inputs, dependency gate, feature boundary, task list, and extension-specific acceptance criteria in `plans.md`.

- [ ] **Step 2: Verify the active block matches the extensions branch**

Run: `sed -n '1,260p' plans.md`
Expected: the active feature is `Extensions` on `feature/extensions` and the next likely step points to `conformance` or `mock-server`

### Task 2: Write The Failing Extension Validator First

**Files:**
- Create: `scripts/validate_extension_semantics.sh`
- Create: `conformance/tests/validate_extension_semantics.py`

- [ ] **Step 1: Add a validator that fails while extension assets are missing**

Create a shell entrypoint and Python validator that require `spec/extensions.md`, the extension example files, and the extension fixture files to exist before deeper checks run.

- [ ] **Step 2: Run the validator and confirm the red state**

Run: `./scripts/validate_extension_semantics.sh`
Expected: FAIL with missing extension asset paths because `spec/extensions.md` and the extension fixture/example files do not exist yet

### Task 3: Implement The Normative Extension Spec

**Files:**
- Create: `spec/extensions.md`

- [ ] **Step 1: Document extension rules and namespacing**

Write the normative extension spec covering allowed extension surfaces, namespaced methods, namespaced events, namespaced additive fields, and capability advertisement.

- [ ] **Step 2: Document ignore-safe behavior and schema boundaries**

Define unknown extension handling, the closed-versus-open schema rule, and how closed core param and payload schemas require new namespaced methods or events instead of inline extra fields.

### Task 4: Add Extension Examples

**Files:**
- Create: `examples/capabilities/capabilities-with-extensions.json`
- Create: `examples/extensions/method-request.json`
- Create: `examples/extensions/method-response.json`
- Create: `examples/extensions/event-envelope.json`
- Create: `examples/extensions/session-field-extension.json`

- [ ] **Step 1: Add namespaced method, event, and capability examples**

Create schema-valid examples for extension capability advertisement, a namespaced method request and success response, and a namespaced event envelope.

- [ ] **Step 2: Add additive field examples on open core surfaces**

Create a schema-valid core object example that shows namespaced additive fields without redefining core meaning.

### Task 5: Add Extension Conformance Fixtures

**Files:**
- Create: `conformance/fixtures/extensions/extension-catalog.json`
- Create: `conformance/fixtures/extensions/ignore-behavior.json`

- [ ] **Step 1: Encode the extension surfaces and namespacing rules as fixture data**

Capture the allowed extension surfaces, example file coverage, and required namespacing patterns in a validator-friendly fixture.

- [ ] **Step 2: Encode ignore-safe behavior and closed-schema expectations**

Record the expected behavior for unknown extension fields, unknown namespaced events, capability discovery, and closed core param objects.

### Task 6: Make The Extension Validator Pass

**Files:**
- Modify: `conformance/tests/validate_extension_semantics.py`
- Modify: `scripts/validate_extension_semantics.sh`

- [ ] **Step 1: Validate extension fixture structure and extension-specific invariants**

Assert spec coverage, namespaced prefixes, schema-valid capability and envelope examples, open-surface field extensions, and ignore-behavior rules.

- [ ] **Step 2: Run extension validation to green**

Run: `./scripts/validate_extension_semantics.sh`
Expected: PASS with a summary of the validated extension fixtures

### Task 7: Checkpoint The Branch

**Files:**
- Modify: `docs/status.md`
- Modify: `plans.md`

- [ ] **Step 1: Mark the extension tasks complete in `plans.md`**

Update task status rows and completion outcome after validation passes.

- [ ] **Step 2: Add an extensions checkpoint entry**

Record the branch name, summary, documentation updated, and next likely step in `docs/status.md`.
