export interface HostDaemonLogger {
    info(message: string, details?: Record<string, unknown>): void;
    error(message: string, details?: Record<string, unknown>): void;
}
export declare function createConsoleLogger(): HostDaemonLogger;
//# sourceMappingURL=logger.d.ts.map