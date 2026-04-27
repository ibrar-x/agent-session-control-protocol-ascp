# Auth And Approvals Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the normative ASCP auth and approvals document, auth- and approval-focused examples, and repeatable validation for scope expectations, approval lifecycle behavior, audit attribution hooks, and `UNAUTHORIZED` versus `FORBIDDEN` classification.

**Architecture:** Keep the frozen method and event contracts unchanged, then layer auth semantics in `spec/auth.md` plus approval-lifecycle and auth-failure fixtures under `examples/` and `conformance/fixtures/auth/`. Use a small Python-backed validator to assert branch-specific auth rules rather than inventing new protocol nouns or provider-specific auth objects.

**Tech Stack:** Markdown, JSON, Bash, `python3`, `jsonschema`, Git

---

### Task 1: Scope The Auth Branch In Repository State

**Files:**
- Modify: `plans.md`

- [ ] **Step 1: Rewrite the active feature block for `feature/auth-approvals`**

Set the active branch, source inputs, auth dependency gate, feature boundary, task list, and auth-specific acceptance criteria in `plans.md`.

- [ ] **Step 2: Verify the active block matches the auth branch**

Run: `sed -n '1,260p' plans.md`
Expected: the active feature is `Auth and approvals` on `feature/auth-approvals` and the next likely step points to `extensions` or `conformance`

### Task 2: Write The Failing Auth Validator First

**Files:**
- Create: `scripts/validate_auth_semantics.sh`
- Create: `conformance/tests/validate_auth_semantics.py`

- [ ] **Step 1: Add a validator that fails while auth assets are missing**

Create a shell entrypoint and Python validator that require `spec/auth.md`, the auth fixture files, and the auth example files to exist before deeper checks run.

- [ ] **Step 2: Run the validator and confirm the red state**

Run: `./scripts/validate_auth_semantics.sh`
Expected: FAIL with missing auth asset paths because `spec/auth.md` and the auth fixture/example files do not exist yet

### Task 3: Implement The Normative Auth Spec

**Files:**
- Create: `spec/auth.md`

- [ ] **Step 1: Document scope expectations and sensitive-method rules**

Write the normative auth spec covering recommended read and control scopes, capability-aligned expectations, and artifact/diff access guidance.

- [ ] **Step 2: Document approval lifecycle and attribution behavior**

Define approval state transitions, resolve and conflict behavior, `actor_id` requirements, and how `device_id` and `correlation_id` remain auditable without reopening frozen payload contracts.

### Task 4: Add Approval And Auth Examples

**Files:**
- Create: `examples/approvals/approval-request-command.json`
- Create: `examples/approvals/approval-flow-approved.json`
- Create: `examples/approvals/approval-flow-rejected.json`
- Create: `examples/approvals/approval-flow-expired.json`
- Create: `examples/errors/sessions-start-unauthorized.json`
- Create: `examples/errors/sessions-start-forbidden.json`
- Create: `examples/errors/sessions-list-unauthorized.json`
- Create: `examples/errors/approvals-respond-unauthorized.json`
- Create: `examples/errors/approvals-respond-forbidden.json`
- Create: `examples/errors/artifacts-get-unauthorized.json`

- [ ] **Step 1: Add approval examples for pending, approved, rejected, and expired flows**

Each approval flow fixture should bind a canonical `ApprovalRequest` to its related method request, method response, approval events, and audit expectations.

- [ ] **Step 2: Add auth failure examples for missing auth versus insufficient scope**

Add representative read and control method errors that show `UNAUTHORIZED` and `FORBIDDEN` as distinct outcomes.

### Task 5: Add Auth Conformance Fixtures

**Files:**
- Create: `conformance/fixtures/auth/auth-scope-matrix.json`
- Create: `conformance/fixtures/auth/approval-lifecycle.json`

- [ ] **Step 1: Encode the method scope matrix as fixture data**

Capture recommended scopes for discovery, read, control, approval, artifact, and diff methods in a validator-friendly fixture.

- [ ] **Step 2: Encode approval lifecycle invariants**

Record the allowed lifecycle transitions and the required attribution or conflict expectations for each outcome.

### Task 6: Make The Auth Validator Pass

**Files:**
- Modify: `conformance/tests/validate_auth_semantics.py`
- Modify: `scripts/validate_auth_semantics.sh`

- [ ] **Step 1: Validate auth fixture structure and auth-specific invariants**

Assert method scope coverage, schema-valid approval flows, allowed error-code classification, and required approval attribution.

- [ ] **Step 2: Run auth validation to green**

Run: `./scripts/validate_auth_semantics.sh`
Expected: PASS with a summary of the validated auth fixtures

### Task 7: Checkpoint The Branch

**Files:**
- Modify: `docs/status.md`
- Modify: `plans.md`

- [ ] **Step 1: Mark the auth tasks complete in `plans.md`**

Update task status rows and completion outcome after validation passes.

- [ ] **Step 2: Add an auth-and-approvals checkpoint entry**

Record the branch name, summary, documentation updated, and next likely step in `docs/status.md`.
