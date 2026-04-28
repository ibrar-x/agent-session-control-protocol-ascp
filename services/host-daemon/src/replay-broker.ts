import { createEventEnvelope, type EventEnvelope, type SessionsSubscribeParams, type SessionsSubscribeResult, type SessionsUnsubscribeParams, type SessionsUnsubscribeResult } from "ascp-sdk-typescript";

import type { AttachmentManager } from "./attachment-manager.js";
import type { CursorStore } from "./stores/cursor-store.js";
import type { EventStore } from "./stores/event-store.js";
import type { SessionStore } from "./stores/session-store.js";

interface SubscriptionState {
  sessionId: string;
  queue: EventEnvelope<Record<string, unknown>>[];
  subscriptionId: string;
}

export interface ReplayBroker {
  createSubscription(input: {
    sessionId: string;
    includeSnapshot: boolean;
    fromEventId?: string;
    fromSeq?: number;
  }): { events: EventEnvelope<Record<string, unknown>>[]; subscriptionId: string };
  drainSubscriptionEvents(subscriptionId: string, limit?: number): EventEnvelope<Record<string, unknown>>[];
  unsubscribe(params: SessionsUnsubscribeParams): SessionsUnsubscribeResult;
}

export function createReplayBroker(deps: {
  cursorStore?: CursorStore;
  eventStore: EventStore;
  sessionStore: SessionStore;
}): ReplayBroker {
  const subscriptions = new Map<string, SubscriptionState>();
  let nextSubscriptionOrdinal = 1;

  return {
    createSubscription(input) {
      const queue: EventEnvelope<Record<string, unknown>>[] = [];
      const snapshot = deps.sessionStore.getSnapshot(input.sessionId);
      const replayRequested = input.fromSeq !== undefined || input.fromEventId !== undefined;

      if (input.includeSnapshot && snapshot !== null) {
        queue.push(
          createEventEnvelope({
            id: `daemon:event:sync_snapshot:${input.sessionId}:${Date.now()}`,
            type: "sync.snapshot",
            ts: new Date().toISOString(),
            session_id: input.sessionId,
            payload: {
              session: snapshot.session,
              active_run: snapshot.activeRun,
              pending_approvals: snapshot.pendingApprovals,
              pending_inputs: snapshot.pendingInputs,
              metadata: {
                snapshot_origin: snapshot.snapshotOrigin,
                completeness: snapshot.completeness,
                missing_fields: snapshot.missingFields,
                missing_reasons: snapshot.missingReasons,
                attachment_status: snapshot.attachmentStatus
              }
            }
          })
        );
      }

      const replayEvents =
        input.fromEventId !== undefined
          ? deps.eventStore.listAfterEventId(input.sessionId, input.fromEventId)
          : deps.eventStore.listAfterSeq(input.sessionId, input.fromSeq ?? 0);

      queue.push(...(replayEvents as unknown as EventEnvelope<Record<string, unknown>>[]));

      if (replayRequested && replayEvents.length > 0) {
        queue.push(
          createEventEnvelope({
            id: `daemon:event:sync_replayed:${input.sessionId}:${Date.now()}`,
            type: "sync.replayed",
            ts: new Date().toISOString(),
            session_id: input.sessionId,
            payload: {
              from_seq: input.fromSeq ?? 0,
              to_seq: replayEvents.at(-1)?.seq ?? input.fromSeq ?? 0,
              event_count: replayEvents.length
            }
          })
        );
      }

      const subscriptionId = `daemon:subscription:${input.sessionId}:${nextSubscriptionOrdinal++}`;
      subscriptions.set(subscriptionId, {
        sessionId: input.sessionId,
        queue,
        subscriptionId
      });

      return {
        subscriptionId,
        events: queue
      };
    },
    drainSubscriptionEvents(subscriptionId, limit) {
      const subscription = subscriptions.get(subscriptionId);

      if (subscription === undefined) {
        return [];
      }

      if (limit === undefined || limit >= subscription.queue.length) {
        return subscription.queue.splice(0, subscription.queue.length);
      }

      return subscription.queue.splice(0, limit);
    },
    unsubscribe(params) {
      return {
        subscription_id: params.subscription_id,
        unsubscribed: subscriptions.delete(params.subscription_id)
      };
    }
  };
}

function bindMethod<TMethod extends (...args: never[]) => unknown>(
  method: TMethod | undefined,
  runtime: object
): TMethod | undefined {
  return method?.bind(runtime) as TMethod | undefined;
}

export function createReplayBackedRuntime(deps: {
  attachmentManager: AttachmentManager;
  replayBroker: ReplayBroker;
  runtime: {
    capabilitiesGet: (...args: never[]) => unknown;
    hostsGet: (...args: never[]) => unknown;
    runtimesList?: (...args: never[]) => unknown;
    sessionsList?: (...args: never[]) => unknown;
    sessionsGet?: (...args: never[]) => unknown;
    sessionsStart?: (...args: never[]) => unknown;
    sessionsResume?: (...args: never[]) => unknown;
    sessionsStop?: (...args: never[]) => unknown;
    sessionsSendInput?: (...args: never[]) => unknown;
    approvalsList?: (...args: never[]) => unknown;
    approvalsRespond?: (...args: never[]) => unknown;
    artifactsList?: (...args: never[]) => unknown;
    artifactsGet?: (...args: never[]) => unknown;
    diffsGet?: (...args: never[]) => unknown;
    onEvent?: (listener: (event: EventEnvelope<Record<string, unknown>>) => void) => () => void;
    close?: () => unknown;
  };
}) {
  const runtime = deps.runtime;

  return {
    capabilitiesGet: runtime.capabilitiesGet.bind(runtime),
    hostsGet: runtime.hostsGet.bind(runtime),
    runtimesList: bindMethod(runtime.runtimesList, runtime),
    sessionsList: bindMethod(runtime.sessionsList, runtime),
    sessionsGet: bindMethod(runtime.sessionsGet, runtime),
    sessionsStart: bindMethod(runtime.sessionsStart, runtime),
    sessionsResume: bindMethod(runtime.sessionsResume, runtime),
    sessionsStop: bindMethod(runtime.sessionsStop, runtime),
    sessionsSendInput: bindMethod(runtime.sessionsSendInput, runtime),
    sessionsSubscribe: async (params: SessionsSubscribeParams): Promise<SessionsSubscribeResult> => {
      await deps.attachmentManager.attachSession(params.session_id);
      const subscription = deps.replayBroker.createSubscription({
        sessionId: params.session_id,
        includeSnapshot: params.include_snapshot === true,
        fromEventId: params.from_event_id,
        fromSeq: params.from_seq
      });

      return {
        session_id: params.session_id,
        subscription_id: subscription.subscriptionId,
        snapshot_emitted: params.include_snapshot === true
      };
    },
    sessionsUnsubscribe: async (
      params: SessionsUnsubscribeParams
    ): Promise<SessionsUnsubscribeResult> => deps.replayBroker.unsubscribe(params),
    approvalsList: bindMethod(runtime.approvalsList, runtime),
    approvalsRespond: bindMethod(runtime.approvalsRespond, runtime),
    artifactsList: bindMethod(runtime.artifactsList, runtime),
    artifactsGet: bindMethod(runtime.artifactsGet, runtime),
    diffsGet: bindMethod(runtime.diffsGet, runtime),
    drainSubscriptionEvents: (subscriptionId: string, limit?: number) =>
      deps.replayBroker.drainSubscriptionEvents(subscriptionId, limit),
    onEvent: runtime.onEvent?.bind(runtime),
    close: runtime.close?.bind(runtime)
  };
}
