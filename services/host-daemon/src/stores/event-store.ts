import type { DaemonDatabase } from "../sqlite.js";

export interface StoredEventEnvelope<TPayload extends Record<string, unknown> = Record<string, unknown>> {
  id: string;
  type: string;
  ts: string;
  session_id: string;
  payload: TPayload;
  run_id?: string;
  seq: number;
}

export interface PersistedEventInput<TPayload extends Record<string, unknown> = Record<string, unknown>> {
  id: string;
  type: string;
  ts: string;
  session_id: string;
  payload: TPayload;
  run_id?: string;
}

interface EventRow {
  seq: number;
  event_json: string;
}

function parseJson<TValue>(value: string): TValue {
  return JSON.parse(value) as TValue;
}

function serialize(value: unknown): string {
  return JSON.stringify(value);
}

function isSyntheticReplayControlEvent(type: string): boolean {
  return type === "sync.snapshot" || type === "sync.replayed";
}

function hydrateEvent(row: EventRow): StoredEventEnvelope {
  return parseJson<StoredEventEnvelope>(row.event_json);
}

export interface EventStore {
  append(event: PersistedEventInput): StoredEventEnvelope;
  listAfterSeq(sessionId: string, seq: number): StoredEventEnvelope[];
  listAfterEventId(sessionId: string, eventId: string): StoredEventEnvelope[];
}

export function createEventStore(database: DaemonDatabase): EventStore {
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
        const { next_seq } = selectNextSeq.get(event.session_id) as { next_seq: number };
        const storedEvent: StoredEventEnvelope = {
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
      } catch (error) {
        database.exec("ROLLBACK");
        throw error;
      }
    },
    listAfterSeq(sessionId, seq) {
      return (selectAfterSeq.all(sessionId, seq) as unknown as EventRow[]).map(hydrateEvent);
    },
    listAfterEventId(sessionId, eventId) {
      const anchor = selectEventSeq.get(sessionId, eventId) as unknown as
        | { seq: number }
        | undefined;
      return anchor === undefined ? [] : this.listAfterSeq(sessionId, anchor.seq);
    }
  };
}
