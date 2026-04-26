import type { AscpClientRequestOptions } from "../client/index.js";
import type {
  SessionsSubscribeParams,
  SessionsSubscribeResult
} from "../methods/index.js";
import type {
  ApprovalRequest,
  EventEnvelope,
  FlexibleObject,
  Id,
  InputRequest,
  Run,
  Session
} from "../models/index.js";
import { AsyncQueue } from "../transport/async-queue.js";
import type { AscpTransportSubscription } from "../transport/index.js";
import { parseCoreEventEnvelope } from "../validation/index.js";

const CORE_SUBSCRIBE_PARAM_KEYS = new Set([
  "session_id",
  "from_seq",
  "from_event_id",
  "include_snapshot"
]);

export interface ReplayFromSeqParams {
  session_id: Id;
  from_seq: number;
  include_snapshot?: boolean;
}

export interface ReplayAfterEventIdParams {
  session_id: Id;
  from_event_id: Id;
  include_snapshot?: boolean;
}

export interface ReplayWithOpaqueCursorOptions {
  params: {
    session_id: Id;
    include_snapshot?: boolean;
  };
  params_extension: FlexibleObject;
}

export interface ReplayFromSeqRequest {
  kind: "from_seq";
  params: ReplayFromSeqParams;
}

export interface ReplayAfterEventIdRequest {
  kind: "from_event_id";
  params: ReplayAfterEventIdParams;
}

export interface ReplayWithOpaqueCursorRequest {
  kind: "opaque_cursor";
  params: ReplayWithOpaqueCursorOptions["params"];
  params_extension: FlexibleObject;
}

export type AscpReplayRequest =
  | ReplayFromSeqRequest
  | ReplayAfterEventIdRequest
  | ReplayWithOpaqueCursorRequest;

export type AscpReplayStreamPhase = "replay" | "live";

export interface SyncSnapshotPayload extends FlexibleObject {
  session: Session;
  active_run?: Run;
  pending_approvals: ApprovalRequest[];
  pending_inputs?: InputRequest[];
  summary?: FlexibleObject;
}

export interface SyncReplayedPayload extends FlexibleObject {
  from_seq: number;
  to_seq: number;
  event_count: number;
}

export interface SyncCursorAdvancedPayload extends FlexibleObject {
  cursor: string;
}

export type SyncSnapshotEvent = EventEnvelope<SyncSnapshotPayload> & {
  type: "sync.snapshot";
};
export type SyncReplayedEvent = EventEnvelope<SyncReplayedPayload> & {
  type: "sync.replayed";
};
export type SyncCursorAdvancedEvent = EventEnvelope<SyncCursorAdvancedPayload> & {
  type: "sync.cursor_advanced";
};

export type AscpReplayStreamItem =
  | {
      kind: "snapshot";
      event: SyncSnapshotEvent;
    }
  | {
      kind: "replay_event";
      event: EventEnvelope;
    }
  | {
      kind: "replay_complete";
      event: SyncReplayedEvent;
    }
  | {
      kind: "live_event";
      event: EventEnvelope;
    }
  | {
      kind: "cursor_advanced";
      cursor: string;
      event: SyncCursorAdvancedEvent;
      stream_phase: AscpReplayStreamPhase;
    };

export interface AscpReplayClient {
  events(): AscpTransportSubscription;
  subscribe(
    params: SessionsSubscribeParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsSubscribeResult>;
  unsubscribe(
    params: { subscription_id: Id },
    options?: AscpClientRequestOptions
  ): Promise<unknown>;
}

export class AscpReplayConfigurationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "AscpReplayConfigurationError";
  }
}

function parseSyncSnapshotEvent(event: EventEnvelope): SyncSnapshotEvent {
  const parsed = parseCoreEventEnvelope(event);

  if (parsed.type !== "sync.snapshot") {
    throw new AscpReplayConfigurationError("Expected a sync.snapshot event.");
  }

  return parsed as unknown as SyncSnapshotEvent;
}

function parseSyncReplayedEvent(event: EventEnvelope): SyncReplayedEvent {
  const parsed = parseCoreEventEnvelope(event);

  if (parsed.type !== "sync.replayed") {
    throw new AscpReplayConfigurationError("Expected a sync.replayed event.");
  }

  return parsed as unknown as SyncReplayedEvent;
}

function parseSyncCursorAdvancedEvent(event: EventEnvelope): SyncCursorAdvancedEvent {
  const parsed = parseCoreEventEnvelope(event);

  if (parsed.type !== "sync.cursor_advanced") {
    throw new AscpReplayConfigurationError("Expected a sync.cursor_advanced event.");
  }

  return parsed as unknown as SyncCursorAdvancedEvent;
}

export function replayFromSeq(params: ReplayFromSeqParams): ReplayFromSeqRequest {
  return {
    kind: "from_seq",
    params
  };
}

export function replayAfterEventId(
  params: ReplayAfterEventIdParams
): ReplayAfterEventIdRequest {
  return {
    kind: "from_event_id",
    params
  };
}

export function replayWithOpaqueCursor(
  options: ReplayWithOpaqueCursorOptions
): ReplayWithOpaqueCursorRequest {
  return {
    kind: "opaque_cursor",
    params: options.params,
    params_extension: options.params_extension
  };
}

export function buildReplaySubscribeParams(
  request: AscpReplayRequest
): SessionsSubscribeParams & FlexibleObject {
  if (request.kind !== "opaque_cursor") {
    return {
      ...request.params
    };
  }

  const params = {
    ...request.params
  } as SessionsSubscribeParams & FlexibleObject;

  for (const [key, value] of Object.entries(request.params_extension)) {
    if (CORE_SUBSCRIBE_PARAM_KEYS.has(key)) {
      throw new AscpReplayConfigurationError(
        `Opaque replay cursor extensions must not overwrite core subscribe params: ${key}.`
      );
    }

    params[key] = value;
  }

  return params;
}

export async function subscribeWithReplay(
  client: AscpReplayClient,
  request: AscpReplayRequest,
  options?: AscpClientRequestOptions
): Promise<AscpReplaySubscription> {
  const stream = client.events();

  try {
    const subscribe_result = await client.subscribe(
      buildReplaySubscribeParams(request) as SessionsSubscribeParams,
      options
    );

    return new AscpReplaySubscription({
      client,
      options,
      request,
      stream,
      subscribe_result
    });
  } catch (error) {
    await stream.close();
    throw error;
  }
}

export interface AscpReplaySubscriptionOptions {
  client: AscpReplayClient;
  options: AscpClientRequestOptions | undefined;
  request: AscpReplayRequest;
  stream: AscpTransportSubscription;
  subscribe_result: SessionsSubscribeResult;
}

export class AscpReplaySubscription implements AsyncIterable<AscpReplayStreamItem> {
  readonly subscribe_result: SessionsSubscribeResult;
  readonly request: AscpReplayRequest;

  private readonly client: AscpReplayClient;
  private readonly options: AscpClientRequestOptions | undefined;
  private readonly queue = new AsyncQueue<AscpReplayStreamItem>();
  private readonly stream: AscpTransportSubscription;
  private closed = false;
  private cursorValue: string | null = null;
  private readonly consumePromise: Promise<void>;
  private lastReplayedValue: SyncReplayedEvent | null = null;
  private lastSnapshotValue: SyncSnapshotEvent | null = null;
  private replayPhaseActive: boolean;

  constructor(options: AscpReplaySubscriptionOptions) {
    this.client = options.client;
    this.options = options.options;
    this.request = options.request;
    this.stream = options.stream;
    this.subscribe_result = options.subscribe_result;
    this.replayPhaseActive = true;
    this.consumePromise = this.consume();
  }

  get cursor(): string | null {
    return this.cursorValue;
  }

  get last_replayed(): SyncReplayedEvent | null {
    return this.lastReplayedValue;
  }

  get last_snapshot(): SyncSnapshotEvent | null {
    return this.lastSnapshotValue;
  }

  async close(): Promise<void> {
    if (this.closed) {
      return;
    }

    this.closed = true;

    let unsubscribeError: unknown;

    try {
      await this.client.unsubscribe(
        {
          subscription_id: this.subscribe_result.subscription_id
        },
        this.options
      );
    } catch (error) {
      unsubscribeError = error;
    }

    await this.stream.close();

    try {
      await this.consumePromise;
    } catch (error) {
      if (unsubscribeError === undefined) {
        unsubscribeError = error;
      }
    }

    this.queue.close();

    if (unsubscribeError !== undefined) {
      throw unsubscribeError;
    }
  }

  [Symbol.asyncIterator](): AsyncIterator<AscpReplayStreamItem> {
    return this.queue[Symbol.asyncIterator]();
  }

  private async consume(): Promise<void> {
    try {
      for await (const event of this.stream) {
        if (event.session_id !== this.subscribe_result.session_id) {
          continue;
        }

        const item = this.classifyEvent(event);

        if (item !== null) {
          this.queue.push(item);
        }
      }

      this.queue.close();
    } catch (error) {
      this.queue.fail(error);
      throw error;
    }
  }

  private classifyEvent(event: EventEnvelope): AscpReplayStreamItem | null {
    switch (event.type) {
      case "sync.snapshot": {
        const snapshot = parseSyncSnapshotEvent(event);
        this.lastSnapshotValue = snapshot;
        return {
          kind: "snapshot",
          event: snapshot
        };
      }

      case "sync.replayed": {
        const replayed = parseSyncReplayedEvent(event);
        this.lastReplayedValue = replayed;
        this.replayPhaseActive = false;
        return {
          kind: "replay_complete",
          event: replayed
        };
      }

      case "sync.cursor_advanced": {
        const cursorAdvanced = parseSyncCursorAdvancedEvent(event);
        this.cursorValue = cursorAdvanced.payload.cursor;
        return {
          kind: "cursor_advanced",
          cursor: cursorAdvanced.payload.cursor,
          event: cursorAdvanced,
          stream_phase: this.replayPhaseActive ? "replay" : "live"
        };
      }

      default:
        return this.replayPhaseActive
          ? {
              kind: "replay_event",
              event
            }
          : {
              kind: "live_event",
              event
            };
    }
  }
}
