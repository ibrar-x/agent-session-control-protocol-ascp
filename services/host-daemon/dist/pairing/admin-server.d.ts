import type { PairingBackendService } from "./service.js";
export interface PairingAdminServer {
    close(): Promise<void>;
    listen(): Promise<void>;
    readonly url: string;
}
export declare function createPairingAdminServer(options: {
    host?: string;
    pairingService: PairingBackendService;
    port?: number;
}): PairingAdminServer;
//# sourceMappingURL=admin-server.d.ts.map