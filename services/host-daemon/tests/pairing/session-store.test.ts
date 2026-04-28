import { randomBytes, randomUUID } from "node:crypto";

import { describe, expect, it } from "vitest";

import { createPairingSessionStore } from "../../src/pairing/session-store.js";
import { openDaemonDatabase } from "../../src/sqlite.js";

describe("pairing session store", () => {
  it("creates, claims, approves, and expires pairing sessions", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createPairingSessionStore(database);

    const created = store.insertSession({
      code: "PAIR-1234",
      expiresAt: "2026-04-28T12:10:00.000Z",
      requestedScopes: ["read:hosts", "read:sessions", "write:sessions"],
      sessionId: `pairing:${randomUUID()}`
    });

    expect(store.getSession(created.sessionId)).toMatchObject({
      claimToken: null,
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
    store.setStatus(created.sessionId, "approved", "2026-04-28T12:02:00.000Z");
    store.markExpired(created.sessionId, "2026-04-28T12:11:00.000Z");

    expect(store.getSession(created.sessionId)).toMatchObject({
      deviceLabel: "Ibrar iPhone",
      status: "expired"
    });
  });
});
