import type { PairingCreateFormState, PairingSessionRecord } from "../types";

const AVAILABLE_SCOPES = [
  "read:hosts",
  "read:runtimes",
  "read:sessions",
  "write:sessions",
  "read:approvals",
  "write:approvals",
  "read:artifacts"
] as const;

interface PairingSessionsPanelProps {
  canSubmit: boolean;
  createForm: PairingCreateFormState;
  error: string | null;
  isSubmitting: boolean;
  onChangeScopes: (scopes: string[]) => void;
  onChangeTtlMinutes: (ttlMinutes: number) => void;
  onCopyCode: (sessionId: string) => void;
  onCreate: () => void;
  onRefresh: () => void;
  sessions: PairingSessionRecord[];
}

function formatList(values: string[]): string {
  return values.length > 0 ? values.join(", ") : "None requested";
}

function renderLifecycleDetails(session: PairingSessionRecord) {
  return (
    <dl className="pairing-session-details">
      <div>
        <dt>Created</dt>
        <dd>{session.createdAt}</dd>
      </div>
      <div>
        <dt>Expires</dt>
        <dd>{session.expiresAt}</dd>
      </div>
      <div>
        <dt>Claimed</dt>
        <dd>{session.claimedAt ?? "Waiting for device claim"}</dd>
      </div>
      <div>
        <dt>Approved</dt>
        <dd>{session.approvedAt ?? "Not approved"}</dd>
      </div>
      <div>
        <dt>Rejected</dt>
        <dd>{session.rejectedAt ?? "Not rejected"}</dd>
      </div>
      <div>
        <dt>Consumed</dt>
        <dd>{session.consumedAt ?? "Pending device pickup"}</dd>
      </div>
    </dl>
  );
}

export function PairingSessionsPanel(props: PairingSessionsPanelProps) {
  return (
    <section className="pairing-panel pairing-sessions-panel">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Pairing Sessions</p>
          <h2>Lifecycle</h2>
        </div>
        <button type="button" className="ghost" onClick={props.onRefresh}>
          Refresh
        </button>
      </div>

      <div className="pairing-create-card">
        <div className="pairing-create-grid">
          <label>
            Requested scopes
            <select
              multiple
              value={props.createForm.requestedScopes}
              onChange={(event) =>
                props.onChangeScopes(Array.from(event.target.selectedOptions).map((option) => option.value))
              }
            >
              {AVAILABLE_SCOPES.map((scope) => (
                <option key={scope} value={scope}>
                  {scope}
                </option>
              ))}
            </select>
          </label>

          <label>
            TTL minutes
            <input
              type="number"
              min={1}
              max={30}
              value={props.createForm.ttlMinutes}
              onChange={(event) => props.onChangeTtlMinutes(Number(event.target.value))}
            />
          </label>
        </div>

        <div className="topbar-actions">
          <button type="button" onClick={props.onCreate} disabled={!props.canSubmit || props.isSubmitting}>
            {props.isSubmitting ? "Creating…" : "Create pairing session"}
          </button>
        </div>

        <p className="subcopy">Show raw pairing code in v1. QR payload is retained but not rendered yet.</p>
        {props.error ? <p className="panel-error">{props.error}</p> : null}
      </div>

      {props.sessions.length === 0 ? <p className="empty">No pairing sessions created yet.</p> : null}

      <div className="pairing-session-list">
        {props.sessions.map((session) => (
          <article key={session.sessionId} className="pairing-session-card">
            <div className="session-row-top">
              <div>
                <strong>{session.code}</strong>
                <p className="subcopy">{session.sessionId}</p>
              </div>
              <span className={`status-pill status-${session.status}`}>{session.status}</span>
            </div>

            <div className="session-row-meta">
              <span>{session.deviceLabel ?? "Waiting for claim"}</span>
              <span>{session.issuedDeviceId ?? "No issued device yet"}</span>
            </div>

            <p>Scopes: {formatList(session.requestedScopes)}</p>

            <div className="code-row">
              <code>{session.code}</code>
              <button type="button" className="ghost" onClick={() => props.onCopyCode(session.sessionId)}>
                {session.copiedCode ? "Copied" : "Copy code"}
              </button>
            </div>

            <p className="subcopy">Copyable text only in v1. QR rendering is intentionally out of scope.</p>

            {renderLifecycleDetails(session)}

            {session.error ? <p className="panel-error">{session.error}</p> : null}
          </article>
        ))}
      </div>
    </section>
  );
}
