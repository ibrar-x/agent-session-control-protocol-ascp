import type { DaemonDatabase } from "../sqlite.js";
import type { PairingSessionRecord, PairingSessionStatus } from "./types.js";
export interface PairingSessionStore {
    attachClaim(input: {
        claimToken: string;
        sessionId: string;
        deviceLabel: string;
        claimedAt?: string;
    }): PairingSessionRecord;
    attachIssuedDevice(sessionId: string, deviceId: string): PairingSessionRecord;
    consumeApprovedSession(input: {
        consumedAt?: string;
        sessionId: string;
    }): PairingSessionRecord | null;
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
export declare function createPairingSessionStore(database: DaemonDatabase): PairingSessionStore;
//# sourceMappingURL=session-store.d.ts.map