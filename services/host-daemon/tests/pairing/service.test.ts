import { describe, expect, it } from "vitest";

import { createTrustStore } from "../../src/auth/trust-store.js";
import { createPairingSessionStore } from "../../src/pairing/session-store.js";
import {
  createDevicePairingIssuer,
  createPairingService
} from "../../src/pairing/service.js";
import { openDaemonDatabase } from "../../src/sqlite.js";

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
      now: "2026-04-28T12:00:00.000Z",
      requestedScopes: ["read:hosts", "read:sessions"],
      ttlMs: 300_000
    });

    const claim = await service.claimPairing({
      code: session.code,
      deviceLabel: "QA phone"
    });

    await expect(service.pollPairing(claim.claimToken)).resolves.toMatchObject({
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
    expect(trustStore.getDevice(approved.credentials.device_id)).not.toBeNull();
    await expect(service.pollPairing(claim.claimToken)).resolves.toMatchObject({
      status: "consumed",
      issued_device_id: approved.credentials.device_id
    });
  });

  it("rejects a second claim for the same pairing code", async () => {
    const database = openDaemonDatabase(":memory:");
    const store = createPairingSessionStore(database);
    const trustStore = createTrustStore(database);
    const service = createPairingService({
      devicePairingIssuer: createDevicePairingIssuer({ trustStore }),
      sessionStore: store,
      trustStore
    });

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

  it("rejects expired pairing codes and revokes trusted devices", async () => {
    const database = openDaemonDatabase(":memory:");
    const store = createPairingSessionStore(database);
    const trustStore = createTrustStore(database);
    const service = createPairingService({
      devicePairingIssuer: createDevicePairingIssuer({ trustStore }),
      sessionStore: store,
      trustStore
    });

    const session = service.startPairing({
      now: "2026-04-28T12:10:00.000Z",
      requestedScopes: ["read:sessions"],
      ttlMs: 1
    });
    expect(service.expireStaleSessions("2026-04-28T12:10:01.000Z")).toBe(1);

    await expect(
      service.claimPairing({ code: session.code, deviceLabel: "Late phone" })
    ).rejects.toThrow("Pairing session expired.");

    const active = service.startPairing({
      now: "2026-04-28T12:00:00.000Z",
      requestedScopes: ["read:sessions"],
      ttlMs: 300_000
    });
    const claim = await service.claimPairing({
      code: active.code,
      deviceLabel: "Primary phone"
    });
    service.approvePairing(active.sessionId);
    const approved = await service.pollPairing(claim.claimToken);

    if (approved.status !== "approved") {
      throw new Error("Expected approved credential response.");
    }

    expect(service.listTrustedDevices()).toHaveLength(1);
    service.revokeTrustedDevice(approved.credentials.device_id);
    expect(trustStore.getDevice(approved.credentials.device_id)?.revoked).toBe(true);
  });
});
