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
export interface EventStore {
    append(event: PersistedEventInput): StoredEventEnvelope;
    listAfterSeq(sessionId: string, seq: number): StoredEventEnvelope[];
    listAfterEventId(sessionId: string, eventId: string): StoredEventEnvelope[];
}
export declare function createEventStore(database: DaemonDatabase): EventStore;
//# sourceMappingURL=event-store.d.ts.map