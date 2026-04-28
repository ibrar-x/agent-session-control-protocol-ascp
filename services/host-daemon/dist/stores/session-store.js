function serialize(value) {
    return JSON.stringify(value);
}
function parseJson(value) {
    return JSON.parse(value);
}
function hydrateSnapshot(row) {
    return {
        sessionId: row.session_id,
        runtimeId: row.runtime_id,
        session: parseJson(row.session_json),
        activeRun: row.active_run_json === null ? null : parseJson(row.active_run_json),
        pendingApprovals: parseJson(row.pending_approvals_json),
        pendingInputs: parseJson(row.pending_inputs_json),
        snapshotOrigin: row.snapshot_origin,
        completeness: row.completeness,
        missingFields: parseJson(row.missing_fields_json),
        missingReasons: parseJson(row.missing_reasons_json),
        attachmentStatus: row.attachment_status,
        seededAt: row.seeded_at,
        updatedAt: row.updated_at
    };
}
export function createSessionStore(database) {
    const selectSnapshot = database.prepare(`
    SELECT
      session_id,
      runtime_id,
      session_json,
      active_run_json,
      pending_approvals_json,
      pending_inputs_json,
      snapshot_origin,
      completeness,
      missing_fields_json,
      missing_reasons_json,
      attachment_status,
      seeded_at,
      updated_at
    FROM daemon_sessions
    WHERE session_id = ?
  `);
    const upsertSnapshot = database.prepare(`
    INSERT INTO daemon_sessions (
      session_id,
      runtime_id,
      session_json,
      active_run_json,
      pending_approvals_json,
      pending_inputs_json,
      snapshot_origin,
      completeness,
      missing_fields_json,
      missing_reasons_json,
      attachment_status,
      seeded_at,
      updated_at
    ) VALUES (
      @session_id,
      @runtime_id,
      @session_json,
      @active_run_json,
      @pending_approvals_json,
      @pending_inputs_json,
      @snapshot_origin,
      @completeness,
      @missing_fields_json,
      @missing_reasons_json,
      @attachment_status,
      @seeded_at,
      @updated_at
    )
    ON CONFLICT(session_id) DO UPDATE SET
      runtime_id = excluded.runtime_id,
      session_json = excluded.session_json,
      active_run_json = excluded.active_run_json,
      pending_approvals_json = excluded.pending_approvals_json,
      pending_inputs_json = excluded.pending_inputs_json,
      snapshot_origin = excluded.snapshot_origin,
      completeness = excluded.completeness,
      missing_fields_json = excluded.missing_fields_json,
      missing_reasons_json = excluded.missing_reasons_json,
      attachment_status = excluded.attachment_status,
      updated_at = excluded.updated_at
  `);
    return {
        getSnapshot(sessionId) {
            const row = selectSnapshot.get(sessionId);
            return row === undefined ? null : hydrateSnapshot(row);
        },
        upsertSeededSnapshot(snapshot) {
            const existing = this.getSnapshot(snapshot.sessionId);
            const now = new Date().toISOString();
            upsertSnapshot.run({
                session_id: snapshot.sessionId,
                runtime_id: snapshot.runtimeId,
                session_json: serialize(snapshot.session),
                active_run_json: snapshot.activeRun === null ? null : serialize(snapshot.activeRun),
                pending_approvals_json: serialize(snapshot.pendingApprovals),
                pending_inputs_json: serialize(snapshot.pendingInputs),
                snapshot_origin: snapshot.snapshotOrigin,
                completeness: snapshot.completeness,
                missing_fields_json: serialize(snapshot.missingFields),
                missing_reasons_json: serialize(snapshot.missingReasons),
                attachment_status: snapshot.attachmentStatus,
                seeded_at: existing?.seededAt ?? now,
                updated_at: now
            });
            const stored = this.getSnapshot(snapshot.sessionId);
            if (stored === null) {
                throw new Error(`Failed to persist daemon session snapshot: ${snapshot.sessionId}`);
            }
            return stored;
        }
    };
}
//# sourceMappingURL=session-store.js.map