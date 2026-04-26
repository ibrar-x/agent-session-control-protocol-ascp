import type {
  ErrorCode,
  ErrorObject,
  SessionsGetParams,
  SessionsGetResult,
  SessionsListParams,
  SessionsListResult,
  SessionsResumeParams,
  SessionsResumeResult,
  SessionsSendInputParams,
  SessionsSendInputResult
} from "ascp-sdk-typescript";

import { CodexAppServerClient, CodexJsonRpcError } from "./app-server-client.js";
import { CODEX_RUNTIME_ID } from "./discovery.js";
import type { CodexThread, CodexTurn } from "./session-mapper.js";
import { mapThreadToSession, mapTurnToRun } from "./session-mapper.js";

interface CodexThreadListResponse {
  data: CodexThread[];
  nextCursor?: string | null;
}

interface CodexThreadReadResponse {
  thread?: (CodexThread & { turns?: CodexTurn[] }) | null;
}

interface CodexThreadResumeResponse {
  thread?: (CodexThread & { turns?: CodexTurn[] }) | null;
}

interface CodexTurnSteerResponse {
  turnId: string;
}

interface CodexTurnStartResponse {
  turn?: CodexTurn;
}

interface CodexServiceClient {
  threadList(limit?: number): Promise<unknown>;
  threadRead(threadId: string, options?: { includeTurns?: boolean }): Promise<unknown>;
  threadResume(threadId: string): Promise<unknown>;
  turnStart(params: Record<string, unknown>): Promise<unknown>;
  turnSteer(params: Record<string, unknown>): Promise<unknown>;
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

function parseSessionId(sessionId: string): string {
  if (!sessionId.startsWith("codex:")) {
    throw createServiceError("NOT_FOUND", `Unknown Codex session id: ${sessionId}`, false, {
      session_id: sessionId
    });
  }

  return sessionId.slice("codex:".length);
}

function buildTextInput(input: string): Array<{ type: "text"; text: string }> {
  return [
    {
      type: "text",
      text: input
    }
  ];
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function hasTurnId(value: unknown): value is CodexTurnSteerResponse {
  return isRecord(value) && typeof value.turnId === "string";
}

function hasTurnObject(value: unknown): value is CodexTurnStartResponse {
  return isRecord(value) && isRecord(value.turn);
}

function toThreadListResponse(value: unknown): CodexThreadListResponse {
  if (
    isRecord(value) &&
    Array.isArray(value.data)
  ) {
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
  constructor(private readonly client: CodexServiceClient = new CodexAppServerClient()) {}

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
      const response = toThreadResponse(
        await this.client.threadRead(threadId, {
          includeTurns: params.include_runs === true
        }),
        "thread/read"
      );

      if (response.thread == null) {
        throw createServiceError("NOT_FOUND", `Codex thread not found: ${threadId}`, false, {
          session_id: params.session_id
        });
      }

      return {
        session: mapThreadToSession(response.thread),
        ...(params.include_runs === true && Array.isArray(response.thread.turns)
          ? {
              runs: response.thread.turns.map((turn) => mapTurnToRun(turn, response.thread!.id))
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
      const response = toThreadResponse(await this.client.threadResume(threadId), "thread/resume");

      if (response.thread == null) {
        throw createServiceError("NOT_FOUND", `Codex thread not found: ${threadId}`, false, {
          session_id: params.session_id
        });
      }

      return {
        session: mapThreadToSession(response.thread),
        replay_supported: false,
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
      const response = toThreadResponse(
        await this.client.threadRead(threadId, {
          includeTurns: true
        }),
        "thread/read"
      );

      if (response.thread == null) {
        throw createServiceError("NOT_FOUND", `Codex thread not found: ${threadId}`, false, {
          session_id: params.session_id
        });
      }

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
}
