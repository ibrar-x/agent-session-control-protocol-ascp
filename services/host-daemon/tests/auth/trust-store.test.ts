import { describe, expect, it } from "vitest";

import { openDaemonDatabase } from "../../src/sqlite.js";
import { createTrustStore } from "../../src/auth/trust-store.js";

describe("trust store", () => {
  it("persists a paired device, last-seen state, and revocation", () => {
    const database = openDaemonDatabase(":memory:");
    const trustStore = createTrustStore(database);

    trustStore.upsertDevice({
      deviceId: "daemon:device:test-1",
      displayName: "Ibrar iPhone",
      scopes: ["read:sessions", "write:sessions"],
      secretSalt: "salt",
      secretVerifier: "verifier",
      kdf: "scrypt",
      kdfParams: { N: 16384, r: 8, p: 1, keylen: 32 }
    });

    trustStore.recordSeen("daemon:device:test-1", "2026-04-28T10:00:00.000Z");

    expect(trustStore.getDevice("daemon:device:test-1")).toEqual(
      expect.objectContaining({
        deviceId: "daemon:device:test-1",
        displayName: "Ibrar iPhone",
        revoked: false,
        revokedAt: null,
        lastSeenAt: "2026-04-28T10:00:00.000Z",
        scopes: ["read:sessions", "write:sessions"],
        secretSalt: "salt",
        secretVerifier: "verifier",
        kdf: "scrypt",
        kdfParams: { N: 16384, r: 8, p: 1, keylen: 32 }
      })
    );

    trustStore.revokeDevice("daemon:device:test-1", "2026-04-28T11:00:00.000Z");

    expect(trustStore.getDevice("daemon:device:test-1")).toEqual(
      expect.objectContaining({
        deviceId: "daemon:device:test-1",
        revoked: true,
        revokedAt: "2026-04-28T11:00:00.000Z"
      })
    );
  });
});
