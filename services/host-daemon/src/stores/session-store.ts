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

interface SessionRow {
  session_id: string;
  runtime_id: string;
  session_json: string;
  active_run_json: string | null;
  pending_approvals_json: string;
  pending_inputs_json: string;
  snapshot_origin: SnapshotOrigin;
  completeness: SnapshotCompleteness;
  missing_fields_json: string;
  missing_reasons_json: string;
  attachment_status: AttachmentStatus;
  seeded_at: string;
  updated_at: string;
}

function serialize(value: unknown): string {
  return JSON.stringify(value);
}

function parseJson<TValue>(value: string): TValue {
  return JSON.parse(value) as TValue;
}

function hydrateSnapshot(row: SessionRow): StoredSessionSnapshot {
  return {
    sessionId: row.session_id,
    runtimeId: row.runtime_id,
    session: parseJson<Record<string, unknown>>(row.session_json),
    activeRun:
      row.active_run_json === null ? null : parseJson<Record<string, unknown>>(row.active_run_json),
    pendingApprovals: parseJson<Record<string, unknown>[]>(row.pending_approvals_json),
    pendingInputs: parseJson<Record<string, unknown>[]>(row.pending_inputs_json),
    snapshotOrigin: row.snapshot_origin,
    completeness: row.completeness,
    missingFields: parseJson<string[]>(row.missing_fields_json),
    missingReasons: parseJson<Record<string, string>>(row.missing_reasons_json),
    attachmentStatus: row.attachment_status,
    seededAt: row.seeded_at,
    updatedAt: row.updated_at
  };
}

export interface SessionStore {
  getSnapshot(sessionId: string): StoredSessionSnapshot | null;
  upsertSeededSnapshot(snapshot: SeededSessionSnapshotInput): StoredSessionSnapshot;
}

export function createSessionStore(database: DaemonDatabase): SessionStore {
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
      const row = selectSnapshot.get(sessionId) as SessionRow | undefined;
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
