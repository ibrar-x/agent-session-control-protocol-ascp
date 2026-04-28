import type { DaemonDatabase } from "../sqlite.js";
export type CursorOrigin = "seeded_snapshot" | "live_stream";
export interface StoredCursor {
    sessionId: string;
    origin: CursorOrigin;
    lastSeq: number | null;
    lastEventId: string | null;
    cursor: Record<string, unknown>;
}
export interface RecordLivePositionInput {
    sessionId: string;
    lastSeq: number;
    lastEventId: string;
    cursor?: Record<string, unknown>;
}
export interface CursorStore {
    getCursor(sessionId: string): StoredCursor | null;
    initializeSeededCursor(sessionId: string, cursor?: Record<string, unknown>): StoredCursor;
    recordLivePosition(input: RecordLivePositionInput): StoredCursor;
}
export declare function createCursorStore(database: DaemonDatabase): CursorStore;
//# sourceMappingURL=cursor-store.d.ts.map