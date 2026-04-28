# Host Pairing UI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a host-side pairing/admin workspace to `apps/host-console` that can create pairing sessions, surface pending approvals, and manage trusted devices against the existing daemon pairing backend.

**Architecture:** Keep the current session chat workspace intact and add a second top-level `Pairing` workspace in the same app shell. Implement pairing as a separate frontend state boundary under `apps/host-console/src/pairing/`, backed by a small loopback admin HTTP client, a polling-aware pairing model, and dedicated UI panels for lifecycle, approval queue, and trusted devices.

**Tech Stack:** React, TypeScript, Vite, Vitest, browser `fetch`, existing `ascp-sdk-typescript` client for the session workspace.

---

## File Structure

- `apps/host-console/src/pairing/types.ts`
  - Pairing session, trusted device, and create-form DTOs mapped from daemon admin JSON.
- `apps/host-console/src/pairing/api.ts`
  - Small loopback admin client for list/create/approve/reject/revoke calls.
- `apps/host-console/src/pairing/model.ts`
  - Pairing workspace state, derived approval queue, polling helpers, and merge/update utilities.
- `apps/host-console/src/pairing/model.test.ts`
  - Focused tests for derivation, polling enablement, and state updates.
- `apps/host-console/src/pairing/components/PairingWorkspace.tsx`
  - Pairing workspace layout and panel composition.
- `apps/host-console/src/pairing/components/PairingSessionsPanel.tsx`
  - Inline create form plus lifecycle list.
- `apps/host-console/src/pairing/components/ClaimApprovalPanel.tsx`
  - Action queue for `pending_host_approval` sessions.
- `apps/host-console/src/pairing/components/TrustedDevicesPanel.tsx`
  - Device inventory and revoke actions.
- `apps/host-console/src/components/WorkspaceSwitcher.tsx`
  - Top-level switch between session and pairing workspaces.
- `apps/host-console/src/App.tsx`
  - Top-level workspace switch, pairing workspace state/effects, and admin URL handling.
- `apps/host-console/src/styles.css`
  - Workspace switcher and pairing panel styling.
- `apps/host-console/README.md`
  - Operator instructions for the pairing workspace.
- `services/host-daemon/src/pairing/admin-server.ts`
  - Small UI-enabling admin endpoint to list pairing sessions for the lifecycle panel.
- `services/host-daemon/src/pairing/service.ts`
  - Exposes pairing-session listing through the existing backend service boundary.
- `services/host-daemon/tests/pairing/admin-server.test.ts`
  - Verification for the new pairing-session list endpoint.
- `internal/plans.md`
  - Already updated for this feature; mark tasks complete during implementation.
- `internal/status.md`
  - Add a checkpoint when the slice is complete.

### Task 1: Expose pairing-session list data and add frontend model helpers

**Files:**
- Modify: `services/host-daemon/src/pairing/admin-server.ts`
- Modify: `services/host-daemon/src/pairing/service.ts`
- Modify: `services/host-daemon/tests/pairing/admin-server.test.ts`
- Create: `apps/host-console/src/pairing/types.ts`
- Create: `apps/host-console/src/pairing/api.ts`
- Create: `apps/host-console/src/pairing/model.ts`
- Create: `apps/host-console/src/pairing/model.test.ts`
- Test: `apps/host-console/src/pairing/model.test.ts`

- [ ] **Step 1: Write the failing model tests**

```ts
// services/host-daemon/tests/pairing/admin-server.test.ts
it("lists pairing sessions for the host lifecycle panel", async () => {
  const daemon = await createPairingHarness();
  daemonsToClose.add(daemon);

  const created = await requestJson(daemon.adminUrl, "POST", "/admin/pairing/sessions", {
    requested_scopes: ["read:sessions"]
  });

  const sessionsResponse = await requestJson(daemon.adminUrl, "GET", "/admin/pairing/sessions");

  expect(sessionsResponse.sessions).toEqual([
    expect.objectContaining({
      session_id: created.session_id,
      code: created.code,
      status: "pending_host_claim"
    })
  ]);
});
```

```ts
// apps/host-console/src/pairing/model.test.ts
import { describe, expect, it } from "vitest";

import {
  createPairingWorkspaceState,
  deriveApprovalQueue,
  mergePairingSession,
  shouldUseActivePolling,
  updateTrustedDeviceList
} from "./model";
import type { PairingSessionRecord, TrustedDeviceRecord } from "./types";

function session(overrides: Partial<PairingSessionRecord>): PairingSessionRecord {
  return {
    sessionId: "pairing:1",
    code: "PAIR-ABCD1234",
    claimToken: null,
    requestedScopes: ["read:sessions"],
    status: "pending_host_claim",
    createdAt: "2026-04-28T12:00:00.000Z",
    expiresAt: "2026-04-28T12:05:00.000Z",
    claimedAt: null,
    approvedAt: null,
    rejectedAt: null,
    consumedAt: null,
    deviceLabel: null,
    issuedDeviceId: null,
    qrPayload: '{"code":"PAIR-ABCD1234","session_id":"pairing:1"}',
    error: null,
    isRefreshing: false,
    copiedCode: false,
    lastUpdatedAt: "2026-04-28T12:00:00.000Z",
    ...overrides
  };
}

function device(overrides: Partial<TrustedDeviceRecord>): TrustedDeviceRecord {
  return {
    deviceId: "device_1",
    displayName: "Ibrar iPhone",
    scopes: ["read:sessions"],
    pairedAt: "2026-04-28T12:03:00.000Z",
    lastSeenAt: null,
    revoked: false,
    revokedAt: null,
    status: "active",
    ...overrides
  };
}

describe("pairing workspace model", () => {
  it("derives the approval queue from pending_host_approval sessions only", () => {
    const queue = deriveApprovalQueue([
      session({ sessionId: "pairing:1", status: "pending_host_claim" }),
      session({ sessionId: "pairing:2", status: "pending_host_approval", deviceLabel: "Pixel 9" }),
      session({ sessionId: "pairing:3", status: "approved", deviceLabel: "iPhone" })
    ]);

    expect(queue.map((item) => item.sessionId)).toEqual(["pairing:2"]);
  });

  it("keeps active polling enabled for pending and approved sessions", () => {
    expect(shouldUseActivePolling([session({ status: "pending_host_claim" })])).toBe(true);
    expect(shouldUseActivePolling([session({ status: "pending_host_approval" })])).toBe(true);
    expect(shouldUseActivePolling([session({ status: "approved" })])).toBe(true);
    expect(shouldUseActivePolling([session({ status: "consumed" })])).toBe(false);
    expect(shouldUseActivePolling([session({ status: "rejected" })])).toBe(false);
    expect(shouldUseActivePolling([session({ status: "expired" })])).toBe(false);
  });

  it("merges pairing session updates by session id without dropping lifecycle history", () => {
    const merged = mergePairingSession(
      [session({ sessionId: "pairing:1", status: "pending_host_approval", deviceLabel: "Pixel" })],
      session({ sessionId: "pairing:1", status: "approved", issuedDeviceId: "device_9" })
    );

    expect(merged).toEqual([
      expect.objectContaining({
        sessionId: "pairing:1",
        status: "approved",
        issuedDeviceId: "device_9"
      })
    ]);
  });

  it("replaces trusted device inventory with the freshest daemon response", () => {
    expect(
      updateTrustedDeviceList(
        [
          device({
            deviceId: "device_old",
            revoked: true,
            revokedAt: "2026-04-28T12:04:00.000Z",
            status: "revoked"
          })
        ],
        [device({ deviceId: "device_new" })]
      )
    ).toEqual([device({ deviceId: "device_new" })]);
  });

  it("creates a clean initial workspace state for first entry and re-entry", () => {
    expect(createPairingWorkspaceState()).toEqual({
      createForm: {
        requestedScopes: ["read:hosts", "read:runtimes", "read:sessions"],
        ttlMinutes: 5
      },
      devices: [],
      error: null,
      isLoaded: false,
      isLoading: false,
      isSubmitting: false,
      lastLoadedAt: null,
      sessions: []
    });
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/admin-server.test.ts && npm --workspace @ascp/app-host-console exec vitest run src/pairing/model.test.ts`
Expected: FAIL because `GET /admin/pairing/sessions` is missing and `src/pairing/model.ts` / `src/pairing/types.ts` do not exist yet.

- [ ] **Step 3: Add the pairing-session list endpoint to the daemon admin server**

```ts
if (request.method === "GET" && pathname === "/admin/pairing/sessions") {
  sendJson(response, 200, {
    sessions: this.pairingService.listPairingSessions().map((session) => ({
      approved_at: session.approvedAt,
      claim_token: session.claimToken,
      claimed_at: session.claimedAt,
      code: session.code,
      consumed_at: session.consumedAt,
      created_at: session.createdAt,
      device_label: session.deviceLabel,
      expires_at: session.expiresAt,
      issued_device_id: session.issuedDeviceId,
      qr_payload: JSON.stringify({
        code: session.code,
        session_id: session.sessionId
      }),
      rejected_at: session.rejectedAt,
      requested_scopes: session.requestedScopes,
      session_id: session.sessionId,
      status: session.status
    }))
  });
  return;
}
```

- [ ] **Step 4: Extend the pairing backend service contract with session listing**

```ts
export interface PairingBackendService {
  approvePairing(sessionId: string): void;
  claimPairing(input: { code: string; deviceLabel: string }): Promise<{
    claimToken: string;
    sessionId: string;
  }>;
  expireStaleSessions(now?: string): number;
  listPairingSessions(): PairingSessionRecord[];
  listTrustedDevices(): TrustedDeviceRecord[];
  pollPairing(claimToken: string): Promise<
    | { status: "pending_host_approval" | "rejected" | "expired" }
    | { status: "approved"; credentials: { device_id: string; device_secret: string } }
    | { status: "consumed"; issued_device_id: string | null }
  >;
  rejectPairing(sessionId: string): void;
  revokeTrustedDevice(deviceId: string): void;
  startPairing(input: {
    requestedScopes: string[];
    ttlMs?: number;
    now?: string;
  }): {
    code: string;
    expiresAt: string;
    qrPayload: string;
    sessionId: string;
  };
}

// inside createPairingService(...)
listPairingSessions() {
  return deps.sessionStore.listSessions();
},
```

- [ ] **Step 5: Write the pairing types**

```ts
export type PairingSessionStatus =
  | "pending_host_claim"
  | "pending_host_approval"
  | "approved"
  | "rejected"
  | "expired"
  | "consumed";

export interface PairingSessionRecord {
  sessionId: string;
  code: string;
  claimToken: string | null;
  requestedScopes: string[];
  status: PairingSessionStatus;
  createdAt: string;
  expiresAt: string;
  claimedAt: string | null;
  approvedAt: string | null;
  rejectedAt: string | null;
  consumedAt: string | null;
  deviceLabel: string | null;
  issuedDeviceId: string | null;
  qrPayload: string;
  error: string | null;
  isRefreshing: boolean;
  copiedCode: boolean;
  lastUpdatedAt: string;
}

export interface TrustedDeviceRecord {
  deviceId: string;
  displayName: string;
  scopes: string[];
  pairedAt: string;
  lastSeenAt: string | null;
  revoked: boolean;
  revokedAt: string | null;
  status: "active" | "revoked";
}

export interface PairingCreateFormState {
  requestedScopes: string[];
  ttlMinutes: number;
}

export interface PairingWorkspaceState {
  createForm: PairingCreateFormState;
  devices: TrustedDeviceRecord[];
  error: string | null;
  isLoaded: boolean;
  isLoading: boolean;
  isSubmitting: boolean;
  lastLoadedAt: string | null;
  sessions: PairingSessionRecord[];
}
```

- [ ] **Step 6: Write the pairing model helpers**

```ts
import type {
  PairingCreateFormState,
  PairingSessionRecord,
  PairingWorkspaceState,
  TrustedDeviceRecord
} from "./types";

export const DEFAULT_PAIRING_SCOPES = [
  "read:hosts",
  "read:runtimes",
  "read:sessions"
];

export const ACTIVE_POLLING_MS = 3_000;
export const IDLE_REFRESH_MS = 30_000;

export function createPairingWorkspaceState(): PairingWorkspaceState {
  return {
    createForm: {
      requestedScopes: [...DEFAULT_PAIRING_SCOPES],
      ttlMinutes: 5
    },
    devices: [],
    error: null,
    isLoaded: false,
    isLoading: false,
    isSubmitting: false,
    lastLoadedAt: null,
    sessions: []
  };
}

export function deriveApprovalQueue(sessions: PairingSessionRecord[]): PairingSessionRecord[] {
  return sessions
    .filter((session) => session.status === "pending_host_approval")
    .sort((left, right) => left.createdAt.localeCompare(right.createdAt));
}

export function shouldUseActivePolling(sessions: PairingSessionRecord[]): boolean {
  return sessions.some(
    (session) =>
      session.status === "pending_host_claim" ||
      session.status === "pending_host_approval" ||
      session.status === "approved"
  );
}

export function mergePairingSession(
  sessions: PairingSessionRecord[],
  nextSession: PairingSessionRecord
): PairingSessionRecord[] {
  const existingIndex = sessions.findIndex((session) => session.sessionId === nextSession.sessionId);
  const merged =
    existingIndex === -1
      ? [...sessions, nextSession]
      : sessions.map((session) =>
          session.sessionId === nextSession.sessionId ? nextSession : session
        );

  return merged.sort((left, right) => right.createdAt.localeCompare(left.createdAt));
}

export function updateTrustedDeviceList(
  _existing: TrustedDeviceRecord[],
  nextDevices: TrustedDeviceRecord[]
): TrustedDeviceRecord[] {
  return [...nextDevices].sort((left, right) => right.pairedAt.localeCompare(left.pairedAt));
}

export function updateCreateForm(
  form: PairingCreateFormState,
  nextPatch: Partial<PairingCreateFormState>
): PairingCreateFormState {
  return {
    ...form,
    ...nextPatch
  };
}
```

- [ ] **Step 7: Write the pairing admin HTTP client**

```ts
import type { PairingSessionRecord, TrustedDeviceRecord } from "./types";

export function mapPairingSession(payload: Record<string, unknown>): PairingSessionRecord {
  const now = new Date().toISOString();

  return {
    sessionId: String(payload.session_id ?? ""),
    code: String(payload.code ?? ""),
    claimToken: typeof payload.claim_token === "string" ? payload.claim_token : null,
    requestedScopes: Array.isArray(payload.requested_scopes)
      ? payload.requested_scopes.map((value) => String(value))
      : [],
    status: String(payload.status ?? "pending_host_claim") as PairingSessionRecord["status"],
    createdAt: String(payload.created_at ?? now),
    expiresAt: String(payload.expires_at ?? now),
    claimedAt: typeof payload.claimed_at === "string" ? payload.claimed_at : null,
    approvedAt: typeof payload.approved_at === "string" ? payload.approved_at : null,
    rejectedAt: typeof payload.rejected_at === "string" ? payload.rejected_at : null,
    consumedAt: typeof payload.consumed_at === "string" ? payload.consumed_at : null,
    deviceLabel: typeof payload.device_label === "string" ? payload.device_label : null,
    issuedDeviceId: typeof payload.issued_device_id === "string" ? payload.issued_device_id : null,
    qrPayload:
      typeof payload.qr_payload === "string"
        ? payload.qr_payload
        : JSON.stringify({ code: payload.code, session_id: payload.session_id }),
    error: null,
    isRefreshing: false,
    copiedCode: false,
    lastUpdatedAt: now
  };
}

function mapDevice(payload: Record<string, unknown>): TrustedDeviceRecord {
  return {
    deviceId: String(payload.device_id ?? ""),
    displayName: String(payload.display_name ?? payload.device_id ?? ""),
    scopes: Array.isArray(payload.scopes) ? payload.scopes.map((value) => String(value)) : [],
    pairedAt: String(payload.paired_at ?? ""),
    lastSeenAt: typeof payload.last_seen_at === "string" ? payload.last_seen_at : null,
    revoked: Boolean(payload.revoked),
    revokedAt: typeof payload.revoked_at === "string" ? payload.revoked_at : null,
    status: payload.revoked ? "revoked" : "active"
  };
}

export function createPairingAdminClient(baseUrl: string) {
  async function request(path: string, init?: RequestInit): Promise<Record<string, unknown>> {
    const response = await fetch(`${baseUrl}${path}`, {
      ...init,
      headers: {
        "content-type": "application/json",
        ...(init?.headers ?? {})
      }
    });
    const payload = (await response.json()) as Record<string, unknown>;

    if (!response.ok) {
      throw new Error(String(payload.message ?? "Request failed."));
    }

    return payload;
  }

  return {
    async listPairingSessions() {
      const payload = await request("/admin/pairing/sessions");
      return Array.isArray(payload.sessions)
        ? payload.sessions.map((item) => mapPairingSession(item as Record<string, unknown>))
        : [];
    },
    async createPairingSession(input: { requestedScopes: string[]; ttlMinutes: number }) {
      const payload = await request("/admin/pairing/sessions", {
        body: JSON.stringify({
          requested_scopes: input.requestedScopes,
          ttl_ms: input.ttlMinutes * 60 * 1000
        }),
        method: "POST"
      });

      return mapPairingSession({
        ...payload,
        requested_scopes: input.requestedScopes,
        status: "pending_host_claim",
        created_at: new Date().toISOString()
      });
    },
    async approvePairing(sessionId: string) {
      await request(`/admin/pairing/sessions/${encodeURIComponent(sessionId)}/approve`, {
        body: JSON.stringify({}),
        method: "POST"
      });
    },
    async rejectPairing(sessionId: string) {
      await request(`/admin/pairing/sessions/${encodeURIComponent(sessionId)}/reject`, {
        body: JSON.stringify({}),
        method: "POST"
      });
    },
    async listTrustedDevices() {
      const payload = await request("/admin/trusted-devices");
      return Array.isArray(payload.devices)
        ? payload.devices.map((item) => mapDevice(item as Record<string, unknown>))
        : [];
    },
    async revokeTrustedDevice(deviceId: string) {
      await request(`/admin/trusted-devices/${encodeURIComponent(deviceId)}/revoke`, {
        body: JSON.stringify({}),
        method: "POST"
      });
    }
  };
}
```

- [ ] **Step 8: Run test to verify it passes**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/admin-server.test.ts && npm --workspace @ascp/app-host-console exec vitest run src/pairing/model.test.ts`
Expected: PASS

- [ ] **Step 9: Commit**

```bash
git add services/host-daemon/src/pairing/admin-server.ts services/host-daemon/tests/pairing/admin-server.test.ts apps/host-console/src/pairing/types.ts apps/host-console/src/pairing/api.ts apps/host-console/src/pairing/model.ts apps/host-console/src/pairing/model.test.ts
git commit -m "feat(host-console): add pairing workspace data model"
```

### Task 2: Add the pairing workspace shell and top-level app state

**Files:**
- Create: `apps/host-console/src/components/WorkspaceSwitcher.tsx`
- Modify: `apps/host-console/src/App.tsx`
- Modify: `apps/host-console/src/styles.css`
- Test: `apps/host-console/src/model.test.ts`

- [ ] **Step 1: Extend the host-console model test with a workspace-switching expectation**

```ts
it("preserves session detail state shape while pairing workspace lives separately", () => {
  const loading = createLoadingSessionView("codex:session_2");

  expect(loading.sessionId).toBe("codex:session_2");
  expect(loading.mode).toBe("loading");
  expect(loading.approvals).toEqual([]);
  expect(loading.inputs).toEqual([]);
});
```

- [ ] **Step 2: Run tests to verify current app coverage still passes**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/model.test.ts src/subscriptions.test.ts src/timeline.test.ts`
Expected: PASS

- [ ] **Step 3: Add the workspace switcher component**

```tsx
interface WorkspaceSwitcherProps {
  activeWorkspace: "sessions" | "pairing";
  onSelectWorkspace: (workspace: "sessions" | "pairing") => void;
}

export function WorkspaceSwitcher({ activeWorkspace, onSelectWorkspace }: WorkspaceSwitcherProps) {
  return (
    <div className="workspace-switcher" role="tablist" aria-label="Console workspaces">
      <button
        type="button"
        className={`workspace-tab ${activeWorkspace === "sessions" ? "active" : ""}`}
        onClick={() => onSelectWorkspace("sessions")}
      >
        Sessions
      </button>
      <button
        type="button"
        className={`workspace-tab ${activeWorkspace === "pairing" ? "active" : ""}`}
        onClick={() => onSelectWorkspace("pairing")}
      >
        Pairing
      </button>
    </div>
  );
}
```

- [ ] **Step 4: Add top-level workspace state and pairing admin URL wiring in `App.tsx`**

```tsx
type ConsoleWorkspace = "sessions" | "pairing";

const DEFAULT_PAIRING_ADMIN_URL = "http://127.0.0.1:8766";

const [activeWorkspace, setActiveWorkspace] = useState<ConsoleWorkspace>("sessions");
const [pairingAdminUrl, setPairingAdminUrl] = useState(DEFAULT_PAIRING_ADMIN_URL);
const [pairingState, setPairingState] = useState(createPairingWorkspaceState());
const pairingClientRef = useRef(createPairingAdminClient(DEFAULT_PAIRING_ADMIN_URL));

useEffect(() => {
  pairingClientRef.current = createPairingAdminClient(pairingAdminUrl);
}, [pairingAdminUrl]);
```

Add the switcher and a new admin URL field in the top bar:

```tsx
<div className="topbar-controls">
  <WorkspaceSwitcher
    activeWorkspace={activeWorkspace}
    onSelectWorkspace={setActiveWorkspace}
  />
  <label className="host-field">
    <span>Pairing admin URL</span>
    <input
      value={pairingAdminUrl}
      onChange={(event) => setPairingAdminUrl(event.target.value)}
      placeholder="http://127.0.0.1:8766"
    />
  </label>
</div>
```

Render either the current session workspace or the new pairing workspace placeholder:

```tsx
{activeWorkspace === "sessions" ? (
  <div className="workspace-main">{/* existing chat pane and operator rail */}</div>
) : (
  <div className="pairing-workspace-placeholder">Pairing workspace loading…</div>
)}
```

- [ ] **Step 5: Add switcher styling**

```css
.workspace-switcher {
  display: inline-flex;
  gap: 0.5rem;
  padding: 0.35rem;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.05);
}

.workspace-tab {
  background: transparent;
  color: rgba(244, 234, 216, 0.74);
  border-radius: 999px;
  padding: 0.65rem 0.9rem;
}

.workspace-tab.active {
  background: rgba(235, 139, 58, 0.18);
  color: #f9efe0;
}

.pairing-workspace-placeholder {
  min-height: 72vh;
  border-radius: 1.6rem;
  padding: 1.5rem;
  backdrop-filter: blur(20px);
  background: rgba(18, 16, 14, 0.78);
  border: 1px solid rgba(255, 255, 255, 0.08);
}
```

- [ ] **Step 6: Run the focused host-console tests**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/model.test.ts src/subscriptions.test.ts src/timeline.test.ts src/pairing/model.test.ts`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add apps/host-console/src/components/WorkspaceSwitcher.tsx apps/host-console/src/App.tsx apps/host-console/src/styles.css apps/host-console/src/model.test.ts apps/host-console/src/pairing/model.test.ts
git commit -m "feat(host-console): add pairing workspace shell"
```

### Task 3: Build pairing panels, fetch flows, and scoped polling

**Files:**
- Create: `apps/host-console/src/pairing/components/PairingWorkspace.tsx`
- Create: `apps/host-console/src/pairing/components/PairingSessionsPanel.tsx`
- Create: `apps/host-console/src/pairing/components/ClaimApprovalPanel.tsx`
- Create: `apps/host-console/src/pairing/components/TrustedDevicesPanel.tsx`
- Modify: `apps/host-console/src/App.tsx`
- Modify: `apps/host-console/src/styles.css`
- Test: `apps/host-console/src/pairing/model.test.ts`

- [ ] **Step 1: Add failing tests for polling and approval refresh behavior**

```ts
it("keeps active polling enabled for approved sessions until they become consumed", () => {
  expect(shouldUseActivePolling([session({ status: "approved" })])).toBe(true);
});

it("keeps pending_host_approval sessions visible in both lifecycle and approval queue projections", () => {
  const sessions = [session({ sessionId: "pairing:2", status: "pending_host_approval", deviceLabel: "Pixel 9" })];

  expect(sessions).toHaveLength(1);
  expect(deriveApprovalQueue(sessions)).toEqual([
    expect.objectContaining({ sessionId: "pairing:2", status: "pending_host_approval" })
  ]);
});
```

- [ ] **Step 2: Run the pairing model test again**

Run: `npm --workspace @ascp/app-host-console exec vitest run src/pairing/model.test.ts`
Expected: PASS or unchanged; keep it as a safety check before wiring UI effects.

- [ ] **Step 3: Build the pairing workspace panels**

`apps/host-console/src/pairing/components/PairingSessionsPanel.tsx`

```tsx
import type { PairingCreateFormState, PairingSessionRecord } from "../types";

interface PairingSessionsPanelProps {
  canSubmit: boolean;
  createForm: PairingCreateFormState;
  error: string | null;
  isSubmitting: boolean;
  onChangeScopes: (scopes: string[]) => void;
  onChangeTtlMinutes: (ttlMinutes: number) => void;
  onCopyCode: (sessionId: string) => void;
  onCreate: () => void;
  onRefresh: () => void;
  sessions: PairingSessionRecord[];
}

export function PairingSessionsPanel(props: PairingSessionsPanelProps) {
  return (
    <section className="pairing-panel">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Pairing Sessions</p>
          <h2>Lifecycle</h2>
        </div>
        <button type="button" className="ghost" onClick={props.onRefresh}>
          Refresh
        </button>
      </div>

      <div className="pairing-create-card">
        <label>
          Requested scopes
          <select
            multiple
            value={props.createForm.requestedScopes}
            onChange={(event) =>
              props.onChangeScopes(Array.from(event.target.selectedOptions).map((option) => option.value))
            }
          >
            <option value="read:hosts">read:hosts</option>
            <option value="read:runtimes">read:runtimes</option>
            <option value="read:sessions">read:sessions</option>
            <option value="write:sessions">write:sessions</option>
            <option value="read:approvals">read:approvals</option>
            <option value="write:approvals">write:approvals</option>
            <option value="read:artifacts">read:artifacts</option>
          </select>
        </label>
        <label>
          TTL minutes
          <input
            type="number"
            min={1}
            max={30}
            value={props.createForm.ttlMinutes}
            onChange={(event) => props.onChangeTtlMinutes(Number(event.target.value))}
          />
        </label>
        <button type="button" onClick={props.onCreate} disabled={!props.canSubmit || props.isSubmitting}>
          {props.isSubmitting ? "Creating…" : "Create pairing session"}
        </button>
        {props.error ? <p className="panel-error">{props.error}</p> : null}
      </div>

      <div className="pairing-session-list">
        {props.sessions.map((session) => (
          <article key={session.sessionId} className="pairing-session-card">
            <div className="session-row-top">
              <strong>{session.code}</strong>
              <span className={`status-pill status-${session.status}`}>{session.status}</span>
            </div>
            <div className="session-row-meta">
              <span>Expires {session.expiresAt}</span>
              <span>{session.deviceLabel ?? "Waiting for claim"}</span>
            </div>
            <p>Scopes: {session.requestedScopes.join(", ") || "None requested"}</p>
            <div className="code-row">
              <code>{session.code}</code>
              <button type="button" className="ghost" onClick={() => props.onCopyCode(session.sessionId)}>
                {session.copiedCode ? "Copied" : "Copy code"}
              </button>
            </div>
            <p className="subcopy">QR payload stored but not rendered in v1.</p>
          </article>
        ))}
      </div>
    </section>
  );
}
```

`apps/host-console/src/pairing/components/ClaimApprovalPanel.tsx`

```tsx
import type { PairingSessionRecord } from "../types";

interface ClaimApprovalPanelProps {
  items: PairingSessionRecord[];
  onApprove: (sessionId: string) => void;
  onReject: (sessionId: string) => void;
}

export function ClaimApprovalPanel({ items, onApprove, onReject }: ClaimApprovalPanelProps) {
  return (
    <section className="pairing-panel">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Claim Approval</p>
          <h2>Action Queue</h2>
        </div>
      </div>
      {items.length === 0 ? <p className="empty">No claims awaiting host approval.</p> : null}
      {items.map((item) => (
        <article key={item.sessionId} className="approval-card">
          <strong>{item.deviceLabel ?? item.code}</strong>
          <p>{item.requestedScopes.join(", ")}</p>
          <div className="topbar-actions">
            <button type="button" onClick={() => onApprove(item.sessionId)}>
              Approve
            </button>
            <button type="button" className="ghost" onClick={() => onReject(item.sessionId)}>
              Reject
            </button>
          </div>
        </article>
      ))}
    </section>
  );
}
```

`apps/host-console/src/pairing/components/TrustedDevicesPanel.tsx`

```tsx
import type { TrustedDeviceRecord } from "../types";

interface TrustedDevicesPanelProps {
  devices: TrustedDeviceRecord[];
  onRefresh: () => void;
  onRevoke: (deviceId: string) => void;
}

export function TrustedDevicesPanel({ devices, onRefresh, onRevoke }: TrustedDevicesPanelProps) {
  return (
    <section className="pairing-panel">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Trusted Devices</p>
          <h2>Inventory</h2>
        </div>
        <button type="button" className="ghost" onClick={onRefresh}>
          Refresh
        </button>
      </div>
      {devices.length === 0 ? <p className="empty">No trusted devices loaded.</p> : null}
      {devices.map((device) => (
        <article key={device.deviceId} className="device-card">
          <div className="session-row-top">
            <strong>{device.displayName}</strong>
            <span className={`status-pill status-${device.status}`}>{device.status}</span>
          </div>
          <p>{device.scopes.join(", ")}</p>
          <div className="session-row-meta">
            <span>{device.pairedAt}</span>
            {device.status === "active" ? (
              <button type="button" className="ghost" onClick={() => onRevoke(device.deviceId)}>
                Revoke
              </button>
            ) : null}
          </div>
        </article>
      ))}
    </section>
  );
}
```

`apps/host-console/src/pairing/components/PairingWorkspace.tsx`

```tsx
import { deriveApprovalQueue } from "../model";
import type { PairingWorkspaceState } from "../types";
import { ClaimApprovalPanel } from "./ClaimApprovalPanel";
import { PairingSessionsPanel } from "./PairingSessionsPanel";
import { TrustedDevicesPanel } from "./TrustedDevicesPanel";

interface PairingWorkspaceProps {
  state: PairingWorkspaceState;
  onApprove: (sessionId: string) => void;
  onChangeScopes: (scopes: string[]) => void;
  onChangeTtlMinutes: (ttlMinutes: number) => void;
  onCopyCode: (sessionId: string) => void;
  onCreate: () => void;
  onRefreshDevices: () => void;
  onRefreshSessions: () => void;
  onReject: (sessionId: string) => void;
  onRevokeDevice: (deviceId: string) => void;
}

export function PairingWorkspace(props: PairingWorkspaceProps) {
  const approvalQueue = deriveApprovalQueue(props.state.sessions);

  return (
    <div className="pairing-workspace-grid">
      <PairingSessionsPanel
        canSubmit={props.state.createForm.requestedScopes.length > 0 && props.state.createForm.ttlMinutes > 0}
        createForm={props.state.createForm}
        error={props.state.error}
        isSubmitting={props.state.isSubmitting}
        onChangeScopes={props.onChangeScopes}
        onChangeTtlMinutes={props.onChangeTtlMinutes}
        onCopyCode={props.onCopyCode}
        onCreate={props.onCreate}
        onRefresh={props.onRefreshSessions}
        sessions={props.state.sessions}
      />
      <ClaimApprovalPanel items={approvalQueue} onApprove={props.onApprove} onReject={props.onReject} />
      <TrustedDevicesPanel devices={props.state.devices} onRefresh={props.onRefreshDevices} onRevoke={props.onRevokeDevice} />
    </div>
  );
}
```

- [ ] **Step 4: Wire fetch, re-entry, and polling behavior in `App.tsx`**

```tsx
async function reloadPairingWorkspace(options: { refreshDevices: boolean }) {
  const sessionsResponse = await fetch(`${pairingAdminUrl}/admin/pairing/sessions`);
  const sessionsPayload = (await sessionsResponse.json()) as { sessions?: Record<string, unknown>[] };
  const sessions = Array.isArray(sessionsPayload.sessions)
    ? sessionsPayload.sessions.map((item) => mapPairingSession(item))
    : [];
  const devices = options.refreshDevices
    ? await pairingClientRef.current.listTrustedDevices()
    : pairingState.devices;

  setPairingState((current) => ({
    ...current,
    devices: options.refreshDevices ? updateTrustedDeviceList(current.devices, devices) : current.devices,
    error: null,
    isLoaded: true,
    isLoading: false,
    lastLoadedAt: new Date().toISOString(),
    sessions
  }));
}

useEffect(() => {
  if (activeWorkspace !== "pairing") {
    return;
  }

  let cancelled = false;

  async function loadPairingWorkspace() {
    setPairingState((current) => ({ ...current, error: null, isLoading: true }));

    try {
      const [sessions, devices] = await Promise.all([
        pairingClientRef.current.listPairingSessions(),
        pairingClientRef.current.listTrustedDevices()
      ]);

      if (cancelled) {
        return;
      }

      setPairingState((current) => ({
        ...current,
        devices: updateTrustedDeviceList(current.devices, devices),
        error: null,
        isLoaded: true,
        isLoading: false,
        lastLoadedAt: new Date().toISOString(),
        sessions
      }));
    } catch (error) {
      if (!cancelled) {
        setPairingState((current) => ({
          ...current,
          error: error instanceof Error ? error.message : "Failed to load pairing workspace.",
          isLoading: false
        }));
      }
    }
  }

  void loadPairingWorkspace();

  return () => {
    cancelled = true;
  };
}, [activeWorkspace, pairingAdminUrl]);

useEffect(() => {
  if (activeWorkspace !== "pairing") {
    return;
  }

  const intervalMs = shouldUseActivePolling(pairingState.sessions) ? ACTIVE_POLLING_MS : IDLE_REFRESH_MS;
  const timer = window.setInterval(() => {
    void reloadPairingWorkspace({ refreshDevices: shouldUseActivePolling(pairingState.sessions) });
  }, intervalMs);

  return () => window.clearInterval(timer);
}, [activeWorkspace, pairingAdminUrl, pairingState.sessions]);
```

Add actions:

```tsx
async function handleCreatePairingSession() {
  setPairingState((current) => ({ ...current, error: null, isSubmitting: true }));
  try {
    const created = await pairingClientRef.current.createPairingSession(pairingState.createForm);
    setPairingState((current) => ({
      ...current,
      isSubmitting: false,
      sessions: mergePairingSession(current.sessions, created)
    }));
  } catch (error) {
    setPairingState((current) => ({
      ...current,
      error: error instanceof Error ? error.message : "Failed to create pairing session.",
      isSubmitting: false
    }));
  }
}

async function handleApprovePairing(sessionId: string) {
  await pairingClientRef.current.approvePairing(sessionId);
  await reloadPairingWorkspace({ refreshDevices: true });
}

async function handleRejectPairing(sessionId: string) {
  await pairingClientRef.current.rejectPairing(sessionId);
  await reloadPairingWorkspace({ refreshDevices: false });
}

async function handleRevokeDevice(deviceId: string) {
  await pairingClientRef.current.revokeTrustedDevice(deviceId);
  await reloadPairingWorkspace({ refreshDevices: true });
}
```

Render the workspace:

```tsx
{activeWorkspace === "sessions" ? (
  <div className="workspace-main">{/* existing session UI */}</div>
) : (
  <PairingWorkspace
    state={pairingState}
    onApprove={handleApprovePairing}
    onChangeScopes={(requestedScopes) =>
      setPairingState((current) => ({
        ...current,
        createForm: updateCreateForm(current.createForm, { requestedScopes })
      }))
    }
    onChangeTtlMinutes={(ttlMinutes) =>
      setPairingState((current) => ({
        ...current,
        createForm: updateCreateForm(current.createForm, { ttlMinutes })
      }))
    }
    onCopyCode={(sessionId) => {
      const item = pairingState.sessions.find((session) => session.sessionId === sessionId);
      if (item) {
        void navigator.clipboard.writeText(item.code);
        setPairingState((current) => ({
          ...current,
          sessions: current.sessions.map((session) =>
            session.sessionId === sessionId ? { ...session, copiedCode: true } : session
          )
        }));
        window.setTimeout(() => {
          setPairingState((current) => ({
            ...current,
            sessions: current.sessions.map((session) =>
              session.sessionId === sessionId ? { ...session, copiedCode: false } : session
            )
          }));
        }, 2_000);
      }
    }}
    onCreate={handleCreatePairingSession}
    onRefreshDevices={() => void reloadPairingWorkspace({ refreshDevices: true })}
    onRefreshSessions={() => void reloadPairingWorkspace({ refreshDevices: false })}
    onReject={handleRejectPairing}
    onRevokeDevice={handleRevokeDevice}
  />
)}
```

- [ ] **Step 5: Add pairing workspace styling**

```css
.pairing-workspace-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.5fr) minmax(280px, 0.95fr) minmax(280px, 0.95fr);
  gap: 1rem;
  align-items: start;
  min-height: 72vh;
}

.pairing-panel {
  display: grid;
  gap: 0.9rem;
  padding: 1rem;
  border-radius: 1.6rem;
  backdrop-filter: blur(20px);
  background: rgba(18, 16, 14, 0.78);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.24);
}

.pairing-create-card,
.pairing-session-card,
.approval-card,
.device-card {
  display: grid;
  gap: 0.75rem;
  padding: 0.95rem;
  border-radius: 1.2rem;
  background: rgba(255, 255, 255, 0.04);
}

.code-row {
  display: flex;
  gap: 0.75rem;
  align-items: center;
  justify-content: space-between;
}

.panel-error {
  margin: 0;
  color: #ffd1d1;
}
```

- [ ] **Step 6: Run host-console tests and build**

Run: `npm --workspace @ascp/app-host-console test && npm --workspace @ascp/app-host-console run build`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add apps/host-console/src/pairing/components/PairingWorkspace.tsx apps/host-console/src/pairing/components/PairingSessionsPanel.tsx apps/host-console/src/pairing/components/ClaimApprovalPanel.tsx apps/host-console/src/pairing/components/TrustedDevicesPanel.tsx apps/host-console/src/App.tsx apps/host-console/src/styles.css apps/host-console/src/pairing/model.test.ts
git commit -m "feat(host-console): add pairing admin workspace"
```

### Task 4: Document, checkpoint, and verify the slice

**Files:**
- Modify: `apps/host-console/README.md`
- Modify: `README.md`
- Modify: `internal/plans.md`
- Modify: `internal/status.md`
- Modify: `docs/superpowers/plans/2026-04-28-host-pairing-ui.md`

- [ ] **Step 1: Update the host-console README**

```md
## Pairing workspace

The host console now includes a separate `Pairing` workspace for daemon-admin onboarding flows.

It exercises the loopback pairing backend through:

- `POST /admin/pairing/sessions`
- `GET /admin/pairing/sessions`
- `POST /admin/pairing/sessions/:id/approve`
- `POST /admin/pairing/sessions/:id/reject`
- `GET /admin/trusted-devices`
- `POST /admin/trusted-devices/:id/revoke`

Behavior notes:

- pairing creation is inline within the lifecycle panel
- `pending_host_approval` sessions appear both in the lifecycle list and the approval queue
- v1 shows copyable pairing codes only; `qr_payload` is not rendered as an image yet
- polling runs every 3 seconds while pending or approved sessions exist, then slows to 30 seconds when all sessions are terminal
```

- [ ] **Step 2: Update top-level docs and branch tracker**

Add one bullet to `README.md` under architecture notes:

```md
- `apps/host-console/` now also exposes a host-side pairing workspace for daemon-admin onboarding and trusted-device management above the loopback pairing backend.
```

Update `internal/plans.md` task table to mark all four pairing UI tasks `completed`.

Add a new checkpoint entry to `internal/status.md`:

```md
### 2026-04-28 - Host pairing UI slice

- Branch: `branch-host-pairing-ui`
- Commit: `not committed`
- Summary: added a separate host-console pairing workspace with inline pairing-session creation, lifecycle visibility, pending-claim approval queue, trusted-device inventory, and polling scoped to pending and approved device onboarding states
- Documentation updated: `internal/plans.md`, `internal/status.md`, `README.md`, `apps/host-console/README.md`, `docs/superpowers/specs/2026-04-28-host-pairing-ui-design.md`, `docs/superpowers/plans/2026-04-28-host-pairing-ui.md`
- Next likely step: build the mobile claim UI on top of the completed daemon pairing backend and host pairing workspace, or harden the daemon transport toward TLS-backed pairing flows
```

- [ ] **Step 3: Run final verification**

Run: `npm --workspace @ascp/app-host-console test && npm --workspace @ascp/app-host-console run build && npm --workspace @ascp/host-daemon exec vitest run tests/pairing/admin-server.test.ts && npm --workspace @ascp/host-daemon run check`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add apps/host-console/README.md README.md internal/plans.md internal/status.md docs/superpowers/plans/2026-04-28-host-pairing-ui.md
git commit -m "docs: checkpoint host pairing ui slice"
```

## Self-Review

- Spec coverage: this plan covers the workspace split, inline pairing creation, approval queue duplication rules, trusted-device management, re-entry re-fetch, `qr_payload` copy-only handling, and `approved`-state polling.
- Placeholder scan: no `TODO`, `TBD`, or deferred implementation markers remain.
- Type consistency: the plan uses one pairing state model, one admin client boundary, and one `PairingSessionRecord` shape across tasks.
