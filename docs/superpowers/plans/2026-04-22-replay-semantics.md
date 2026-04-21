# Replay Semantics Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the normative ASCP replay semantics document, replay-oriented conformance fixtures, and repeatable validation for reconnect flow, ordering, snapshot boundaries, cursor handling, and retention-limited fallback behavior.

**Architecture:** Keep the frozen method and event contracts unchanged, then layer replay semantics in `spec/replay.md` plus ordered fixture streams under `conformance/fixtures/replay/`. Use a small Python-backed validator to assert branch-specific replay rules rather than inventing new protocol nouns.

**Tech Stack:** Markdown, JSON, Bash, `python3`, `jsonschema`, Git

---

### Task 1: Scope The Replay Branch In Repository State

**Files:**
- Modify: `plans.md`

- [ ] **Step 1: Rewrite the active feature block for `feature/replay-semantics`**

Set the active branch, source inputs, replay dependency gate, feature boundary, task list, and replay-specific acceptance criteria in `plans.md`.

- [ ] **Step 2: Verify the active block matches the replay branch**

Run: `sed -n '1,260p' plans.md`
Expected: the active feature is `Replay semantics` on `feature/replay-semantics` and the next likely step no longer points back to replay work from the previous branch

### Task 2: Write The Failing Replay Validator First

**Files:**
- Create: `scripts/validate_replay_semantics.sh`
- Create: `conformance/tests/validate_replay_semantics.py`

- [ ] **Step 1: Add a validator that fails while replay assets are missing**

Create a shell entrypoint and Python validator that require `spec/replay.md` and the replay fixture files to exist before deeper checks run.

- [ ] **Step 2: Run the validator and confirm the red state**

Run: `./scripts/validate_replay_semantics.sh`
Expected: FAIL with missing replay asset paths because `spec/replay.md` and the replay fixtures do not exist yet

### Task 3: Implement The Normative Replay Spec

**Files:**
- Create: `spec/replay.md`

- [ ] **Step 1: Document reconnect flow, ordering guarantees, and snapshot boundaries**

Write the normative replay spec covering subscribe or resume flow, `sync.snapshot`, `sync.replayed`, and live continuation boundaries.

- [ ] **Step 2: Document cursor and retention behavior**

Define the expected interpretation of `from_seq`, `from_event_id`, and opaque cursors, plus the allowed replay-limited fallback outcomes.

### Task 4: Add Replay Conformance Fixtures

**Files:**
- Create: `conformance/fixtures/replay/subscribe-with-snapshot.json`
- Create: `conformance/fixtures/replay/subscribe-from-seq.json`
- Create: `conformance/fixtures/replay/subscribe-from-event-id.json`
- Create: `conformance/fixtures/replay/subscribe-with-opaque-cursor.json`
- Create: `conformance/fixtures/replay/replay-retention-fallback.json`

- [ ] **Step 1: Add success fixtures for the supported replay paths**

Each success fixture should include request metadata, ordered event envelopes, replay boundary expectations, and expected live continuation.

- [ ] **Step 2: Add a retention-limited fallback fixture**

Model the allowed outcomes when the requested replay window is no longer available without inventing storage policy details.

### Task 5: Make The Replay Validator Pass

**Files:**
- Modify: `conformance/tests/validate_replay_semantics.py`
- Modify: `scripts/validate_replay_semantics.sh`

- [ ] **Step 1: Validate replay fixture structure and replay-specific invariants**

Assert ordered `seq`, monotonic replay segments, valid replay markers, legal cursor metadata, and retention fallback rules.

- [ ] **Step 2: Run replay validation to green**

Run: `./scripts/validate_replay_semantics.sh`
Expected: PASS with a summary of the validated replay fixtures

### Task 6: Checkpoint The Branch

**Files:**
- Modify: `docs/status.md`
- Modify: `plans.md`

- [ ] **Step 1: Mark the replay tasks complete in `plans.md`**

Update task status rows and completion outcome after validation passes.

- [ ] **Step 2: Add a replay-semantics checkpoint entry**

Record the branch name, summary, documentation updated, and next likely step in `docs/status.md`.
