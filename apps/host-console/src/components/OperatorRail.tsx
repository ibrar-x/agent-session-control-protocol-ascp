import type {
  ApprovalRequest,
  Artifact,
  DiffSummary,
  EventEnvelope,
  InputRequest,
  Run,
  Session
} from "ascp-sdk-typescript/models";

import { JsonDisclosure } from "./JsonDisclosure";

interface OperatorRailProps {
  mode: "idle" | "loading" | "live" | "snapshot-only" | "error";
  session: Session | null;
  currentRun: Run | null;
  approvals: ApprovalRequest[];
  inputs: InputRequest[];
  events: EventEnvelope[];
  artifacts: Artifact[];
  artifactDetail: Artifact | null;
  diff: DiffSummary | null;
  capabilities: unknown;
  artifactsExpanded: boolean;
  diffExpanded: boolean;
  selectedArtifactId: string | null;
  onToggleArtifacts: () => void;
  onToggleDiff: () => void;
  onSelectArtifact: (artifactId: string) => void;
  onRetryLive: () => void;
}

function pendingCount(approvals: ApprovalRequest[], inputs: InputRequest[]): number {
  return approvals.filter((item) => item.status === "pending").length + inputs.filter((item) => item.status === "pending").length;
}

export function OperatorRail({
  mode,
  session,
  currentRun,
  approvals,
  inputs,
  events,
  artifacts,
  artifactDetail,
  diff,
  capabilities,
  artifactsExpanded,
  diffExpanded,
  selectedArtifactId,
  onToggleArtifacts,
  onToggleDiff,
  onSelectArtifact,
  onRetryLive
}: OperatorRailProps) {
  return (
    <aside className="operator-rail">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Operator Rail</p>
          <h2>State and Protocol</h2>
        </div>
        {mode === "live" ? <span className="live-dot">Live</span> : null}
      </div>

      {mode === "snapshot-only" ? (
        <div className="rail-banner warning">
          <strong>Live updates paused</strong>
          <p>The session snapshot is loaded, but the live subscription is not attached.</p>
          <button type="button" className="ghost" onClick={onRetryLive}>
            Retry live attach
          </button>
        </div>
      ) : null}

      <section className="rail-card">
        <h3>Session summary</h3>
        {session === null ? <p className="empty">No session selected.</p> : null}
        {session !== null ? (
          <>
            <strong>{session.title ?? session.id}</strong>
            <p>{session.summary ?? "No summary provided."}</p>
            <span className={`status-pill status-${session.status}`}>{session.status}</span>
            <JsonDisclosure label="Session payload" value={session} />
          </>
        ) : null}
      </section>

      <section className="rail-card">
        <h3>Current run</h3>
        {currentRun === null ? <p className="empty">No active or recent run.</p> : null}
        {currentRun !== null ? (
          <>
            <strong>{currentRun.id}</strong>
            <p>{currentRun.status}</p>
            <JsonDisclosure label="Run payload" value={currentRun} />
          </>
        ) : null}
      </section>

      <section className="rail-card">
        <h3>Pending interactions</h3>
        <p>{pendingCount(approvals, inputs)} active</p>
        {approvals.filter((item) => item.status === "pending").map((approval) => (
          <div key={approval.id} className="mini-row">
            <strong>{approval.title ?? approval.id}</strong>
            <span>Approval</span>
          </div>
        ))}
        {inputs.filter((item) => item.status === "pending").map((input) => (
          <div key={input.id} className="mini-row">
            <strong>{input.question}</strong>
            <span>Input</span>
          </div>
        ))}
        {pendingCount(approvals, inputs) === 0 ? <p className="empty">No pending interactions.</p> : null}
      </section>

      <section className="rail-card">
        <div className="rail-card-head">
          <h3>Artifacts and diffs</h3>
          <button type="button" className="ghost" onClick={onToggleArtifacts}>
            {artifactsExpanded ? "Collapse" : "Expand"}
          </button>
        </div>
        <p>{artifacts.length > 0 ? `${artifacts.length} artifacts loaded` : "Load on demand from this card."}</p>
        {artifactsExpanded ? (
          <>
            {artifacts.map((artifact) => (
              <button
                key={artifact.id}
                type="button"
                className={`mini-row ghost mini-action ${selectedArtifactId === artifact.id ? "selected" : ""}`}
                onClick={() => onSelectArtifact(artifact.id)}
              >
                <strong>{artifact.name ?? artifact.id}</strong>
                <span>{artifact.kind}</span>
              </button>
            ))}
            {artifactDetail !== null ? <JsonDisclosure label="Selected artifact" value={artifactDetail} /> : null}
            <button type="button" className="ghost" onClick={onToggleDiff}>
              {diffExpanded ? "Hide diff" : "Open diff"}
            </button>
          </>
        ) : null}
        {diffExpanded && diff !== null ? <JsonDisclosure label="Diff payload" value={diff} defaultOpen /> : null}
      </section>

      <section className="rail-card">
        <h3>Recent events</h3>
        <p>{events.length} captured for this session</p>
        {events.slice(0, 6).map((event) => (
          <div key={event.id} className="mini-row">
            <strong>{event.type}</strong>
            <span>{event.ts}</span>
          </div>
        ))}
        {events.length > 0 ? <JsonDisclosure label="Recent event envelopes" value={events.slice(0, 20)} /> : null}
      </section>

      <section className="rail-card">
        <h3>Capabilities</h3>
        <JsonDisclosure label="Capability document" value={capabilities ?? {}} />
      </section>
    </aside>
  );
}
