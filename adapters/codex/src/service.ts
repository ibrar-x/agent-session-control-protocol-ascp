import { createEventEnvelope } from "ascp-sdk-typescript";
import type {
  ApprovalRequest,
  Artifact,
  ArtifactsGetParams,
  ArtifactsGetResult,
  ArtifactsListParams,
  ArtifactsListResult,
  ApprovalsListParams,
  ApprovalsListResult,
  ApprovalsRespondParams,
  ApprovalsRespondResult,
  DiffChangeType,
  DiffFile,
  DiffsGetParams,
  DiffsGetResult,
  ErrorCode,
  ErrorObject,
  EventEnvelope,
  SessionsGetParams,
  SessionsGetResult,
  SessionsListParams,
  SessionsListResult,
  SessionsResumeParams,
  SessionsResumeResult,
  SessionsSendInputParams,
  SessionsSendInputResult,
  SessionsSubscribeParams,
  SessionsSubscribeResult,
  SessionsUnsubscribeParams,
  SessionsUnsubscribeResult
} from "ascp-sdk-typescript";

import { mapApprovalRequest, mapApprovalRequestToEvent, type CodexApprovalRequestMessage } from "./approvals.js";
import { type CodexJsonRpcNotification, CodexAppServerClient, CodexJsonRpcError } from "./app-server-client.js";
import { CODEX_RUNTIME_ID } from "./discovery.js";
import { toRunId, toSessionId } from "./ids.js";
import { mapNotificationToEvents } from "./events.js";
import type { CodexThread, CodexTurn } from "./session-mapper.js";
import { mapThreadToSession, mapTurnToRun } from "./session-mapper.js";

const APPROVAL_RESPOND_METHOD_CANDIDATES = ["approval/respond"] as const;
const MAX_SESSION_EVENT_HISTORY = 2_000;

interface CodexThreadListResponse {
  data: CodexThread[];
  nextCursor?: string | null;
}

interface CodexThreadReadResponse {
  thread?: (CodexThread & { turns?: CodexTurn[] }) | null;
}

interface CodexTurnSteerResponse {
  turnId: string;
}

interface CodexTurnStartResponse {
  turn?: CodexTurn;
}

export interface CodexServiceClient {
  threadList(limit?: number): Promise<unknown>;
  threadRead(threadId: string, options?: { includeTurns?: boolean }): Promise<unknown>;
  threadResume(threadId: string): Promise<unknown>;
  turnStart(params: Record<string, unknown>): Promise<unknown>;
  turnSteer(params: Record<string, unknown>): Promise<unknown>;
  request?(method: string, params?: Record<string, unknown>): Promise<unknown>;
  onNotification?(
    listener: (notification: CodexJsonRpcNotification) => void
  ): () => void;
  markApprovalRequestObserved?(): void;
  markApprovalResponseSupported?(): void;
}

interface CodexAdapterServiceOptions {
  approvalRespondMethods?: string[];
}

interface SubscriptionState {
  subscriptionId: string;
  sessionId: string;
  queue: EventEnvelope<Record<string, unknown>>[];
}

interface FileChangeRecord {
  itemId: string;
  changeIndex: number;
  path: string;
  changeType: DiffChangeType;
  insertions: number;
  deletions: number;
}

interface ParsedArtifactId {
  threadId: string;
  turnId: string;
  itemId: string;
  changeIndex: number;
}

export class CodexAdapterServiceError extends Error {
  readonly code: ErrorCode;
  readonly retryable: boolean;
  readonly details?: Record<string, unknown> | null;
  readonly correlation_id?: string;

  constructor(error: ErrorObject) {
    super(error.message);
    this.name = "CodexAdapterServiceError";
    this.code = error.code;
    this.retryable = error.retryable;
    this.details = error.details;
    this.correlation_id = error.correlation_id;
  }
}

function createServiceError(
  code: ErrorCode,
  message: string,
  retryable: boolean,
  details?: Record<string, unknown>
): CodexAdapterServiceError {
  return new CodexAdapterServiceError({
    code,
    message,
    retryable,
    details: details ?? null
  });
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function readString(record: Record<string, unknown>, key: string): string | undefined {
  const value = record[key];
  return typeof value === "string" && value.length > 0 ? value : undefined;
}

function readNumber(record: Record<string, unknown>, key: string): number | undefined {
  const value = record[key];
  return typeof value === "number" && Number.isFinite(value) ? value : undefined;
}

function parseSessionId(sessionId: string): string {
  if (!sessionId.startsWith("codex:")) {
    throw createServiceError("NOT_FOUND", `Unknown Codex session id: ${sessionId}`, false, {
      session_id: sessionId
    });
  }

  return sessionId.slice("codex:".length);
}

function parseRunTurnId(runId: string, sessionId: string): string {
  const prefix = `${sessionId}:`;

  if (!runId.startsWith(prefix)) {
    throw createServiceError("NOT_FOUND", `Run ${runId} is not part of session ${sessionId}.`, false, {
      run_id: runId,
      session_id: sessionId
    });
  }

  const turnId = runId.slice(prefix.length);

  if (turnId.length === 0) {
    throw createServiceError("INVALID_REQUEST", `Invalid run id: ${runId}`, false, {
      run_id: runId
    });
  }

  return turnId;
}

function parseApprovalId(approvalId: string): string {
  return approvalId.startsWith("codex:") ? approvalId : `codex:${approvalId}`;
}

function parseArtifactId(artifactId: string): ParsedArtifactId {
  const match = artifactId.match(/^codex:artifact:([^:]+):([^:]+):([^:]+):(\d+)$/);

  if (match?.[1] === undefined || match[2] === undefined || match[3] === undefined || match[4] === undefined) {
    throw createServiceError("NOT_FOUND", `Unknown artifact id: ${artifactId}`, false, {
      artifact_id: artifactId
    });
  }

  return {
    threadId: match[1],
    turnId: match[2],
    itemId: match[3],
    changeIndex: Number(match[4])
  };
}

function toTimestamp(value: unknown, fallbackNow = new Date().toISOString()): string {
  if (typeof value === "string" && value.length > 0) {
    return value;
  }

  if (typeof value === "number" && Number.isFinite(value)) {
    return new Date(value * 1_000).toISOString();
  }

  return fallbackNow;
}

function buildTextInput(input: string): Array<{ type: "text"; text: string }> {
  return [
    {
      type: "text",
      text: input
    }
  ];
}

function hasTurnId(value: unknown): value is CodexTurnSteerResponse {
  return isRecord(value) && typeof value.turnId === "string";
}

function hasTurnObject(value: unknown): value is CodexTurnStartResponse {
  return isRecord(value) && isRecord(value.turn);
}

function isMethodNotFoundError(error: unknown): boolean {
  if (error instanceof CodexJsonRpcError) {
    if (error.code === -32601) {
      return true;
    }

    return /not found/i.test(error.message);
  }

  if (error instanceof Error) {
    return /not found/i.test(error.message);
  }

  return false;
}

function toThreadListResponse(value: unknown): CodexThreadListResponse {
  if (isRecord(value) && Array.isArray(value.data)) {
    return {
      data: value.data as CodexThread[],
      nextCursor:
        typeof value.nextCursor === "string" || value.nextCursor === null
          ? value.nextCursor
          : null
    };
  }

  throw createServiceError("RUNTIME_ERROR", "Codex thread/list returned an unexpected shape.", false);
}

function toThreadResponse(value: unknown, method: "thread/read" | "thread/resume"): CodexThreadReadResponse {
  if (isRecord(value)) {
    return value as CodexThreadReadResponse;
  }

  throw createServiceError("RUNTIME_ERROR", `Codex ${method} returned an unexpected shape.`, false);
}

function findActiveTurn(thread: { turns?: CodexTurn[] }): CodexTurn | undefined {
  if (!Array.isArray(thread.turns)) {
    return undefined;
  }

  return [...thread.turns].reverse().find((turn) => turn.status === "inProgress");
}

function countDiffLines(diff: string): { insertions: number; deletions: number } {
  let insertions = 0;
  let deletions = 0;

  for (const line of diff.split("\n")) {
    if (line.startsWith("+++ ") || line.startsWith("--- ") || line.startsWith("@@")) {
      continue;
    }

    if (line.startsWith("+")) {
      insertions += 1;
    } else if (line.startsWith("-")) {
      deletions += 1;
    }
  }

  return {
    insertions,
    deletions
  };
}

function toDiffChangeType(kind: string | undefined): DiffChangeType {
  switch (kind) {
    case "add":
      return "added";
    case "delete":
      return "deleted";
    case "move":
      return "renamed";
    case "update":
    default:
      return "modified";
  }
}

function mapRuntimeError(error: unknown, context: Record<string, unknown>): CodexAdapterServiceError {
  if (error instanceof CodexAdapterServiceError) {
    return error;
  }

  if (error instanceof CodexJsonRpcError) {
    return createServiceError("RUNTIME_ERROR", error.message, false, {
      ...context,
      code: error.code,
      data: error.data
    });
  }

  if (error instanceof Error) {
    return createServiceError("RUNTIME_ERROR", error.message, false, context);
  }

  return createServiceError("RUNTIME_ERROR", "Codex adapter request failed.", false, context);
}

function filterSessions(
  sessions: SessionsListResult["sessions"],
  params: SessionsListParams
): SessionsListResult["sessions"] {
  return sessions.filter((session) => {
    if (params.status !== undefined && session.status !== params.status) {
      return false;
    }

    if (params.workspace !== undefined && session.workspace !== params.workspace) {
      return false;
    }

    if (
      params.updated_after !== undefined &&
      session.updated_at.localeCompare(params.updated_after) <= 0
    ) {
      return false;
    }

    if (params.search_text !== undefined) {
      const haystack = `${session.title ?? ""}\n${session.summary ?? ""}`.toLowerCase();

      if (!haystack.includes(params.search_text.toLowerCase())) {
        return false;
      }
    }

    return true;
  });
}

export class CodexAdapterService {
  private readonly subscriptions = new Map<string, SubscriptionState>();
  private readonly sessionEvents = new Map<string, EventEnvelope<Record<string, unknown>>[]>();
  private readonly sessionSeq = new Map<string, number>();
  private readonly approvals = new Map<string, ApprovalRequest>();
  private readonly approvalIdsBySession = new Map<string, Set<string>>();
  private readonly eventListeners = new Set<
    (event: EventEnvelope<Record<string, unknown>>) => void
  >();
  private readonly approvalRespondMethods: string[];
  private readonly removeNotificationListener: (() => void) | null;
  private nextSubscriptionOrdinal = 1;

  constructor(
    private readonly client: CodexServiceClient = new CodexAppServerClient(),
    options: CodexAdapterServiceOptions = {}
  ) {
    this.approvalRespondMethods = options.approvalRespondMethods ?? [...APPROVAL_RESPOND_METHOD_CANDIDATES];
    this.removeNotificationListener =
      this.client.onNotification?.((notification) => {
        this.handleNotification(notification);
      }) ?? null;
  }

  close(): void {
    this.removeNotificationListener?.();
    this.subscriptions.clear();
    this.eventListeners.clear();
  }

  onEvent(listener: (event: EventEnvelope<Record<string, unknown>>) => void): () => void {
    this.eventListeners.add(listener);

    return () => {
      this.eventListeners.delete(listener);
    };
  }

  drainSubscriptionEvents(subscriptionId: string, limit?: number): EventEnvelope<Record<string, unknown>>[] {
    const subscription = this.subscriptions.get(subscriptionId);

    if (subscription === undefined) {
      throw createServiceError("NOT_FOUND", `Unknown subscription id: ${subscriptionId}`, false, {
        subscription_id: subscriptionId
      });
    }

    if (limit === undefined || limit >= subscription.queue.length) {
      return subscription.queue.splice(0, subscription.queue.length);
    }

    return subscription.queue.splice(0, limit);
  }

  async sessionsList(params: SessionsListParams = {}): Promise<SessionsListResult> {
    if (params.runtime_id !== undefined && params.runtime_id !== CODEX_RUNTIME_ID) {
      return {
        sessions: [],
        next_cursor: null
      };
    }

    try {
      const response = toThreadListResponse(await this.client.threadList(params.limit ?? 20));
      const sessions = filterSessions(response.data.map(mapThreadToSession), params);

      return {
        sessions,
        next_cursor: response.nextCursor ?? null
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "sessions.list"
      });
    }
  }

  async sessionsGet(params: SessionsGetParams): Promise<SessionsGetResult> {
    const threadId = parseSessionId(params.session_id);

    try {
      const response = await this.readThreadOrThrow(threadId, "thread/read", {
        includeTurns: params.include_runs === true
      });
      const session = mapThreadToSession(response.thread);

      return {
        session,
        ...(params.include_runs === true && Array.isArray(response.thread.turns)
          ? {
              runs: response.thread.turns.map((turn) => mapTurnToRun(turn, response.thread!.id))
            }
          : {}),
        ...(params.include_pending_approvals === true
          ? {
              pending_approvals: this.listSessionApprovals(session.id).filter(
                (approval) => approval.status === "pending"
              )
            }
          : {})
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "sessions.get",
        session_id: params.session_id
      });
    }
  }

  async sessionsResume(params: SessionsResumeParams): Promise<SessionsResumeResult> {
    if (params.runtime_id !== undefined && params.runtime_id !== CODEX_RUNTIME_ID) {
      throw createServiceError("UNSUPPORTED", `Unsupported runtime: ${params.runtime_id}`, false, {
        runtime_id: params.runtime_id
      });
    }

    const threadId = parseSessionId(params.session_id);

    try {
      const response = await this.readThreadOrThrow(threadId, "thread/resume");
      return {
        session: mapThreadToSession(response.thread),
        replay_supported: true,
        snapshot_emitted: false
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "sessions.resume",
        session_id: params.session_id
      });
    }
  }

  async sessionsSendInput(params: SessionsSendInputParams): Promise<SessionsSendInputResult> {
    const threadId = parseSessionId(params.session_id);

    try {
      const response = await this.readThreadOrThrow(threadId, "thread/read", {
        includeTurns: true
      });
      const input = buildTextInput(params.input);
      const activeTurn = findActiveTurn(response.thread);

      if (activeTurn !== undefined) {
        const steerResponse = await this.client.turnSteer({
          threadId,
          expectedTurnId: activeTurn.id,
          input
        });

        if (!hasTurnId(steerResponse)) {
          throw createServiceError(
            "RUNTIME_ERROR",
            "Codex turn/steer returned an unexpected shape.",
            false
          );
        }
      } else {
        await this.readThreadOrThrow(threadId, "thread/resume");

        const startResponse = await this.client.turnStart({
          threadId,
          input
        });

        if (!hasTurnObject(startResponse)) {
          throw createServiceError(
            "RUNTIME_ERROR",
            "Codex turn/start returned an unexpected shape.",
            false
          );
        }
      }

      return {
        session_id: params.session_id,
        accepted: true
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "sessions.send_input",
        session_id: params.session_id
      });
    }
  }

  async sessionsSubscribe(params: SessionsSubscribeParams): Promise<SessionsSubscribeResult> {
    const threadId = parseSessionId(params.session_id);

    try {
      const response = await this.readThreadOrThrow(threadId, "thread/read", {
        includeTurns: true
      });
      const sessionId = toSessionId(threadId);
      const subscriptionId = `codex:subscription:${threadId}:${this.nextSubscriptionOrdinal++}`;
      const subscription: SubscriptionState = {
        subscriptionId,
        sessionId,
        queue: []
      };

      this.subscriptions.set(subscriptionId, subscription);

      if (params.include_snapshot === true) {
        subscription.queue.push(
          this.createSequencedEvent(
            createEventEnvelope({
              id: `codex:event:sync_snapshot:${threadId}:${Date.now()}`,
              type: "sync.snapshot",
              ts: new Date().toISOString(),
              session_id: sessionId,
              payload: {
                session: mapThreadToSession(response.thread),
                pending_approvals: this.listSessionApprovals(sessionId)
              }
            })
          )
        );
      }

      const replayEvents = this.selectReplayEvents(sessionId, params);

      for (const event of replayEvents.events) {
        subscription.queue.push(event);
      }

      if (replayEvents.replayRequested) {
        subscription.queue.push(
          this.createSequencedEvent(
            createEventEnvelope({
              id: `codex:event:sync_replayed:${threadId}:${Date.now()}`,
              type: "sync.replayed",
              ts: new Date().toISOString(),
              session_id: sessionId,
              payload: {
                from_seq: replayEvents.fromSeq,
                to_seq: replayEvents.toSeq,
                event_count: replayEvents.events.length
              }
            })
          )
        );
      }

      return {
        session_id: sessionId,
        subscription_id: subscriptionId,
        snapshot_emitted: params.include_snapshot === true
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "sessions.subscribe",
        session_id: params.session_id
      });
    }
  }

  async sessionsUnsubscribe(params: SessionsUnsubscribeParams): Promise<SessionsUnsubscribeResult> {
    const removed = this.subscriptions.delete(params.subscription_id);

    return {
      subscription_id: params.subscription_id,
      unsubscribed: removed
    };
  }

  async approvalsList(params: ApprovalsListParams = {}): Promise<ApprovalsListResult> {
    const approvals = [...this.approvals.values()]
      .filter((approval) => {
        if (params.session_id !== undefined && approval.session_id !== params.session_id) {
          return false;
        }

        if (params.status !== undefined && approval.status !== params.status) {
          return false;
        }

        return true;
      })
      .sort((left, right) => left.created_at.localeCompare(right.created_at));
    const start = params.cursor === undefined ? 0 : Number(params.cursor);
    const safeStart = Number.isFinite(start) && start >= 0 ? Math.floor(start) : 0;
    const limit = params.limit ?? approvals.length;
    const page = approvals.slice(safeStart, safeStart + limit);
    const nextCursor = safeStart + limit < approvals.length ? String(safeStart + limit) : null;

    return {
      approvals: page,
      next_cursor: nextCursor
    };
  }

  async approvalsRespond(params: ApprovalsRespondParams): Promise<ApprovalsRespondResult> {
    const approvalId = parseApprovalId(params.approval_id);
    const approval = this.approvals.get(approvalId);

    if (approval === undefined) {
      throw createServiceError("NOT_FOUND", `Unknown approval id: ${params.approval_id}`, false, {
        approval_id: params.approval_id
      });
    }

    if (approval.status !== "pending") {
      return {
        approval_id: approval.id,
        status: approval.status
      };
    }

    if (this.client.request === undefined || this.approvalRespondMethods.length === 0) {
      throw createServiceError("UNSUPPORTED", "Codex approval response surface is not available.", false);
    }

    const rawApprovalId = approval.id.startsWith("codex:") ? approval.id.slice("codex:".length) : approval.id;
    let supported = false;

    for (const method of this.approvalRespondMethods) {
      try {
        await this.client.request(method, {
          approvalId: rawApprovalId,
          decision: params.decision,
          ...(params.note !== undefined ? { note: params.note } : {})
        });
        supported = true;
        break;
      } catch (error) {
        if (isMethodNotFoundError(error)) {
          continue;
        }

        throw mapRuntimeError(error, {
          method: "approvals.respond",
          approval_id: params.approval_id
        });
      }
    }

    if (!supported) {
      throw createServiceError("UNSUPPORTED", "Codex approval response surface is not available.", false);
    }

    this.client.markApprovalResponseSupported?.();
    approval.status = params.decision === "approved" ? "approved" : "rejected";
    approval.resolved_at = new Date().toISOString();
    this.approvals.set(approval.id, approval);

    this.ingestEvent(
      createEventEnvelope({
        id: `codex:event:approval_${approval.status}:${approval.id}`,
        type: approval.status === "approved" ? "approval.approved" : "approval.rejected",
        ts: approval.resolved_at,
        session_id: approval.session_id,
        ...(approval.run_id !== undefined ? { run_id: approval.run_id } : {}),
        payload: {
          approval
        }
      })
    );

    return {
      approval_id: approval.id,
      status: approval.status
    };
  }

  async artifactsList(params: ArtifactsListParams): Promise<ArtifactsListResult> {
    const threadId = parseSessionId(params.session_id);

    try {
      const response = await this.readThreadOrThrow(threadId, "thread/read", {
        includeTurns: true
      });
      const turns = Array.isArray(response.thread.turns) ? response.thread.turns : [];
      const targetTurnId =
        params.run_id === undefined ? undefined : parseRunTurnId(params.run_id, params.session_id);
      const artifacts = turns
        .filter((turn) => targetTurnId === undefined || turn.id === targetTurnId)
        .flatMap((turn) => this.buildArtifactsFromTurn(threadId, turn))
        .filter((artifact) => params.kind === undefined || artifact.kind === params.kind);

      return {
        artifacts
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "artifacts.list",
        session_id: params.session_id
      });
    }
  }

  async artifactsGet(params: ArtifactsGetParams): Promise<ArtifactsGetResult> {
    const parsed = parseArtifactId(params.artifact_id);

    try {
      const response = await this.readThreadOrThrow(parsed.threadId, "thread/read", {
        includeTurns: true
      });
      const turns = Array.isArray(response.thread.turns) ? response.thread.turns : [];
      const turn = turns.find((candidate) => candidate.id === parsed.turnId);

      if (turn === undefined) {
        throw createServiceError("NOT_FOUND", `Artifact turn not found: ${params.artifact_id}`, false, {
          artifact_id: params.artifact_id
        });
      }

      const artifact = this.buildArtifactsFromTurn(parsed.threadId, turn).find(
        (candidate) => candidate.id === params.artifact_id
      );

      if (artifact === undefined) {
        throw createServiceError("NOT_FOUND", `Artifact not found: ${params.artifact_id}`, false, {
          artifact_id: params.artifact_id
        });
      }

      return {
        artifact
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "artifacts.get",
        artifact_id: params.artifact_id
      });
    }
  }

  async diffsGet(params: DiffsGetParams): Promise<DiffsGetResult> {
    const threadId = parseSessionId(params.session_id);
    const turnId = parseRunTurnId(params.run_id, params.session_id);

    try {
      const response = await this.readThreadOrThrow(threadId, "thread/read", {
        includeTurns: true
      });
      const turns = Array.isArray(response.thread.turns) ? response.thread.turns : [];
      const turn = turns.find((candidate) => candidate.id === turnId);

      if (turn === undefined) {
        throw createServiceError("NOT_FOUND", `Run not found: ${params.run_id}`, false, {
          run_id: params.run_id
        });
      }

      const diff = this.buildDiffSummary(threadId, turn);

      if (diff === undefined) {
        throw createServiceError("NOT_FOUND", `No diff data found for run: ${params.run_id}`, false, {
          run_id: params.run_id
        });
      }

      return {
        diff
      };
    } catch (error) {
      throw mapRuntimeError(error, {
        method: "diffs.get",
        session_id: params.session_id,
        run_id: params.run_id
      });
    }
  }

  private async readThreadOrThrow(
    threadId: string,
    method: "thread/read" | "thread/resume",
    options: { includeTurns?: boolean } = {}
  ): Promise<{ thread: CodexThread & { turns?: CodexTurn[] } }> {
    const response = toThreadResponse(
      method === "thread/read"
        ? await this.client.threadRead(threadId, options)
        : await this.client.threadResume(threadId),
      method
    );

    if (response.thread == null) {
      throw createServiceError("NOT_FOUND", `Codex thread not found: ${threadId}`, false, {
        session_id: toSessionId(threadId)
      });
    }

    return {
      thread: response.thread
    };
  }

  private nextSeq(sessionId: string): number {
    const next = (this.sessionSeq.get(sessionId) ?? 0) + 1;
    this.sessionSeq.set(sessionId, next);
    return next;
  }

  private createSequencedEvent(
    event: EventEnvelope<Record<string, unknown>>
  ): EventEnvelope<Record<string, unknown>> {
    if (event.seq !== undefined) {
      return event;
    }

    return {
      ...event,
      seq: this.nextSeq(event.session_id)
    };
  }

  private ingestEvent(event: EventEnvelope<Record<string, unknown>>): void {
    const sequenced = this.createSequencedEvent(event);
    const history = this.sessionEvents.get(sequenced.session_id) ?? [];
    history.push(sequenced);

    if (history.length > MAX_SESSION_EVENT_HISTORY) {
      history.splice(0, history.length - MAX_SESSION_EVENT_HISTORY);
    }

    this.sessionEvents.set(sequenced.session_id, history);

    for (const subscription of this.subscriptions.values()) {
      if (subscription.sessionId === sequenced.session_id) {
        subscription.queue.push(sequenced);
      }
    }

    for (const listener of this.eventListeners) {
      listener(sequenced);
    }
  }

  private selectReplayEvents(
    sessionId: string,
    params: SessionsSubscribeParams
  ): {
    replayRequested: boolean;
    fromSeq: number;
    toSeq: number;
    events: EventEnvelope<Record<string, unknown>>[];
  } {
    const replayRequested = params.from_seq !== undefined || params.from_event_id !== undefined;
    const history = this.sessionEvents.get(sessionId) ?? [];

    if (!replayRequested) {
      return {
        replayRequested: false,
        fromSeq: 0,
        toSeq: 0,
        events: []
      };
    }

    if (params.from_event_id !== undefined) {
      const fromEvent = history.find((event) => event.id === params.from_event_id);

      if (fromEvent === undefined || fromEvent.seq === undefined) {
        throw createServiceError("NOT_FOUND", `Replay cursor event not found: ${params.from_event_id}`, false, {
          from_event_id: params.from_event_id,
          session_id: sessionId
        });
      }

      const events = history.filter((event) => (event.seq ?? 0) > fromEvent.seq!);

      return {
        replayRequested: true,
        fromSeq: fromEvent.seq,
        toSeq: events.length === 0 ? fromEvent.seq : (events.at(-1)?.seq ?? fromEvent.seq),
        events
      };
    }

    const fromSeq =
      params.from_seq !== undefined && Number.isInteger(params.from_seq) && params.from_seq >= 0
        ? params.from_seq
        : 0;
    const events = history.filter((event) => (event.seq ?? 0) > fromSeq);

    return {
      replayRequested: true,
      fromSeq,
      toSeq: events.length === 0 ? fromSeq : (events.at(-1)?.seq ?? fromSeq),
      events
    };
  }

  private listSessionApprovals(sessionId: string): ApprovalRequest[] {
    const ids = this.approvalIdsBySession.get(sessionId);

    if (ids === undefined) {
      return [];
    }

    return [...ids]
      .map((id) => this.approvals.get(id))
      .filter((approval): approval is ApprovalRequest => approval !== undefined)
      .sort((left, right) => left.created_at.localeCompare(right.created_at));
  }

  private recordApproval(approval: ApprovalRequest): void {
    this.approvals.set(approval.id, approval);

    const sessionApprovals = this.approvalIdsBySession.get(approval.session_id) ?? new Set<string>();
    sessionApprovals.add(approval.id);
    this.approvalIdsBySession.set(approval.session_id, sessionApprovals);
  }

  private handleNotification(notification: CodexJsonRpcNotification): void {
    for (const event of mapNotificationToEvents(notification)) {
      this.ingestEvent(event);
    }

    try {
      const message = notification as CodexApprovalRequestMessage;
      const approval = mapApprovalRequest(message);
      this.recordApproval(approval);
      this.client.markApprovalRequestObserved?.();
      this.ingestEvent(mapApprovalRequestToEvent(message));
    } catch {
      // Ignore non-approval notifications.
    }
  }

  private extractFileChanges(turn: CodexTurn): FileChangeRecord[] {
    if (!isRecord(turn) || !Array.isArray((turn as Record<string, unknown>).items)) {
      return [];
    }

    const items = (turn as Record<string, unknown>).items as Array<Record<string, unknown>>;
    const records: FileChangeRecord[] = [];

    for (const item of items) {
      if (!isRecord(item) || item.type !== "fileChange" || !Array.isArray(item.changes)) {
        continue;
      }

      const itemId = readString(item, "id") ?? "unknown_item";

      for (const [changeIndex, rawChange] of item.changes.entries()) {
        if (!isRecord(rawChange)) {
          continue;
        }

        const path = readString(rawChange, "path");

        if (path === undefined) {
          continue;
        }

        const kind = isRecord(rawChange.kind) ? readString(rawChange.kind, "type") : undefined;
        const diff = readString(rawChange, "diff");
        const counts = diff === undefined ? { insertions: 0, deletions: 0 } : countDiffLines(diff);

        records.push({
          itemId,
          changeIndex,
          path,
          changeType: toDiffChangeType(kind),
          insertions: counts.insertions,
          deletions: counts.deletions
        });
      }
    }

    return records;
  }

  private buildDiffSummary(threadId: string, turn: CodexTurn): DiffsGetResult["diff"] | undefined {
    const changes = this.extractFileChanges(turn);

    if (changes.length === 0) {
      return undefined;
    }

    const files: DiffFile[] = changes.map((change) => ({
      path: change.path,
      change_type: change.changeType,
      insertions: change.insertions,
      deletions: change.deletions
    }));
    const insertions = changes.reduce((sum, change) => sum + change.insertions, 0);
    const deletions = changes.reduce((sum, change) => sum + change.deletions, 0);
    const sessionId = toSessionId(threadId);

    return {
      session_id: sessionId,
      run_id: toRunId(threadId, turn.id),
      files_changed: files.length,
      insertions,
      deletions,
      files
    };
  }

  private buildArtifactsFromTurn(threadId: string, turn: CodexTurn): Artifact[] {
    const changes = this.extractFileChanges(turn);

    if (changes.length === 0) {
      return [];
    }

    const sessionId = toSessionId(threadId);
    const runId = toRunId(threadId, turn.id);
    const turnRecord = turn as unknown as Record<string, unknown>;
    const createdAt = toTimestamp(turnRecord.completedAt ?? turnRecord.startedAt);

    return changes.map((change) => ({
      id: `codex:artifact:${threadId}:${turn.id}:${change.itemId}:${change.changeIndex}`,
      session_id: sessionId,
      run_id: runId,
      kind: "diff",
      created_at: createdAt,
      name: `${change.path.split("/").at(-1) ?? "change"}.diff`,
      uri: `codex://thread/${threadId}/turn/${turn.id}/item/${change.itemId}/change/${change.changeIndex}`,
      mime_type: "text/x-diff",
      metadata: {
        path: change.path,
        change_type: change.changeType,
        insertions: change.insertions,
        deletions: change.deletions
      }
    }));
  }
}
