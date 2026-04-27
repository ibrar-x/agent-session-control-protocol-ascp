import { createEventEnvelope, type EventEnvelope } from "ascp-sdk-typescript";

import { toRunId, toSessionId } from "./ids.js";
import type { CodexThread, CodexTurn } from "./session-mapper.js";

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

function readTextContent(item: Record<string, unknown>): string | undefined {
  const directText = readString(item, "text");

  if (directText !== undefined) {
    return directText;
  }

  const rawContent = item.content;

  if (!Array.isArray(rawContent)) {
    return undefined;
  }

  for (const entry of rawContent) {
    if (!isRecord(entry)) {
      continue;
    }

    const contentType = readString(entry, "type");
    const contentText = readString(entry, "text");

    if (contentType === "text" && contentText !== undefined) {
      return contentText;
    }
  }

  return undefined;
}

function getTurnItems(turn: CodexTurn): Array<Record<string, unknown>> {
  const rawItems = (turn as unknown as Record<string, unknown>).items;
  return Array.isArray(rawItems) ? rawItems.filter(isRecord) : [];
}

function turnTimestamp(turn: CodexTurn): string {
  return (
    normalizeTimestamp(turn.completedAt) ??
    normalizeTimestamp(turn.completed_at) ??
    normalizeTimestamp(turn.endedAt) ??
    normalizeTimestamp(turn.ended_at) ??
    normalizeTimestamp(turn.startedAt) ??
    normalizeTimestamp(turn.started_at) ??
    normalizeTimestamp(turn.createdAt) ??
    normalizeTimestamp(turn.created_at) ??
    new Date().toISOString()
  );
}

function assistantMessageEvent(
  threadId: string,
  turn: CodexTurn,
  item: Record<string, unknown>,
  index: number
): EventEnvelope<Record<string, unknown>> | null {
  if (item.type !== "agentMessage") {
    return null;
  }

  const content = readString(item, "text");

  if (content === undefined) {
    return null;
  }

  const itemId = readString(item, "id") ?? `agent_message_${index}`;
  const sessionId = toSessionId(threadId);
  const runId = toRunId(threadId, turn.id);

  return createEventEnvelope({
    id: `codex:event:agent_message_completed:${threadId}:${turn.id}:${itemId}`,
    type: "message.assistant.completed",
    ts: turnTimestamp(turn),
    session_id: sessionId,
    run_id: runId,
    payload: {
      message_id: `codex:message:${threadId}:${itemId}`,
      content
    }
  });
}

function userMessageEvent(
  threadId: string,
  turn: CodexTurn,
  item: Record<string, unknown>,
  index: number
): EventEnvelope<Record<string, unknown>> | null {
  const candidateType = readString(item, "type");

  if (candidateType !== "userMessage" && candidateType !== "text") {
    return null;
  }

  const content = readTextContent(item);

  if (content === undefined) {
    return null;
  }

  const sessionId = toSessionId(threadId);
  const runId = toRunId(threadId, turn.id);
  const itemId = readString(item, "id") ?? `user_message_${index}`;

  return createEventEnvelope({
    id: `codex:event:user_message_snapshot:${threadId}:${turn.id}:${itemId}`,
    type: "message.user",
    ts: turnTimestamp(turn),
    session_id: sessionId,
    run_id: runId,
    payload: {
      message_id: `codex:message:${threadId}:${itemId}`,
      content
    }
  });
}

export function extractTranscriptEvents(
  thread: CodexThread & { turns?: CodexTurn[] }
): EventEnvelope<Record<string, unknown>>[] {
  if (!Array.isArray(thread.turns)) {
    return [];
  }

  const events: EventEnvelope<Record<string, unknown>>[] = [];

  for (const turn of thread.turns) {
    const items = getTurnItems(turn);

    for (let index = 0; index < items.length; index += 1) {
      const item = items[index];
      const userEvent = userMessageEvent(thread.id, turn, item, index);

      if (userEvent !== null) {
        events.push(userEvent);
      }

      const assistantEvent = assistantMessageEvent(thread.id, turn, item, index);

      if (assistantEvent !== null) {
        events.push(assistantEvent);
      }
    }
  }

  return events.sort((left, right) => left.ts.localeCompare(right.ts));
}
