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

export function buildSnapshotMetadata(input: SnapshotMetadataInput): SnapshotMetadata {
  const missingFields: string[] = [];
  const missingReasons: Record<string, string> = {};

  if (input.activeRun === undefined) {
    missingFields.push("active_run");
    missingReasons.active_run = "runtime_omitted";
  }

  return {
    snapshotOrigin: input.snapshotOrigin,
    completeness: missingFields.length === 0 ? "complete" : "partial",
    missingFields,
    missingReasons,
    attachmentStatus: input.attachmentStatus
  };
}
