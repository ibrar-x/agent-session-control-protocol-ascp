# Host Console Chat Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `apps/host-console` into a chat-first multi-session demo with a layered operator rail that proves the live ASCP flow end to end.

**Architecture:** Split the current one-file console into a small set of UI components plus a selected-session controller/model layer. Put loading, `live`, `snapshot-only`, and interaction-history rules into pure TypeScript helpers first, then build the React surface on top of that shared state so the chat pane and operator rail cannot drift.

**Tech Stack:** React, TypeScript, Vite, CSS, Vitest, existing ASCP TypeScript browser transport/client.

---

### Task 1: Add host-console test harness and state helpers

**Files:**
- Modify: `apps/host-console/package.json`
- Create: `apps/host-console/vitest.config.ts`
- Create: `apps/host-console/src/model.ts`
- Create: `apps/host-console/src/model.test.ts`

- [ ] **Step 1: Write the failing tests for selected-session state and timeline interaction behavior**

```ts
import { describe, expect, it } from "vitest";

import {
  buildInteractionTimelineItems,
  createLoadingSessionView,
  createSnapshotOnlySessionView
} from "./model";

describe("host-console model", () => {
  it("clears stale session detail immediately on session switch", () => {
    expect(createLoadingSessionView("codex:next-session")).toEqual({
      sessionId: "codex:next-session",
      mode: "loading",
      session: null,
      runs: [],
      currentRun: null,
      approvals: [],
      inputs: [],
      artifacts: [],
      artifactDetail: null,
      diff: null,
      events: []
    });
  });

  it("marks snapshot-only mode when live attach fails after snapshot load", () => {
    const view = createSnapshotOnlySessionView({
      sessionId: "codex:session_1",
      pausedReason: "subscribe_failed"
    });

    expect(view.mode).toBe("snapshot-only");
    expect(view.livePausedReason).toBe("subscribe_failed");
  });

  it("keeps answered interaction cards inline in the timeline", () => {
    const items = buildInteractionTimelineItems({
      approvals: [
        {
          id: "codex:approval_1",
          session_id: "codex:session_1",
          kind: "command",
          status: "approved",
          title: "Approve command",
          risk_level: "medium",
          payload: {},
          created_at: "2026-04-27T12:00:00.000Z",
          resolved_at: "2026-04-27T12:01:00.000Z"
        }
      ],
      inputs: []
    });

    expect(items).toEqual([
      expect.objectContaining({
        kind: "approval",
        state: "answered"
      })
    ]);
  });
});
```

- [ ] **Step 2: Run the new test file and verify it fails**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/model.test.ts`
Expected: FAIL because the model helpers do not exist yet

- [ ] **Step 3: Add the minimal model helpers and Vitest wiring**

```ts
export type SessionViewMode = "loading" | "live" | "snapshot-only" | "error";

export interface SessionViewState {
  sessionId: string;
  mode: SessionViewMode;
  session: unknown | null;
  runs: unknown[];
  currentRun: unknown | null;
  approvals: unknown[];
  inputs: unknown[];
  artifacts: unknown[];
  artifactDetail: unknown | null;
  diff: unknown | null;
  events: unknown[];
  livePausedReason?: "subscribe_failed" | "subscription_dropped";
}

export function createLoadingSessionView(sessionId: string): SessionViewState {
  return {
    sessionId,
    mode: "loading",
    session: null,
    runs: [],
    currentRun: null,
    approvals: [],
    inputs: [],
    artifacts: [],
    artifactDetail: null,
    diff: null,
    events: []
  };
}

export function createSnapshotOnlySessionView(options: {
  sessionId: string;
  pausedReason: "subscribe_failed" | "subscription_dropped";
}): SessionViewState {
  return {
    ...createLoadingSessionView(options.sessionId),
    mode: "snapshot-only",
    livePausedReason: options.pausedReason
  };
}
```

- [ ] **Step 4: Re-run the focused test**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/model.test.ts`
Expected: PASS

### Task 2: Normalize selected-session state and lazy secondary loading in `App`

**Files:**
- Modify: `apps/host-console/src/App.tsx`
- Modify: `apps/host-console/src/model.ts`
- Modify: `apps/host-console/src/model.test.ts`

- [ ] **Step 1: Add a failing model test for lazy secondary detail triggers**

```ts
it("keeps artifact and diff detail unloaded until the rail section is explicitly opened", () => {
  const view = hydrateSessionSnapshot({
    sessionId: "codex:session_1",
    session: { id: "codex:session_1", status: "idle" },
    runs: [],
    approvals: [],
    inputs: []
  });

  expect(view.artifacts).toEqual([]);
  expect(view.diff).toBeNull();
  expect(view.secondaryState.artifactsRequested).toBe(false);
  expect(view.secondaryState.diffRequested).toBe(false);
});
```

- [ ] **Step 2: Run the focused test and verify it fails**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/model.test.ts`
Expected: FAIL because `hydrateSessionSnapshot` and `secondaryState` do not exist yet

- [ ] **Step 3: Implement normalized selected-session state and wire it into `App.tsx`**

Code goals:
- replace the scattered `selectedSession`, `runs`, `approvals`, `artifacts`, `artifactDetail`, `diff` state with one selected-session state object
- clear that state immediately on session switch
- load `include_pending_inputs: true` along with runs and approvals
- set `mode: "snapshot-only"` when subscribe fails after snapshot
- only call `listArtifacts` or `getDiff` from explicit rail expansion handlers

- [ ] **Step 4: Re-run the focused test**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/model.test.ts`
Expected: PASS

### Task 3: Split the UI into chat-first components

**Files:**
- Modify: `apps/host-console/src/App.tsx`
- Create: `apps/host-console/src/components/SessionSwitcher.tsx`
- Create: `apps/host-console/src/components/ChatPane.tsx`
- Create: `apps/host-console/src/components/OperatorRail.tsx`
- Create: `apps/host-console/src/components/JsonDisclosure.tsx`

- [ ] **Step 1: Add a failing component test for the paused-live banner behavior**

```ts
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { OperatorRail } from "./components/OperatorRail";

describe("OperatorRail", () => {
  it("shows a visible paused banner only in snapshot-only mode", () => {
    render(
      <OperatorRail
        mode="snapshot-only"
        session={null}
        currentRun={null}
        approvals={[]}
        inputs={[]}
        events={[]}
        onRetryLive={() => {}}
      />
    );

    expect(screen.getByText(/live updates paused/i)).toBeInTheDocument();
  });
});
```

- [ ] **Step 2: Add test dependencies and run the focused test to watch it fail**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/components/OperatorRail.test.tsx`
Expected: FAIL because the component and test stack are not wired yet

- [ ] **Step 3: Implement the split UI**

Component responsibilities:
- `SessionSwitcher.tsx`: multi-session list with status and blocked badges
- `ChatPane.tsx`: header, timeline, composer, inline approval/input cards
- `OperatorRail.tsx`: ordered compact cards, quiet healthy live state, loud degraded banner only when needed
- `JsonDisclosure.tsx`: consistent expandable JSON section pattern

`App.tsx` should become orchestration only.

- [ ] **Step 4: Run the focused component test**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/components/OperatorRail.test.tsx`
Expected: PASS

### Task 4: Style the app as a believable operator chat demo

**Files:**
- Modify: `apps/host-console/src/styles.css`
- Modify: `apps/host-console/src/components/ChatPane.tsx`
- Modify: `apps/host-console/src/components/OperatorRail.tsx`
- Modify: `apps/host-console/src/components/SessionSwitcher.tsx`

- [ ] **Step 1: Write the failing visual acceptance checklist in the plan and use browser validation after implementation**

Checklist:
- chat is the dominant pane
- interaction cards are left-anchored and distinct from assistant bubbles
- answered interaction cards stay inline in compact form
- healthy live state is visually quiet
- degraded live state expands into a clear banner
- rail card order is summary, current run, pending interactions, artifacts/diffs, events, raw detail

- [ ] **Step 2: Implement the visual system in CSS**

Style goals:
- three-zone desktop layout
- mobile collapse without breaking session switching
- intentional typography and spacing
- subtle state accents for approval/input cards
- compact operator rail cards with expandable detail

- [ ] **Step 3: Build the app**

Run: `npm --workspace @ascp/app-host-console run build`
Expected: PASS

### Task 5: Live validate and document the refreshed demo

**Files:**
- Modify: `apps/host-console/README.md`
- Modify: `docs/status.md`

- [ ] **Step 1: Validate in the browser against the live local stack**

Run:
- `npm --workspace @ascp/adapter-codex run host`
- `npm --workspace @ascp/app-host-console run dev`

Verify:
- multiple session switching blanks stale detail immediately
- blocked approvals/inputs render inline in chat when present
- paused-live banner appears only when subscription is degraded
- artifacts/diffs load from explicit rail expansion, not from initial session selection

- [ ] **Step 2: Update docs**

Update `apps/host-console/README.md` to explain:
- the new chat-first layout
- inline interaction cards
- layered rail behavior
- snapshot-only degraded mode

Add a `docs/status.md` checkpoint describing:
- branch
- commit
- demo refresh outcome
- next likely step

- [ ] **Step 3: Run final verification**

Run:
- `npm --workspace @ascp/app-host-console run build`
- `npm --workspace @ascp/adapter-codex run check`

Expected: PASS
