import type { AscpHostRuntime } from "@ascp/host-service";
import type { DaemonRuntimeKind } from "./config.js";
export interface RuntimeRegistry {
    createRuntime(runtime: string): AscpHostRuntime;
}
export interface RuntimeRegistryFactories {
    codex: () => AscpHostRuntime;
}
export declare function createRuntimeRegistry(factories?: Partial<RuntimeRegistryFactories>): RuntimeRegistry;
export declare function isDaemonRuntimeKind(value: string): value is DaemonRuntimeKind;
//# sourceMappingURL=runtime-registry.d.ts.map