import { describe, expect, it } from "vitest";

import { createPairingService } from "../../src/auth/pairing-service.js";
import { verifyDeviceSecret } from "../../src/auth/crypto.js";
import { openDaemonDatabase } from "../../src/sqlite.js";
import { createTrustStore } from "../../src/auth/trust-store.js";

describe("pairing service", () => {
  it("issues unique device ids and returns the raw secret once while persisting only verifier data", async () => {
    const database = openDaemonDatabase(":memory:");
    const trustStore = createTrustStore(database);
    const pairingService = createPairingService({ trustStore });

    const first = await pairingService.pairDevice({
      displayName: "Ibrar iPhone",
      scopes: ["read:sessions", "write:sessions"]
    });
    const second = await pairingService.pairDevice({
      displayName: "Ibrar iPad",
      scopes: ["read:sessions"]
    });

    expect(first.deviceId).not.toBe(second.deviceId);
    expect(first.deviceSecret).not.toBe(second.deviceSecret);
    expect(first.deviceSecret.length).toBeGreaterThan(10);

    const stored = trustStore.getDevice(first.deviceId);

    expect(stored).toEqual(
      expect.objectContaining({
        deviceId: first.deviceId,
        displayName: "Ibrar iPhone",
        revoked: false,
        scopes: ["read:sessions", "write:sessions"]
      })
    );
    expect(stored?.secretVerifier).not.toBe(first.deviceSecret);
    expect(await verifyDeviceSecret(stored!, first.deviceSecret)).toBe(true);
    expect("deviceSecret" in (stored as Record<string, unknown>)).toBe(false);
  });
});
