# Real Device Path

## The Actual Blocker

The daemon pairing backend is complete and all 38 tests pass. The state machine, SQLite persistence, credential issuance, and admin HTTP surface all work correctly.

The reason a real mobile device cannot pair right now has nothing to do with any of that. It is a single architectural fact:

> The mobile-facing claim and poll endpoints (`POST /pairing/claim`, `GET /pairing/claims/:token`) live inside the loopback-only admin server, bound to `127.0.0.1`. A phone cannot reach `127.0.0.1` on a desktop. Ever.

Everything downstream of this — CLI commands, browser UI, mobile app polish — is irrelevant until this is resolved.

There are also two smaller bugs in the daemon that should be fixed before anything else is built on top of it.

---

## Phase 0: Fix the two daemon bugs (do this now, ~2 hours)

These are correctness issues in the existing code. Fix them on the current `branch-host-daemon` branch before branching for transport work.

### Bug 1: Pairing codes never expire automatically

`expireStaleSessions()` exists on the service but nothing calls it. Pairing codes accumulate in SQLite indefinitely. A device that scans an expired code gets an error at claim time but the record stays in the database forever.

Fix: add a sweep in `runDaemonProcess` in `services/host-daemon/src/main.ts`:

```ts
setInterval(() => {
  pairingBackendService.expireStaleSessions();
}, 60_000);
```

### Bug 2: `/admin/trusted-devices` leaks crypto material

`listTrustedDevices()` returns the full `TrustedDeviceRecord` which includes `secretSalt`, `secretVerifier`, `kdf`, and `kdfParams`. The admin server passes this directly to `sendJson`. Even on loopback, you should not serialize raw credential verifiers to HTTP.

Fix: add a `serializeTrustedDevice` helper in `admin-server.ts` that strips crypto fields:

```ts
function serializeTrustedDevice(device: TrustedDeviceRecord): Record<string, unknown> {
  return {
    device_id: device.deviceId,
    display_name: device.displayName,
    scopes: device.scopes,
    paired_at: device.pairedAt,
    last_seen_at: device.lastSeenAt,
    revoked: device.revoked,
    revoked_at: device.revokedAt
  };
}
```

Use it in the `GET /admin/trusted-devices` handler and the revoke response.

---

## Phase 1: Transport split — make mobile endpoints reachable (next, ~1 day)

### The decision

The admin endpoints (create/approve/reject/list/revoke) must stay loopback-only. They are operator controls and should never be reachable from the network.

The mobile pairing endpoints (claim + poll) must be reachable from the phone. They need a separate server that can bind to a network interface.

### What changes

**Add a mobile pairing server** alongside the existing admin server. This server:

- binds to the LAN interface (or `0.0.0.0` when in TLS mode)
- exposes only two endpoints:
  - `POST /pairing/claim`
  - `GET /pairing/claims/:token`
- requires TLS (self-signed is acceptable for LAN v1)
- is completely separate from the admin server

**Update the QR payload** to include the endpoint URL so the mobile app knows where to send the claim request:

```json
{
  "code": "PAIR-ABCD1234",
  "endpoint": "https://192.168.1.100:8767"
}
```

Currently `qrPayload` is `{"code":"...","session_id":"..."}`. Drop `session_id` (the phone does not need it), add `endpoint`.

**Add config** for the mobile pairing server:

```ts
export interface HostDaemonConfig {
  adminPort: number;           // 8766, loopback only
  authTransport: "loopback" | "tls";
  databasePath: string;
  host: string;                // ASCP WebSocket host
  mobileHost: string;          // mobile pairing server host, e.g. 0.0.0.0
  mobilePort: number;          // 8767
  mobileTlsCert?: string;      // path to TLS cert
  mobileTlsKey?: string;       // path to TLS key
  port: number;                // ASCP WebSocket port
  runtime: DaemonRuntimeKind;
}
```

**New file:** `services/host-daemon/src/pairing/mobile-server.ts`

Mirrors the structure of `admin-server.ts` but exposes only the two mobile endpoints and uses `node:https` instead of `node:http`.

### TLS for v1

For LAN pairing, a self-signed certificate is acceptable. The mobile app trusts it on first use (TOFU — Trust On First Use). The QR code is the out-of-band trust establishment: if you scanned the code physically, you trust that endpoint.

Generate with:

```bash
openssl req -x509 -newkey rsa:4096 -keyout pairing.key -out pairing.crt \
  -days 365 -nodes -subj "/CN=ascp-daemon"
```

Point to them with `ASCP_MOBILE_TLS_CERT` and `ASCP_MOBILE_TLS_KEY` env vars.

### After this phase

The full pairing flow is possible end-to-end for the first time:

1. Operator: `curl -X POST http://127.0.0.1:8766/admin/pairing/sessions` → gets code + QR payload
2. Operator: shows QR payload to mobile (copy/paste or render)
3. Mobile: reads `endpoint` and `code` from QR payload
4. Mobile: `POST https://192.168.1.100:8767/pairing/claim` with the code
5. Operator: `curl -X POST http://127.0.0.1:8766/admin/pairing/sessions/:id/approve`
6. Mobile: `GET https://192.168.1.100:8767/pairing/claims/:token` → gets `device_id + device_secret`
7. Mobile: stores credentials and connects to ASCP WebSocket at `wss://192.168.1.100:8765`

---

## Phase 2: End-to-end verification with a real device (~1 day)

Before building anything new, prove the full flow works with a real phone using only curl on the host side and a simple mobile test client.

### What to verify

1. Daemon starts, generates TLS cert, mobile server listens on LAN interface
2. Mobile (using a simple fetch script or Dart test client) can reach `POST /pairing/claim`
3. Host approval works via curl to the admin server
4. Mobile poll returns `approved` and receives `device_id + device_secret`
5. Mobile connects to the ASCP WebSocket using those credentials and is authenticated
6. Reconnect: mobile uses stored credentials, WebSocket auth succeeds again
7. Revoke: operator revokes the device, next mobile connection is rejected

Write this as an integration test in `services/host-daemon/tests/integration-real-device.test.ts` that spins up the daemon with a mobile server and exercises the full flow in-process. No actual phone needed for the test — the point is to exercise every hop.

### Auth transport clarification

When `authTransport` is `loopback`, the daemon skips credential verification. This is fine for development but wrong for any real device connection. The mobile WebSocket connection must use `authTransport: "tls"` which requires `device_id + device_secret` to be verified on every connection.

Make sure the integration test runs with `authTransport: "tls"`.

---

## Phase 3: CLI operator surface (~half day)

Only after Phase 2 is verified. The HTTP endpoints already work — this is just ergonomics for operators who do not want to use curl.

Add a subcommand parser to `services/host-daemon/src/cli.ts`:

```
node dist/cli.js                         # start daemon (current behavior)
node dist/cli.js pair create             # create pairing session, print code + QR payload
node dist/cli.js pair list               # list pairing sessions with status
node dist/cli.js pair approve <id>       # approve a claimed session
node dist/cli.js pair reject <id>        # reject a claimed session
node dist/cli.js devices list            # list trusted devices
node dist/cli.js devices revoke <id>     # revoke a trusted device
```

The subcommands hit the local admin HTTP server — they do not reimplement any logic. The daemon must already be running for subcommands to work.

This gives operators a usable surface without building a dashboard.

---

## Phase 4: Mobile claim flow (~2–3 days)

With the backend and transport verified, build the mobile-side pairing flow.

### What mobile needs to do

1. Scan or read QR payload: extract `code` and `endpoint`
2. Prompt user for a device label (or use device name)
3. `POST {endpoint}/pairing/claim` with `{ code, device_label }`
4. Show "waiting for host approval" state with the `claim_token`
5. Poll `GET {endpoint}/pairing/claims/{token}` every 3 seconds
6. On `pending_host_approval`: keep showing waiting state
7. On `approved`: extract `device_id + device_secret`, store them securely (Keychain on iOS, Keystore on Android), stop polling
8. On `rejected` / `expired`: show error, allow retry

### Credential storage contract

`device_secret` must be stored in secure enclave storage. It must never be written to disk unencrypted. `device_id` is not secret and can be stored in regular preferences.

### After pairing, ASCP connection

The mobile connects to `wss://{host}:{port}` using the stored credentials. Exactly how those credentials are presented in the WebSocket handshake is governed by the existing auth spec in `protocol/spec/auth.md`. Verify this path before shipping pairing — pairing is useless if the post-pair connection does not work.

---

## Phase 5: Relay (only if needed beyond LAN)

If the use case requires the phone to pair and connect from outside the local network, a relay server is required. Do not design or build this until Phase 4 is complete and you know the real requirement.

The relay approach:
- Mobile connects to relay via TLS
- Relay proxies to daemon via a persistent authenticated tunnel
- Daemon does not expose itself to the internet directly

This is significant architectural work. Do not start it speculatively.

---

## What to skip entirely

- **Browser UI for pairing**: the host console work is already done but is not on the critical path. The operator can use CLI or curl. Do not invest more here.
- **TLS/mTLS at the WebSocket layer for host**: the loopback WebSocket for Codex is fine as-is. Only the mobile server needs TLS right now.
- **Runtime-specific trust policy**: premature until multi-runtime is real.
- **Multi-device management polish**: get one device working reliably first.

---

## Summary: What to do in order

| Phase | Work | Outcome |
|---|---|---|
| 0 | Fix expiry sweep + crypto field leak | Daemon is correct |
| 1 | Transport split: mobile pairing server with TLS | Mobile can reach claim + poll endpoints |
| 2 | Integration test: full flow with real credentials | End-to-end is proven before building more |
| 3 | CLI subcommands | Operators have a usable surface without curl |
| 4 | Mobile claim + poll + credential storage + WebSocket auth | First real paired device |
| 5 | Relay | Only if LAN is insufficient |

Stop at Phase 2 and verify before moving to Phase 3 or 4. Building more backend or UI before you have confirmed end-to-end works on a real device is the mistake that got you to where you are now.
