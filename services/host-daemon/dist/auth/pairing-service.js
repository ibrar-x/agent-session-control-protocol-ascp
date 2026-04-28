import { randomBytes, randomUUID } from "node:crypto";
import { createDeviceSecretVerifier } from "./crypto.js";
export function createPairingService(deps) {
    return {
        async pairDevice(input) {
            const deviceSecret = randomBytes(32).toString("base64url");
            const verifier = await createDeviceSecretVerifier(deviceSecret);
            const deviceId = `daemon:device:${randomUUID()}`;
            const record = deps.trustStore.upsertDevice({
                deviceId,
                displayName: input.displayName,
                scopes: input.scopes,
                ...verifier
            });
            return {
                deviceId,
                deviceSecret,
                record
            };
        }
    };
}
//# sourceMappingURL=pairing-service.js.map