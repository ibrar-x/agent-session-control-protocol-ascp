import type { ApprovalRequest, EventEnvelope, FlexibleObject, InputRequest } from "ascp-sdk-typescript/models";

import type { ChatTimelineItem } from "./components/ChatPane";
import { buildInteractionTimelineItems } from "./model";

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

function approvalActionLabel(approval: ApprovalRequest): string {
  return approval.title ?? approval.description ?? approval.id;
}

function inputActionLabel(input: InputRequest): string {
  return input.question;
}

export function buildTimeline(
  events: EventEnvelope<FlexibleObject>[],
  approvals: ApprovalRequest[],
  inputs: InputRequest[]
): ChatTimelineItem[] {
  const items: ChatTimelineItem[] = [];
  const assistantIndexByMessageId = new Map<string, number>();
  const interactionItems = buildInteractionTimelineItems({
    approvals,
    inputs
  }).map<ChatTimelineItem>((item) =>
    item.kind === "approval"
      ? {
          id: item.id,
          kind: "approval",
          title: approvalActionLabel(item.approval!),
          body: item.approval?.description ?? "Approval is required before the agent can continue.",
          state: item.state,
          ts: item.ts,
          approval: item.approval
        }
      : {
          id: item.id,
          kind: "input",
          title: inputActionLabel(item.input!),
          body:
            item.input?.input_type === "choice" && Array.isArray(item.input.choices)
              ? `Choices: ${item.input.choices.join(", ")}`
              : "The agent is waiting for user input.",
          state: item.state,
          ts: item.ts,
          input: item.input
        }
  );

  for (const event of events) {
    const payload = isRecord(event.payload) ? event.payload : {};

    switch (event.type) {
      case "message.user":
        items.push({
          id: event.id,
          kind: "user",
          body: readString(payload, "content") ?? "User input sent.",
          ts: event.ts
        });
        break;
      case "message.assistant.completed":
      case "message.assistant.delta": {
        const messageId = readString(payload, "message_id");

        if (messageId === undefined) {
          break;
        }

        const existingIndex = assistantIndexByMessageId.get(messageId);

        if (event.type === "message.assistant.delta") {
          const delta = readString(payload, "delta") ?? "";

          if (existingIndex === undefined) {
            assistantIndexByMessageId.set(messageId, items.length);
            items.push({
              id: event.id,
              kind: "assistant",
              body: delta,
              ts: event.ts
            });
            break;
          }

          const existingItem = items[existingIndex];
          items[existingIndex] = {
            ...existingItem,
            body: `${existingItem.body}${delta}`,
            ts: event.ts
          };
          break;
        }

        const content = readString(payload, "content") ?? "Assistant response completed.";

        if (existingIndex === undefined) {
          assistantIndexByMessageId.set(messageId, items.length);
          items.push({
            id: event.id,
            kind: "assistant",
            body: content,
            ts: event.ts
          });
          break;
        }

        items[existingIndex] = {
          ...items[existingIndex],
          id: event.id,
          body: content,
          ts: event.ts
        };
        break;
      }
      case "message.system":
        items.push({
          id: event.id,
          kind: "system",
          body: readString(payload, "content") ?? "System message received.",
          ts: event.ts
        });
        break;
      case "run.started":
        items.push({
          id: event.id,
          kind: "activity",
          title: "Run started",
          body: event.run_id ?? "The agent started a new run.",
          ts: event.ts
        });
        break;
      case "run.completed":
        items.push({
          id: event.id,
          kind: "activity",
          title: "Run completed",
          body: event.run_id ?? "The current run completed.",
          ts: event.ts
        });
        break;
      case "run.failed":
        items.push({
          id: event.id,
          kind: "activity",
          title: "Run failed",
          body: readString(payload, "reason") ?? event.run_id ?? "The current run failed.",
          ts: event.ts
        });
        break;
      case "run.cancelled":
        items.push({
          id: event.id,
          kind: "activity",
          title: "Run cancelled",
          body: readString(payload, "reason") ?? event.run_id ?? "The current run was cancelled.",
          ts: event.ts
        });
        break;
      case "session.status_changed":
        items.push({
          id: event.id,
          kind: "system",
          title: "Session status changed",
          body: `${readString(payload, "from") ?? "unknown"} -> ${readString(payload, "to") ?? "unknown"}`,
          ts: event.ts
        });
        break;
      case "diff.updated":
        items.push({
          id: event.id,
          kind: "activity",
          title: "Diff updated",
          body: "The adapter reported file changes for the current run.",
          ts: event.ts
        });
        break;
      case "sync.replayed":
        items.push({
          id: event.id,
          kind: "system",
          title: "Replay loaded",
          body: "Replay-safe events were restored after subscription attach.",
          ts: event.ts
        });
        break;
      default:
        break;
    }
  }

  return [...items, ...interactionItems].sort((left, right) =>
    (left.ts ?? "").localeCompare(right.ts ?? "")
  );
}
