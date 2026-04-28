import { type AscpHostServiceOptions, type AscpHostService } from "@ascp/host-service";
import { type PairingService } from "./auth/pairing-service.js";
import { type PairingAdminServer } from "./pairing/admin-server.js";
import { type PairingBackendService } from "./pairing/service.js";
import type { HostDaemonConfig } from "./config.js";
import { type HostDaemonLogger } from "./logger.js";
import { type RuntimeRegistry } from "./runtime-registry.js";
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
export declare function startHostDaemon(options: StartHostDaemonOptions): Promise<RunningHostDaemon>;
export declare function runDaemonProcess(env?: NodeJS.ProcessEnv, logger?: HostDaemonLogger): Promise<RunningHostDaemon>;
//# sourceMappingURL=main.d.ts.map