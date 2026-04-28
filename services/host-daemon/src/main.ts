import {
  createAscpHostService,
  type AscpHostServiceOptions,
  type AscpHostRuntime,
  type AscpHostService
} from "@ascp/host-service";

import { createAttachmentManager } from "./attachment-manager.js";
import { createAuditStore } from "./auth/audit-store.js";
import { createAuthenticator } from "./auth/authenticator.js";
import { createAuthorizer } from "./auth/authorizer.js";
import { createPairingService, type PairingService } from "./auth/pairing-service.js";
import { createPairingAdminServer, type PairingAdminServer } from "./pairing/admin-server.js";
import {
  createDevicePairingIssuer,
  createPairingService as createPairingBackendService,
  type PairingBackendService
} from "./pairing/service.js";
import { createAuthAwareRuntime } from "./auth/runtime.js";
import { createTrustStore } from "./auth/trust-store.js";
import type { HostDaemonConfig } from "./config.js";
import { createConsoleLogger, type HostDaemonLogger } from "./logger.js";
import { createReplayBackedRuntime, createReplayBroker } from "./replay-broker.js";
import { createRuntimeRegistry, type RuntimeRegistry } from "./runtime-registry.js";
import { openDaemonDatabase } from "./sqlite.js";
import { createPairingSessionStore } from "./pairing/session-store.js";
import { createCursorStore } from "./stores/cursor-store.js";
import { createEventStore } from "./stores/event-store.js";
import { createSessionStore } from "./stores/session-store.js";

export interface RunningHostDaemon {
  adminUrl: string;
  close(): Promise<void>;
  pairingBackendService: PairingBackendService;
  pairingService: PairingService;
  url: string;
}

export interface StartHostDaemonOptions {
  config: HostDaemonConfig;
  createAdminServer?: (options: {
    host: string;
    pairingService: PairingBackendService;
    port: number;
  }) => PairingAdminServer;
  createHostService?: (options: AscpHostServiceOptions) => AscpHostService;
  logger?: HostDaemonLogger;
  runtimeRegistry: RuntimeRegistry;
}

export async function startHostDaemon(options: StartHostDaemonOptions): Promise<RunningHostDaemon> {
  const runtime = options.runtimeRegistry.createRuntime(options.config.runtime) as AscpHostRuntime & {
    sessionsGet?: (...args: never[]) => unknown;
    onEvent?: (listener: (event: Record<string, unknown>) => void) => () => void;
  };
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
    runtime: runtime as never,
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
    runtime: runtime as never
  });
  const authAwareRuntime = createAuthAwareRuntime({
    runtime: replayBackedRuntime as AscpHostRuntime,
    transportMode: options.config.authTransport
  });
  const hostService =
    options.createHostService?.({
      authorizeConnection: async (request) => authenticator.authenticateRequest(request),
      createRequestContext: async (input) => authorizer.createRequestContext(input),
      host: options.config.host,
      onRequestAudit: async (entry) => {
        auditStore.append({
          actorId: entry.actorId ?? null,
          authState: entry.authenticated ? "authenticated" : "unauthenticated",
          authorizationState:
            entry.stage === "received" ? "not_checked" : entry.authorized ? "allowed" : "denied",
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
          authorizationState:
            entry.stage === "received" ? "not_checked" : entry.authorized ? "allowed" : "denied",
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
  const adminServer =
    options.createAdminServer?.({
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

export async function runDaemonProcess(
  env: NodeJS.ProcessEnv = process.env,
  logger: HostDaemonLogger = createConsoleLogger()
): Promise<RunningHostDaemon> {
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
