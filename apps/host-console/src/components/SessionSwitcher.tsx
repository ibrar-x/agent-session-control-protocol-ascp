import type { Session } from "ascp-sdk-typescript/models";

interface SessionSwitcherProps {
  sessions: Session[];
  selectedSessionId: string | null;
  startTitle: string;
  startPrompt: string;
  canStart: boolean;
  onSelectSession: (sessionId: string) => void;
  onRefresh: () => void;
  onStartTitleChange: (value: string) => void;
  onStartPromptChange: (value: string) => void;
  onStartSession: () => void;
}

function sessionTitle(session: Session): string {
  return session.title ?? session.summary ?? session.id;
}

export function SessionSwitcher({
  sessions,
  selectedSessionId,
  startTitle,
  startPrompt,
  canStart,
  onSelectSession,
  onRefresh,
  onStartTitleChange,
  onStartPromptChange,
  onStartSession
}: SessionSwitcherProps) {
  return (
    <aside className="session-switcher">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Live Sessions</p>
          <h2>Threads</h2>
        </div>
        <button type="button" className="ghost" onClick={onRefresh}>
          Refresh
        </button>
      </div>
      <section className="session-create">
        <label>
          Session title
          <input
            value={startTitle}
            onChange={(event) => onStartTitleChange(event.target.value)}
            placeholder="Upgrade npm packages"
          />
        </label>
        <label>
          Initial prompt
          <textarea
            rows={4}
            value={startPrompt}
            onChange={(event) => onStartPromptChange(event.target.value)}
            placeholder="Describe what the agent should do first"
          />
        </label>
        <button type="button" onClick={onStartSession} disabled={!canStart || startPrompt.trim().length === 0}>
          Start session
        </button>
      </section>
      <div className="session-list">
        {sessions.map((session) => {
          const selected = selectedSessionId === session.id;
          const blocked =
            session.status === "waiting_approval" || session.status === "waiting_input";

          return (
            <button
              key={session.id}
              type="button"
              className={`session-row ${selected ? "selected" : ""}`}
              onClick={() => onSelectSession(session.id)}
            >
              <div className="session-row-top">
                <strong>{sessionTitle(session)}</strong>
                <span className={`status-pill status-${session.status}`}>{session.status}</span>
              </div>
              <div className="session-row-meta">
                <span>{session.updated_at}</span>
                {blocked ? (
                  <span className="blocked-badge">
                    {session.status === "waiting_approval" ? "Approval" : "Input"}
                  </span>
                ) : null}
              </div>
            </button>
          );
        })}
        {sessions.length === 0 ? <p className="empty">No sessions loaded.</p> : null}
      </div>
    </aside>
  );
}
