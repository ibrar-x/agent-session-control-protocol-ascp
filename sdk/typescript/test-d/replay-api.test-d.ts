import type { AscpClientRequestOptions } from "../src/client/index.js";
import type { SessionsSubscribeResult } from "../src/methods/index.js";
import {
  replayAfterEventId,
  replayFromSeq,
  replayWithOpaqueCursor,
  subscribeWithReplay,
  type AscpReplayClient,
  type AscpReplayRequest,
  type AscpReplayStreamItem,
  type AscpReplaySubscription,
  type SyncReplayedEvent,
  type SyncSnapshotEvent
} from "../src/replay/index.js";

declare function expectType<T>(value: T): void;
declare const client: AscpReplayClient;
declare const requestOptions: AscpClientRequestOptions;

const fromSeq = replayFromSeq({
  session_id: "sess_01",
  from_seq: 104,
  include_snapshot: true
});
const fromEventId = replayAfterEventId({
  session_id: "sess_01",
  from_event_id: "evt_hist_103"
});
const opaqueCursor = replayWithOpaqueCursor({
  params: {
    session_id: "sess_01"
  },
  params_extension: {
    cursor: "opaque:sess_01:104"
  }
});

expectType<AscpReplayRequest>(fromSeq);
expectType<AscpReplayRequest>(fromEventId);
expectType<AscpReplayRequest>(opaqueCursor);

const subscriptionPromise = subscribeWithReplay(client, fromSeq, requestOptions);

expectType<Promise<AscpReplaySubscription>>(subscriptionPromise);

const subscription = await subscriptionPromise;
const subscribeResult: SessionsSubscribeResult = subscription.subscribe_result;
const firstItemResult = await subscription[Symbol.asyncIterator]().next();

if (!firstItemResult.done) {
  expectType<AscpReplayStreamItem>(firstItemResult.value);
}

const maybeCursor: string | null = subscription.cursor;
const maybeSnapshot: SyncSnapshotEvent | null = subscription.last_snapshot;
const maybeReplayed: SyncReplayedEvent | null = subscription.last_replayed;

void subscribeResult;
void maybeCursor;
void maybeSnapshot;
void maybeReplayed;
