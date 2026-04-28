import type { PairDeviceResult } from "./types.js";
import type { TrustStore } from "./trust-store.js";
export interface PairingService {
    pairDevice(input: {
        displayName: string;
        scopes: string[];
    }): Promise<PairDeviceResult>;
}
export declare function createPairingService(deps: {
    trustStore: TrustStore;
}): PairingService;
//# sourceMappingURL=pairing-service.d.ts.map