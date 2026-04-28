import type { DaemonDatabase } from "../sqlite.js";
import type { TrustedDeviceRecord, TrustedDeviceUpsertInput } from "./types.js";
export interface TrustStore {
    getDevice(deviceId: string): TrustedDeviceRecord | null;
    listDevices(): TrustedDeviceRecord[];
    upsertDevice(device: TrustedDeviceUpsertInput): TrustedDeviceRecord;
    recordSeen(deviceId: string, seenAt?: string): TrustedDeviceRecord | null;
    revokeDevice(deviceId: string, revokedAt?: string): TrustedDeviceRecord | null;
}
export declare function createTrustStore(database: DaemonDatabase): TrustStore;
//# sourceMappingURL=trust-store.d.ts.map