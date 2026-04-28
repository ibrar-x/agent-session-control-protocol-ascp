function serialize(value) {
    return JSON.stringify(value);
}
function parseJson(value) {
    return JSON.parse(value);
}
function hydrateAuditLog(row) {
    return {
        correlationId: row.correlation_id,
        ts: row.ts,
        stage: row.stage,
        method: row.method,
        requestId: row.request_id,
        deviceId: row.device_id,
        actorId: row.actor_id,
        transportMode: row.transport_mode,
        authState: row.auth_state,
        authorizationState: row.authorization_state,
        outcome: row.outcome,
        errorCode: row.error_code,
        details: row.details_json === null ? null : parseJson(row.details_json)
    };
}
export function createAuditStore(database) {
    const insertAuditLog = database.prepare(`
    INSERT INTO daemon_audit_log (
      correlation_id,
      ts,
      stage,
      method,
      request_id,
      device_id,
      actor_id,
      transport_mode,
      auth_state,
      authorization_state,
      outcome,
      error_code,
      details_json
    ) VALUES (
      @correlation_id,
      @ts,
      @stage,
      @method,
      @request_id,
      @device_id,
      @actor_id,
      @transport_mode,
      @auth_state,
      @authorization_state,
      @outcome,
      @error_code,
      @details_json
    )
  `);
    const selectByCorrelationId = database.prepare(`
    SELECT
      correlation_id,
      ts,
      stage,
      method,
      request_id,
      device_id,
      actor_id,
      transport_mode,
      auth_state,
      authorization_state,
      outcome,
      error_code,
      details_json
    FROM daemon_audit_log
    WHERE correlation_id = ?
    ORDER BY rowid ASC
  `);
    return {
        append(entry) {
            const ts = entry.ts ?? new Date().toISOString();
            insertAuditLog.run({
                correlation_id: entry.correlationId,
                ts,
                stage: entry.stage,
                method: entry.method,
                request_id: entry.requestId ?? null,
                device_id: entry.deviceId ?? null,
                actor_id: entry.actorId ?? null,
                transport_mode: entry.transportMode,
                auth_state: entry.authState,
                authorization_state: entry.authorizationState,
                outcome: entry.outcome,
                error_code: entry.errorCode ?? null,
                details_json: entry.details === undefined || entry.details === null ? null : serialize(entry.details)
            });
            const [stored] = this.listByCorrelationId(entry.correlationId).slice(-1);
            if (stored === undefined) {
                throw new Error(`Failed to persist audit log: ${entry.correlationId}`);
            }
            return stored;
        },
        listByCorrelationId(correlationId) {
            return selectByCorrelationId.all(correlationId).map(hydrateAuditLog);
        }
    };
}
//# sourceMappingURL=audit-store.js.map