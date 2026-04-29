# Mobile Companion App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a phone-first ASCP companion app that handles host pairing, trusted-device onboarding, session control, approvals, and lightweight inspection through a reusable shadcn-style design system.

**Architecture:** Keep pairing, session browsing, approvals, inspection, and settings as separate mobile workspaces so each screen owns one job. Build the UI on top of small state helpers and a shared design system layer, then connect those pieces to the existing daemon pairing backend and ASCP session APIs without mixing trust onboarding into session detail logic.

**Tech Stack:** React, TypeScript, mobile-friendly CSS, shadcn-style UI primitives, browser `fetch` or the existing ASCP client where appropriate, Vitest.

---

## File Structure

- `apps/mobile/src/app.tsx`
  - top-level shell, navigation, and route/workspace orchestration.
- `apps/mobile/src/design-tokens.ts`
  - color, spacing, typography, and motion tokens for the mobile system.
- `apps/mobile/src/ui/`
  - app-shell primitives and reusable mobile components built from shadcn-style patterns.
- `apps/mobile/src/pairing/`
  - pairing flow state, claim polling, and trust onboarding helpers.
- `apps/mobile/src/sessions/`
  - session list, session detail, timeline, and composer state.
- `apps/mobile/src/approvals/`
  - approval queue state and action helpers.
- `apps/mobile/src/inspect/`
  - artifact and diff summary helpers.
- `apps/mobile/src/settings/`
  - trusted devices, revoke flow, and transport status helpers.
- `apps/mobile/README.md`
  - mobile app usage, pairing instructions, and design-system notes.
- `internal/prompts/mobile-companion.md`
  - starter prompt for future implementation agents.

---

### Task 1: Define the mobile shell and design system foundation

**Files:**
- Create: `apps/mobile/src/design-tokens.ts`
- Create: `apps/mobile/src/ui/AppShell.tsx`
- Create: `apps/mobile/src/ui/StatusBadge.tsx`
- Create: `apps/mobile/src/ui/MetricCard.tsx`
- Create: `apps/mobile/src/ui/EmptyState.tsx`
- Create: `apps/mobile/src/ui/CodeBlock.tsx`
- Create: `apps/mobile/src/ui/ActionSheet.tsx`

- [ ] **Step 1: Write the failing tests for the shell primitives and token exports**

```ts
import { describe, expect, it } from "vitest";

import { appTokens } from "./design-tokens";

describe("mobile design tokens", () => {
  it("defines a dark technical color system with primary and state accents", () => {
    expect(appTokens.color.surface).toBeTruthy();
    expect(appTokens.color.primary).toBeTruthy();
    expect(appTokens.color.success).toBeTruthy();
    expect(appTokens.color.warning).toBeTruthy();
    expect(appTokens.color.destructive).toBeTruthy();
  });
});
```

- [ ] **Step 2: Run the test and verify it fails**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/design-tokens.test.ts`
Expected: FAIL because the mobile app and token module do not exist yet.

- [ ] **Step 3: Implement the shell primitives and token map**

Use shadcn-style `Card`, `Sheet`, `Dialog`, `Tabs`, `Button`, `Badge`, `Separator`, `Skeleton`, `Input`, and `Textarea` patterns as the base.

- [ ] **Step 4: Re-run the focused test**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/design-tokens.test.ts`
Expected: PASS.

### Task 2: Build pairing and trust onboarding

**Files:**
- Create: `apps/mobile/src/pairing/types.ts`
- Create: `apps/mobile/src/pairing/api.ts`
- Create: `apps/mobile/src/pairing/model.ts`
- Create: `apps/mobile/src/pairing/model.test.ts`
- Create: `apps/mobile/src/pairing/PairingScreen.tsx`

- [ ] **Step 1: Write the failing pairing tests**

```ts
import { describe, expect, it } from "vitest";

import { derivePairingStep, createPairingState } from "./model";

describe("pairing model", () => {
  it("keeps QR/code claim and host approval as distinct steps", () => {
    expect(derivePairingStep({ status: "pending_claim" })).toBe("claiming");
    expect(derivePairingStep({ status: "pending_host_approval" })).toBe("waiting_approval");
    expect(derivePairingStep({ status: "approved" })).toBe("trusted");
  });

  it("creates a clean onboarding state", () => {
    expect(createPairingState()).toEqual({
      step: "idle",
      error: null,
      host: null,
      claim: null,
      trust: null
    });
  });
});
```

- [ ] **Step 2: Run the pairing test and confirm it fails**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/pairing/model.test.ts`
Expected: FAIL.

- [ ] **Step 3: Implement pairing claim, polling, and secure trust state**

The pairing layer should:

- support QR and manual code entry
- poll until approved, rejected, expired, or consumed
- store the raw secret only after approval
- surface trust confirmation before entering the main shell

- [ ] **Step 4: Re-run the pairing test**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/pairing/model.test.ts`
Expected: PASS.

### Task 3: Build sessions, approvals, and inspection workspaces

**Files:**
- Create: `apps/mobile/src/sessions/types.ts`
- Create: `apps/mobile/src/sessions/model.ts`
- Create: `apps/mobile/src/sessions/SessionListScreen.tsx`
- Create: `apps/mobile/src/sessions/SessionDetailScreen.tsx`
- Create: `apps/mobile/src/sessions/Timeline.tsx`
- Create: `apps/mobile/src/sessions/Composer.tsx`
- Create: `apps/mobile/src/approvals/model.ts`
- Create: `apps/mobile/src/approvals/ApprovalsScreen.tsx`
- Create: `apps/mobile/src/inspect/model.ts`
- Create: `apps/mobile/src/inspect/InspectScreen.tsx`

- [ ] **Step 1: Write failing tests for session and approval derivation**

```ts
import { describe, expect, it } from "vitest";

import { derivePendingApprovals, createSessionViewState } from "./model";

describe("session and approval models", () => {
  it("derives pending approvals from session data", () => {
    expect(derivePendingApprovals([
      { id: "s1", approvalStatus: "pending" },
      { id: "s2", approvalStatus: "approved" }
    ])).toEqual([{ id: "s1", approvalStatus: "pending" }]);
  });

  it("creates a loading session detail state", () => {
    expect(createSessionViewState("s1").mode).toBe("loading");
  });
});
```

- [ ] **Step 2: Run the tests and verify they fail**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/sessions/model.test.ts`
Expected: FAIL.

- [ ] **Step 3: Implement the session, approval, and inspect screens**

Requirements:

- the session detail screen must keep the transcript central
- approvals must be actionable from a fast queue
- inspect views should remain compact and expandable
- answered items should collapse into history rather than disappear

- [ ] **Step 4: Re-run the focused tests**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/sessions/model.test.ts`
Expected: PASS.

### Task 4: Wire navigation, responsive layout, and error handling

**Files:**
- Modify: `apps/mobile/src/app.tsx`
- Modify: `apps/mobile/src/ui/AppShell.tsx`
- Modify: `apps/mobile/src/ui/ActionSheet.tsx`
- Modify: `apps/mobile/src/ui/EmptyState.tsx`
- Modify: `apps/mobile/src/styles.css`

- [ ] **Step 1: Write a failing navigation test for preserved tab and session state**

```ts
import { describe, expect, it } from "vitest";

import { createNavigationState } from "./app";

describe("mobile navigation", () => {
  it("preserves the current tab and last selected session", () => {
    expect(createNavigationState()).toEqual({
      activeTab: "home",
      lastSessionId: null
    });
  });
});
```

- [ ] **Step 2: Run the test and verify it fails**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/app.test.ts`
Expected: FAIL.

- [ ] **Step 3: Implement the app shell and responsive mobile layout**

Use bottom nav, safe-area spacing, and sheet-based actions for mobile ergonomics.

- [ ] **Step 4: Re-run the navigation test**

Run: `npm --workspace @ascp/app-mobile exec vitest run src/app.test.ts`
Expected: PASS.

### Task 5: Document the mobile companion app and starter prompt

**Files:**
- Create: `apps/mobile/README.md`
- Create: `internal/prompts/mobile-companion.md`

- [ ] **Step 1: Write the mobile usage and prompt documents**

The README should explain how to pair, where the trust state lives, and how the main mobile surfaces map to the daemon backend.

The prompt should tell future agents to read the repo bootstrap files, then implement the mobile design system first, then pairing, then sessions and approvals.

- [ ] **Step 2: Review the files for placeholder text and scope drift**

Check for:

- `TBD`
- `TODO`
- missing file paths
- unsupported protocol claims

- [ ] **Step 3: Commit the documentation slice**

```bash
git add apps/mobile/src internal/prompts/mobile-companion.md apps/mobile/README.md docs/superpowers/specs/2026-04-28-mobile-companion-design.md docs/superpowers/plans/2026-04-28-mobile-companion.md
git commit -m "docs: add mobile companion design and plan"
```

---

## Execution Notes

- build the design system before feature screens so the mobile app stays visually consistent
- keep trust onboarding separate from session browsing
- use shadcn-style components as the starting point, then refine them for a compact phone layout
- prefer small, testable helpers for state derivation and filtering
- keep destructive and trust-sensitive actions behind explicit confirmations
