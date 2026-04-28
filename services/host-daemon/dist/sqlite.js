import { mkdirSync } from "node:fs";
import { dirname } from "node:path";
import { DatabaseSync } from "node:sqlite";
const BOOTSTRAP_SQL = `
  CREATE TABLE IF NOT EXISTS daemon_sessions (
    session_id TEXT PRIMARY KEY,
    runtime_id TEXT NOT NULL,
    session_json TEXT NOT NULL,
    active_run_json TEXT,
    pending_approvals_json TEXT NOT NULL,
    pending_inputs_json TEXT NOT NULL,
    snapshot_origin TEXT NOT NULL,
    completeness TEXT NOT NULL,
    missing_fields_json TEXT NOT NULL,
    missing_reasons_json TEXT NOT NULL,
    attachment_status TEXT NOT NULL,
    seeded_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS daemon_session_events (
    session_id TEXT NOT NULL,
    seq INTEGER NOT NULL,
    event_id TEXT NOT NULL UNIQUE,
    event_type TEXT NOT NULL,
    event_ts TEXT NOT NULL,
    event_json TEXT NOT NULL,
    persisted_at TEXT NOT NULL,
    PRIMARY KEY (session_id, seq)
  );

  CREATE TABLE IF NOT EXISTS daemon_session_cursors (
    session_id TEXT PRIMARY KEY,
    origin TEXT NOT NULL,
    last_seq INTEGER,
    last_event_id TEXT,
    cursor_json TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS daemon_trusted_devices (
    device_id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    scopes_json TEXT NOT NULL,
    paired_at TEXT NOT NULL,
    last_seen_at TEXT,
    revoked INTEGER NOT NULL DEFAULT 0,
    revoked_at TEXT,
    secret_salt TEXT NOT NULL,
    secret_verifier TEXT NOT NULL,
    kdf TEXT NOT NULL,
    kdf_params_json TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS daemon_audit_log (
    correlation_id TEXT NOT NULL,
    ts TEXT NOT NULL,
    stage TEXT NOT NULL,
    method TEXT NOT NULL,
    request_id TEXT,
    device_id TEXT,
    actor_id TEXT,
    transport_mode TEXT NOT NULL,
    auth_state TEXT NOT NULL,
    authorization_state TEXT NOT NULL,
    outcome TEXT NOT NULL,
    error_code TEXT,
    details_json TEXT
  );

  CREATE TABLE IF NOT EXISTS daemon_pairing_sessions (
    session_id TEXT PRIMARY KEY,
    pairing_code TEXT NOT NULL UNIQUE,
    claim_token TEXT UNIQUE,
    requested_scopes_json TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    claimed_at TEXT,
    approved_at TEXT,
    rejected_at TEXT,
    consumed_at TEXT,
    device_label TEXT,
    issued_device_id TEXT
  );

  CREATE INDEX IF NOT EXISTS daemon_pairing_sessions_status_idx
    ON daemon_pairing_sessions (status, expires_at);
`;
function ensureParentDirectory(path) {
    if (path === ":memory:" || path.length === 0) {
        return;
    }
    mkdirSync(dirname(path), { recursive: true });
}
export function openDaemonDatabase(path) {
    ensureParentDirectory(path);
    const database = new DatabaseSync(path);
    database.exec(BOOTSTRAP_SQL);
    return database;
}
//# sourceMappingURL=sqlite.js.map