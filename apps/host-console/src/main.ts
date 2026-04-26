import { createAscpClient, type AscpClient } from "ascp-sdk-typescript/client";
import type {
  ApprovalRequest,
  Artifact,
  EventEnvelope,
  Session
} from "ascp-sdk-typescript/models";

import { AscpBrowserWebSocketTransport } from "../../../sdks/typescript/src/transport/browser-websocket.js";

import "./styles.css";

const app = requiredElement<HTMLDivElement>("#app");

app.innerHTML = `
  <h1>ASCP Host Console</h1>
  <p class="muted">Codex-first operator console over ASCP websocket.</p>
  <div class="grid">
    <section class="panel">
      <h2>Connection</h2>
      <label for="ws-url">WebSocket URL</label>
      <input id="ws-url" type="text" value="ws://127.0.0.1:7788" />
      <div class="row" style="margin-top:8px;">
        <button id="connect-toggle">Connect</button>
        <button id="refresh-sessions" disabled>Refresh Sessions</button>
      </div>
      <p id="connection-state" class="muted">Disconnected</p>
      <pre id="connection-log"></pre>
    </section>

    <section class="panel">
      <h2>Session</h2>
      <label for="session-select">Select Session</label>
      <select id="session-select" disabled></select>
      <div class="row" style="margin-top:8px;">
        <button id="subscribe-selected" disabled>Subscribe</button>
        <button id="unsubscribe-selected" disabled>Unsubscribe</button>
      </div>
      <pre id="session-details"></pre>
    </section>

    <section class="panel">
      <h2>Send Input</h2>
      <label for="input-kind">Input Kind</label>
      <select id="input-kind">
        <option value="reply">reply</option>
        <option value="text">text</option>
        <option value="instruction">instruction</option>
        <option value="control">control</option>
      </select>
      <label for="input-text" style="margin-top:8px;">Input Payload</label>
      <textarea id="input-text" placeholder="Send an operator message or steer instruction"></textarea>
      <button id="send-input" style="margin-top:8px;" disabled>Send Input</button>
      <pre id="send-input-output"></pre>
    </section>

    <section class="panel">
      <h2>Approvals</h2>
      <button id="refresh-approvals" disabled>Refresh Approvals</button>
      <div id="approvals-list" class="list" style="margin-top:8px;"></div>
      <pre id="approvals-output"></pre>
    </section>

    <section class="panel">
      <h2>Artifacts</h2>
      <button id="refresh-artifacts" disabled>Refresh Artifacts</button>
      <div id="artifacts-list" class="list" style="margin-top:8px;"></div>
      <pre id="artifacts-output"></pre>
    </section>

    <section class="panel">
      <h2>Diffs</h2>
      <label for="diff-run-id">Run ID</label>
      <input id="diff-run-id" type="text" placeholder="run_..." />
      <button id="fetch-diff" style="margin-top:8px;" disabled>Fetch Diff</button>
      <pre id="diff-output"></pre>
    </section>
  </div>
  <section class="panel" style="margin-top:12px;">
    <h2>Live Events</h2>
    <pre id="events-output"></pre>
  </section>
`;

const wsUrlInput = requiredElement<HTMLInputElement>("#ws-url");
const connectToggleButton = requiredElement<HTMLButtonElement>("#connect-toggle");
const refreshSessionsButton = requiredElement<HTMLButtonElement>("#refresh-sessions");
const connectionStateText = requiredElement<HTMLParagraphElement>("#connection-state");
const connectionLogOutput = requiredElement<HTMLPreElement>("#connection-log");

const sessionSelect = requiredElement<HTMLSelectElement>("#session-select");
const subscribeButton = requiredElement<HTMLButtonElement>("#subscribe-selected");
const unsubscribeButton = requiredElement<HTMLButtonElement>("#unsubscribe-selected");
const sessionDetailsOutput = requiredElement<HTMLPreElement>("#session-details");

const inputKindSelect = requiredElement<HTMLSelectElement>("#input-kind");
const inputTextArea = requiredElement<HTMLTextAreaElement>("#input-text");
const sendInputButton = requiredElement<HTMLButtonElement>("#send-input");
const sendInputOutput = requiredElement<HTMLPreElement>("#send-input-output");

const refreshApprovalsButton = requiredElement<HTMLButtonElement>("#refresh-approvals");
const approvalsList = requiredElement<HTMLDivElement>("#approvals-list");
const approvalsOutput = requiredElement<HTMLPreElement>("#approvals-output");

const refreshArtifactsButton = requiredElement<HTMLButtonElement>("#refresh-artifacts");
const artifactsList = requiredElement<HTMLDivElement>("#artifacts-list");
const artifactsOutput = requiredElement<HTMLPreElement>("#artifacts-output");

const diffRunIdInput = requiredElement<HTMLInputElement>("#diff-run-id");
const fetchDiffButton = requiredElement<HTMLButtonElement>("#fetch-diff");
const diffOutput = requiredElement<HTMLPreElement>("#diff-output");

const eventsOutput = requiredElement<HTMLPreElement>("#events-output");

interface AppState {
  client: AscpClient | null;
  connected: boolean;
  currentSubscriptionId: string | null;
  eventStreamToken: number;
  sessions: Session[];
}

const state: AppState = {
  client: null,
  connected: false,
  currentSubscriptionId: null,
  eventStreamToken: 0,
  sessions: []
};

wireActions();
updateConnectionUi();
renderSessions();
appendConnectionLog("Ready.");

function wireActions(): void {
  connectToggleButton.addEventListener("click", async () => {
    if (state.connected) {
      await disconnect();
      return;
    }

    await connect();
  });

  refreshSessionsButton.addEventListener("click", () => {
    void refreshSessions();
  });

  sessionSelect.addEventListener("change", () => {
    const session = selectedSession();
    sessionDetailsOutput.textContent = session === undefined ? "" : formatJson(session);
    void subscribeToSelectedSession();
    void refreshApprovals();
    void refreshArtifacts();
  });

  subscribeButton.addEventListener("click", () => {
    void subscribeToSelectedSession();
  });

  unsubscribeButton.addEventListener("click", () => {
    void unsubscribeCurrentSession();
  });

  sendInputButton.addEventListener("click", () => {
    void sendInput();
  });

  refreshApprovalsButton.addEventListener("click", () => {
    void refreshApprovals();
  });

  approvalsList.addEventListener("click", (event) => {
    const button = (event.target as HTMLElement | null)?.closest("button");

    if (button === null) {
      return;
    }

    const approvalId = button.dataset.approvalId;
    const decision = button.dataset.decision as "approved" | "rejected" | undefined;

    if (approvalId === undefined || decision === undefined) {
      return;
    }

    void respondToApproval(approvalId, decision);
  });

  refreshArtifactsButton.addEventListener("click", () => {
    void refreshArtifacts();
  });

  artifactsList.addEventListener("click", (event) => {
    const button = (event.target as HTMLElement | null)?.closest("button");

    if (button === null) {
      return;
    }

    const artifactId = button.dataset.artifactId;

    if (artifactId === undefined) {
      return;
    }

    void inspectArtifact(artifactId);
  });

  fetchDiffButton.addEventListener("click", () => {
    void inspectDiff();
  });
}

async function connect(): Promise<void> {
  const wsUrl = wsUrlInput.value.trim();

  if (wsUrl.length === 0) {
    appendConnectionLog("WebSocket URL is required.");
    return;
  }

  try {
    const transport = new AscpBrowserWebSocketTransport({
      url: wsUrl
    });
    const client = createAscpClient({
      transport
    });

    await client.connect();

    state.client = client;
    state.connected = true;
    state.currentSubscriptionId = null;

    updateConnectionUi();
    appendConnectionLog(`Connected to ${wsUrl}.`);
    startEventPump(client);
    await refreshSessions();
  } catch (error) {
    appendConnectionLog(`Connect failed: ${stringifyError(error)}`);
  }
}

async function disconnect(): Promise<void> {
  const client = state.client;

  if (client === null) {
    return;
  }

  try {
    await unsubscribeCurrentSession();
    state.eventStreamToken += 1;
    await client.close();
    appendConnectionLog("Disconnected.");
  } catch (error) {
    appendConnectionLog(`Disconnect warning: ${stringifyError(error)}`);
  } finally {
    state.client = null;
    state.connected = false;
    state.currentSubscriptionId = null;
    state.sessions = [];
    updateConnectionUi();
    renderSessions();
    sessionDetailsOutput.textContent = "";
  }
}

function startEventPump(client: AscpClient): void {
  const token = ++state.eventStreamToken;
  const stream = client.events();

  void (async () => {
    try {
      for await (const event of stream) {
        if (token !== state.eventStreamToken) {
          break;
        }

        appendEvent(event);
      }
    } catch (error) {
      if (token === state.eventStreamToken && state.connected) {
        appendConnectionLog(`Event stream closed: ${stringifyError(error)}`);
      }
    }
  })();
}

async function refreshSessions(): Promise<void> {
  const client = state.client;

  if (client === null) {
    return;
  }

  try {
    const result = await client.listSessions({
      limit: 100
    });

    const previous = sessionSelect.value;
    state.sessions = result.sessions;
    renderSessions(previous);
    appendConnectionLog(`Loaded ${result.sessions.length} sessions.`);
  } catch (error) {
    appendConnectionLog(`sessions.list failed: ${stringifyError(error)}`);
  }
}

function renderSessions(preferredSessionId?: string): void {
  const firstSession = state.sessions.at(0);
  const selectedId = preferredSessionId ?? sessionSelect.value ?? firstSession?.id ?? "";
  const options = state.sessions.map((session) => {
    const selected = session.id === selectedId ? "selected" : "";
    return `<option value="${escapeHtml(session.id)}" ${selected}>${escapeHtml(session.id)} (${escapeHtml(session.status)})</option>`;
  });

  sessionSelect.innerHTML = options.join("");
  const session = selectedSession();
  sessionDetailsOutput.textContent = session === undefined ? "" : formatJson(session);
}

async function subscribeToSelectedSession(): Promise<void> {
  const client = state.client;
  const session = selectedSession();

  if (client === null || session === undefined) {
    return;
  }

  try {
    await unsubscribeCurrentSession();

    const result = await client.subscribe({
      session_id: session.id,
      include_snapshot: true
    });

    state.currentSubscriptionId = result.subscription_id;
    appendConnectionLog(
      `Subscribed to ${session.id} with subscription ${result.subscription_id}.`
    );
    updateConnectionUi();
  } catch (error) {
    appendConnectionLog(`sessions.subscribe failed: ${stringifyError(error)}`);
  }
}

async function unsubscribeCurrentSession(): Promise<void> {
  const client = state.client;

  if (client === null || state.currentSubscriptionId === null) {
    return;
  }

  try {
    await client.unsubscribe({
      subscription_id: state.currentSubscriptionId
    });
    appendConnectionLog(`Unsubscribed ${state.currentSubscriptionId}.`);
  } catch (error) {
    appendConnectionLog(`sessions.unsubscribe warning: ${stringifyError(error)}`);
  } finally {
    state.currentSubscriptionId = null;
    updateConnectionUi();
  }
}

async function sendInput(): Promise<void> {
  const client = state.client;
  const session = selectedSession();

  if (client === null || session === undefined) {
    return;
  }

  const input = inputTextArea.value.trim();

  if (input.length === 0) {
    sendInputOutput.textContent = "Input payload is required.";
    return;
  }

  try {
    const result = await client.sendInput({
      session_id: session.id,
      input,
      input_kind: inputKindSelect.value as "text" | "instruction" | "reply" | "control"
    });

    sendInputOutput.textContent = formatJson(result);
  } catch (error) {
    sendInputOutput.textContent = `send_input failed: ${stringifyError(error)}`;
  }
}

async function refreshApprovals(): Promise<void> {
  const client = state.client;
  const session = selectedSession();

  if (client === null) {
    return;
  }

  try {
    const result = await client.listApprovals(
      session === undefined
        ? undefined
        : {
            session_id: session.id
          }
    );

    renderApprovals(result.approvals);
    approvalsOutput.textContent = formatJson(result);
  } catch (error) {
    approvalsOutput.textContent = `approvals.list failed: ${stringifyError(error)}`;
  }
}

function renderApprovals(approvals: ApprovalRequest[]): void {
  if (approvals.length === 0) {
    approvalsList.innerHTML = '<div class="card muted">No approvals found.</div>';
    return;
  }

  approvalsList.innerHTML = approvals
    .map(
      (approval) => `
        <div class="card">
          <div class="card-title">${escapeHtml(approval.id)} (${escapeHtml(approval.status)})</div>
          <div class="muted">${escapeHtml(approval.kind)} | session ${escapeHtml(approval.session_id)}</div>
          <div>${escapeHtml(approval.title ?? "Untitled approval")}</div>
          <div class="row" style="margin-top:8px;">
            <button data-approval-id="${escapeHtml(approval.id)}" data-decision="approved">Approve</button>
            <button data-approval-id="${escapeHtml(approval.id)}" data-decision="rejected">Reject</button>
          </div>
        </div>
      `
    )
    .join("");
}

async function respondToApproval(
  approvalId: string,
  decision: "approved" | "rejected"
): Promise<void> {
  const client = state.client;

  if (client === null) {
    return;
  }

  try {
    const result = await client.respondApproval({
      approval_id: approvalId,
      decision
    });
    approvalsOutput.textContent = formatJson(result);
    await refreshApprovals();
  } catch (error) {
    approvalsOutput.textContent = `approvals.respond failed: ${stringifyError(error)}`;
  }
}

async function refreshArtifacts(): Promise<void> {
  const client = state.client;
  const session = selectedSession();

  if (client === null || session === undefined) {
    artifactsList.innerHTML = '<div class="card muted">Select a session first.</div>';
    return;
  }

  try {
    const result = await client.listArtifacts({
      session_id: session.id
    });

    renderArtifacts(result.artifacts);
    artifactsOutput.textContent = formatJson(result);
  } catch (error) {
    artifactsOutput.textContent = `artifacts.list failed: ${stringifyError(error)}`;
  }
}

function renderArtifacts(artifacts: Artifact[]): void {
  if (artifacts.length === 0) {
    artifactsList.innerHTML = '<div class="card muted">No artifacts found.</div>';
    return;
  }

  artifactsList.innerHTML = artifacts
    .map(
      (artifact) => `
        <div class="card">
          <div class="card-title">${escapeHtml(artifact.id)}</div>
          <div class="muted">${escapeHtml(artifact.kind)} | ${escapeHtml(artifact.run_id ?? "no run")}</div>
          <div>${escapeHtml(artifact.name ?? "(unnamed artifact)")}</div>
          <button data-artifact-id="${escapeHtml(artifact.id)}" style="margin-top:8px;">Inspect</button>
        </div>
      `
    )
    .join("");
}

async function inspectArtifact(artifactId: string): Promise<void> {
  const client = state.client;

  if (client === null) {
    return;
  }

  try {
    const result = await client.getArtifact({
      artifact_id: artifactId
    });
    artifactsOutput.textContent = formatJson(result);
  } catch (error) {
    artifactsOutput.textContent = `artifacts.get failed: ${stringifyError(error)}`;
  }
}

async function inspectDiff(): Promise<void> {
  const client = state.client;
  const session = selectedSession();
  const runId = diffRunIdInput.value.trim();

  if (client === null || session === undefined) {
    return;
  }

  if (runId.length === 0) {
    diffOutput.textContent = "Run ID is required.";
    return;
  }

  try {
    const result = await client.getDiff({
      session_id: session.id,
      run_id: runId
    });
    diffOutput.textContent = formatJson(result);
  } catch (error) {
    diffOutput.textContent = `diffs.get failed: ${stringifyError(error)}`;
  }
}

function selectedSession(): Session | undefined {
  const sessionId = sessionSelect.value;
  return state.sessions.find((session) => session.id === sessionId);
}

function appendEvent(event: EventEnvelope): void {
  const line = `${event.ts} ${event.type} session=${event.session_id} seq=${event.seq ?? "-"}`;
  const current = eventsOutput.textContent?.split("\n").filter((entry) => entry.length > 0) ?? [];
  current.push(`${line}\n${formatJson(event.payload)}`);
  eventsOutput.textContent = current.slice(-30).join("\n\n");
  eventsOutput.scrollTop = eventsOutput.scrollHeight;
}

function updateConnectionUi(): void {
  const connectedClass = state.connected ? "status-online" : "status-offline";
  const connectedText = state.connected ? "Connected" : "Disconnected";

  connectionStateText.className = connectedClass;
  connectionStateText.textContent = connectedText;
  connectToggleButton.textContent = state.connected ? "Disconnect" : "Connect";

  refreshSessionsButton.disabled = !state.connected;
  sessionSelect.disabled = !state.connected;
  subscribeButton.disabled = !state.connected || selectedSession() === undefined;
  unsubscribeButton.disabled = !state.connected || state.currentSubscriptionId === null;
  sendInputButton.disabled = !state.connected || selectedSession() === undefined;
  refreshApprovalsButton.disabled = !state.connected;
  refreshArtifactsButton.disabled = !state.connected || selectedSession() === undefined;
  fetchDiffButton.disabled = !state.connected || selectedSession() === undefined;
}

function appendConnectionLog(message: string): void {
  const lines = connectionLogOutput.textContent
    ?.split("\n")
    .filter((entry) => entry.length > 0) ?? [];
  lines.push(message);
  connectionLogOutput.textContent = lines.slice(-20).join("\n");
}

function formatJson(value: unknown): string {
  return JSON.stringify(value, null, 2);
}

function stringifyError(error: unknown): string {
  if (error instanceof Error) {
    return error.message;
  }

  return String(error);
}

function escapeHtml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function requiredElement<TElement extends HTMLElement>(selector: string): TElement {
  const element = document.querySelector(selector);

  if (element === null) {
    throw new Error(`Expected element ${selector} to exist.`);
  }

  return element as TElement;
}
