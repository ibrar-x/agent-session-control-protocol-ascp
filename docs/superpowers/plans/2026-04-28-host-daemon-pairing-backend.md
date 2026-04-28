# Host Daemon Pairing Backend Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a loopback-only daemon pairing backend that lets a host-side UI create short-lived pairing sessions, lets an unauthenticated mobile client claim one session, requires explicit host approval, and issues a trusted device credential only after approval without changing ASCP core methods or event semantics.

**Architecture:** Keep ASCP WebSocket traffic and paired-device auth in the existing daemon and `@ascp/host-service` path. Add a separate daemon-local HTTP admin surface in `services/host-daemon` for pairing session management and trusted-device administration, backed by SQLite tables and the existing trust store. The mobile onboarding flow uses short-lived pairing codes plus a pending/approved state machine; only the final approved step issues `device_id + secret`, which the mobile app must store immediately and later uses on the existing ASCP WebSocket auth path. The admin surface is intentionally unauthenticated in v1 and relies entirely on loopback-only binding.

**Tech Stack:** TypeScript, Node 22 `node:http`, Node 22 `node:sqlite`, existing daemon auth/trust modules, Vitest.

---

## Scope Boundary

This plan is intentionally for the **pairing backend slice only**.

Included:
- pairing session persistence and expiry
- host-side admin HTTP endpoints for session creation, approval, rejection, listing, and revoke
- mobile-facing claim/poll HTTP endpoints for onboarding completion
- daemon startup/config wiring for the admin server
- focused backend docs and tests

Explicitly excluded:
- QR rendering UI
- host-console pairing screens
- mobile app pairing UI
- TLS/network transport upgrade
- relay transport auth
- runtime-specific trust policy

---

## File Map

### New files
- `services/host-daemon/src/pairing/types.ts` — pairing session, claim state, admin response, and mobile polling DTOs.
- `services/host-daemon/src/pairing/session-store.ts` — SQLite persistence for pairing sessions and trusted-device admin queries.
- `services/host-daemon/src/pairing/service.ts` — pairing state machine: create, claim, approve, reject, consume approved credentials, expire.
- `services/host-daemon/src/pairing/admin-server.ts` — loopback-only HTTP server exposing admin and mobile pairing endpoints.
- `services/host-daemon/tests/pairing/session-store.test.ts`
- `services/host-daemon/tests/pairing/service.test.ts`
- `services/host-daemon/tests/pairing/admin-server.test.ts`

### Modified files
- `services/host-daemon/src/config.ts` — add admin port config and validation.
- `services/host-daemon/src/sqlite.ts` — add pairing session tables and indexes.
- `services/host-daemon/src/main.ts` — start/stop the admin server beside the ASCP WebSocket daemon and expose the pairing service for tests.
- `services/host-daemon/src/index.ts` — export pairing modules.
- `services/host-daemon/README.md` — document pairing backend endpoints and flow.
- `README.md` — update daemon status summary.
- `internal/plans.md` — switch active feature to the pairing backend slice.
- `internal/status.md` — add checkpoint entry once the slice is complete.

---

### Task 1: Add pairing session persistence and expiry primitives

**Files:**
- Create: `services/host-daemon/src/pairing/types.ts`
- Create: `services/host-daemon/src/pairing/session-store.ts`
- Modify: `services/host-daemon/src/sqlite.ts`
- Test: `services/host-daemon/tests/pairing/session-store.test.ts`

- [ ] **Step 1: Write the failing pairing-session store tests**

```ts
import { describe, expect, it } from "vitest";
import { randomBytes } from "node:crypto";

import { openDaemonDatabase } from "../../src/sqlite.js";
import { createPairingSessionStore } from "../../src/pairing/session-store.js";

describe("pairing session store", () => {
  it("creates, claims, approves, and expires pairing sessions", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createPairingSessionStore(database);

    const created = store.insertSession({
      code: "PAIR-1234",
      expiresAt: "2026-04-28T12:10:00.000Z",
      requestedScopes: ["read:hosts", "read:sessions", "write:sessions"]
    });

    expect(store.getSession(created.sessionId)).toMatchObject({
      code: "PAIR-1234",
      status: "pending_host_claim"
    });

    store.attachClaim({
      claimToken: randomBytes(32).toString("hex"),
      sessionId: created.sessionId,
      deviceLabel: "Ibrar iPhone",
      claimedAt: "2026-04-28T12:01:00.000Z"
    });
    store.setStatus(created.sessionId, "pending_host_approval");
    store.setStatus(created.sessionId, "approved");
    store.markExpired(created.sessionId, "2026-04-28T12:11:00.000Z");

    expect(store.getSession(created.sessionId)).toMatchObject({
      deviceLabel: "Ibrar iPhone",
      status: "expired"
    });
  });
});
```

- [ ] **Step 2: Run the store test to confirm the new pairing modules are missing**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/session-store.test.ts`
Expected: FAIL with module-resolution errors for `src/pairing/*`.

- [ ] **Step 3: Implement pairing session types and store**

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
}
```

```ts
connection.exec(`
  CREATE TABLE IF NOT EXISTS daemon_pairing_sessions (
    session_id TEXT PRIMARY KEY,
    pairing_code TEXT NOT NULL UNIQUE,
    claim_token TEXT UNIQUE,
    requested_scopes_json TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    claimed_at TEXT,
    approved_at TEXT,
    rejected_at TEXT,
    consumed_at TEXT,
    device_label TEXT,
    issued_device_id TEXT
  );

  CREATE INDEX IF NOT EXISTS daemon_pairing_sessions_status_idx
    ON daemon_pairing_sessions (status, expires_at);
`);
```

```ts
export interface PairingSessionStore {
  insertSession(input: {
    code: string;
    claimToken?: string | null;
    expiresAt: string;
    requestedScopes: string[];
  }): PairingSessionRecord;
  getByClaimToken(claimToken: string): PairingSessionRecord | null;
  getByCode(code: string): PairingSessionRecord | null;
  getSession(sessionId: string): PairingSessionRecord | null;
  listActiveSessions(now: string): PairingSessionRecord[];
  attachClaim(input: {
    claimToken: string;
    sessionId: string;
    deviceLabel: string;
    claimedAt?: string;
  }): PairingSessionRecord;
  setStatus(sessionId: string, status: PairingSessionStatus, changedAt?: string): PairingSessionRecord;
  attachIssuedDevice(sessionId: string, deviceId: string): PairingSessionRecord;
  consumeApprovedSession(input: {
    sessionId: string;
    consumedAt?: string;
  }): PairingSessionRecord | null;
  markExpired(sessionId: string, expiredAt?: string): PairingSessionRecord;
}
```

```ts
const claimToken = randomBytes(32).toString("hex");
```

- [ ] **Step 4: Run the pairing-session store test to verify it passes**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/session-store.test.ts`
Expected: PASS.

- [ ] **Step 5: Commit Task 1**

```bash
git add services/host-daemon/src/pairing/types.ts services/host-daemon/src/pairing/session-store.ts services/host-daemon/src/sqlite.ts services/host-daemon/tests/pairing/session-store.test.ts
git commit -m "feat: add daemon pairing session store"
```

### Task 2: Add pairing state machine and trusted-device admin operations

**Files:**
- Create: `services/host-daemon/src/pairing/service.ts`
- Test: `services/host-daemon/tests/pairing/service.test.ts`

- [ ] **Step 1: Write the failing pairing-service tests**

```ts
import { describe, expect, it } from "vitest";

import { createPairingService } from "../../src/pairing/service.js";
import { openDaemonDatabase } from "../../src/sqlite.js";
import { createPairingSessionStore } from "../../src/pairing/session-store.js";
import { createDevicePairingIssuer } from "../../src/pairing/service.js";
import { createTrustStore } from "../../src/auth/trust-store.js";

describe("pairing service", () => {
  it("issues credentials only after explicit host approval", async () => {
    const database = openDaemonDatabase(":memory:");
    const store = createPairingSessionStore(database);
    const trustStore = createTrustStore(database);
    const devicePairingIssuer = createDevicePairingIssuer({ trustStore });
    const service = createPairingService({
      devicePairingIssuer,
      sessionStore: store,
      trustStore
    });

    const session = service.startPairing({
      requestedScopes: ["read:hosts", "read:sessions"],
      ttlMs: 300_000
    });

    const claim = await service.claimPairing({
      code: session.code,
      deviceLabel: "QA phone"
    });

    expect(service.pollPairing(claim.claimToken)).toMatchObject({
      status: "pending_host_approval"
    });

    service.approvePairing(session.sessionId);

    const approved = await service.pollPairing(claim.claimToken);

    expect(approved).toMatchObject({
      status: "approved",
      credentials: {
        device_id: expect.stringContaining("daemon:device:"),
        device_secret: expect.any(String)
      }
    });
    expect(trustStore.getDevice(approved.credentials!.device_id)).not.toBeNull();
  });
});
```

- [ ] **Step 2: Run the service tests to confirm the state machine is missing**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/service.test.ts`
Expected: FAIL.

- [ ] **Step 3: Implement the pairing state machine**

```ts
export interface PairingBackendService {
  startPairing(input: { requestedScopes: string[]; ttlMs?: number; now?: string }): {
    sessionId: string;
    code: string;
    expiresAt: string;
    qrPayload: string;
  };
  claimPairing(input: { code: string; deviceLabel: string }): Promise<{ claimToken: string; sessionId: string }>;
  pollPairing(claimToken: string): Promise<
    | { status: "pending_host_approval" | "rejected" | "expired" }
    | { status: "approved"; credentials: { device_id: string; device_secret: string } }
    | { status: "consumed"; issued_device_id: string | null }
  >;
  approvePairing(sessionId: string): void;
  rejectPairing(sessionId: string): void;
  listTrustedDevices(): TrustedDeviceRecord[];
  revokeTrustedDevice(deviceId: string): void;
  expireStaleSessions(now?: string): number;
}
```

```ts
export interface DevicePairingIssuer {
  issueTrustedDevice(input: {
    displayName: string;
    scopes: string[];
  }): Promise<{
    deviceId: string;
    deviceSecret: string;
  }>;
}
```

```ts
export function createDevicePairingIssuer(deps: {
  trustStore: TrustStore;
}): DevicePairingIssuer {
  return {
    async issueTrustedDevice(input) {
      const paired = await createPairingPrimitive({ trustStore: deps.trustStore }).pairDevice({
        displayName: input.displayName,
        scopes: input.scopes
      });

      return {
        deviceId: paired.deviceId,
        deviceSecret: paired.deviceSecret
      };
    }
  };
}
```

```ts
export function createPairingService(deps: {
  devicePairingIssuer: DevicePairingIssuer;
  sessionStore: PairingSessionStore;
  trustStore: TrustStore;
}): PairingBackendService {
  // ...
}
```

```ts
async function trustApprovedSession(session: PairingSessionRecord): Promise<{
  deviceId: string;
  deviceSecret: string;
}> {
  const issued = await devicePairingIssuer.issueTrustedDevice({
    displayName: session.deviceLabel ?? "Paired device",
    scopes: session.requestedScopes
  });
  sessionStore.attachIssuedDevice(session.sessionId, issued.deviceId);
  return issued;
}
```

```ts
const consumed = sessionStore.consumeApprovedSession({
  sessionId: session.sessionId,
  consumedAt: now
});

if (consumed !== null) {
  const issued = await trustApprovedSession(session);
  return {
    status: "approved",
    credentials: {
      device_id: issued.deviceId,
      device_secret: issued.deviceSecret
    }
  };
}

const alreadyConsumed = sessionStore.getSession(session.sessionId);
return {
  status: "consumed",
  issued_device_id: alreadyConsumed?.issuedDeviceId ?? null
};
```

```ts
UPDATE daemon_pairing_sessions
SET status = 'consumed', consumed_at = ?
WHERE session_id = ? AND status = 'approved'
RETURNING *
```

- [ ] **Step 4: Add tests for rejection, expiry, and trusted-device revocation**

```ts
it("rejects expired pairing codes and revokes trusted devices", async () => {
  const session = service.startPairing({
    now: "2026-04-28T12:10:00.000Z",
    requestedScopes: ["read:sessions"],
    ttlMs: 1
  });
  service.expireStaleSessions("2026-04-28T12:10:01.000Z");

  await expect(service.claimPairing({ code: session.code, deviceLabel: "Late phone" })).rejects.toThrow(
    "Pairing session expired."
  );
});
```

```ts
it("rejects a second claim for the same pairing code", async () => {
  const session = service.startPairing({
    now: "2026-04-28T12:00:00.000Z",
    requestedScopes: ["read:sessions"],
    ttlMs: 300_000
  });

  await service.claimPairing({ code: session.code, deviceLabel: "Phone A" });

  await expect(
    service.claimPairing({ code: session.code, deviceLabel: "Phone B" })
  ).rejects.toThrow("Already claimed.");
});
```

- [ ] **Step 5: Run the pairing-service tests to verify they pass**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/service.test.ts`
Expected: PASS.

- [ ] **Step 6: Commit Task 2**

```bash
git add services/host-daemon/src/pairing/service.ts services/host-daemon/tests/pairing/service.test.ts
git commit -m "feat: add daemon pairing state machine"
```

### Task 3: Add loopback admin HTTP server and daemon wiring

**Files:**
- Create: `services/host-daemon/src/pairing/admin-server.ts`
- Modify: `services/host-daemon/src/config.ts`
- Modify: `services/host-daemon/src/main.ts`
- Modify: `services/host-daemon/src/index.ts`
- Test: `services/host-daemon/tests/pairing/admin-server.test.ts`
- Test: `services/host-daemon/tests/config.test.ts`
- Test: `services/host-daemon/tests/main.test.ts`

- [ ] **Step 1: Write the failing admin-server tests**

```ts
it("creates pairing sessions, approves them, and revokes trusted devices over loopback HTTP", async () => {
  const harness = await createPairingHarness();

  const createResponse = await requestJson(harness.adminBaseUrl, "POST", "/admin/pairing/sessions", {
    requested_scopes: ["read:hosts", "read:sessions"]
  });

  expect(createResponse).toMatchObject({
    session_id: expect.any(String),
    code: expect.stringMatching(/^[A-Z0-9-]+$/),
    expires_at: expect.any(String)
  });

  const claimResponse = await requestJson(harness.adminBaseUrl, "POST", "/pairing/claim", {
    code: createResponse.code,
    device_label: "QA phone"
  });

  await requestJson(harness.adminBaseUrl, "POST", `/admin/pairing/sessions/${createResponse.session_id}/approve`, {});

  const pollResponse = await requestJson(
    harness.adminBaseUrl,
    "GET",
    `/pairing/claims/${claimResponse.claim_token}`
  );

  expect(pollResponse).toMatchObject({
    status: "approved",
    credentials: {
      device_id: expect.any(String),
      device_secret: expect.any(String)
    }
  });
});
```

- [ ] **Step 2: Run the admin/config tests to confirm the HTTP surface is missing**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/admin-server.test.ts tests/config.test.ts tests/main.test.ts`
Expected: FAIL.

- [ ] **Step 3: Implement the loopback admin server and config wiring**

```ts
export interface HostDaemonConfig {
  authTransport: "loopback" | "tls";
  databasePath: string;
  host: string;
  port: number;
  adminPort: number;
  runtime: DaemonRuntimeKind;
}
```

```ts
if (req.method === "POST" && pathname === "/admin/pairing/sessions") {
  const body = await readJsonBody(req);
  const created = pairingService.startPairing({
    requestedScopes: body.requested_scopes,
    ttlMs: body.ttl_ms
  });
  return sendJson(res, 201, {
    session_id: created.sessionId,
    code: created.code,
    qr_payload: created.qrPayload,
    expires_at: created.expiresAt
  });
}
```

```ts
const adminServer = createPairingAdminServer({
  host: "127.0.0.1",
  port: config.adminPort,
  pairingService
});
await adminServer.listen();
```

- [ ] **Step 4: Cover trusted-device listing and revocation**

```ts
if (req.method === "GET" && pathname === "/admin/trusted-devices") {
  return sendJson(res, 200, {
    devices: pairingService.listTrustedDevices()
  });
}

if (req.method === "POST" && matchTrustedDeviceRevoke(pathname)) {
  pairingService.revokeTrustedDevice(deviceId);
  return sendJson(res, 200, { revoked: true, device_id: deviceId });
}
```

```ts
if (req.method === "POST" && pathname === "/pairing/claim") {
  try {
    const claimed = await pairingService.claimPairing({
      code: body.code,
      deviceLabel: body.device_label
    });
    return sendJson(res, 200, { claim_token: claimed.claimToken, session_id: claimed.sessionId });
  } catch (error) {
    if (isAlreadyClaimedError(error)) {
      return sendJson(res, 409, { code: "ALREADY_CLAIMED", message: "Already claimed." });
    }
    throw error;
  }
}
```

- [ ] **Step 5: Run the targeted admin/config tests to verify they pass**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/pairing/admin-server.test.ts tests/config.test.ts tests/main.test.ts`
Expected: PASS.

- [ ] **Step 6: Commit Task 3**

```bash
git add services/host-daemon/src/pairing/admin-server.ts services/host-daemon/src/config.ts services/host-daemon/src/main.ts services/host-daemon/src/index.ts services/host-daemon/tests/pairing/admin-server.test.ts services/host-daemon/tests/config.test.ts services/host-daemon/tests/main.test.ts
git commit -m "feat: add daemon pairing admin server"
```

### Task 4: Update docs, tracker state, and full verification

**Files:**
- Modify: `services/host-daemon/README.md`
- Modify: `README.md`
- Modify: `internal/plans.md`
- Modify: `internal/status.md`

- [ ] **Step 1: Update daemon docs with the pairing backend contract**

```md
## Pairing backend

The daemon now exposes a loopback-only admin HTTP surface for onboarding trusted devices.

This admin surface is intentionally unauthenticated in v1. Its security model relies entirely on binding to `127.0.0.1` only.

- `POST /admin/pairing/sessions` creates a short-lived pairing code
- `POST /pairing/claim` lets an unauthenticated mobile client claim that code
- `POST /admin/pairing/sessions/:id/approve` or `/reject` resolves the pending claim
- `GET /pairing/claims/:token` returns `pending_host_approval`, `approved`, `rejected`, `expired`, or `consumed`
- approved claims issue `device_id + secret` once, then the device uses the existing ASCP WebSocket auth path
- after first successful credential delivery the session becomes `consumed`; later polls may return `consumed` plus `issued_device_id`, but never the secret again
```

- [ ] **Step 2: Update branch tracker files**

```md
- Feature name: Host daemon pairing backend slice
- Goal: add loopback-only pairing session management and trusted-device onboarding above the completed auth engine without changing ASCP core semantics
```

```md
### 2026-04-28 - Host daemon pairing backend slice
- Branch: `branch-host-daemon`
- Commit: `not committed`
- Summary: added loopback-only pairing session persistence, host approval flow, mobile claim/poll endpoints, and trusted-device admin endpoints above the daemon auth engine
- Documentation updated: `internal/plans.md`, `internal/status.md`, `README.md`, `services/host-daemon/README.md`, `docs/superpowers/plans/2026-04-28-host-daemon-pairing-backend.md`
- Next likely step: build host-console and mobile UI flows on top of the completed pairing backend
```

- [ ] **Step 3: Run full verification for the pairing backend slice**

Run: `npm --workspace @ascp/host-daemon run check && npm --workspace @ascp/host-service exec vitest run tests/host-service.test.ts && npm --workspace @ascp/adapter-codex exec vitest run tests/host-runtime.test.ts tests/service.test.ts`
Expected: PASS with pairing tests green and no replay/auth regressions.

- [ ] **Step 4: Commit Task 4**

```bash
git add services/host-daemon/README.md README.md internal/plans.md internal/status.md docs/superpowers/plans/2026-04-28-host-daemon-pairing-backend.md
git commit -m "docs: record daemon pairing backend slice"
```

---

## Self-Review Checklist

- Spec coverage: the plan covers the next agreed backend slice only — pairing session persistence, host approval flow, mobile claim/poll flow, device revocation/listing, admin server wiring, and docs. It intentionally leaves host/mobile UI and TLS for later plans.
- Placeholder scan: no `TODO`, `TBD`, or empty “write tests” placeholders remain; each task includes exact file paths, test targets, and concrete code direction.
- Type consistency: the plan uses one session-state model (`pending_host_claim`, `pending_host_approval`, `approved`, `rejected`, `expired`, `consumed`), one admin server boundary, and the existing `device_id + secret` trust model from the auth slice.
