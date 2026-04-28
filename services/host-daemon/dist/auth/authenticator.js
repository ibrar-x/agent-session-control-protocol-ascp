import { verifyDeviceSecret } from "./crypto.js";
const DEVICE_ID_HEADER = "x-ascp-device-id";
const DEVICE_SECRET_HEADER = "x-ascp-device-secret";
export function createAuthenticator(deps) {
    return {
        async authenticateRequest(request) {
            if (deps.transportMode !== "loopback") {
                return unauthenticated(deps.transportMode, "Device-secret authentication requires loopback transport.");
            }
            const deviceId = readHeader(request, DEVICE_ID_HEADER);
            const deviceSecret = readHeader(request, DEVICE_SECRET_HEADER);
            if (deviceId === undefined || deviceSecret === undefined) {
                return unauthenticated(deps.transportMode, "Missing device credentials.");
            }
            const record = deps.trustStore.getDevice(deviceId);
            if (record === null || record.revoked) {
                return unauthenticated(deps.transportMode, "Unknown or revoked device.");
            }
            const valid = await verifyDeviceSecret(record, deviceSecret);
            if (!valid) {
                return unauthenticated(deps.transportMode, "Invalid device secret.");
            }
            deps.trustStore.recordSeen(deviceId);
            return {
                authenticated: true,
                deviceId,
                scopes: record.scopes,
                transportMode: deps.transportMode
            };
        }
    };
}
function readHeader(request, name) {
    const value = request.headers[name];
    if (typeof value === "string" && value.length > 0) {
        return value;
    }
    return Array.isArray(value) ? value[0] : undefined;
}
function unauthenticated(transportMode, errorMessage) {
    return {
        authenticated: false,
        errorMessage,
        scopes: [],
        transportMode
    };
}
//# sourceMappingURL=authenticator.js.map