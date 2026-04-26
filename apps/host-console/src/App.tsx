import { useEffect, useRef, useState } from "react";

import {
  type ApprovalRequest,
  type Artifact,
  type DiffSummary,
  type EventEnvelope,
  type Run,
  type Session
} from "ascp-sdk-typescript/models";
import { createAscpClient, type AscpClient } from "ascp-sdk-typescript/client";
import type { AscpTransportSubscription } from "ascp-sdk-typescript/transport";
import { AscpBrowserWebSocketTransport } from "ascp-sdk-typescript/transport/browser-websocket";

type ConnectionState = "disconnected" | "connecting" | "connected" | "error";

function formatJson(value: unknown): string {
  return JSON.stringify(value, null, 2);
}

function sortRuns(runs: Array<Record<string, unknown>> | undefined): Run[] {
  return (runs ?? [])
    .filter((run): run is Run => typeof run.id === "string")
    .sort((left, right) => right.started_at.localeCompare(left.started_at));
}

export function App() {
  const clientRef = useRef<AscpClient | null>(null);
  const streamRef = useRef<AscpTransportSubscription | null>(null);
  const subscriptionIdRef = useRef("");

  const [url, setUrl] = useState("ws://127.0.0.1:8765");
  const [connectionState, setConnectionState] = useState<ConnectionState>("disconnected");
  const [error, setError] = useState<string | null>(null);
  const [sessions, setSessions] = useState<Session[]>([]);
  const [selectedSession, setSelectedSession] = useState<Session | null>(null);
  const [runs, setRuns] = useState<Run[]>([]);
  const [selectedRunId, setSelectedRunId] = useState<string>("");
  const [subscriptionId, setSubscriptionId] = useState<string>("");
  const [eventLog, setEventLog] = useState<EventEnvelope[]>([]);
  const [inputText, setInputText] = useState("say only yes");
  const [approvals, setApprovals] = useState<ApprovalRequest[]>([]);
  const [artifacts, setArtifacts] = useState<Artifact[]>([]);
  const [artifactDetail, setArtifactDetail] = useState<Artifact | null>(null);
  const [diff, setDiff] = useState<DiffSummary | null>(null);
  const [capabilities, setCapabilities] = useState<string>("");

  useEffect(() => {
    return () => {
      void disconnect();
    };
  }, []);

  async function disconnect(): Promise<void> {
    const client = clientRef.current;
    const stream = streamRef.current;

    setConnectionState("disconnected");
    setSubscriptionId("");
    subscriptionIdRef.current = "";

    try {
      if (subscriptionIdRef.current.length > 0 && client !== null) {
        await client.unsubscribe({
          subscription_id: subscriptionIdRef.current
        });
      }
    } catch {
      // Best-effort cleanup only.
    }

    try {
      await stream?.close();
    } catch {
      // Ignore.
    }

    try {
      await client?.close();
    } catch {
      // Ignore.
    }

    clientRef.current = null;
    streamRef.current = null;
  }

  async function connect(): Promise<void> {
    await disconnect();
    setConnectionState("connecting");
    setError(null);
    setEventLog([]);

    try {
      const transport = new AscpBrowserWebSocketTransport({
        url
      });
      const client = createAscpClient({
        transport
      });
      await client.connect();
      const stream = client.events();

      clientRef.current = client;
      streamRef.current = stream;
      setConnectionState("connected");

      void (async () => {
        try {
          for await (const event of stream) {
            setEventLog((current) => [event, ...current].slice(0, 100));
          }
        } catch (streamError) {
          setError(streamError instanceof Error ? streamError.message : String(streamError));
          setConnectionState("error");
        }
      })();

      const capabilityDocument = await client.getCapabilities();
      setCapabilities(formatJson(capabilityDocument));
      await refreshSessions(client);
    } catch (connectError) {
      setError(connectError instanceof Error ? connectError.message : String(connectError));
      setConnectionState("error");
    }
  }

  async function refreshSessions(client = clientRef.current): Promise<void> {
    if (client === null) {
      return;
    }

    const result = await client.listSessions({
      limit: 20
    });
    setSessions(result.sessions);
  }

  async function inspectSession(sessionId: string): Promise<void> {
    const client = clientRef.current;

    if (client === null) {
      return;
    }

    setError(null);

    try {
      const result = await client.getSession({
        session_id: sessionId,
        include_runs: true,
        include_pending_approvals: true
      });
      const nextRuns = sortRuns(result.runs);

      setSelectedSession(result.session);
      setRuns(nextRuns);
      setSelectedRunId((current) => current || nextRuns[0]?.id || "");
      setApprovals(result.pending_approvals ?? []);
      setArtifacts([]);
      setArtifactDetail(null);
      setDiff(null);
      await subscribeToSession(sessionId, client);
    } catch (sessionError) {
      setError(sessionError instanceof Error ? sessionError.message : String(sessionError));
    }
  }

  async function subscribeToSession(sessionId: string, client = clientRef.current): Promise<void> {
    if (client === null) {
      return;
    }

    if (subscriptionId.length > 0) {
      await client.unsubscribe({
        subscription_id: subscriptionId
      });
      setSubscriptionId("");
    }

    setEventLog([]);

    const result = await client.subscribe({
      session_id: sessionId,
      include_snapshot: true
    });
    setSubscriptionId(result.subscription_id);
    subscriptionIdRef.current = result.subscription_id;
  }

  async function sendInput(): Promise<void> {
    const client = clientRef.current;

    if (client === null || selectedSession === null || inputText.trim().length === 0) {
      return;
    }

    await client.sendInput({
      session_id: selectedSession.id,
      input: inputText
    });
    await inspectSession(selectedSession.id);
  }

  async function loadApprovals(): Promise<void> {
    const client = clientRef.current;

    if (client === null || selectedSession === null) {
      return;
    }

    const result = await client.listApprovals({
      session_id: selectedSession.id
    });
    setApprovals(result.approvals);
  }

  async function respondApproval(approvalId: string, decision: "approved" | "rejected"): Promise<void> {
    const client = clientRef.current;

    if (client === null) {
      return;
    }

    await client.respondApproval({
      approval_id: approvalId,
      decision
    });
    await loadApprovals();
  }

  async function loadArtifacts(): Promise<void> {
    const client = clientRef.current;

    if (client === null || selectedSession === null) {
      return;
    }

    const result = await client.listArtifacts({
      session_id: selectedSession.id,
      ...(selectedRunId.length > 0 ? { run_id: selectedRunId } : {})
    });
    setArtifacts(result.artifacts);
  }

  async function loadArtifact(artifactId: string): Promise<void> {
    const client = clientRef.current;

    if (client === null) {
      return;
    }

    const result = await client.getArtifact({
      artifact_id: artifactId
    });
    setArtifactDetail(result.artifact);
  }

  async function loadDiff(): Promise<void> {
    const client = clientRef.current;

    if (client === null || selectedSession === null || selectedRunId.length === 0) {
      return;
    }

    const result = await client.getDiff({
      session_id: selectedSession.id,
      run_id: selectedRunId
    });
    setDiff(result.diff);
  }

  return (
    <div className="shell">
      <header className="hero">
        <div>
          <p className="eyebrow">ASCP Local Host</p>
          <h1>Codex Operator Console</h1>
          <p className="subcopy">
            Connect to the reusable ASCP WebSocket host, inspect live Codex sessions, and test real-time stream control.
          </p>
        </div>
        <div className={`state state-${connectionState}`}>{connectionState}</div>
      </header>

      <section className="panel connection">
        <label>
          Host URL
          <input value={url} onChange={(event) => setUrl(event.target.value)} />
        </label>
        <div className="actions">
          <button onClick={() => void connect()} disabled={connectionState === "connecting"}>
            Connect
          </button>
          <button onClick={() => void refreshSessions()} disabled={clientRef.current === null}>
            Refresh Sessions
          </button>
          <button onClick={() => void disconnect()}>Disconnect</button>
        </div>
        {error !== null ? <pre className="error-box">{error}</pre> : null}
      </section>

      <main className="grid">
        <section className="panel">
          <div className="panel-header">
            <h2>Sessions</h2>
            <span>{sessions.length}</span>
          </div>
          <div className="session-list">
            {sessions.map((session) => (
              <button
                key={session.id}
                className={`session-card ${selectedSession?.id === session.id ? "selected" : ""}`}
                onClick={() => void inspectSession(session.id)}
              >
                <strong>{session.title ?? session.id}</strong>
                <span>{session.status}</span>
                <small>{session.updated_at}</small>
              </button>
            ))}
          </div>
        </section>

        <section className="panel">
          <div className="panel-header">
            <h2>Session Control</h2>
            <span>{selectedSession?.id ?? "none"}</span>
          </div>
          <label>
            Input
            <textarea
              rows={4}
              value={inputText}
              onChange={(event) => setInputText(event.target.value)}
            />
          </label>
          <div className="actions">
            <button onClick={() => void sendInput()} disabled={selectedSession === null}>
              Send Input
            </button>
            <button
              onClick={() => void selectedSession && subscribeToSession(selectedSession.id)}
              disabled={selectedSession === null}
            >
              Subscribe
            </button>
            <button onClick={() => void loadApprovals()} disabled={selectedSession === null}>
              Load Approvals
            </button>
          </div>
          <label>
            Run For Diff / Artifacts
            <select
              value={selectedRunId}
              onChange={(event) => setSelectedRunId(event.target.value)}
            >
              <option value="">Latest / none</option>
              {runs.map((run) => (
                <option key={run.id} value={run.id}>
                  {run.id}
                </option>
              ))}
            </select>
          </label>
          <div className="actions">
            <button onClick={() => void loadArtifacts()} disabled={selectedSession === null}>
              Load Artifacts
            </button>
            <button onClick={() => void loadDiff()} disabled={selectedRunId.length === 0}>
              Load Diff
            </button>
          </div>
        </section>

        <section className="panel wide">
          <div className="panel-header">
            <h2>Live Event Stream</h2>
            <span>{subscriptionId || "not subscribed"}</span>
          </div>
          <div className="stream">
            {eventLog.length === 0 ? <p className="empty">No events yet.</p> : null}
            {eventLog.map((event) => (
              <article key={event.id} className="event-card">
                <div className="event-head">
                  <strong>{event.type}</strong>
                  <span>seq {event.seq ?? "?"}</span>
                </div>
                <small>{event.ts}</small>
                <pre>{formatJson(event.payload)}</pre>
              </article>
            ))}
          </div>
        </section>

        <section className="panel">
          <div className="panel-header">
            <h2>Approvals</h2>
            <span>{approvals.length}</span>
          </div>
          <div className="stack">
            {approvals.map((approval) => (
              <div key={approval.id} className="tile">
                <strong>{approval.title ?? approval.id}</strong>
                <span>{approval.status}</span>
                <small>{approval.kind}</small>
                <div className="actions">
                  <button onClick={() => void respondApproval(approval.id, "approved")}>
                    Approve
                  </button>
                  <button
                    className="ghost"
                    onClick={() => void respondApproval(approval.id, "rejected")}
                  >
                    Reject
                  </button>
                </div>
              </div>
            ))}
            {approvals.length === 0 ? <p className="empty">No approvals.</p> : null}
          </div>
        </section>

        <section className="panel">
          <div className="panel-header">
            <h2>Artifacts</h2>
            <span>{artifacts.length}</span>
          </div>
          <div className="stack">
            {artifacts.map((artifact) => (
              <button
                key={artifact.id}
                className="tile left"
                onClick={() => void loadArtifact(artifact.id)}
              >
                <strong>{artifact.name ?? artifact.id}</strong>
                <span>{artifact.kind}</span>
              </button>
            ))}
            {artifacts.length === 0 ? <p className="empty">No artifacts loaded.</p> : null}
          </div>
          {artifactDetail !== null ? <pre>{formatJson(artifactDetail)}</pre> : null}
        </section>

        <section className="panel">
          <div className="panel-header">
            <h2>Diff</h2>
            <span>{selectedRunId || "select a run"}</span>
          </div>
          {diff === null ? <p className="empty">No diff loaded.</p> : <pre>{formatJson(diff)}</pre>}
        </section>

        <section className="panel wide">
          <div className="panel-header">
            <h2>Capabilities</h2>
            <span>discovery</span>
          </div>
          <pre>{capabilities || "Connect to load capabilities."}</pre>
        </section>
      </main>
    </div>
  );
}
