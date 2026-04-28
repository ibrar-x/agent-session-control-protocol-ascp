import { createAscpHostService } from "@ascp/host-service";
import { createAttachmentManager } from "./attachment-manager.js";
import { createAuditStore } from "./auth/audit-store.js";
import { createAuthenticator } from "./auth/authenticator.js";
import { createAuthorizer } from "./auth/authorizer.js";
import { createPairingService } from "./auth/pairing-service.js";
import { createPairingAdminServer } from "./pairing/admin-server.js";
import { createDevicePairingIssuer, createPairingService as createPairingBackendService } from "./pairing/service.js";
import { createAuthAwareRuntime } from "./auth/runtime.js";
import { createTrustStore } from "./auth/trust-store.js";
import { createConsoleLogger } from "./logger.js";
import { createReplayBackedRuntime, createReplayBroker } from "./replay-broker.js";
import { createRuntimeRegistry } from "./runtime-registry.js";
import { openDaemonDatabase } from "./sqlite.js";
import { createPairingSessionStore } from "./pairing/session-store.js";
import { createCursorStore } from "./stores/cursor-store.js";
import { createEventStore } from "./stores/event-store.js";
import { createSessionStore } from "./stores/session-store.js";
export async function startHostDaemon(options) {
    const runtime = options.runtimeRegistry.createRuntime(options.config.runtime);
    const database = openDaemonDatabase(options.config.databasePath ?? ":memory:");
    const sessionStore = createSessionStore(database);
    const eventStore = createEventStore(database);
    const cursorStore = createCursorStore(database);
    const trustStore = createTrustStore(database);
    const auditStore = createAuditStore(database);
    const pairingService = createPairingService({ trustStore });
    const pairingBackendService = createPairingBackendService({
        devicePairingIssuer: createDevicePairingIssuer({ trustStore }),
        sessionStore: createPairingSessionStore(database),
        trustStore
    });
    const authenticator = createAuthenticator({
        transportMode: options.config.authTransport,
        trustStore
    });
    const authorizer = createAuthorizer();
    const attachmentManager = createAttachmentManager({
        runtime: runtime,
        sessionStore,
        eventStore,
        cursorStore
    });
    const replayBroker = createReplayBroker({
        cursorStore,
        eventStore,
        sessionStore
    });
    const replayBackedRuntime = createReplayBackedRuntime({
        attachmentManager,
        replayBroker,
        runtime: runtime
    });
    const authAwareRuntime = createAuthAwareRuntime({
        runtime: replayBackedRuntime,
        transportMode: options.config.authTransport
    });
    const hostService = options.createHostService?.({
        authorizeConnection: async (request) => authenticator.authenticateRequest(request),
        createRequestContext: async (input) => authorizer.createRequestContext(input),
        host: options.config.host,
        onRequestAudit: async (entry) => {
            auditStore.append({
                actorId: entry.actorId ?? null,
                authState: entry.authenticated ? "authenticated" : "unauthenticated",
                authorizationState: entry.stage === "received" ? "not_checked" : entry.authorized ? "allowed" : "denied",
                correlationId: entry.correlationId,
                deviceId: entry.deviceId ?? null,
                errorCode: entry.errorCode ?? null,
                method: entry.method,
                outcome: entry.outcome,
                requestId: String(entry.requestId),
                stage: entry.stage,
                transportMode: entry.transportMode,
                ts: new Date().toISOString()
            });
        },
        port: options.config.port,
        runtime: authAwareRuntime
    }) ??
        createAscpHostService({
            authorizeConnection: async (request) => authenticator.authenticateRequest(request),
            createRequestContext: async (input) => authorizer.createRequestContext(input),
            host: options.config.host,
            onRequestAudit: async (entry) => {
                auditStore.append({
                    actorId: entry.actorId ?? null,
                    authState: entry.authenticated ? "authenticated" : "unauthenticated",
                    authorizationState: entry.stage === "received" ? "not_checked" : entry.authorized ? "allowed" : "denied",
                    correlationId: entry.correlationId,
                    deviceId: entry.deviceId ?? null,
                    errorCode: entry.errorCode ?? null,
                    method: entry.method,
                    outcome: entry.outcome,
                    requestId: String(entry.requestId),
                    stage: entry.stage,
                    transportMode: entry.transportMode,
                    ts: new Date().toISOString()
                });
            },
            port: options.config.port,
            runtime: authAwareRuntime
        });
    const adminServer = options.createAdminServer?.({
        host: "127.0.0.1",
        pairingService: pairingBackendService,
        port: options.config.adminPort
    }) ??
        createPairingAdminServer({
            host: "127.0.0.1",
            pairingService: pairingBackendService,
            port: options.config.adminPort
        });
    await hostService.listen();
    await adminServer.listen();
    return {
        adminUrl: adminServer.url,
        pairingBackendService,
        pairingService,
        url: hostService.url,
        async close() {
            await adminServer.close();
            await hostService.close();
            database.close();
        }
    };
}
export async function runDaemonProcess(env = process.env, logger = createConsoleLogger()) {
    const { resolveDaemonConfig } = await import("./config.js");
    const config = resolveDaemonConfig(env);
    const daemon = await startHostDaemon({
        config,
        logger,
        runtimeRegistry: createRuntimeRegistry()
    });
    logger.info("ASCP host daemon listening", {
        admin_url: daemon.adminUrl,
        auth_transport: config.authTransport,
        database_path: config.databasePath,
        runtime: config.runtime,
        url: daemon.url
    });
    return daemon;
}
//# sourceMappingURL=main.js.map