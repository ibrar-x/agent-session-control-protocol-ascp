import { createEventEnvelope } from "ascp-sdk-typescript";
export function createReplayBroker(deps) {
    const subscriptions = new Map();
    let nextSubscriptionOrdinal = 1;
    return {
        createSubscription(input) {
            const queue = [];
            const snapshot = deps.sessionStore.getSnapshot(input.sessionId);
            const replayRequested = input.fromSeq !== undefined || input.fromEventId !== undefined;
            if (input.includeSnapshot && snapshot !== null) {
                queue.push(createEventEnvelope({
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
                }));
            }
            const replayEvents = input.fromEventId !== undefined
                ? deps.eventStore.listAfterEventId(input.sessionId, input.fromEventId)
                : deps.eventStore.listAfterSeq(input.sessionId, input.fromSeq ?? 0);
            queue.push(...replayEvents);
            if (replayRequested && replayEvents.length > 0) {
                queue.push(createEventEnvelope({
                    id: `daemon:event:sync_replayed:${input.sessionId}:${Date.now()}`,
                    type: "sync.replayed",
                    ts: new Date().toISOString(),
                    session_id: input.sessionId,
                    payload: {
                        from_seq: input.fromSeq ?? 0,
                        to_seq: replayEvents.at(-1)?.seq ?? input.fromSeq ?? 0,
                        event_count: replayEvents.length
                    }
                }));
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
function bindMethod(method, runtime) {
    return method?.bind(runtime);
}
export function createReplayBackedRuntime(deps) {
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
        sessionsSubscribe: async (params) => {
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
        sessionsUnsubscribe: async (params) => deps.replayBroker.unsubscribe(params),
        approvalsList: bindMethod(runtime.approvalsList, runtime),
        approvalsRespond: bindMethod(runtime.approvalsRespond, runtime),
        artifactsList: bindMethod(runtime.artifactsList, runtime),
        artifactsGet: bindMethod(runtime.artifactsGet, runtime),
        diffsGet: bindMethod(runtime.diffsGet, runtime),
        drainSubscriptionEvents: (subscriptionId, limit) => deps.replayBroker.drainSubscriptionEvents(subscriptionId, limit),
        onEvent: runtime.onEvent?.bind(runtime),
        close: runtime.close?.bind(runtime)
    };
}
//# sourceMappingURL=replay-broker.js.map