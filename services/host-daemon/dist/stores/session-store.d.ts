import type { DaemonDatabase } from "../sqlite.js";
export type SnapshotOrigin = "seeded_snapshot" | "live_stream";
export type SnapshotCompleteness = "complete" | "partial";
export type AttachmentStatus = "attached" | "detached";
export interface StoredSessionSnapshot {
    sessionId: string;
    runtimeId: string;
    session: Record<string, unknown>;
    activeRun: Record<string, unknown> | null;
    pendingApprovals: Record<string, unknown>[];
    pendingInputs: Record<string, unknown>[];
    snapshotOrigin: SnapshotOrigin;
    completeness: SnapshotCompleteness;
    missingFields: string[];
    missingReasons: Record<string, string>;
    attachmentStatus: AttachmentStatus;
    seededAt: string;
    updatedAt: string;
}
export interface SeededSessionSnapshotInput {
    sessionId: string;
    runtimeId: string;
    session: Record<string, unknown>;
    activeRun: Record<string, unknown> | null;
    pendingApprovals: Record<string, unknown>[];
    pendingInputs: Record<string, unknown>[];
    snapshotOrigin: SnapshotOrigin;
    completeness: SnapshotCompleteness;
    missingFields: string[];
    missingReasons: Record<string, string>;
    attachmentStatus: AttachmentStatus;
}
export interface SessionStore {
    getSnapshot(sessionId: string): StoredSessionSnapshot | null;
    upsertSeededSnapshot(snapshot: SeededSessionSnapshotInput): StoredSessionSnapshot;
}
export declare function createSessionStore(database: DaemonDatabase): SessionStore;
//# sourceMappingURL=session-store.d.ts.map