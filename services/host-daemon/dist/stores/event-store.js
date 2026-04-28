function parseJson(value) {
    return JSON.parse(value);
}
function serialize(value) {
    return JSON.stringify(value);
}
function isSyntheticReplayControlEvent(type) {
    return type === "sync.snapshot" || type === "sync.replayed";
}
function hydrateEvent(row) {
    return parseJson(row.event_json);
}
export function createEventStore(database) {
    const selectNextSeq = database.prepare(`
    SELECT COALESCE(MAX(seq), 0) + 1 AS next_seq
    FROM daemon_session_events
    WHERE session_id = ?
  `);
    const insertEvent = database.prepare(`
    INSERT INTO daemon_session_events (
      session_id,
      seq,
      event_id,
      event_type,
      event_ts,
      event_json,
      persisted_at
    ) VALUES (
      @session_id,
      @seq,
      @event_id,
      @event_type,
      @event_ts,
      @event_json,
      @persisted_at
    )
  `);
    const selectAfterSeq = database.prepare(`
    SELECT seq, event_json
    FROM daemon_session_events
    WHERE session_id = ? AND seq > ?
    ORDER BY seq ASC
  `);
    const selectEventSeq = database.prepare(`
    SELECT seq
    FROM daemon_session_events
    WHERE session_id = ? AND event_id = ?
  `);
    return {
        append(event) {
            if (isSyntheticReplayControlEvent(event.type)) {
                throw new Error("Synthetic replay-control events must not be persisted");
            }
            database.exec("BEGIN IMMEDIATE");
            try {
                const { next_seq } = selectNextSeq.get(event.session_id);
                const storedEvent = {
                    ...event,
                    seq: next_seq
                };
                insertEvent.run({
                    session_id: storedEvent.session_id,
                    seq: storedEvent.seq,
                    event_id: storedEvent.id,
                    event_type: storedEvent.type,
                    event_ts: storedEvent.ts,
                    event_json: serialize(storedEvent),
                    persisted_at: new Date().toISOString()
                });
                database.exec("COMMIT");
                return storedEvent;
            }
            catch (error) {
                database.exec("ROLLBACK");
                throw error;
            }
        },
        listAfterSeq(sessionId, seq) {
            return selectAfterSeq.all(sessionId, seq).map(hydrateEvent);
        },
        listAfterEventId(sessionId, eventId) {
            const anchor = selectEventSeq.get(sessionId, eventId);
            return anchor === undefined ? [] : this.listAfterSeq(sessionId, anchor.seq);
        }
    };
}
//# sourceMappingURL=event-store.js.map