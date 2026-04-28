import { describe, expect, it } from "vitest";

import { createAuthenticator } from "../../src/auth/authenticator.js";
import { createDeviceSecretVerifier } from "../../src/auth/crypto.js";
import { openDaemonDatabase } from "../../src/sqlite.js";
import { createTrustStore } from "../../src/auth/trust-store.js";

describe("createAuthenticator", () => {
  it("authenticates a trusted loopback device from request headers", async () => {
    const database = openDaemonDatabase(":memory:");
    const trustStore = createTrustStore(database);
    const authenticator = createAuthenticator({
      transportMode: "loopback",
      trustStore
    });
    const verifier = await createDeviceSecretVerifier("known-secret");
    trustStore.upsertDevice({
      deviceId: "daemon:device:test-1",
      displayName: "Phone",
      scopes: ["read:sessions"],
      ...verifier
    });

    const result = await authenticator.authenticateRequest({
      headers: {
        "x-ascp-device-id": "daemon:device:test-1",
        "x-ascp-device-secret": "known-secret"
      }
    } as never);

    expect(result).toMatchObject({
      authenticated: true,
      deviceId: "daemon:device:test-1",
      scopes: ["read:sessions"],
      transportMode: "loopback"
    });
    expect(trustStore.getDevice("daemon:device:test-1")?.lastSeenAt).not.toBeNull();
  });

  it("returns unauthenticated state for missing credentials or non-loopback transport", async () => {
    const database = openDaemonDatabase(":memory:");
    const trustStore = createTrustStore(database);

    const nonLoopback = createAuthenticator({
      transportMode: "tls",
      trustStore
    });
    const missingHeaders = createAuthenticator({
      transportMode: "loopback",
      trustStore
    });

    await expect(
      nonLoopback.authenticateRequest({
        headers: {}
      } as never)
    ).resolves.toMatchObject({
      authenticated: false,
      transportMode: "tls"
    });
    await expect(
      missingHeaders.authenticateRequest({
        headers: {}
      } as never)
    ).resolves.toMatchObject({
      authenticated: false,
      errorMessage: "Missing device credentials."
    });
  });
});
