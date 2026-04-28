import type { PairingSessionRecord, TrustedDeviceRecord } from "./types";

function parseStringArray(value: unknown): string[] {
  return Array.isArray(value) ? value.map((item) => String(item)) : [];
}

export function mapPairingSession(payload: Record<string, unknown>): PairingSessionRecord {
  const now = new Date().toISOString();

  return {
    sessionId: String(payload.session_id ?? payload.sessionId ?? ""),
    code: String(payload.code ?? ""),
    claimToken:
      typeof payload.claim_token === "string"
        ? payload.claim_token
        : typeof payload.claimToken === "string"
          ? payload.claimToken
          : null,
    requestedScopes: parseStringArray(payload.requested_scopes ?? payload.requestedScopes),
    status: String(payload.status ?? "pending_host_claim") as PairingSessionRecord["status"],
    createdAt: String(payload.created_at ?? payload.createdAt ?? now),
    expiresAt: String(payload.expires_at ?? payload.expiresAt ?? now),
    claimedAt: typeof payload.claimed_at === "string" ? payload.claimed_at : typeof payload.claimedAt === "string" ? payload.claimedAt : null,
    approvedAt: typeof payload.approved_at === "string" ? payload.approved_at : typeof payload.approvedAt === "string" ? payload.approvedAt : null,
    rejectedAt: typeof payload.rejected_at === "string" ? payload.rejected_at : typeof payload.rejectedAt === "string" ? payload.rejectedAt : null,
    consumedAt: typeof payload.consumed_at === "string" ? payload.consumed_at : typeof payload.consumedAt === "string" ? payload.consumedAt : null,
    deviceLabel: typeof payload.device_label === "string" ? payload.device_label : typeof payload.deviceLabel === "string" ? payload.deviceLabel : null,
    issuedDeviceId: typeof payload.issued_device_id === "string" ? payload.issued_device_id : typeof payload.issuedDeviceId === "string" ? payload.issuedDeviceId : null,
    qrPayload:
      typeof payload.qr_payload === "string"
        ? payload.qr_payload
        : JSON.stringify({ code: payload.code, session_id: payload.session_id ?? payload.sessionId }),
    error: null,
    isRefreshing: false,
    copiedCode: false,
    lastUpdatedAt: now
  };
}

function mapTrustedDevice(payload: Record<string, unknown>): TrustedDeviceRecord {
  return {
    deviceId: String(payload.device_id ?? payload.deviceId ?? ""),
    displayName: String(payload.display_name ?? payload.displayName ?? payload.device_id ?? payload.deviceId ?? ""),
    scopes: parseStringArray(payload.scopes),
    pairedAt: String(payload.paired_at ?? payload.pairedAt ?? ""),
    lastSeenAt: typeof payload.last_seen_at === "string" ? payload.last_seen_at : typeof payload.lastSeenAt === "string" ? payload.lastSeenAt : null,
    revoked: Boolean(payload.revoked),
    revokedAt: typeof payload.revoked_at === "string" ? payload.revoked_at : typeof payload.revokedAt === "string" ? payload.revokedAt : null,
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
    async approvePairing(sessionId: string) {
      await request(`/admin/pairing/sessions/${encodeURIComponent(sessionId)}/approve`, {
        body: JSON.stringify({}),
        method: "POST"
      });
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
    async listPairingSessions() {
      const payload = await request("/admin/pairing/sessions");
      return Array.isArray(payload.sessions)
        ? payload.sessions.map((item) => mapPairingSession(item as Record<string, unknown>))
        : [];
    },
    async listTrustedDevices() {
      const payload = await request("/admin/trusted-devices");
      return Array.isArray(payload.devices)
        ? payload.devices.map((item) => mapTrustedDevice(item as Record<string, unknown>))
        : [];
    },
    async rejectPairing(sessionId: string) {
      await request(`/admin/pairing/sessions/${encodeURIComponent(sessionId)}/reject`, {
        body: JSON.stringify({}),
        method: "POST"
      });
    },
    async revokeTrustedDevice(deviceId: string) {
      await request(`/admin/trusted-devices/${encodeURIComponent(deviceId)}/revoke`, {
        body: JSON.stringify({}),
        method: "POST"
      });
    }
  };
}
