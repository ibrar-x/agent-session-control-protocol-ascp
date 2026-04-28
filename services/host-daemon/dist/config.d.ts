export type DaemonRuntimeKind = "codex";
export type DaemonAuthTransport = "loopback" | "tls";
export interface HostDaemonConfig {
    adminPort: number;
    authTransport: DaemonAuthTransport;
    databasePath: string;
    host: string;
    port: number;
    runtime: DaemonRuntimeKind;
}
export declare function resolveDaemonConfig(env: NodeJS.ProcessEnv, defaults?: Partial<HostDaemonConfig>): HostDaemonConfig;
//# sourceMappingURL=config.d.ts.map