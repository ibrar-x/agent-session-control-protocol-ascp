import { useEffect, useRef, useState } from "react";

import {
  type Artifact,
  type CapabilityDocument,
  type DiffSummary,
  type FlexibleObject,
  type InputRequest,
  type Run,
  type Session
} from "ascp-sdk-typescript/models";
import {
  AscpProtocolError,
  createAscpClient,
  type AscpClient
} from "ascp-sdk-typescript/client";
import type { AscpTransportSubscription } from "ascp-sdk-typescript/transport";
import { AscpBrowserWebSocketTransport } from "ascp-sdk-typescript/transport/browser-websocket";

import { ChatPane } from "./components/ChatPane";
import { OperatorRail } from "./components/OperatorRail";
import { SessionSwitcher } from "./components/SessionSwitcher";
import {
  createLoadingSessionView,
  hydrateSessionSnapshot,
  mergeApprovals,
  mergeInputs,
  type SessionViewState
} from "./model";
import { buildSessionSubscriptionRequest } from "./subscriptions";
import { buildTimeline } from "./timeline";

type ConnectionState = "disconnected" | "connecting" | "connected" | "error";

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function readString(value: unknown, key: string): string | undefined {
  if (!isRecord(value)) {
    return undefined;
  }

  const candidate = value[key];
  return typeof candidate === "string" ? candidate : undefined;
}

function sortRuns(runs: Array<Record<string, unknown>> | undefined): Run[] {
  return (runs ?? [])
    .filter((run): run is Run => typeof run.id === "string" && typeof run.started_at === "string")
    .sort((left, right) => right.started_at.localeCompare(left.started_at));
}

function upsertById<T extends { id: string }>(items: T[], nextItem: T): T[] {
  const existingIndex = items.findIndex((item) => item.id === nextItem.id);

  if (existingIndex === -1) {
    return [...items, nextItem];
  }

  return items.map((item) => (item.id === nextItem.id ? nextItem : item));
}

function appendEvent(events: EventEnvelope[], nextEvent: EventEnvelope): EventEnvelope[] {
  if (events.some((event) => event.id === nextEvent.id)) {
    return events;
  }

  return [...events, nextEvent]
    .sort((left, right) => {
      const leftSeq = typeof left.seq === "number" ? left.seq : Number.MAX_SAFE_INTEGER;
      const rightSeq = typeof right.seq === "number" ? right.seq : Number.MAX_SAFE_INTEGER;

      if (leftSeq !== rightSeq) {
        return leftSeq - rightSeq;
      }

      return left.ts.localeCompare(right.ts);
    })
    .slice(-120);
}

function pendingInputRequest(inputs: InputRequest[]): InputRequest | undefined {
  return inputs.find((input) => input.status === "pending");
}

function updateApprovalStatus(
  approvals: ApprovalRequest[],
  approvalId: string,
  status: ApprovalRequest["status"],
  resolvedAt?: string
): ApprovalRequest[] {
  return approvals.map((approval) =>
    approval.id === approvalId
      ? {
          ...approval,
          status,
          ...(resolvedAt !== undefined ? { resolved_at: resolvedAt } : {})
        }
      : approval
  );
}

function updateInputStatus(
  inputs: InputRequest[],
  inputId: string,
  status: InputRequest["status"]
): InputRequest[] {
  return inputs.map((input) => (input.id === inputId ? { ...input, status } : input));
}

function updateRunCollection(runs: Run[], nextRun: Run): Run[] {
  return upsertById(runs, nextRun).sort((left, right) => right.started_at.localeCompare(left.started_at));
}

function updateRunFromCompletion(
  runs: Run[],
  runId: string,
  status: Run["status"],
  payload: Record<string, unknown>
): Run[] {
  return runs
    .map((run) =>
      run.id === runId
        ? {
            ...run,
            status,
            ended_at: readString(payload, "ended_at") ?? run.ended_at,
            ...(typeof payload.exit_code === "number" ? { exit_code: payload.exit_code } : {})
          }
        : run
    )
    .sort((left, right) => right.started_at.localeCompare(left.started_at));
}

function integrateEvent(view: SessionViewState, event: EventEnvelope): SessionViewState {
  const payload = isRecord(event.payload) ? event.payload : {};
  const nextView: SessionViewState = {
    ...view,
    events: appendEvent(view.events, event)
  };

  switch (event.type) {
    case "sync.snapshot": {
      const session = isRecord(payload.session) ? (payload.session as Session) : view.session;
      const approvals = Array.isArray(payload.pending_approvals)
        ? mergeApprovals(view.approvals, payload.pending_approvals as ApprovalRequest[])
        : view.approvals;
      const inputs = Array.isArray(payload.pending_inputs)
        ? mergeInputs(view.inputs, payload.pending_inputs as InputRequest[])
        : view.inputs;

      return {
        ...nextView,
        session,
        approvals,
        inputs
      };
    }
    case "approval.requested": {
      const approval = isRecord(payload.approval) ? (payload.approval as ApprovalRequest) : undefined;

      return approval === undefined
        ? nextView
        : {
            ...nextView,
            approvals: upsertById(view.approvals, approval)
          };
    }
    case "approval.updated":
    case "approval.approved":
    case "approval.rejected":
    case "approval.expired": {
      const approvalId = readString(payload, "approval_id");

      if (approvalId === undefined) {
        return nextView;
      }

      const status =
        event.type === "approval.approved"
          ? "approved"
          : event.type === "approval.rejected"
            ? "rejected"
            : event.type === "approval.expired"
              ? "expired"
              : readString(payload, "status") === "approved" || readString(payload, "status") === "rejected"
                ? (readString(payload, "status") as ApprovalRequest["status"])
                : "pending";

      return {
        ...nextView,
        approvals: updateApprovalStatus(view.approvals, approvalId, status, readString(payload, "resolved_at") ?? event.ts)
      };
    }
    case "input.requested": {
      const input = isRecord(payload.input) ? (payload.input as InputRequest) : undefined;

      return input === undefined
        ? nextView
        : {
            ...nextView,
            inputs: upsertById(view.inputs, input)
          };
    }
    case "input.completed": {
      const inputId = readString(payload, "input_id");

      return inputId === undefined
        ? nextView
        : {
            ...nextView,
            inputs: updateInputStatus(view.inputs, inputId, "answered")
          };
    }
    case "input.expired": {
      const inputId = readString(payload, "input_id");

      return inputId === undefined
        ? nextView
        : {
            ...nextView,
            inputs: updateInputStatus(view.inputs, inputId, "expired")
          };
    }
    case "session.status_changed": {
      return view.session === null
        ? nextView
        : {
            ...nextView,
            session: {
              ...view.session,
              status: (readString(payload, "to") as Session["status"]) ?? view.session.status,
              updated_at: event.ts
            }
          };
    }
    case "run.started": {
      const run = isRecord(payload.run) ? (payload.run as Run) : undefined;

      return run === undefined
        ? nextView
        : {
            ...nextView,
            runs: updateRunCollection(view.runs, run),
            currentRun: run
          };
    }
    case "run.completed":
    case "run.failed":
    case "run.cancelled": {
      if (event.run_id === undefined) {
        return nextView;
      }

      const status =
        event.type === "run.completed"
          ? "completed"
          : event.type === "run.failed"
            ? "failed"
            : "cancelled";
      const runs = updateRunFromCompletion(view.runs, event.run_id, status, payload);

      return {
        ...nextView,
        runs,
        currentRun: runs.find((run) => run.id === event.run_id) ?? runs[0] ?? null
      };
    }
    default:
      return nextView;
  }
}

function defaultRuntimeId(capabilities: CapabilityDocument | null): string | null {
  return capabilities?.runtimes[0]?.id ?? null;
}

function isUnmaterializedThreadError(error: unknown): boolean {
  const message = error instanceof Error ? error.message : String(error);
  return message.includes("includeTurns is unavailable before first user message");
}

export function App() {
  const clientRef = useRef<AscpClient | null>(null);
  const streamRef = useRef<AscpTransportSubscription | null>(null);
  const subscriptionIdRef = useRef("");
  const selectedSessionIdRef = useRef<string | null>(null);
  const loadRequestRef = useRef(0);

  const [url, setUrl] = useState("ws://127.0.0.1:8765");
  const [connectionState, setConnectionState] = useState<ConnectionState>("disconnected");
  const [error, setError] = useState<string | null>(null);
  const [sessions, setSessions] = useState<Session[]>([]);
  const [capabilities, setCapabilities] = useState<CapabilityDocument | null>(null);
  const [selectedSessionId, setSelectedSessionId] = useState<string | null>(null);
  const [sessionView, setSessionView] = useState<SessionViewState | null>(null);
  const [composerValue, setComposerValue] = useState("say only yes");
  const [startTitle, setStartTitle] = useState("");
  const [startPrompt, setStartPrompt] = useState("");

  useEffect(() => {
    return () => {
      void disconnect();
    };
  }, []);

  async function closeSessionSubscription(client: AscpClient | null): Promise<void> {
    const subscriptionId = subscriptionIdRef.current;

    if (client === null || subscriptionId.length === 0) {
      subscriptionIdRef.current = "";
      return;
    }

    try {
      await client.unsubscribe({
        subscription_id: subscriptionId
      });
    } catch {
      // Best-effort cleanup only.
    }

    subscriptionIdRef.current = "";
  }

  async function disconnect(options: { preserveSelection?: boolean } = {}): Promise<void> {
    const client = clientRef.current;
    const stream = streamRef.current;
    const preservedSessionId = options.preserveSelection === true ? selectedSessionIdRef.current : null;

    await closeSessionSubscription(client);

    try {
      await stream?.close();
    } catch {
      // Ignore transport close errors during cleanup.
    }

    try {
      await client?.close();
    } catch {
      // Ignore runtime close errors during cleanup.
    }

    clientRef.current = null;
    streamRef.current = null;
    loadRequestRef.current += 1;

    setConnectionState("disconnected");
    setSessions([]);
    setCapabilities(null);
    setError(null);

    if (preservedSessionId === null) {
      selectedSessionIdRef.current = null;
      setSelectedSessionId(null);
      setSessionView(null);
      return;
    }

    selectedSessionIdRef.current = preservedSessionId;
    setSelectedSessionId(preservedSessionId);
    setSessionView(createLoadingSessionView(preservedSessionId));
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

  async function attachSessionSubscription(sessionId: string, client = clientRef.current): Promise<void> {
    if (client === null) {
      return;
    }

    await closeSessionSubscription(client);

    const result = await client.subscribe({
      ...buildSessionSubscriptionRequest(sessionId)
    });
    subscriptionIdRef.current = result.subscription_id;
  }

  async function loadSelectedSession(
    sessionId: string,
    options: {
      markLoading: boolean;
      resubscribe: boolean;
    }
  ): Promise<void> {
    const client = clientRef.current;

    if (client === null) {
      return;
    }

    const requestId = ++loadRequestRef.current;

    if (options.markLoading) {
      setSessionView(createLoadingSessionView(sessionId));
    }

    try {
      const result = await client.getSession({
        session_id: sessionId,
        include_runs: true,
        include_pending_approvals: true,
        include_pending_inputs: true
      });

      if (selectedSessionIdRef.current !== sessionId || requestId !== loadRequestRef.current) {
        return;
      }

      const nextRuns = sortRuns(result.runs);

      setSessionView((current) => {
        const previous = current?.sessionId === sessionId ? current : null;
        const hydrated = hydrateSessionSnapshot({
          sessionId,
          session: result.session,
          runs: nextRuns,
          approvals: [],
          inputs: []
        });

        return {
          ...hydrated,
          approvals: mergeApprovals(previous?.approvals ?? [], result.pending_approvals ?? []),
          inputs: mergeInputs(previous?.inputs ?? [], result.pending_inputs ?? []),
          events: previous?.events ?? [],
          artifacts: previous?.artifacts ?? [],
          artifactDetail: previous?.artifactDetail ?? null,
          diff: previous?.diff ?? null,
          expanded: previous?.expanded ?? hydrated.expanded,
          mode: previous?.mode === "snapshot-only" ? "snapshot-only" : "live",
          livePausedReason: previous?.mode === "snapshot-only" ? previous.livePausedReason : undefined
        };
      });

      if (options.resubscribe) {
        try {
          await attachSessionSubscription(sessionId, client);
          setSessionView((current) =>
            current?.sessionId === sessionId
              ? {
                  ...current,
                  mode: "live",
                  livePausedReason: undefined
                }
              : current
          );
        } catch (subscribeError) {
          setSessionView((current) =>
            current?.sessionId === sessionId
              ? {
                  ...current,
                  mode: "snapshot-only",
                  livePausedReason: "subscribe_failed"
                }
              : current
          );
          setError(
            subscribeError instanceof Error ? subscribeError.message : String(subscribeError)
          );
        }
      }
    } catch (loadError) {
      if (selectedSessionIdRef.current !== sessionId || requestId !== loadRequestRef.current) {
        return;
      }

      if (isUnmaterializedThreadError(loadError)) {
        const fallbackSession = sessions.find((session) => session.id === sessionId);

        if (fallbackSession !== undefined) {
          setSessionView((current) => {
            const previous = current?.sessionId === sessionId ? current : null;
            const hydrated = hydrateSessionSnapshot({
              sessionId,
              session: fallbackSession,
              runs: [],
              approvals: [],
              inputs: []
            });

            return {
              ...hydrated,
              approvals: previous?.approvals ?? [],
              inputs: previous?.inputs ?? [],
              events: previous?.events ?? [],
              artifacts: previous?.artifacts ?? [],
              artifactDetail: previous?.artifactDetail ?? null,
              diff: previous?.diff ?? null,
              expanded: previous?.expanded ?? hydrated.expanded,
              mode: "snapshot-only",
              livePausedReason: "subscribe_failed"
            };
          });
          setError(null);
          return;
        }
      }

      setSessionView({
        ...createLoadingSessionView(sessionId),
        mode: "error"
      });
      setError(loadError instanceof Error ? loadError.message : String(loadError));
    }
  }

  async function inspectSession(sessionId: string): Promise<void> {
    selectedSessionIdRef.current = sessionId;
    setSelectedSessionId(sessionId);
    setError(null);
    setSessionView(createLoadingSessionView(sessionId));
    await loadSelectedSession(sessionId, {
      markLoading: false,
      resubscribe: true
    });
  }

  async function connect(): Promise<void> {
    const reconnectSessionId = selectedSessionIdRef.current;

    await disconnect({
      preserveSelection: reconnectSessionId !== null
    });
    setConnectionState("connecting");
    setError(null);

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
            if (selectedSessionIdRef.current === event.session_id) {
              setSessionView((current) =>
                current?.sessionId === event.session_id ? integrateEvent(current, event) : current
              );
            }

            if (
              event.type === "session.status_changed" ||
              event.type.startsWith("run.") ||
              event.type.startsWith("approval.") ||
              event.type.startsWith("input.")
            ) {
              void refreshSessions(clientRef.current);
            }
          }
        } catch (streamError) {
          setConnectionState("error");
          setError(streamError instanceof Error ? streamError.message : String(streamError));
          setSessionView((current) =>
            current === null
              ? current
              : {
                  ...current,
                  mode: "snapshot-only",
                  livePausedReason: "subscription_dropped"
                }
          );
        }
      })();

      const capabilityDocument = await client.getCapabilities();
      setCapabilities(capabilityDocument);
      await refreshSessions(client);

      if (reconnectSessionId !== null) {
        await loadSelectedSession(reconnectSessionId, {
          markLoading: false,
          resubscribe: true
        });
      }
    } catch (connectError) {
      setConnectionState("error");
      setError(connectError instanceof Error ? connectError.message : String(connectError));
    }
  }

  async function retryLiveAttach(): Promise<void> {
    const sessionId = selectedSessionIdRef.current;

    if (sessionId === null) {
      return;
    }

    try {
      await attachSessionSubscription(sessionId);
      setSessionView((current) =>
        current?.sessionId === sessionId
          ? {
              ...current,
              mode: "live",
              livePausedReason: undefined
            }
          : current
      );
    } catch (retryError) {
      setConnectionState("error");
      setError(retryError instanceof Error ? retryError.message : String(retryError));
    }
  }

  async function startSession(): Promise<void> {
    const client = clientRef.current;
    const runtimeId = defaultRuntimeId(capabilities);

    if (client === null || runtimeId === null || startPrompt.trim().length === 0) {
      return;
    }

    try {
      const result = await client.startSession({
        runtime_id: runtimeId,
        ...(startTitle.trim().length > 0 ? { title: startTitle.trim() } : {}),
        initial_prompt: startPrompt.trim()
      });
      setStartTitle("");
      setStartPrompt("");
      selectedSessionIdRef.current = result.session.id;
      setSelectedSessionId(result.session.id);
      setSessionView({
        ...hydrateSessionSnapshot({
          sessionId: result.session.id,
          session: result.session,
          runs: [],
          approvals: [],
          inputs: []
        }),
        mode: "snapshot-only",
        livePausedReason: "subscribe_failed"
      });
      setError(null);
      await refreshSessions(client);
    } catch (startError) {
      if (startError instanceof AscpProtocolError) {
        setError(`${startError.code}: ${startError.message}`);
        return;
      }

      setError(startError instanceof Error ? startError.message : String(startError));
    }
  }

  async function sendInput(): Promise<void> {
    const client = clientRef.current;
    const session = sessionView?.session;
    const text = composerValue.trim();

    if (client === null || session === null || text.length === 0) {
      return;
    }

    const inputRequest = pendingInputRequest(sessionView?.inputs ?? []);

    await client.sendInput({
      session_id: session.id,
      input: text,
      ...(inputRequest !== undefined
        ? {
            metadata: {
              request_id: inputRequest.id
            }
          }
        : {})
    });

    setComposerValue("");
    setSessionView((current) =>
      current === null
        ? current
        : {
            ...current,
            inputs:
              inputRequest === undefined
                ? current.inputs
                : updateInputStatus(current.inputs, inputRequest.id, "answered")
          }
    );

    if (sessionView?.mode !== "live") {
      await loadSelectedSession(session.id, {
        markLoading: false,
        resubscribe: true
      });
    }
  }

  async function respondApproval(
    approvalId: string,
    decision: "approved" | "rejected"
  ): Promise<void> {
    const client = clientRef.current;

    if (client === null) {
      return;
    }

    await client.respondApproval({
      approval_id: approvalId,
      decision
    });

    setSessionView((current) =>
      current === null
        ? current
        : {
            ...current,
            approvals: updateApprovalStatus(
              current.approvals,
              approvalId,
              decision === "approved" ? "approved" : "rejected",
              new Date().toISOString()
            )
          }
    );
  }

  async function loadArtifacts(): Promise<void> {
    const client = clientRef.current;
    const session = sessionView?.session;

    if (client === null || session === null) {
      return;
    }

    const result = await client.listArtifacts({
      session_id: session.id,
      ...(sessionView?.currentRun?.id !== undefined ? { run_id: sessionView.currentRun.id } : {})
    });

    setSessionView((current) =>
      current?.sessionId === session.id
        ? {
            ...current,
            artifacts: result.artifacts
          }
        : current
    );
  }

  async function loadArtifactDetail(artifactId: string): Promise<void> {
    const client = clientRef.current;

    if (client === null) {
      return;
    }

    const result = await client.getArtifact({
      artifact_id: artifactId
    });

    setSessionView((current) =>
      current === null
        ? current
        : {
            ...current,
            artifactDetail: result.artifact
          }
    );
  }

  async function loadDiff(): Promise<void> {
    const client = clientRef.current;
    const session = sessionView?.session;
    const run = sessionView?.currentRun;

    if (client === null || session === null || run === null) {
      return;
    }

    const result = await client.getDiff({
      session_id: session.id,
      run_id: run.id
    });

    setSessionView((current) =>
      current?.sessionId === session.id
        ? {
            ...current,
            diff: result.diff
          }
        : current
    );
  }

  async function toggleArtifacts(): Promise<void> {
    if (sessionView === null) {
      return;
    }

    const nextExpanded = !sessionView.expanded.artifacts;

    setSessionView((current) =>
      current === null
        ? current
        : {
            ...current,
            expanded: {
              ...current.expanded,
              artifacts: nextExpanded,
              ...(nextExpanded ? {} : { diff: false })
            }
          }
    );

    if (nextExpanded && sessionView.artifacts.length === 0) {
      await loadArtifacts();
    }
  }

  async function toggleDiff(): Promise<void> {
    if (sessionView === null) {
      return;
    }

    const nextExpanded = !sessionView.expanded.diff;

    setSessionView((current) =>
      current === null
        ? current
        : {
            ...current,
            expanded: {
              ...current.expanded,
              diff: nextExpanded
            }
          }
    );

    if (nextExpanded && sessionView.diff === null) {
      await loadDiff();
    }
  }

  const timeline = buildTimeline(
    sessionView?.events ?? [],
    sessionView?.approvals ?? [],
    sessionView?.inputs ?? []
  );
  const viewMode = sessionView?.mode ?? "idle";

  return (
    <div className="app-shell">
      <header className="topbar">
        <div className="brand-block">
          <p className="eyebrow">ASCP Host Console</p>
          <h1>Codex-first operator workspace</h1>
          <p className="subcopy">
            Live chat on the left, protocol truth on the right. Sessions, blocked interactions,
            artifacts, and diffs all flow through the same ASCP host surface.
          </p>
        </div>
        <div className="topbar-controls">
          <label className="host-field">
            <span>Host URL</span>
            <input value={url} onChange={(event) => setUrl(event.target.value)} />
          </label>
          <div className="topbar-actions">
            <button type="button" onClick={() => void connect()} disabled={connectionState === "connecting"}>
              {connectionState === "disconnected" ? "Connect" : "Reconnect"}
            </button>
            <button type="button" className="ghost" onClick={() => void disconnect()}>
              Disconnect
            </button>
          </div>
          <div className={`connection-pill connection-${connectionState}`}>{connectionState}</div>
        </div>
      </header>

      {error !== null ? (
        <section className="global-alert">
          <strong>Runtime message</strong>
          <p>{error}</p>
        </section>
      ) : null}

      <main className="workspace">
        <SessionSwitcher
          sessions={sessions}
          selectedSessionId={selectedSessionId}
          startTitle={startTitle}
          startPrompt={startPrompt}
          canStart={connectionState === "connected" && defaultRuntimeId(capabilities) !== null}
          onSelectSession={(sessionId) => void inspectSession(sessionId)}
          onRefresh={() => void refreshSessions()}
          onStartTitleChange={setStartTitle}
          onStartPromptChange={setStartPrompt}
          onStartSession={() => void startSession()}
        />

        <section className="workspace-main">
          <ChatPane
            mode={viewMode}
            session={sessionView?.session ?? null}
            timeline={timeline}
            composerValue={composerValue}
            onComposerChange={setComposerValue}
            onSend={() => void sendInput()}
            onApprove={(approvalId) => void respondApproval(approvalId, "approved")}
            onReject={(approvalId) => void respondApproval(approvalId, "rejected")}
            onRetryLive={() => void retryLiveAttach()}
            livePausedReason={
              sessionView?.livePausedReason === "subscription_dropped"
                ? "The live connection dropped after the snapshot loaded."
                : sessionView?.livePausedReason === "subscribe_failed"
                  ? "The live subscription could not attach after the snapshot loaded."
                  : undefined
            }
          />
          <OperatorRail
            mode={viewMode}
            session={sessionView?.session ?? null}
            currentRun={sessionView?.currentRun ?? null}
            approvals={sessionView?.approvals ?? []}
            inputs={sessionView?.inputs ?? []}
            events={sessionView?.events ?? []}
            artifacts={sessionView?.artifacts ?? []}
            artifactDetail={sessionView?.artifactDetail ?? null}
            diff={sessionView?.diff ?? null}
            capabilities={capabilities}
            artifactsExpanded={sessionView?.expanded.artifacts ?? false}
            diffExpanded={sessionView?.expanded.diff ?? false}
            selectedArtifactId={sessionView?.artifactDetail?.id ?? null}
            onToggleArtifacts={() => void toggleArtifacts()}
            onToggleDiff={() => void toggleDiff()}
            onSelectArtifact={(artifactId) => void loadArtifactDetail(artifactId)}
            onRetryLive={() => void retryLiveAttach()}
          />
        </section>
      </main>
    </div>
  );
}
