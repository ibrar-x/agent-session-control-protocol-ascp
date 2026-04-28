# Host Daemon Auth Trust Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add daemon-owned host-wide device pairing, loopback-only device-secret authentication, scope enforcement, and audit attribution above the existing daemon replay boundary without changing ASCP core method or event semantics.

**Architecture:** Keep `packages/host-service` as the WebSocket JSON-RPC transport primitive, but extend it with an optional daemon auth context hook and connection gate so the daemon can authenticate a paired device once per socket and authorize each method call centrally before any adapter/runtime invocation. Store device trust records in daemon-owned SQLite, expose truthful additive auth metadata through `capabilities.get`, and record daemon-generated correlation IDs plus allow/deny outcomes for every request.

**Tech Stack:** TypeScript, Node 22 `node:sqlite`, `node:crypto` (`scrypt`, `timingSafeEqual`, `randomBytes`, `randomUUID`), Vitest, existing `@ascp/host-service`, existing `@ascp/host-daemon` replay stores.

---

## File Map

### New files
- `services/host-daemon/src/auth/types.ts` — auth transport mode, trust record, request context, audit record, pairing result, and scope types.
- `services/host-daemon/src/auth/scopes.ts` — scope constants and method-to-scope policy helpers.
- `services/host-daemon/src/auth/errors.ts` — daemon auth error helpers that normalize to truthful ASCP `UNAUTHORIZED` and `FORBIDDEN` failures.
- `services/host-daemon/src/auth/crypto.ts` — `scrypt` verifier creation and secret verification helpers.
- `services/host-daemon/src/auth/trust-store.ts` — SQLite trust record persistence, revocation, and lookup.
- `services/host-daemon/src/auth/audit-store.ts` — SQLite audit record persistence and query helpers.
- `services/host-daemon/src/auth/pairing-service.ts` — create trusted device records and issue raw device secrets.
- `services/host-daemon/src/auth/authenticator.ts` — socket-level device authentication using `device_id + secret`.
- `services/host-daemon/src/auth/authorizer.ts` — method-level scope checks.
- `services/host-daemon/src/auth/runtime.ts` — auth-aware runtime wrapper that enriches `capabilities.get` and delegates request-context operations.
- `services/host-daemon/tests/auth/crypto.test.ts`
- `services/host-daemon/tests/auth/trust-store.test.ts`
- `services/host-daemon/tests/auth/pairing-service.test.ts`
- `services/host-daemon/tests/auth/authenticator.test.ts`
- `services/host-daemon/tests/auth/authorizer.test.ts`
- `services/host-daemon/tests/auth/runtime.test.ts`
- `services/host-daemon/tests/auth/integration-auth.test.ts`

### Modified files
- `packages/host-service/src/index.ts` — add optional connection authentication hook, per-request context factory, and audit callback support without changing ASCP method names.
- `packages/host-service/tests/host-service.test.ts` — cover auth handshake failures, `UNAUTHORIZED`, `FORBIDDEN`, and audit callback sequencing.
- `services/host-daemon/src/config.ts` — add auth transport mode, database path defaulting, and loopback-only validation for v1 auth.
- `services/host-daemon/src/sqlite.ts` — ensure auth tables initialize on daemon startup.
- `services/host-daemon/src/main.ts` — wire trust store, pairing service, authenticator, authorizer, audit store, and auth-aware host-service hooks.
- `services/host-daemon/src/index.ts` — export auth modules.
- `services/host-daemon/README.md` — document pairing, transport restriction, and scope behavior.
- `README.md` — update daemon feature status summary.
- `internal/plans.md` — switch active feature from replay persistence to auth/trust slice before implementation starts.
- `internal/status.md` — add checkpoint entry after the slice is complete.

---

### Task 1: Add daemon trust storage and pairing primitives

**Files:**
- Create: `services/host-daemon/src/auth/types.ts`
- Create: `services/host-daemon/src/auth/scopes.ts`
- Create: `services/host-daemon/src/auth/errors.ts`
- Create: `services/host-daemon/src/auth/crypto.ts`
- Create: `services/host-daemon/src/auth/trust-store.ts`
- Create: `services/host-daemon/src/auth/audit-store.ts`
- Create: `services/host-daemon/src/auth/pairing-service.ts`
- Modify: `services/host-daemon/src/sqlite.ts`
- Modify: `services/host-daemon/src/index.ts`
- Test: `services/host-daemon/tests/auth/crypto.test.ts`
- Test: `services/host-daemon/tests/auth/trust-store.test.ts`
- Test: `services/host-daemon/tests/auth/pairing-service.test.ts`

- [ ] **Step 1: Write the failing crypto and trust-store tests**

```ts
import { describe, expect, it } from "vitest";

import { createDeviceSecretVerifier, verifyDeviceSecret } from "../../src/auth/crypto.js";
import { openDaemonDatabase } from "../../src/sqlite.js";
import { createTrustStore } from "../../src/auth/trust-store.js";

describe("createDeviceSecretVerifier", () => {
  it("verifies the original secret and rejects a different one", async () => {
    const verifier = await createDeviceSecretVerifier("top-secret-device-key");

    await expect(verifyDeviceSecret(verifier, "top-secret-device-key")).resolves.toBe(true);
    await expect(verifyDeviceSecret(verifier, "wrong-secret")).resolves.toBe(false);
  });
});

describe("trust store", () => {
  it("persists a paired device and supports revocation", async () => {
    const database = openDaemonDatabase(":memory:");
    const trustStore = createTrustStore(database);

    await trustStore.upsertDevice({
      deviceId: "device-1",
      displayName: "Ibrar iPhone",
      scopes: ["read:sessions", "write:sessions"],
      secretSalt: "salt",
      secretVerifier: "verifier",
      kdf: "scrypt",
      kdfParams: { N: 16384, r: 8, p: 1 }
    });

    expect(await trustStore.getDevice("device-1")).toMatchObject({
      deviceId: "device-1",
      revoked: false,
      scopes: ["read:sessions", "write:sessions"]
    });

    await trustStore.revokeDevice("device-1");
    expect(await trustStore.getDevice("device-1")).toMatchObject({ revoked: true });
  });
});
```

- [ ] **Step 2: Run the auth store tests to confirm missing modules fail**

Run: `npm --workspace @ascp/host-daemon exec vitest run services/host-daemon/tests/auth/crypto.test.ts services/host-daemon/tests/auth/trust-store.test.ts`
Expected: FAIL with module resolution or missing export errors for `src/auth/*`.

- [ ] **Step 3: Implement auth types, crypto, trust store, audit store, and pairing service**

```ts
export type AuthTransportMode = "loopback" | "tls";

export interface DeviceVerifierRecord {
  kdf: "scrypt";
  kdfParams: { N: number; r: number; p: number; keylen: number };
  secretSalt: string;
  secretVerifier: string;
}

export interface TrustedDeviceRecord extends DeviceVerifierRecord {
  deviceId: string;
  displayName: string;
  scopes: string[];
  pairedAt: string;
  lastSeenAt: string | null;
  revoked: boolean;
  revokedAt: string | null;
}
```

```ts
import { randomBytes, scrypt as scryptCallback, timingSafeEqual } from "node:crypto";
import { promisify } from "node:util";

const scrypt = promisify(scryptCallback);

export async function createDeviceSecretVerifier(secret: string) {
  const salt = randomBytes(16);
  const derived = (await scrypt(secret, salt, 32, { N: 16384, r: 8, p: 1 })) as Buffer;

  return {
    kdf: "scrypt" as const,
    kdfParams: { N: 16384, r: 8, p: 1, keylen: 32 },
    secretSalt: salt.toString("base64"),
    secretVerifier: derived.toString("base64")
  };
}

export async function verifyDeviceSecret(record: DeviceVerifierRecord, presentedSecret: string) {
  const derived = (await scrypt(
    presentedSecret,
    Buffer.from(record.secretSalt, "base64"),
    record.kdfParams.keylen,
    { N: record.kdfParams.N, r: record.kdfParams.r, p: record.kdfParams.p }
  )) as Buffer;

  return timingSafeEqual(derived, Buffer.from(record.secretVerifier, "base64"));
}
```

```ts
export interface PairDeviceResult {
  deviceId: string;
  deviceSecret: string;
  record: TrustedDeviceRecord;
}

export async function pairDevice(input: {
  displayName: string;
  scopes: string[];
}): Promise<PairDeviceResult> {
  const deviceSecret = randomBytes(32).toString("base64url");
  const verifier = await createDeviceSecretVerifier(deviceSecret);
  const deviceId = `daemon:device:${randomUUID()}`;
  const record = await trustStore.upsertDevice({
    deviceId,
    displayName: input.displayName,
    scopes: input.scopes,
    ...verifier
  });

  return { deviceId, deviceSecret, record };
}
```

- [ ] **Step 4: Add SQLite table creation for trust and audit storage**

```ts
connection.exec(`
  CREATE TABLE IF NOT EXISTS trusted_devices (
    device_id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    scopes_json TEXT NOT NULL,
    paired_at TEXT NOT NULL,
    last_seen_at TEXT,
    revoked INTEGER NOT NULL DEFAULT 0,
    revoked_at TEXT,
    secret_salt TEXT NOT NULL,
    secret_verifier TEXT NOT NULL,
    kdf TEXT NOT NULL,
    kdf_params_json TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS audit_log (
    correlation_id TEXT PRIMARY KEY,
    ts TEXT NOT NULL,
    method TEXT NOT NULL,
    request_id TEXT,
    device_id TEXT,
    actor_id TEXT,
    transport_mode TEXT NOT NULL,
    auth_state TEXT NOT NULL,
    authorization_state TEXT NOT NULL,
    outcome TEXT NOT NULL,
    error_code TEXT,
    details_json TEXT
  );
`);
```

- [ ] **Step 5: Run the new auth-unit tests to verify they pass**

Run: `npm --workspace @ascp/host-daemon exec vitest run services/host-daemon/tests/auth/crypto.test.ts services/host-daemon/tests/auth/trust-store.test.ts services/host-daemon/tests/auth/pairing-service.test.ts`
Expected: PASS with all trust and pairing tests green.

- [ ] **Step 6: Commit Task 1**

```bash
git add services/host-daemon/src/auth services/host-daemon/src/sqlite.ts services/host-daemon/src/index.ts services/host-daemon/tests/auth
git commit -m "feat: add daemon trust store and pairing primitives"
```

### Task 2: Add socket authentication, authorization, and audit plumbing to `@ascp/host-service`

**Files:**
- Create: `services/host-daemon/src/auth/authenticator.ts`
- Create: `services/host-daemon/src/auth/authorizer.ts`
- Modify: `packages/host-service/src/index.ts`
- Modify: `packages/host-service/tests/host-service.test.ts`
- Test: `services/host-daemon/tests/auth/authenticator.test.ts`
- Test: `services/host-daemon/tests/auth/authorizer.test.ts`

- [ ] **Step 1: Write the failing host-service auth tests first**

```ts
it("rejects requests from unauthenticated sockets", async () => {
  const runtime = createRuntimeStub();
  const service = createAscpHostService({
    runtime,
    authorizeConnection: async () => ({ authenticated: false, transportMode: "loopback" }),
    createRequestContext: async () => {
      throw createAscpUnauthorizedError("Device authentication required.");
    }
  });

  const client = await connectClient(service);
  const response = await sendJsonRpc(client, {
    id: "1",
    jsonrpc: "2.0",
    method: "sessions.list",
    params: {}
  });

  expect(response.error.code).toBe("UNAUTHORIZED");
});

it("rejects authenticated devices without write scope", async () => {
  const runtime = createRuntimeStub();
  const service = createAscpHostService({
    runtime,
    authorizeConnection: async () => ({ authenticated: true, deviceId: "device-1", scopes: ["read:sessions"], transportMode: "loopback" }),
    createRequestContext: async ({ method, connectionAuth }) => ({
      correlationId: "corr-1",
      method,
      deviceId: connectionAuth.deviceId!,
      scopes: connectionAuth.scopes,
      transportMode: connectionAuth.transportMode
    })
  });

  const client = await connectClient(service);
  const response = await sendJsonRpc(client, {
    id: "2",
    jsonrpc: "2.0",
    method: "sessions.send_input",
    params: { session_id: "session-1", input: { type: "text", text: "hi" } }
  });

  expect(response.error.code).toBe("FORBIDDEN");
});
```

- [ ] **Step 2: Run the host-service tests to confirm the new hooks do not exist yet**

Run: `npm --workspace @ascp/host-service exec vitest run tests/host-service.test.ts`
Expected: FAIL with type errors or missing option/property failures for `authorizeConnection` and `createRequestContext`.

- [ ] **Step 3: Implement authenticator and authorizer helpers in the daemon package**

```ts
export async function authenticateDevice(input: {
  deviceId?: string;
  deviceSecret?: string;
  transportMode: AuthTransportMode;
}): Promise<AuthenticatedConnection> {
  if (input.transportMode !== "loopback") {
    throw createAscpUnauthorizedError("Device-secret authentication requires loopback transport.");
  }

  if (input.deviceId === undefined || input.deviceSecret === undefined) {
    throw createAscpUnauthorizedError("Missing device credentials.");
  }

  const record = await trustStore.getDevice(input.deviceId);
  if (record === null || record.revoked) {
    throw createAscpUnauthorizedError("Unknown or revoked device.");
  }

  if (!(await verifyDeviceSecret(record, input.deviceSecret))) {
    throw createAscpUnauthorizedError("Invalid device secret.");
  }

  await trustStore.markSeen(record.deviceId);
  return { authenticated: true, deviceId: record.deviceId, scopes: record.scopes, transportMode: input.transportMode };
}
```

```ts
const METHOD_SCOPE_POLICY: Partial<Record<CoreMethodName, string>> = {
  "hosts.get": "read:hosts",
  "runtimes.list": "read:runtimes",
  "sessions.list": "read:sessions",
  "sessions.get": "read:sessions",
  "sessions.subscribe": "read:sessions",
  "sessions.unsubscribe": "read:sessions",
  "sessions.start": "write:sessions",
  "sessions.resume": "write:sessions",
  "sessions.stop": "write:sessions",
  "sessions.send_input": "write:sessions",
  "approvals.list": "read:approvals",
  "approvals.respond": "write:approvals",
  "artifacts.list": "read:artifacts",
  "artifacts.get": "read:artifacts",
  "diffs.get": "read:artifacts"
};
```

- [ ] **Step 4: Extend `createAscpHostService` with auth hooks and audit callbacks**

```ts
export interface ConnectionAuthState {
  authenticated: boolean;
  deviceId?: string;
  scopes: string[];
  transportMode: "loopback" | "tls";
}

export interface RequestContext {
  correlationId: string;
  method: CoreMethodName;
  deviceId?: string;
  actorId?: string;
  scopes: string[];
  transportMode: "loopback" | "tls";
}

export interface AscpHostServiceOptions {
  runtime: AscpHostRuntime;
  host?: string;
  port?: number;
  authorizeConnection?: (request: IncomingMessage) => Promise<ConnectionAuthState>;
  createRequestContext?: (input: {
    connectionAuth: ConnectionAuthState;
    method: CoreMethodName;
    requestId: RequestId;
    params: JsonObject;
  }) => Promise<RequestContext>;
  onRequestAudit?: (entry: RequestAuditEntry) => Promise<void>;
}
```

```ts
const connectionAuth = this.socketAuth.get(socket) ?? { authenticated: false, scopes: [], transportMode: "loopback" };
const requestContext = await this.createRequestContext?.({
  connectionAuth,
  method: value.method as CoreMethodName,
  requestId: value.id,
  params: value.params ?? {}
});
await this.onRequestAudit?.({ stage: "received", method: value.method as CoreMethodName, correlationId: requestContext?.correlationId ?? randomUUID(), deviceId: requestContext?.deviceId, authenticated: connectionAuth.authenticated });
```

- [ ] **Step 5: Run targeted auth and host-service tests**

Run: `npm --workspace @ascp/host-service exec vitest run tests/host-service.test.ts && npm --workspace @ascp/host-daemon exec vitest run services/host-daemon/tests/auth/authenticator.test.ts services/host-daemon/tests/auth/authorizer.test.ts`
Expected: PASS with `UNAUTHORIZED`, `FORBIDDEN`, and audit-hook coverage validated.

- [ ] **Step 6: Commit Task 2**

```bash
git add packages/host-service/src/index.ts packages/host-service/tests/host-service.test.ts services/host-daemon/src/auth/authenticator.ts services/host-daemon/src/auth/authorizer.ts
git commit -m "feat: add host-service auth and audit hooks"
```

### Task 3: Wire daemon auth into capabilities, runtime startup, and end-to-end flows

**Files:**
- Create: `services/host-daemon/src/auth/runtime.ts`
- Modify: `services/host-daemon/src/config.ts`
- Modify: `services/host-daemon/src/main.ts`
- Modify: `services/host-daemon/src/index.ts`
- Modify: `services/host-daemon/README.md`
- Modify: `README.md`
- Modify: `internal/plans.md`
- Modify: `internal/status.md`
- Test: `services/host-daemon/tests/auth/runtime.test.ts`
- Test: `services/host-daemon/tests/auth/integration-auth.test.ts`
- Test: `services/host-daemon/tests/config.test.ts`
- Test: `services/host-daemon/tests/main.test.ts`

- [ ] **Step 1: Write the failing daemon integration tests**

```ts
it("adds auth.transport metadata to capabilities.get", async () => {
  const runtime = createRuntimeStub({
    capabilitiesGet: async () => ({ protocol_version: "0.1.0", host: { id: "host-1", capabilities: { replay: true } } })
  });

  const wrapped = createAuthAwareRuntime({
    runtime,
    transportMode: "loopback"
  });

  await expect(wrapped.capabilitiesGet()).resolves.toMatchObject({
    auth: { transport: "loopback" }
  });
});

it("authenticates one paired device and allows read but denies write without scope", async () => {
  const harness = await createDaemonHarness();
  const pair = await harness.pairDevice({ displayName: "QA phone", scopes: ["read:sessions"] });
  const client = await harness.connectAuthenticated(pair);

  await expect(client.call("sessions.list", {})).resolves.toHaveProperty("result.sessions");
  await expect(
    client.call("sessions.send_input", { session_id: "session-1", input: { type: "text", text: "hi" } })
  ).resolves.toMatchObject({ error: { code: "FORBIDDEN" } });
});
```

- [ ] **Step 2: Run the daemon auth tests to confirm the wrapper and config logic are missing**

Run: `npm --workspace @ascp/host-daemon exec vitest run services/host-daemon/tests/auth/runtime.test.ts services/host-daemon/tests/auth/integration-auth.test.ts services/host-daemon/tests/config.test.ts services/host-daemon/tests/main.test.ts`
Expected: FAIL with missing `createAuthAwareRuntime`, missing auth config, or missing authenticated harness support.

- [ ] **Step 3: Implement auth-aware runtime capabilities and startup wiring**

```ts
export function createAuthAwareRuntime(deps: {
  runtime: Pick<AscpHostRuntime, "capabilitiesGet"> & Record<string, unknown>;
  transportMode: AuthTransportMode;
}) {
  return {
    ...deps.runtime,
    async capabilitiesGet() {
      const capabilities = await deps.runtime.capabilitiesGet();
      return {
        ...capabilities,
        auth: {
          ...(typeof capabilities === "object" && capabilities !== null && "auth" in capabilities
            ? (capabilities as { auth?: Record<string, unknown> }).auth ?? {}
            : {}),
          transport: deps.transportMode
        }
      };
    }
  };
}
```

```ts
export interface HostDaemonConfig {
  host: string;
  port: number;
  runtime: DaemonRuntimeKind;
  authTransport: "loopback" | "tls";
  databasePath: string;
}

if (authTransport === "loopback" && host !== "127.0.0.1" && host !== "localhost") {
  throw new Error(`ASCP auth transport loopback requires a local-only host binding: ${host}`);
}
```

```ts
const trustStore = createTrustStore(database);
const auditStore = createAuditStore(database);
const pairingService = createPairingService({ trustStore });
const authenticator = createAuthenticator({ trustStore, transportMode: config.authTransport });
const authorizer = createAuthorizer();
const authAwareRuntime = createAuthAwareRuntime({
  runtime: replayBackedRuntime,
  transportMode: config.authTransport
});
const hostService = createAscpHostService({
  host: config.host,
  port: config.port,
  runtime: authAwareRuntime,
  authorizeConnection: async (request) => authenticator.authenticateRequest(request),
  createRequestContext: async ({ connectionAuth, method, requestId, params }) =>
    authorizer.createRequestContext({ connectionAuth, method, requestId, params }),
  onRequestAudit: async (entry) => auditStore.append(entry)
});
```

- [ ] **Step 4: Update README and checkpoint docs once the code is green**

```md
## Auth and trust

`@ascp/host-daemon` now supports host-wide paired-device trust above all adapters.

- pairing is daemon-wide, not per runtime
- v1 reconnect uses `device_id + secret` on loopback-only transport
- daemon enforces scopes before runtime calls
- `capabilities.get` includes additive `auth.transport`
```

- [ ] **Step 5: Run full host-daemon verification for the slice**

Run: `npm --workspace @ascp/host-daemon run check && npm --workspace @ascp/host-service exec vitest run tests/host-service.test.ts && npm --workspace @ascp/adapter-codex exec vitest run tests/host-runtime.test.ts tests/service.test.ts`
Expected: PASS, with no replay regressions and auth behavior validated.

- [ ] **Step 6: Commit Task 3**

```bash
git add services/host-daemon/src services/host-daemon/tests services/host-daemon/README.md README.md internal/plans.md internal/status.md packages/host-service/src/index.ts packages/host-service/tests/host-service.test.ts
git commit -m "feat: add daemon auth and trust enforcement"
```

---

## Self-Review Checklist

- Spec coverage: each section of `docs/superpowers/specs/2026-04-28-host-daemon-auth-trust-design.md` maps to at least one task above: trust records (Task 1), `scrypt` verification (Task 1), loopback transport enforcement (Task 3), daemon-owned correlation IDs and audit logging (Task 2 + Task 3), scope enforcement (Task 2), `auth.transport` capability metadata (Task 3), and adapter-preserving layering (Task 3 wiring only wraps runtime/host-service).
- Placeholder scan: no `TODO`, `TBD`, “implement later”, or empty “write tests” steps remain; each code-changing step includes concrete file targets and code.
- Type consistency: the plan uses one transport enum (`"loopback" | "tls"`), one verifier model (`scrypt`), one request context concept (`correlationId`, `deviceId`, `scopes`), and one scope mapping across all tasks.
