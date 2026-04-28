function parseJson(value) {
    return JSON.parse(value);
}
function serialize(value) {
    return JSON.stringify(value);
}
function hydrateCursor(row) {
    return {
        sessionId: row.session_id,
        origin: row.origin,
        lastSeq: row.last_seq,
        lastEventId: row.last_event_id,
        cursor: parseJson(row.cursor_json)
    };
}
export function createCursorStore(database) {
    const selectCursor = database.prepare(`
    SELECT session_id, origin, last_seq, last_event_id, cursor_json
    FROM daemon_session_cursors
    WHERE session_id = ?
  `);
    const upsertCursor = database.prepare(`
    INSERT INTO daemon_session_cursors (
      session_id,
      origin,
      last_seq,
      last_event_id,
      cursor_json,
      updated_at
    ) VALUES (
      @session_id,
      @origin,
      @last_seq,
      @last_event_id,
      @cursor_json,
      @updated_at
    )
    ON CONFLICT(session_id) DO UPDATE SET
      origin = excluded.origin,
      last_seq = excluded.last_seq,
      last_event_id = excluded.last_event_id,
      cursor_json = excluded.cursor_json,
      updated_at = excluded.updated_at
  `);
    const storeCursor = (sessionId, origin, lastSeq, lastEventId, cursor) => {
        upsertCursor.run({
            session_id: sessionId,
            origin,
            last_seq: lastSeq,
            last_event_id: lastEventId,
            cursor_json: serialize(cursor),
            updated_at: new Date().toISOString()
        });
        const stored = selectCursor.get(sessionId);
        if (stored === undefined) {
            throw new Error(`Failed to persist daemon cursor: ${sessionId}`);
        }
        return hydrateCursor(stored);
    };
    return {
        getCursor(sessionId) {
            const row = selectCursor.get(sessionId);
            return row === undefined ? null : hydrateCursor(row);
        },
        initializeSeededCursor(sessionId, cursor = {}) {
            const existing = this.getCursor(sessionId);
            if (existing !== null && existing.origin === "live_stream") {
                return existing;
            }
            return storeCursor(sessionId, "seeded_snapshot", null, null, cursor);
        },
        recordLivePosition(input) {
            return storeCursor(input.sessionId, "live_stream", input.lastSeq, input.lastEventId, input.cursor ?? {});
        }
    };
}
//# sourceMappingURL=cursor-store.js.map