import { createEventEnvelope, type EventEnvelope } from "ascp-sdk-typescript";

import type { CodexJsonRpcNotification } from "./app-server-client.js";
import type { CodexTurn } from "./session-mapper.js";
import { mapTurnStatus, mapTurnToRun } from "./session-mapper.js";
import { toRunId, toSessionId } from "./ids.js";

export interface CodexEventMappingOptions {
  now?: () => string;
  seq?: number;
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

function readTimestamp(record: Record<string, unknown>, keys: readonly string[]): string | undefined {
  for (const key of keys) {
    const normalized = normalizeTimestampValue(record[key]);

    if (typeof normalized === "string") {
      return normalized;
    }
  }

  return undefined;
}

function readErrorMessage(record: Record<string, unknown>): string | undefined {
  const error = record.error;

  if (!isRecord(error)) {
    return undefined;
  }

  return readString(error, "message");
}

function eventNow(options: CodexEventMappingOptions): string {
  return options.now?.() ?? new Date().toISOString();
}

function createCodexEventId(...parts: string[]): string {
  return `codex:event:${parts.join(":")}`;
}

function toMessageId(threadId: string, itemId: string): string {
  return `codex:message:${threadId}:${itemId}`;
}

function getTurnItems(turnRecord: Record<string, unknown>): Array<Record<string, unknown>> {
  return Array.isArray(turnRecord.items) ? turnRecord.items.filter(isRecord) : [];
}

function latestAgentMessage(
  turnRecord: Record<string, unknown>
): { itemId: string; text: string } | undefined {
  const items = getTurnItems(turnRecord);

  for (let index = items.length - 1; index >= 0; index -= 1) {
    const item = items[index];

    if (item?.type !== "agentMessage") {
      continue;
    }

    const itemId = readString(item, "id");
    const text = readString(item, "text");

    if (itemId !== undefined && text !== undefined) {
      return {
        itemId,
        text
      };
    }
  }

  return undefined;
}

function withOptionalSeq<TPayload extends Record<string, unknown>>(
  event: EventEnvelope<TPayload>,
  seq: number | undefined
): EventEnvelope<TPayload> {
  if (seq === undefined) {
    return event;
  }

  return {
    ...event,
    seq
  };
}

function inferDiffChangedFields(diff: unknown): string[] {
  if (isRecord(diff)) {
    const changedFields: string[] = [];

    if (readNumber(diff, "filesChanged") !== undefined || readNumber(diff, "files_changed") !== undefined) {
      changedFields.push("files_changed");
    }

    if (readNumber(diff, "insertions") !== undefined) {
      changedFields.push("insertions");
    }

    if (readNumber(diff, "deletions") !== undefined) {
      changedFields.push("deletions");
    }

    if (Array.isArray(diff.files)) {
      changedFields.push("files");
    }

    if (changedFields.length > 0) {
      return changedFields;
    }
  }

  return ["x_codex_diff"];
}

function mapTurnStartedEvent(
  params: Record<string, unknown>,
  options: CodexEventMappingOptions
): EventEnvelope<Record<string, unknown>>[] {
  const threadId = readString(params, "threadId");
  const turnRecord = isRecord(params.turn) ? params.turn : undefined;

  if (threadId === undefined || turnRecord === undefined) {
    return [];
  }

  const turnId = readString(turnRecord, "id");

  if (turnId === undefined) {
    return [];
  }

  const turn = turnRecord as unknown as CodexTurn;
  const run = mapTurnToRun(turn, threadId);

  return [
    withOptionalSeq(
      createEventEnvelope({
        id: createCodexEventId("turn_started", threadId, turnId),
        type: "run.started",
        ts: readTimestamp(turnRecord, ["startedAt", "started_at", "createdAt", "created_at"]) ?? eventNow(options),
        session_id: toSessionId(threadId),
        run_id: run.id,
        payload: {
          run
        }
      }),
      options.seq
    )
  ];
}

function mapTurnCompletedEvent(
  params: Record<string, unknown>,
  options: CodexEventMappingOptions
): EventEnvelope<Record<string, unknown>>[] {
  const threadId = readString(params, "threadId");
  const turnRecord = isRecord(params.turn) ? params.turn : undefined;

  if (threadId === undefined || turnRecord === undefined) {
    return [];
  }

  const turnId = readString(turnRecord, "id");

  if (turnId === undefined) {
    return [];
  }

  const turn = turnRecord as unknown as CodexTurn;
  const runId = toRunId(threadId, turnId);
  const endedAt =
    readTimestamp(turnRecord, ["completedAt", "completed_at", "endedAt", "ended_at"]) ?? eventNow(options);

  switch (mapTurnStatus(turn)) {
    case "completed":
      return [
        ...(() => {
          const message = latestAgentMessage(turnRecord);

          if (message === undefined) {
            return [];
          }

          return [
            withOptionalSeq(
              createEventEnvelope({
                id: createCodexEventId("agent_message_completed", threadId, turnId, message.itemId),
                type: "message.assistant.completed",
                ts: endedAt,
                session_id: toSessionId(threadId),
                run_id: runId,
                payload: {
                  message_id: toMessageId(threadId, message.itemId),
                  content: message.text
                }
              }),
              options.seq
            )
          ];
        })(),
        withOptionalSeq(
          createEventEnvelope({
            id: createCodexEventId("turn_completed", threadId, turnId),
            type: "run.completed",
            ts: endedAt,
            session_id: toSessionId(threadId),
            run_id: runId,
            payload: {
              run_id: runId,
              ended_at: endedAt,
              exit_code: readNumber(turnRecord, "exitCode") ?? readNumber(turnRecord, "exit_code") ?? 0
            }
          }),
          options.seq
        )
      ];
    case "failed":
      return [
        withOptionalSeq(
          createEventEnvelope({
            id: createCodexEventId("turn_failed", threadId, turnId),
            type: "run.failed",
            ts: endedAt,
            session_id: toSessionId(threadId),
            run_id: runId,
            payload: {
              run_id: runId,
              ended_at: endedAt,
              error_code: "RUNTIME_ERROR",
              message: readErrorMessage(turnRecord) ?? "Codex turn failed."
            }
          }),
          options.seq
        )
      ];
    case "cancelled":
      return [
        withOptionalSeq(
          createEventEnvelope({
            id: createCodexEventId("turn_cancelled", threadId, turnId),
            type: "run.cancelled",
            ts: endedAt,
            session_id: toSessionId(threadId),
            run_id: runId,
            payload: {
              run_id: runId,
              ended_at: endedAt,
              reason: readErrorMessage(turnRecord) ?? "Codex turn interrupted."
            }
          }),
          options.seq
        )
      ];
    default:
      return [];
  }
}

function mapAgentMessageDeltaEvent(
  params: Record<string, unknown>,
  options: CodexEventMappingOptions
): EventEnvelope<Record<string, unknown>>[] {
  const threadId = readString(params, "threadId");
  const turnId = readString(params, "turnId");
  const itemId = readString(params, "itemId");
  const delta = readString(params, "delta");

  if (threadId === undefined || turnId === undefined || itemId === undefined || delta === undefined) {
    return [];
  }

  return [
    withOptionalSeq(
      createEventEnvelope({
        id: createCodexEventId("agent_message_delta", threadId, turnId, itemId),
        type: "message.assistant.delta",
        ts: eventNow(options),
        session_id: toSessionId(threadId),
        run_id: toRunId(threadId, turnId),
        payload: {
          message_id: toMessageId(threadId, itemId),
          delta
        }
      }),
      options.seq
    )
  ];
}

function mapDiffUpdatedEvent(
  params: Record<string, unknown>,
  options: CodexEventMappingOptions
): EventEnvelope<Record<string, unknown>>[] {
  const threadId = readString(params, "threadId");
  const turnId = readString(params, "turnId");

  if (threadId === undefined || turnId === undefined) {
    return [];
  }

  const sessionId = toSessionId(threadId);
  const runId = toRunId(threadId, turnId);

  return [
    withOptionalSeq(
      createEventEnvelope({
        id: createCodexEventId("turn_diff_updated", threadId, turnId),
        type: "diff.updated",
        ts: eventNow(options),
        session_id: sessionId,
        run_id: runId,
        payload: {
          session_id: sessionId,
          run_id: runId,
          changed_fields: inferDiffChangedFields(params.diff)
        }
      }),
      options.seq
    )
  ];
}

export function mapNotificationToEvents(
  notification: CodexJsonRpcNotification,
  options: CodexEventMappingOptions = {}
): EventEnvelope<Record<string, unknown>>[] {
  const params = isRecord(notification.params) ? notification.params : {};

  switch (notification.method) {
    case "turn/started":
      return mapTurnStartedEvent(params, options);
    case "turn/completed":
      return mapTurnCompletedEvent(params, options);
    case "agentMessageDelta":
      return mapAgentMessageDeltaEvent(params, options);
    case "turn/diff/updated":
      return mapDiffUpdatedEvent(params, options);
    default:
      return [];
  }
}
