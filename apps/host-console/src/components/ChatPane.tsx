import type { ApprovalRequest, InputRequest, Session } from "ascp-sdk-typescript/models";

export interface ChatTimelineItem {
  id: string;
  kind: "system" | "user" | "assistant" | "approval" | "input" | "activity";
  title?: string;
  body: string;
  ts?: string;
  state?: "pending" | "answered" | "expired";
  approval?: ApprovalRequest;
  input?: InputRequest;
}

interface ChatPaneProps {
  mode: "idle" | "loading" | "live" | "snapshot-only" | "error";
  session: Session | null;
  timeline: ChatTimelineItem[];
  composerValue: string;
  onComposerChange: (value: string) => void;
  onSend: () => void;
  onApprove: (approvalId: string) => void;
  onReject: (approvalId: string) => void;
  onRetryLive: () => void;
  livePausedReason?: string;
}

function sessionHeading(session: Session | null): string {
  if (session === null) {
    return "Select a session";
  }

  return session.title ?? session.summary ?? session.id;
}

export function ChatPane({
  mode,
  session,
  timeline,
  composerValue,
  onComposerChange,
  onSend,
  onApprove,
  onReject,
  onRetryLive,
  livePausedReason
}: ChatPaneProps) {
  return (
    <section className="chat-pane">
      <header className="chat-header">
        <div>
          <p className="eyebrow">Selected Session</p>
          <h1>{sessionHeading(session)}</h1>
        </div>
        {mode === "live" ? <span className="live-dot">Live</span> : null}
        {mode === "snapshot-only" ? (
          <div className="paused-inline">
            <strong>Live updates paused</strong>
            <span>{livePausedReason ?? "Subscription attach failed."}</span>
            <button type="button" className="ghost" onClick={onRetryLive}>
              Retry live attach
            </button>
          </div>
        ) : null}
      </header>

      <div className="timeline">
        {mode === "error" ? (
          <div className="timeline-empty">
            <strong>Session load failed.</strong>
            <p>Reconnect the host or select the session again to retry.</p>
          </div>
        ) : null}
        {mode === "loading" ? (
          <div className="loading-stack">
            <div className="skeleton bubble-skeleton" />
            <div className="skeleton card-skeleton" />
            <div className="skeleton bubble-skeleton wide" />
          </div>
        ) : null}
        {mode !== "loading" && mode !== "error" && timeline.length === 0 ? (
          <div className="timeline-empty">
            <strong>Session loaded.</strong>
            <p>Historical transcript is limited to the current browser session. Live events and blocked interactions will appear here.</p>
          </div>
        ) : null}
        {mode !== "loading"
          ? timeline.map((item) => {
              if (item.kind === "approval") {
                return (
                  <article key={item.id} className={`interaction-card approval ${item.state}`}>
                    <div className="interaction-head">
                      <span>Approval request</span>
                      <small>{item.state}</small>
                    </div>
                    <strong>{item.approval?.title ?? item.title}</strong>
                    <p>{item.body}</p>
                    {item.state === "pending" && item.approval !== undefined ? (
                      <div className="actions">
                        <button type="button" onClick={() => onApprove(item.approval!.id)}>
                          Approve
                        </button>
                        <button
                          type="button"
                          className="ghost"
                          onClick={() => onReject(item.approval!.id)}
                        >
                          Reject
                        </button>
                      </div>
                    ) : null}
                  </article>
                );
              }

              if (item.kind === "input") {
                return (
                  <article key={item.id} className={`interaction-card input ${item.state}`}>
                    <div className="interaction-head">
                      <span>Agent question</span>
                      <small>{item.state}</small>
                    </div>
                    <strong>{item.title ?? "Input request"}</strong>
                    <p>{item.body}</p>
                  </article>
                );
              }

              if (item.kind === "user" || item.kind === "assistant") {
                return (
                  <article key={item.id} className={`chat-bubble ${item.kind}`}>
                    {item.title !== undefined ? <strong>{item.title}</strong> : null}
                    <p>{item.body}</p>
                    {item.ts !== undefined ? <small>{item.ts}</small> : null}
                  </article>
                );
              }

              return (
                <article key={item.id} className={`timeline-note ${item.kind}`}>
                  {item.title !== undefined ? <strong>{item.title}</strong> : null}
                  <p>{item.body}</p>
                  {item.ts !== undefined ? <small>{item.ts}</small> : null}
                </article>
              );
            })
          : null}
      </div>

      <footer className="composer">
        <textarea
          rows={3}
          value={composerValue}
          onChange={(event) => onComposerChange(event.target.value)}
          placeholder="Send input to the selected session"
          disabled={session === null}
        />
        <div className="composer-actions">
          <span>{session?.id ?? "No session selected"}</span>
          <button type="button" onClick={onSend} disabled={session === null || composerValue.trim().length === 0}>
            Send
          </button>
        </div>
      </footer>
    </section>
  );
}
