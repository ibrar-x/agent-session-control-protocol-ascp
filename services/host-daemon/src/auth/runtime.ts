import type { AscpHostRuntime } from "@ascp/host-service";

import type { AuthTransportMode } from "./types.js";

export function createAuthAwareRuntime(deps: {
  runtime: AscpHostRuntime;
  transportMode: AuthTransportMode;
}): AscpHostRuntime {
  return {
    ...deps.runtime,
    async capabilitiesGet() {
      const capabilities = await deps.runtime.capabilitiesGet();
      const currentAuth =
        typeof capabilities === "object" && capabilities !== null && "auth" in capabilities
          ? ((capabilities as { auth?: Record<string, unknown> }).auth ?? {})
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
