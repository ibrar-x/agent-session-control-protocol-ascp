import { createDefaultCodexHostRuntime } from "@ascp/adapter-codex";
export function createRuntimeRegistry(factories) {
    const codexFactory = factories?.codex ?? (() => createDefaultCodexHostRuntime());
    return {
        createRuntime(runtime) {
            if (runtime === "codex") {
                return codexFactory();
            }
            throw new Error(`Unsupported daemon runtime: ${runtime}`);
        }
    };
}
export function isDaemonRuntimeKind(value) {
    return value === "codex";
}
//# sourceMappingURL=runtime-registry.js.map