import { randomBytes, randomUUID } from "node:crypto";
import { createPairingService as createTrustedDevicePairingService } from "../auth/pairing-service.js";
const DEFAULT_TTL_MS = 5 * 60 * 1000;
export function createDevicePairingIssuer(deps) {
    const pairingPrimitive = createTrustedDevicePairingService({
        trustStore: deps.trustStore
    });
    return {
        async issueTrustedDevice(input) {
            const paired = await pairingPrimitive.pairDevice({
                displayName: input.displayName,
                scopes: input.scopes
            });
            return {
                deviceId: paired.deviceId,
                deviceSecret: paired.deviceSecret
            };
        }
    };
}
export function createPairingService(deps) {
    return {
        approvePairing(sessionId) {
            const session = requireSession(deps.sessionStore.getSession(sessionId), sessionId);
            if (session.status !== "pending_host_approval") {
                throw new Error(`Pairing session is not awaiting host approval: ${sessionId}`);
            }
            deps.sessionStore.setStatus(sessionId, "approved");
        },
        async claimPairing(input) {
            const session = requireSessionByCode(deps.sessionStore, input.code);
            if (session.status === "expired") {
                throw new Error("Pairing session expired.");
            }
            if (session.status !== "pending_host_claim") {
                throw new Error("Already claimed.");
            }
            if (isExpired(session, new Date().toISOString())) {
                deps.sessionStore.markExpired(session.sessionId);
                throw new Error("Pairing session expired.");
            }
            const claimToken = randomBytes(32).toString("hex");
            deps.sessionStore.attachClaim({
                claimToken,
                claimedAt: new Date().toISOString(),
                deviceLabel: input.deviceLabel,
                sessionId: session.sessionId
            });
            deps.sessionStore.setStatus(session.sessionId, "pending_host_approval");
            return {
                claimToken,
                sessionId: session.sessionId
            };
        },
        expireStaleSessions(now = new Date().toISOString()) {
            let expired = 0;
            for (const session of deps.sessionStore.listSessions()) {
                if ((session.status === "pending_host_claim" ||
                    session.status === "pending_host_approval" ||
                    session.status === "approved") &&
                    isExpired(session, now)) {
                    deps.sessionStore.markExpired(session.sessionId, now);
                    expired += 1;
                }
            }
            return expired;
        },
        listTrustedDevices() {
            return deps.trustStore.listDevices();
        },
        async pollPairing(claimToken) {
            const session = deps.sessionStore.getByClaimToken(claimToken);
            if (session === null) {
                throw new Error("Unknown pairing claim.");
            }
            if (isExpired(session, new Date().toISOString()) && session.status !== "consumed") {
                deps.sessionStore.markExpired(session.sessionId);
                return {
                    status: "expired"
                };
            }
            if (session.status === "pending_host_approval" ||
                session.status === "rejected" ||
                session.status === "expired") {
                return {
                    status: session.status
                };
            }
            if (session.status === "consumed") {
                return {
                    status: "consumed",
                    issued_device_id: session.issuedDeviceId
                };
            }
            if (session.status !== "approved") {
                throw new Error(`Unsupported pairing session state: ${session.status}`);
            }
            const consumed = deps.sessionStore.consumeApprovedSession({
                consumedAt: new Date().toISOString(),
                sessionId: session.sessionId
            });
            if (consumed === null) {
                const current = requireSession(deps.sessionStore.getSession(session.sessionId), session.sessionId);
                return {
                    status: "consumed",
                    issued_device_id: current.issuedDeviceId
                };
            }
            const issued = await trustApprovedSession({
                devicePairingIssuer: deps.devicePairingIssuer,
                session,
                sessionStore: deps.sessionStore
            });
            return {
                status: "approved",
                credentials: {
                    device_id: issued.deviceId,
                    device_secret: issued.deviceSecret
                }
            };
        },
        rejectPairing(sessionId) {
            const session = requireSession(deps.sessionStore.getSession(sessionId), sessionId);
            if (session.status !== "pending_host_approval") {
                throw new Error(`Pairing session is not awaiting host approval: ${sessionId}`);
            }
            deps.sessionStore.setStatus(sessionId, "rejected");
        },
        revokeTrustedDevice(deviceId) {
            const revoked = deps.trustStore.revokeDevice(deviceId);
            if (revoked === null) {
                throw new Error(`Unknown trusted device: ${deviceId}`);
            }
        },
        startPairing(input) {
            const now = input.now ?? new Date().toISOString();
            const sessionId = `pairing:${randomUUID()}`;
            const code = `PAIR-${randomBytes(4).toString("hex").toUpperCase()}`;
            const expiresAt = new Date(Date.parse(now) + (input.ttlMs ?? DEFAULT_TTL_MS)).toISOString();
            const created = deps.sessionStore.insertSession({
                code,
                createdAt: now,
                expiresAt,
                requestedScopes: input.requestedScopes,
                sessionId
            });
            return {
                code: created.code,
                expiresAt: created.expiresAt,
                qrPayload: JSON.stringify({
                    code: created.code,
                    session_id: created.sessionId
                }),
                sessionId: created.sessionId
            };
        }
    };
}
async function trustApprovedSession(deps) {
    const issued = await deps.devicePairingIssuer.issueTrustedDevice({
        displayName: deps.session.deviceLabel ?? "Paired device",
        scopes: deps.session.requestedScopes
    });
    deps.sessionStore.attachIssuedDevice(deps.session.sessionId, issued.deviceId);
    return issued;
}
function isExpired(session, now) {
    return Date.parse(session.expiresAt) <= Date.parse(now);
}
function requireSession(session, sessionId) {
    if (session === null) {
        throw new Error(`Unknown pairing session: ${sessionId}`);
    }
    return session;
}
function requireSessionByCode(sessionStore, code) {
    const session = sessionStore.getByCode(code);
    if (session === null) {
        throw new Error("Unknown pairing code.");
    }
    return session;
}
//# sourceMappingURL=service.js.map