import type { TrustedDeviceRecord } from "../auth/types.js";
import type { TrustStore } from "../auth/trust-store.js";
import type { PairingSessionStore } from "./session-store.js";
import type { PairingSessionRecord } from "./types.js";
export interface DevicePairingIssuer {
    issueTrustedDevice(input: {
        displayName: string;
        scopes: string[];
    }): Promise<{
        deviceId: string;
        deviceSecret: string;
    }>;
}
export interface PairingBackendService {
    approvePairing(sessionId: string): void;
    claimPairing(input: {
        code: string;
        deviceLabel: string;
    }): Promise<{
        claimToken: string;
        sessionId: string;
    }>;
    expireStaleSessions(now?: string): number;
    listPairingSessions(): PairingSessionRecord[];
    listTrustedDevices(): TrustedDeviceRecord[];
    pollPairing(claimToken: string): Promise<{
        status: "pending_host_approval" | "rejected" | "expired";
    } | {
        status: "approved";
        credentials: {
            device_id: string;
            device_secret: string;
        };
    } | {
        status: "consumed";
        issued_device_id: string | null;
    }>;
    rejectPairing(sessionId: string): void;
    revokeTrustedDevice(deviceId: string): void;
    startPairing(input: {
        requestedScopes: string[];
        ttlMs?: number;
        now?: string;
    }): {
        code: string;
        expiresAt: string;
        qrPayload: string;
        sessionId: string;
    };
}
export declare function createDevicePairingIssuer(deps: {
    trustStore: TrustStore;
}): DevicePairingIssuer;
export declare function createPairingService(deps: {
    devicePairingIssuer: DevicePairingIssuer;
    sessionStore: PairingSessionStore;
    trustStore: TrustStore;
}): PairingBackendService;
//# sourceMappingURL=service.d.ts.map