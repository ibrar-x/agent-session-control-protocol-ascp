import type { IncomingMessage } from "node:http";
import type { ConnectionAuthState } from "@ascp/host-service";
import type { AuthTransportMode } from "./types.js";
import type { TrustStore } from "./trust-store.js";
export interface Authenticator {
    authenticateRequest(request: IncomingMessage): Promise<ConnectionAuthState>;
}
export declare function createAuthenticator(deps: {
    transportMode: AuthTransportMode;
    trustStore: TrustStore;
}): Authenticator;
//# sourceMappingURL=authenticator.d.ts.map