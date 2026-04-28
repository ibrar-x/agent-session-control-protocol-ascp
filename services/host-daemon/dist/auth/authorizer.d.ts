import type { ConnectionAuthState, RequestContext } from "@ascp/host-service";
import type { CoreMethodName, RequestId } from "ascp-sdk-typescript";
export interface Authorizer {
    createRequestContext(input: {
        connectionAuth: ConnectionAuthState;
        correlationId?: string;
        method: CoreMethodName;
        params?: Record<string, unknown>;
        requestId: RequestId;
    }): RequestContext;
}
export declare function createAuthorizer(): Authorizer;
//# sourceMappingURL=authorizer.d.ts.map