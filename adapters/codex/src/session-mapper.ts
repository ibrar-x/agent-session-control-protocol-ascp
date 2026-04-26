import type { Run, RunStatus, Session, SessionStatus } from "ascp-sdk-typescript";

import { CODEX_RUNTIME_ID } from "./discovery.js";
import { toRunId, toSessionId } from "./ids.js";

export interface CodexThreadStatus {
  type: string;
  activeFlags?: string[];
  active_flags?: string[];
}

export interface CodexThread {
  id: string;
  status?: CodexThreadStatus;
  name?: string;
  title?: string;
  cwd?: string;
  workspace?: string;
  createdAt?: number | string;
  created_at?: number | string;
  updatedAt?: number | string;
  updated_at?: number | string;
  lastActivityAt?: number | string;
  last_activity_at?: number | string;
  preview?: string;
  summary?: string;
  activeTurnId?: string;
  active_turn_id?: string;
}

export interface CodexTurn {
  id: string;
  status?: string;
  startedAt?: number | string;
  started_at?: number | string;
  createdAt?: number | string;
  created_at?: number | string;
  completedAt?: number | string | null;
  completed_at?: number | string | null;
  endedAt?: number | string | null;
  ended_at?: number | string | null;
  exitCode?: number | null;
  exit_code?: number | null;
}

function normalizeTimestampValue(value: unknown): string | null | undefined {
  if (value === null) {
    return null;
  }

  if (typeof value === "string" && value.length > 0) {
    return value;
  }

  if (typeof value === "number" && Number.isFinite(value)) {
    return new Date(value * 1_000).toISOString();
  }

  return undefined;
}

function readStringField(
  value: object,
  keys: readonly string[]
): string | undefined {
  const record = value as Record<string, unknown>;

  for (const key of keys) {
    const candidate = record[key];

    if (typeof candidate === "string" && candidate.length > 0) {
      return candidate;
    }
  }

  return undefined;
}

function readTimestampField(
  value: object,
  keys: readonly string[]
): string | null | undefined {
  const record = value as Record<string, unknown>;

  for (const key of keys) {
    const normalized = normalizeTimestampValue(record[key]);

    if (normalized !== undefined) {
      return normalized;
    }
  }

  return undefined;
}

function readNullableNumberField(
  value: object,
  keys: readonly string[]
): number | null | undefined {
  const record = value as Record<string, unknown>;

  for (const key of keys) {
    const candidate = record[key];

    if (candidate === null) {
      return null;
    }

    if (typeof candidate === "number") {
      return candidate;
    }
  }

  return undefined;
}

function requireStringField(
  value: object,
  keys: readonly string[],
  label: string
): string {
  const resolved = readStringField(value, keys);

  if (resolved !== undefined) {
    return resolved;
  }

  throw new Error(`Codex ${label} is required for ASCP mapping.`);
}

function requireTimestampField(
  value: object,
  keys: readonly string[],
  label: string
): string {
  const resolved = readTimestampField(value, keys);

  if (typeof resolved === "string") {
    return resolved;
  }

  throw new Error(`Codex ${label} is required for ASCP mapping.`);
}

function readThreadActiveFlags(status: { activeFlags?: string[]; active_flags?: string[] }): string[] {
  return status.activeFlags ?? status.active_flags ?? [];
}

export function mapThreadStatus(status: {
  type: string;
  activeFlags?: string[];
  active_flags?: string[];
}): SessionStatus {
  const activeFlags = readThreadActiveFlags(status);

  if (status.type === "idle") {
    return "idle";
  }

  if (
    status.type === "active" &&
    (activeFlags.includes("waitingOnApproval") || activeFlags.includes("waiting_on_approval"))
  ) {
    return "waiting_approval";
  }

  if (
    status.type === "active" &&
    (activeFlags.includes("waitingOnUserInput") || activeFlags.includes("waiting_on_user_input"))
  ) {
    return "waiting_input";
  }

  if (status.type === "active") {
    return "running";
  }

  if (status.type === "systemError") {
    return "failed";
  }

  if (status.type === "notLoaded") {
    return "idle";
  }

  return "disconnected";
}

export function mapTurnStatus(turn: {
  status?: string;
  completedAt?: number | string | null;
  completed_at?: number | string | null;
  endedAt?: number | string | null;
  ended_at?: number | string | null;
}): RunStatus {
  switch (turn.status) {
    case "inProgress":
    case "in_progress":
      return "running";
    case "completed":
      return "completed";
    case "failed":
      return "failed";
    case "interrupted":
      return "cancelled";
    default:
      if (readTimestampField(turn, ["completedAt", "completed_at", "endedAt", "ended_at"]) !== undefined) {
        return "failed";
      }

      return "starting";
  }
}

export function mapThreadToSession(thread: CodexThread): Session {
  const createdAt = requireTimestampField(
    thread,
    ["createdAt", "created_at"],
    "thread created timestamp"
  );
  const updatedAt = requireTimestampField(
    thread,
    ["updatedAt", "updated_at"],
    "thread updated timestamp"
  );
  const lastActivityAt = readTimestampField(thread, ["lastActivityAt", "last_activity_at"]);
  const title = readStringField(thread, ["name", "title"]);
  const workspace = readStringField(thread, ["cwd", "workspace"]);
  const summary = readStringField(thread, ["preview", "summary"]);

  return {
    id: toSessionId(thread.id),
    runtime_id: CODEX_RUNTIME_ID,
    status: mapThreadStatus(thread.status ?? { type: "unknown" }),
    created_at: createdAt,
    updated_at: updatedAt,
    ...(title !== undefined ? { title } : {}),
    ...(workspace !== undefined ? { workspace } : {}),
    ...(typeof lastActivityAt === "string" ? { last_activity_at: lastActivityAt } : {}),
    ...(summary !== undefined ? { summary } : {}),
    metadata: {
      source: "codex"
    }
  };
}

export function mapTurnToRun(turn: CodexTurn, threadId: string): Run {
  const startedAt = requireTimestampField(
    turn,
    ["startedAt", "started_at", "createdAt", "created_at"],
    "turn started timestamp"
  );
  const endedAt = readTimestampField(turn, ["completedAt", "completed_at", "endedAt", "ended_at"]);
  const exitCode = readNullableNumberField(turn, ["exitCode", "exit_code"]);
  const sessionId = toSessionId(threadId);

  return {
    id: toRunId(threadId, turn.id),
    session_id: sessionId,
    status: mapTurnStatus(turn),
    started_at: startedAt,
    ...(endedAt !== undefined ? { ended_at: endedAt } : {}),
    ...(exitCode !== undefined ? { exit_code: exitCode } : {})
  };
}
