import type { Run, RunStatus, Session, SessionStatus } from "ascp-sdk-typescript";

import { CODEX_RUNTIME_ID } from "./discovery.js";

export interface CodexThreadStatus {
  type: string;
  activeFlags?: string[];
}

export interface CodexThread {
  id: string;
  status?: CodexThreadStatus;
  name?: string;
  title?: string;
  cwd?: string;
  workspace?: string;
  createdAt?: string;
  created_at?: string;
  updatedAt?: string;
  updated_at?: string;
  lastActivityAt?: string;
  last_activity_at?: string;
  preview?: string;
  summary?: string;
  activeTurnId?: string;
  active_turn_id?: string;
}

export interface CodexTurn {
  id: string;
  status?: string;
  startedAt?: string;
  started_at?: string;
  createdAt?: string;
  completedAt?: string | null;
  completed_at?: string | null;
  endedAt?: string | null;
  ended_at?: string | null;
  exitCode?: number | null;
  exit_code?: number | null;
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

function readNullableStringField(
  value: object,
  keys: readonly string[]
): string | null | undefined {
  const record = value as Record<string, unknown>;

  for (const key of keys) {
    const candidate = record[key];

    if (candidate === null) {
      return null;
    }

    if (typeof candidate === "string" && candidate.length > 0) {
      return candidate;
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

export function mapThreadStatus(status: { type: string; activeFlags?: string[] }): SessionStatus {
  if (status.type === "idle") {
    return "idle";
  }

  if (status.type === "active" && status.activeFlags?.includes("waitingOnApproval")) {
    return "waiting_approval";
  }

  if (status.type === "active" && status.activeFlags?.includes("waitingOnInput")) {
    return "waiting_input";
  }

  if (status.type === "active") {
    return "running";
  }

  if (status.type === "systemError") {
    return "failed";
  }

  if (status.type === "completed") {
    return "completed";
  }

  if (status.type === "stopped") {
    return "stopped";
  }

  return "disconnected";
}

export function mapTurnStatus(status: string | undefined): RunStatus {
  switch (status) {
    case "queued":
    case "starting":
      return "starting";
    case "in_progress":
    case "running":
    case "active":
      return "running";
    case "paused":
      return "paused";
    case "completed":
    case "succeeded":
    case "done":
      return "completed";
    case "failed":
    case "error":
    case "systemError":
      return "failed";
    case "cancelled":
    case "canceled":
      return "cancelled";
    default:
      return "starting";
  }
}

export function mapThreadToSession(thread: CodexThread): Session {
  const createdAt = requireStringField(thread, ["createdAt", "created_at"], "thread created timestamp");
  const updatedAt = requireStringField(thread, ["updatedAt", "updated_at"], "thread updated timestamp");
  const lastActivityAt = readStringField(thread, ["lastActivityAt", "last_activity_at"]);
  const title = readStringField(thread, ["name", "title"]);
  const workspace = readStringField(thread, ["cwd", "workspace"]);
  const summary = readStringField(thread, ["preview", "summary"]);
  const activeTurnId = readStringField(thread, ["activeTurnId", "active_turn_id"]);

  return {
    id: `codex:${thread.id}`,
    runtime_id: CODEX_RUNTIME_ID,
    status: mapThreadStatus(thread.status ?? { type: "unknown" }),
    created_at: createdAt,
    updated_at: updatedAt,
    ...(title !== undefined ? { title } : {}),
    ...(workspace !== undefined ? { workspace } : {}),
    ...(lastActivityAt !== undefined ? { last_activity_at: lastActivityAt } : {}),
    ...(summary !== undefined ? { summary } : {}),
    ...(activeTurnId !== undefined ? { active_run_id: `codex:${thread.id}:${activeTurnId}` } : {}),
    metadata: {
      source: "codex"
    }
  };
}

export function mapTurnToRun(turn: CodexTurn, sessionId: string): Run {
  const startedAt = requireStringField(
    turn,
    ["startedAt", "started_at", "createdAt"],
    "turn started timestamp"
  );
  const endedAt = readNullableStringField(turn, ["completedAt", "completed_at", "endedAt", "ended_at"]);
  const exitCode = readNullableNumberField(turn, ["exitCode", "exit_code"]);

  return {
    id: `${sessionId}:${turn.id}`,
    session_id: sessionId,
    status: mapTurnStatus(turn.status),
    started_at: startedAt,
    ...(endedAt !== undefined ? { ended_at: endedAt } : {}),
    ...(exitCode !== undefined ? { exit_code: exitCode } : {})
  };
}
