import type { ApprovalRequest, InputRequest } from "ascp-sdk-typescript";

import type { CodexThread, CodexTurn } from "./session-mapper.js";
import { mapThreadStatus } from "./session-mapper.js";
import { toRunId, toSessionId } from "./ids.js";

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function readString(record: Record<string, unknown>, key: string): string | undefined {
  const value = record[key];
  return typeof value === "string" && value.trim().length > 0 ? value.trim() : undefined;
}

function normalizeTimestamp(value: unknown): string | undefined {
  if (typeof value === "string" && value.length > 0) {
    return value;
  }

  if (typeof value === "number" && Number.isFinite(value)) {
    return new Date(value * 1_000).toISOString();
  }

  return undefined;
}

function turnStartedAt(turn: CodexTurn): string | undefined {
  return (
    normalizeTimestamp(turn.startedAt) ??
    normalizeTimestamp(turn.started_at) ??
    normalizeTimestamp(turn.createdAt) ??
    normalizeTimestamp(turn.created_at)
  );
}

function turnCompletedAt(turn: CodexTurn): string | null | undefined {
  return (
    normalizeTimestamp(turn.completedAt) ??
    normalizeTimestamp(turn.completed_at) ??
    normalizeTimestamp(turn.endedAt) ??
    normalizeTimestamp(turn.ended_at) ??
    (turn.completedAt === null || turn.completed_at === null || turn.endedAt === null || turn.ended_at === null
      ? null
      : undefined)
  );
}

function getTurnItems(turn: CodexTurn): Array<Record<string, unknown>> {
  const rawItems = (turn as unknown as Record<string, unknown>).items;
  return Array.isArray(rawItems) ? rawItems.filter(isRecord) : [];
}

function latestTurn(thread: CodexThread): CodexTurn | undefined {
  const turns = Array.isArray((thread as unknown as Record<string, unknown>).turns)
    ? (((thread as unknown as Record<string, unknown>).turns) as CodexTurn[])
    : [];

  if (turns.length === 0) {
    return undefined;
  }

  const activeTurnId =
    readString(thread as unknown as Record<string, unknown>, "activeTurnId") ??
    readString(thread as unknown as Record<string, unknown>, "active_turn_id");

  if (activeTurnId !== undefined) {
    const activeTurn = turns.find((turn) => turn.id === activeTurnId);

    if (activeTurn !== undefined) {
      return activeTurn;
    }
  }

  return turns.find((turn) => turnCompletedAt(turn) === undefined || turnCompletedAt(turn) === null) ?? turns.at(-1);
}

function latestAgentMessage(turn: CodexTurn): { text: string; itemId: string | undefined } | undefined {
  const items = getTurnItems(turn);

  for (let index = items.length - 1; index >= 0; index -= 1) {
    const item = items[index];

    if (item?.type !== "agentMessage") {
      continue;
    }

    const text = readString(item, "text");

    if (text !== undefined) {
      return {
        text,
        itemId: readString(item, "id")
      };
    }
  }

  return undefined;
}

function deriveApprovalTitle(text: string | undefined): string {
  if (text === undefined) {
    return "Approve blocked action";
  }

  if (/permission|elevated access/i.test(text)) {
    return "Approve elevated permissions";
  }

  if (/command|run\b/i.test(text)) {
    return "Approve shell command";
  }

  if (/file|write|change/i.test(text)) {
    return "Approve file changes";
  }

  return "Approve blocked action";
}

function inferInputType(question: string): InputRequest["input_type"] {
  if (/\b(yes\s*\/\s*no|yes or no|y\/n)\b/i.test(question)) {
    return "confirm";
  }

  if (extractChoices(question).length > 0) {
    return "choice";
  }

  return "text";
}

function extractChoices(question: string): string[] {
  const choices = question
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => /^(\d+[.)]|[-*])\s+/.test(line))
    .map((line) => line.replace(/^(\d+[.)]|[-*])\s+/, "").trim())
    .filter((line) => line.length > 0);

  return Array.from(new Set(choices));
}

function approvalCreatedAt(thread: CodexThread, turn: CodexTurn | undefined): string {
  return (
    (turn !== undefined ? turnStartedAt(turn) : undefined) ??
    normalizeTimestamp(thread.updatedAt) ??
    normalizeTimestamp(thread.updated_at) ??
    normalizeTimestamp(thread.createdAt) ??
    normalizeTimestamp(thread.created_at) ??
    new Date().toISOString()
  );
}

function derivedApprovalId(threadId: string, turnId: string | undefined, itemId: string | undefined): string {
  return `codex:derived-approval:${threadId}:${turnId ?? "thread"}:${itemId ?? "status"}`;
}

function derivedInputId(threadId: string, turnId: string | undefined, itemId: string | undefined): string {
  return `codex:input:${threadId}:${turnId ?? "thread"}:${itemId ?? "status"}`;
}

export function deriveApprovalRequest(thread: CodexThread): ApprovalRequest | null {
  if (mapThreadStatus(thread.status ?? { type: "unknown" }) !== "waiting_approval") {
    return null;
  }

  const turn = latestTurn(thread);
  const message = turn === undefined ? undefined : latestAgentMessage(turn);
  const description = message?.text ?? readString(thread as unknown as Record<string, unknown>, "preview");
  const createdAt = approvalCreatedAt(thread, turn);
  const threadId = thread.id;

  return {
    id: derivedApprovalId(threadId, turn?.id, message?.itemId),
    session_id: toSessionId(threadId),
    ...(turn?.id !== undefined ? { run_id: toRunId(threadId, turn.id) } : {}),
    kind: /permission|sandbox|access/i.test(description ?? "") ? "generic" : "command",
    status: "pending",
    title: deriveApprovalTitle(description),
    ...(description !== undefined ? { description } : {}),
    risk_level: /permission|elevated|global|outside the workspace/i.test(description ?? "") ? "high" : "medium",
    payload: {
      response_mode: "message_send_fallback",
      ...(turn?.id !== undefined ? { turn_id: turn.id } : {}),
      ...(message?.itemId !== undefined ? { item_id: message.itemId } : {})
    },
    metadata: {
      source: "host-derived",
      adapter_kind: "codex",
      derivation_reason: "session_status",
      native_status: "waiting_approval"
    },
    created_at: createdAt
  };
}

export function deriveInputRequest(thread: CodexThread): InputRequest | null {
  if (mapThreadStatus(thread.status ?? { type: "unknown" }) !== "waiting_input") {
    return null;
  }

  const turn = latestTurn(thread);
  const message = turn === undefined ? undefined : latestAgentMessage(turn);
  const question = message?.text ?? readString(thread as unknown as Record<string, unknown>, "preview");

  if (question === undefined) {
    return null;
  }

  const inputType = inferInputType(question);
  const choices = inputType === "choice" ? extractChoices(question) : [];
  const threadId = thread.id;

  return {
    id: derivedInputId(threadId, turn?.id, message?.itemId),
    session_id: toSessionId(threadId),
    ...(turn?.id !== undefined ? { run_id: toRunId(threadId, turn.id) } : {}),
    question,
    input_type: inputType,
    ...(choices.length > 0 ? { choices } : {}),
    status: "pending",
    created_at: approvalCreatedAt(thread, turn),
    metadata: {
      source: "host-derived",
      adapter_kind: "codex",
      derivation_reason: "session_status",
      native_status: "waiting_input"
    }
  };
}

export function buildApprovalResponseInput(
  decision: "approved" | "rejected",
  note: string | undefined
): string {
  if (decision === "approved") {
    return note === undefined ? "approved" : `approved: ${note}`;
  }

  return note === undefined ? "rejected" : `rejected: ${note}`;
}
