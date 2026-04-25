import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

import type { AscpClientRequestOptions } from "../src/client/index.js";
import { AscpClient } from "../src/client/index.js";
import type { CoreMethodName, SessionsSubscribeResult } from "../src/methods/index.js";
import type { EventEnvelope, FlexibleObject } from "../src/models/index.js";
import { AsyncQueue } from "../src/transport/async-queue.js";
import type {
  AscpTransport,
  AscpTransportSubscription,
  CoreMethodParamsMap
} from "../src/transport/index.js";
import type { CoreMethodResponse } from "../src/validation/index.js";

const TEST_DIR = dirname(fileURLToPath(import.meta.url));
const SDK_DIR = resolve(TEST_DIR, "..");
const REPO_DIR = resolve(SDK_DIR, "..");
const REPLAY_FIXTURE_DIR = resolve(REPO_DIR, "../conformance/fixtures/replay");

type ReplayFixture = {
  request: {
    params: {
      session_id: string;
      from_seq?: number;
      from_event_id?: string;
      include_snapshot?: boolean;
    };
  };
  request_extension?: {
    token: string;
  };
  response: {
    result: SessionsSubscribeResult;
  };
  expectations: Record<string, unknown>;
  stream: EventEnvelope[];
};

type ReplayRequestLike =
  | {
      kind: "from_seq";
      params: {
        session_id: string;
        from_seq: number;
        include_snapshot?: boolean;
      };
    }
  | {
      kind: "from_event_id";
      params: {
        session_id: string;
        from_event_id: string;
        include_snapshot?: boolean;
      };
    }
  | {
      kind: "opaque_cursor";
      params: {
        session_id: string;
        include_snapshot?: boolean;
      };
      params_extension: FlexibleObject;
    };

type ReplayStreamItemLike = {
  kind: string;
  event: EventEnvelope;
  cursor?: string;
  stream_phase?: string;
};

type ReplaySubscriptionLike = AsyncIterable<ReplayStreamItemLike> & {
  close(): Promise<void>;
  cursor: string | null;
  last_replayed: EventEnvelope | null;
  last_snapshot: EventEnvelope | null;
  subscribe_result: SessionsSubscribeResult;
};

type ReplayModuleLike = {
  buildReplaySubscribeParams: (request: ReplayRequestLike) => FlexibleObject;
  replayAfterEventId: (params: {
    session_id: string;
    from_event_id: string;
    include_snapshot?: boolean;
  }) => ReplayRequestLike;
  replayFromSeq: (params: {
    session_id: string;
    from_seq: number;
    include_snapshot?: boolean;
  }) => ReplayRequestLike;
  replayWithOpaqueCursor: (options: {
    params: {
      session_id: string;
      include_snapshot?: boolean;
    };
    params_extension: FlexibleObject;
  }) => ReplayRequestLike;
  subscribeWithReplay: (
    client: AscpClient,
    request: ReplayRequestLike,
    options?: AscpClientRequestOptions
  ) => Promise<ReplaySubscriptionLike>;
};

class QueueSubscription implements AscpTransportSubscription {
  constructor(private readonly queue: AsyncQueue<EventEnvelope>) {}

  async close(): Promise<void> {
    this.queue.close();
  }

  [Symbol.asyncIterator](): AsyncIterator<EventEnvelope> {
    return this.queue[Symbol.asyncIterator]();
  }
}

class ReplayStubTransport implements AscpTransport {
  readonly kind = "stub";
  readonly requests: Array<{
    method: CoreMethodName;
    options?: AscpClientRequestOptions;
    params?: CoreMethodParamsMap[CoreMethodName] | FlexibleObject;
  }> = [];

  private readonly queue = new AsyncQueue<EventEnvelope>();
  private readonly responses = new Map<CoreMethodName, CoreMethodResponse<CoreMethodName>>();

  async connect(): Promise<void> {}

  async close(): Promise<void> {
    this.queue.close();
  }

  setResponse(
    method: CoreMethodName,
    response: CoreMethodResponse<CoreMethodName>
  ): void {
    this.responses.set(method, response);
  }

  emitAll(events: EventEnvelope[]): void {
    for (const event of events) {
      this.queue.push(event);
    }

    this.queue.close();
  }

  async request<TMethod extends CoreMethodName>(
    method: TMethod,
    params?: CoreMethodParamsMap[TMethod],
    options?: AscpClientRequestOptions
  ): Promise<CoreMethodResponse<TMethod>> {
    this.requests.push({
      method,
      ...(params !== undefined ? { params } : {}),
      ...(options !== undefined ? { options } : {})
    });

    const response = this.responses.get(method);

    if (response === undefined) {
      throw new Error(`No response configured for ${method}.`);
    }

    return response as CoreMethodResponse<TMethod>;
  }

  subscribe(): AscpTransportSubscription {
    return new QueueSubscription(this.queue);
  }
}

function loadReplayFixture(name: string): ReplayFixture {
  return JSON.parse(
    readFileSync(resolve(REPLAY_FIXTURE_DIR, name), "utf8")
  ) as ReplayFixture;
}

async function loadReplayModule(): Promise<ReplayModuleLike> {
  const module = (await import("../src/replay/index.js")) as Partial<ReplayModuleLike>;

  expect(module.replayFromSeq).toBeTypeOf("function");
  expect(module.replayAfterEventId).toBeTypeOf("function");
  expect(module.replayWithOpaqueCursor).toBeTypeOf("function");
  expect(module.buildReplaySubscribeParams).toBeTypeOf("function");
  expect(module.subscribeWithReplay).toBeTypeOf("function");

  return module as ReplayModuleLike;
}

async function collectItems(
  subscription: ReplaySubscriptionLike,
  count: number
): Promise<ReplayStreamItemLike[]> {
  const items: ReplayStreamItemLike[] = [];

  for await (const item of subscription) {
    items.push(item);

    if (items.length === count) {
      break;
    }
  }

  return items;
}

describe("replay helper layer", () => {
  it("replays historical events from from_seq and preserves replay and cursor boundaries", async () => {
    const replay = await loadReplayModule();
    const fixture = loadReplayFixture("subscribe-from-seq.json");
    const transport = new ReplayStubTransport();
    const client = new AscpClient({ transport });

    transport.setResponse("sessions.subscribe", {
      jsonrpc: "2.0",
      id: "req_sub_seq_1",
      result: fixture.response.result
    });
    transport.setResponse("sessions.unsubscribe", {
      jsonrpc: "2.0",
      id: "req_unsub_seq_1",
      result: {
        subscription_id: fixture.response.result.subscription_id,
        unsubscribed: true
      }
    });

    const request = replay.replayFromSeq({
      session_id: fixture.request.params.session_id,
      from_seq: fixture.request.params.from_seq as number,
      include_snapshot: fixture.request.params.include_snapshot
    });

    expect(replay.buildReplaySubscribeParams(request)).toEqual(fixture.request.params);

    const subscription = await replay.subscribeWithReplay(client, request);
    transport.emitAll(fixture.stream);
    const items = await collectItems(subscription, fixture.stream.length);

    expect(subscription.subscribe_result).toEqual(fixture.response.result);
    expect(transport.requests[0]).toMatchObject({
      method: "sessions.subscribe",
      params: fixture.request.params
    });
    expect(items.map((item) => item.kind)).toEqual([
      "replay_event",
      "replay_event",
      "replay_event",
      "replay_complete",
      "live_event",
      "cursor_advanced"
    ]);
    expect(items[0]?.event.id).toBe("evt_hist_104");
    expect(items[3]).toMatchObject({
      kind: "replay_complete",
      event: {
        payload: {
          from_seq: fixture.expectations.from_seq,
          to_seq: fixture.expectations.to_seq,
          event_count: fixture.expectations.replayed_event_count
        }
      }
    });
    expect(items[5]).toMatchObject({
      kind: "cursor_advanced",
      cursor: fixture.expectations.expected_cursor,
      stream_phase: "live"
    });
    expect(subscription.cursor).toBe(fixture.expectations.expected_cursor);
    expect(subscription.last_replayed?.type).toBe("sync.replayed");

    await subscription.close();

    expect(transport.requests.at(-1)).toMatchObject({
      method: "sessions.unsubscribe",
      params: {
        subscription_id: fixture.response.result.subscription_id
      }
    });
  });

  it("treats from_event_id as an exclusive anchor and switches to live only after sync.replayed", async () => {
    const replay = await loadReplayModule();
    const fixture = loadReplayFixture("subscribe-from-event-id.json");
    const transport = new ReplayStubTransport();
    const client = new AscpClient({ transport });

    transport.setResponse("sessions.subscribe", {
      jsonrpc: "2.0",
      id: "req_sub_event_id_1",
      result: fixture.response.result
    });
    transport.setResponse("sessions.unsubscribe", {
      jsonrpc: "2.0",
      id: "req_unsub_event_id_1",
      result: {
        subscription_id: fixture.response.result.subscription_id,
        unsubscribed: true
      }
    });

    const request = replay.replayAfterEventId({
      session_id: fixture.request.params.session_id,
      from_event_id: fixture.request.params.from_event_id as string,
      include_snapshot: fixture.request.params.include_snapshot
    });

    expect(replay.buildReplaySubscribeParams(request)).toEqual(fixture.request.params);

    const subscription = await replay.subscribeWithReplay(client, request);
    transport.emitAll(fixture.stream);
    const items = await collectItems(subscription, fixture.stream.length);

    expect(items.map((item) => item.kind)).toEqual([
      "replay_event",
      "replay_event",
      "replay_complete",
      "live_event"
    ]);
    expect(items[0]?.event.id).toBe(fixture.expectations.first_replayed_event_id);
    expect(items[2]).toMatchObject({
      kind: "replay_complete",
      event: {
        payload: {
          from_seq: fixture.expectations.from_seq,
          to_seq: fixture.expectations.to_seq,
          event_count: fixture.expectations.replayed_event_count
        }
      }
    });

    await subscription.close();
  });

  it("keeps snapshot events distinct from replayed history and live continuation", async () => {
    const replay = await loadReplayModule();
    const fixture = loadReplayFixture("subscribe-with-snapshot.json");
    const transport = new ReplayStubTransport();
    const client = new AscpClient({ transport });

    transport.setResponse("sessions.subscribe", {
      jsonrpc: "2.0",
      id: "req_sub_snapshot_1",
      result: fixture.response.result
    });
    transport.setResponse("sessions.unsubscribe", {
      jsonrpc: "2.0",
      id: "req_unsub_snapshot_1",
      result: {
        subscription_id: fixture.response.result.subscription_id,
        unsubscribed: true
      }
    });

    const request = replay.replayFromSeq({
      session_id: fixture.request.params.session_id,
      from_seq: fixture.request.params.from_seq as number,
      include_snapshot: fixture.request.params.include_snapshot
    });

    const subscription = await replay.subscribeWithReplay(client, request);
    transport.emitAll(fixture.stream);
    const items = await collectItems(subscription, fixture.stream.length);

    expect(items.map((item) => item.kind)).toEqual([
      "snapshot",
      "replay_event",
      "replay_event",
      "replay_complete",
      "live_event",
      "cursor_advanced"
    ]);
    expect(subscription.last_snapshot?.type).toBe("sync.snapshot");
    expect(items[0]?.event.id).toBe("evt_snapshot_curr_210");
    expect(items[1]?.event.seq).toBe(fixture.expectations.from_seq);
    expect(items[4]?.event.seq).toBe(207);
    expect(subscription.cursor).toBe(fixture.expectations.expected_cursor);

    await subscription.close();
  });

  it("passes opaque cursor extensions through without overwriting frozen core params", async () => {
    const replay = await loadReplayModule();
    const fixture = loadReplayFixture("subscribe-with-opaque-cursor.json");
    const transport = new ReplayStubTransport();
    const client = new AscpClient({ transport });

    transport.setResponse("sessions.subscribe", {
      jsonrpc: "2.0",
      id: "req_sub_cursor_1",
      result: fixture.response.result
    });
    transport.setResponse("sessions.unsubscribe", {
      jsonrpc: "2.0",
      id: "req_unsub_cursor_1",
      result: {
        subscription_id: fixture.response.result.subscription_id,
        unsubscribed: true
      }
    });

    const request = replay.replayWithOpaqueCursor({
      params: fixture.request.params,
      params_extension: {
        cursor: fixture.request_extension?.token
      }
    });

    expect(replay.buildReplaySubscribeParams(request)).toEqual({
      ...fixture.request.params,
      cursor: fixture.request_extension?.token
    });

    const subscription = await replay.subscribeWithReplay(client, request);
    transport.emitAll(fixture.stream);
    const items = await collectItems(subscription, fixture.stream.length);

    expect(transport.requests[0]).toMatchObject({
      method: "sessions.subscribe",
      params: {
        ...fixture.request.params,
        cursor: fixture.request_extension?.token
      }
    });
    expect(items.at(-1)).toMatchObject({
      kind: "cursor_advanced",
      cursor: fixture.expectations.expected_cursor
    });
    expect(subscription.cursor).toBe(fixture.expectations.expected_cursor);

    await subscription.close();
  });

  it("rejects opaque cursor extensions that try to override core subscribe params", async () => {
    const replay = await loadReplayModule();

    const request = replay.replayWithOpaqueCursor({
      params: {
        session_id: "sess_replay_1",
        include_snapshot: false
      },
      params_extension: {
        session_id: "sess_override"
      }
    });

    expect(() => replay.buildReplaySubscribeParams(request)).toThrowError(
      /must not overwrite core subscribe params/i
    );
  });
});
