import { randomUUID } from "node:crypto";

import type { DaemonDatabase } from "../sqlite.js";
import type { PairingSessionRecord, PairingSessionStatus } from "./types.js";

interface PairingSessionRow {
  session_id: string;
  pairing_code: string;
  claim_token: string | null;
  requested_scopes_json: string;
  status: PairingSessionStatus;
  created_at: string;
  expires_at: string;
  claimed_at: string | null;
  approved_at: string | null;
  rejected_at: string | null;
  consumed_at: string | null;
  device_label: string | null;
  issued_device_id: string | null;
}

function parseJson<TValue>(value: string): TValue {
  return JSON.parse(value) as TValue;
}

function serialize(value: unknown): string {
  return JSON.stringify(value);
}

function hydrateSession(row: PairingSessionRow): PairingSessionRecord {
  return {
    sessionId: row.session_id,
    code: row.pairing_code,
    claimToken: row.claim_token,
    requestedScopes: parseJson<string[]>(row.requested_scopes_json),
    status: row.status,
    createdAt: row.created_at,
    expiresAt: row.expires_at,
    claimedAt: row.claimed_at,
    approvedAt: row.approved_at,
    rejectedAt: row.rejected_at,
    consumedAt: row.consumed_at,
    deviceLabel: row.device_label,
    issuedDeviceId: row.issued_device_id
  };
}

export interface PairingSessionStore {
  attachClaim(input: {
    claimToken: string;
    sessionId: string;
    deviceLabel: string;
    claimedAt?: string;
  }): PairingSessionRecord;
  attachIssuedDevice(sessionId: string, deviceId: string): PairingSessionRecord;
  consumeApprovedSession(input: { consumedAt?: string; sessionId: string }): PairingSessionRecord | null;
  getByClaimToken(claimToken: string): PairingSessionRecord | null;
  getByCode(code: string): PairingSessionRecord | null;
  getSession(sessionId: string): PairingSessionRecord | null;
  insertSession(input: {
    claimToken?: string | null;
    code: string;
    createdAt?: string;
    expiresAt: string;
    requestedScopes: string[];
    sessionId?: string;
  }): PairingSessionRecord;
  listActiveSessions(now: string): PairingSessionRecord[];
  listSessions(): PairingSessionRecord[];
  markExpired(sessionId: string, expiredAt?: string): PairingSessionRecord;
  setStatus(sessionId: string, status: PairingSessionStatus, changedAt?: string): PairingSessionRecord;
}

export function createPairingSessionStore(database: DaemonDatabase): PairingSessionStore {
  const selectById = database.prepare(`
    SELECT
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
    FROM daemon_pairing_sessions
    WHERE session_id = ?
  `);
  const selectByCode = database.prepare(`
    SELECT
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
    FROM daemon_pairing_sessions
    WHERE pairing_code = ?
  `);
  const selectByClaimToken = database.prepare(`
    SELECT
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
    FROM daemon_pairing_sessions
    WHERE claim_token = ?
  `);
  const selectActiveSessions = database.prepare(`
    SELECT
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
    FROM daemon_pairing_sessions
    WHERE expires_at > ?
    ORDER BY created_at ASC
  `);
  const selectSessions = database.prepare(`
    SELECT
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
    FROM daemon_pairing_sessions
    ORDER BY created_at ASC
  `);
  const insertSession = database.prepare(`
    INSERT INTO daemon_pairing_sessions (
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
    ) VALUES (
      @session_id,
      @pairing_code,
      @claim_token,
      @requested_scopes_json,
      @status,
      @created_at,
      @expires_at,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL
    )
  `);
  const attachClaim = database.prepare(`
    UPDATE daemon_pairing_sessions
    SET claim_token = @claim_token,
        device_label = @device_label,
        claimed_at = @claimed_at
    WHERE session_id = @session_id
  `);
  const updateIssuedDevice = database.prepare(`
    UPDATE daemon_pairing_sessions
    SET issued_device_id = ?
    WHERE session_id = ?
  `);
  const setStatus = database.prepare(`
    UPDATE daemon_pairing_sessions
    SET status = @status,
        approved_at = @approved_at,
        rejected_at = @rejected_at,
        consumed_at = @consumed_at
    WHERE session_id = @session_id
  `);
  const expireSession = database.prepare(`
    UPDATE daemon_pairing_sessions
    SET status = 'expired'
    WHERE session_id = ?
  `);
  const consumeApproved = database.prepare(`
    UPDATE daemon_pairing_sessions
    SET status = 'consumed',
        consumed_at = ?
    WHERE session_id = ? AND status = 'approved'
    RETURNING
      session_id,
      pairing_code,
      claim_token,
      requested_scopes_json,
      status,
      created_at,
      expires_at,
      claimed_at,
      approved_at,
      rejected_at,
      consumed_at,
      device_label,
      issued_device_id
  `);

  return {
    attachClaim(input) {
      attachClaim.run({
        claim_token: input.claimToken,
        claimed_at: input.claimedAt ?? new Date().toISOString(),
        device_label: input.deviceLabel,
        session_id: input.sessionId
      });
      const stored = this.getSession(input.sessionId);
      if (stored === null) {
        throw new Error(`Failed to attach pairing claim: ${input.sessionId}`);
      }
      return stored;
    },
    attachIssuedDevice(sessionId, deviceId) {
      updateIssuedDevice.run(deviceId, sessionId);
      const stored = this.getSession(sessionId);
      if (stored === null) {
        throw new Error(`Failed to attach issued device: ${sessionId}`);
      }
      return stored;
    },
    consumeApprovedSession(input) {
      const row = consumeApproved.get(
        input.consumedAt ?? new Date().toISOString(),
        input.sessionId
      ) as PairingSessionRow | undefined;
      return row === undefined ? null : hydrateSession(row);
    },
    getByClaimToken(claimToken) {
      const row = selectByClaimToken.get(claimToken) as PairingSessionRow | undefined;
      return row === undefined ? null : hydrateSession(row);
    },
    getByCode(code) {
      const row = selectByCode.get(code) as PairingSessionRow | undefined;
      return row === undefined ? null : hydrateSession(row);
    },
    getSession(sessionId) {
      const row = selectById.get(sessionId) as PairingSessionRow | undefined;
      return row === undefined ? null : hydrateSession(row);
    },
    insertSession(input) {
      insertSession.run({
        claim_token: input.claimToken ?? null,
        created_at: input.createdAt ?? new Date().toISOString(),
        expires_at: input.expiresAt,
        pairing_code: input.code,
        requested_scopes_json: serialize(input.requestedScopes),
        session_id: input.sessionId ?? `pairing:${randomUUID()}`,
        status: "pending_host_claim"
      });
      const stored = this.getByCode(input.code);
      if (stored === null) {
        throw new Error(`Failed to insert pairing session: ${input.code}`);
      }
      return stored;
    },
    listActiveSessions(now) {
      return (selectActiveSessions.all(now) as unknown as PairingSessionRow[]).map(hydrateSession);
    },
    listSessions() {
      return (selectSessions.all() as unknown as PairingSessionRow[]).map(hydrateSession);
    },
    markExpired(sessionId, _expiredAt) {
      expireSession.run(sessionId);
      const stored = this.getSession(sessionId);
      if (stored === null) {
        throw new Error(`Failed to mark pairing session expired: ${sessionId}`);
      }
      return stored;
    },
    setStatus(sessionId, status, changedAt = new Date().toISOString()) {
      setStatus.run({
        approved_at: status === "approved" ? changedAt : null,
        consumed_at: status === "consumed" ? changedAt : null,
        rejected_at: status === "rejected" ? changedAt : null,
        session_id: sessionId,
        status
      });
      const stored = this.getSession(sessionId);
      if (stored === null) {
        throw new Error(`Failed to update pairing session status: ${sessionId}`);
      }
      return stored;
    }
  };
}
