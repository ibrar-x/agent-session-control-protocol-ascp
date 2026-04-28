import { randomUUID } from "node:crypto";
const METHOD_SCOPE_POLICY = {
    "capabilities.get": "read:hosts",
    "hosts.get": "read:hosts",
    "runtimes.list": "read:runtimes",
    "sessions.list": "read:sessions",
    "sessions.get": "read:sessions",
    "sessions.subscribe": "read:sessions",
    "sessions.unsubscribe": "read:sessions",
    "sessions.start": "write:sessions",
    "sessions.resume": "write:sessions",
    "sessions.stop": "write:sessions",
    "sessions.send_input": "write:sessions",
    "approvals.list": "read:approvals",
    "approvals.respond": "write:approvals",
    "artifacts.list": "read:artifacts",
    "artifacts.get": "read:artifacts",
    "diffs.get": "read:artifacts"
};
export function createAuthorizer() {
    return {
        createRequestContext(input) {
            if (!input.connectionAuth.authenticated) {
                throw ascpError("UNAUTHORIZED", input.connectionAuth.errorMessage ?? "Device authentication required.", {
                    correlation_id: input.correlationId ?? randomUUID(),
                    method: input.method
                });
            }
            const requiredScope = METHOD_SCOPE_POLICY[input.method];
            if (requiredScope !== undefined &&
                !input.connectionAuth.scopes.includes(requiredScope)) {
                throw ascpError("FORBIDDEN", `Missing scope: ${requiredScope}`, {
                    correlation_id: input.correlationId ?? randomUUID(),
                    method: input.method,
                    required_scope: requiredScope
                });
            }
            return {
                actorId: input.connectionAuth.actorId,
                correlationId: input.correlationId ?? randomUUID(),
                deviceId: input.connectionAuth.deviceId,
                method: input.method,
                requestId: input.requestId,
                scopes: input.connectionAuth.scopes,
                transportMode: input.connectionAuth.transportMode
            };
        }
    };
}
function ascpError(code, message, details) {
    return {
        code,
        details,
        message,
        retryable: false
    };
}
//# sourceMappingURL=authorizer.js.map