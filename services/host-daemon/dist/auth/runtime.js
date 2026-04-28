export function createAuthAwareRuntime(deps) {
    return {
        ...deps.runtime,
        async capabilitiesGet() {
            const capabilities = await deps.runtime.capabilitiesGet();
            const currentAuth = typeof capabilities === "object" && capabilities !== null && "auth" in capabilities
                ? (capabilities.auth ?? {})
                : {};
            return {
                ...capabilities,
                auth: {
                    ...currentAuth,
                    transport: deps.transportMode
                }
            };
        }
    };
}
//# sourceMappingURL=runtime.js.map