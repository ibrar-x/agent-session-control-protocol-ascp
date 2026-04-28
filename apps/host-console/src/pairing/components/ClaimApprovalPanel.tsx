import type { PairingSessionRecord } from "../types";

interface ClaimApprovalPanelProps {
  items: PairingSessionRecord[];
  onApprove: (sessionId: string) => void;
  onReject: (sessionId: string) => void;
}

function formatList(values: string[]): string {
  return values.length > 0 ? values.join(", ") : "None requested";
}

export function ClaimApprovalPanel({ items, onApprove, onReject }: ClaimApprovalPanelProps) {
  return (
    <section className="pairing-panel claim-approval-panel">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Claim Approval</p>
          <h2>Action Queue</h2>
        </div>
      </div>

      {items.length === 0 ? <p className="empty">No claims awaiting host approval.</p> : null}

      <div className="approval-list">
        {items.map((item) => (
          <article key={item.sessionId} className="approval-card">
            <div className="session-row-top">
              <div>
                <strong>{item.deviceLabel ?? item.code}</strong>
                <p className="subcopy">{item.sessionId}</p>
              </div>
              <span className={`status-pill status-${item.status}`}>{item.status}</span>
            </div>

            <p>Scopes: {formatList(item.requestedScopes)}</p>

            <div className="session-row-meta">
              <span>Claimed {item.claimedAt ?? "Awaiting claim timestamp"}</span>
              <span>Expires {item.expiresAt}</span>
            </div>

            <div className="topbar-actions">
              <button type="button" onClick={() => onApprove(item.sessionId)}>
                Approve
              </button>
              <button type="button" className="ghost" onClick={() => onReject(item.sessionId)}>
                Reject
              </button>
            </div>

            {item.error ? <p className="panel-error">{item.error}</p> : null}
          </article>
        ))}
      </div>
    </section>
  );
}
