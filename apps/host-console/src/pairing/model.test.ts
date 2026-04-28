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
