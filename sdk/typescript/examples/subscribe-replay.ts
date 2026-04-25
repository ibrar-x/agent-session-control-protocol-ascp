import {
  replayFromSeq,
  subscribeWithReplay,
  type AscpReplayStreamItem
} from "ascp-sdk-typescript/replay";

import { createConnectedClient, isDirectExecution, printJson } from "./_shared.ts";

export interface SubscribeReplayExampleSummary {
  sessionId: string;
  subscriptionId: string;
  snapshotStatus: string | null;
  replayEventTypes: string[];
  liveEventTypes: string[];
  replayedEventCount: number | null;
  cursor: string | null;
}

export async function runSubscribeReplayExample(): Promise<SubscribeReplayExampleSummary> {
  const client = await createConnectedClient();
  const subscription = await subscribeWithReplay(
    client,
    replayFromSeq({
      session_id: "sess_abc123",
      from_seq: 34,
      include_snapshot: true
    })
  );

  try {
    const replayEventTypes: string[] = [];
    let snapshotStatus: string | null = null;
    let replayedEventCount: number | null = null;

    for await (const item of subscription) {
      switch (item.kind) {
        case "snapshot":
          snapshotStatus = item.event.payload.session.status;
          break;
        case "replay_event":
          replayEventTypes.push(item.event.type);
          break;
        case "replay_complete":
          replayedEventCount = item.event.payload.event_count;
          break;
        case "cursor_advanced":
          break;
        default:
          throw new Error(`Unexpected stream item before live input: ${describeItem(item)}.`);
      }

      if (item.kind === "cursor_advanced") {
        break;
      }
    }

    await client.sendInput({
      session_id: "sess_abc123",
      input: "Continue with the deterministic next step."
    });

    const liveEventTypes: string[] = [];
    for await (const item of subscription) {
      if (item.kind !== "live_event") {
        continue;
      }

      liveEventTypes.push(item.event.type);

      if (liveEventTypes.length === 3) {
        break;
      }
    }

    return {
      sessionId: "sess_abc123",
      subscriptionId: subscription.subscribe_result.subscription_id,
      snapshotStatus,
      replayEventTypes,
      liveEventTypes,
      replayedEventCount,
      cursor: subscription.cursor
    };
  } finally {
    await subscription.close();
    await client.close();
  }
}

function describeItem(item: AscpReplayStreamItem): string {
  return `${item.kind}:${item.event.type}`;
}

if (isDirectExecution(import.meta.url)) {
  runSubscribeReplayExample()
    .then((summary) => {
      printJson(summary);
    })
    .catch((error: unknown) => {
      const message = error instanceof Error ? error.stack ?? error.message : String(error);
      process.stderr.write(`${message}\n`);
      process.exitCode = 1;
    });
}
