import type { AttachmentStatus, SnapshotCompleteness, SnapshotOrigin } from "./stores/session-store.js";
export interface SnapshotMetadataInput {
    snapshotOrigin: SnapshotOrigin;
    attachmentStatus: AttachmentStatus;
    activeRun?: Record<string, unknown> | null;
    pendingApprovals: Record<string, unknown>[];
    pendingInputs: Record<string, unknown>[];
}
export interface SnapshotMetadata {
    snapshotOrigin: SnapshotOrigin;
    completeness: SnapshotCompleteness;
    missingFields: string[];
    missingReasons: Record<string, string>;
    attachmentStatus: AttachmentStatus;
}
export declare function buildSnapshotMetadata(input: SnapshotMetadataInput): SnapshotMetadata;
//# sourceMappingURL=metadata.d.ts.map