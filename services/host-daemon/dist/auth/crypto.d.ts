import type { DeviceSecretVerifierRecord } from "./types.js";
export declare function createDeviceSecretVerifier(secret: string): Promise<DeviceSecretVerifierRecord>;
export declare function verifyDeviceSecret(record: DeviceSecretVerifierRecord, presentedSecret: string): Promise<boolean>;
//# sourceMappingURL=crypto.d.ts.map