import { type EventEnvelope, type SessionsSubscribeParams, type SessionsSubscribeResult, type SessionsUnsubscribeParams, type SessionsUnsubscribeResult } from "ascp-sdk-typescript";
import type { AttachmentManager } from "./attachment-manager.js";
import type { CursorStore } from "./stores/cursor-store.js";
import type { EventStore } from "./stores/event-store.js";
import type { SessionStore } from "./stores/session-store.js";
export interface ReplayBroker {
    createSubscription(input: {
        sessionId: string;
        includeSnapshot: boolean;
        fromEventId?: string;
        fromSeq?: number;
    }): {
        events: EventEnvelope<Record<string, unknown>>[];
        subscriptionId: string;
    };
    drainSubscriptionEvents(subscriptionId: string, limit?: number): EventEnvelope<Record<string, unknown>>[];
    unsubscribe(params: SessionsUnsubscribeParams): SessionsUnsubscribeResult;
}
export declare function createReplayBroker(deps: {
    cursorStore?: CursorStore;
    eventStore: EventStore;
    sessionStore: SessionStore;
}): ReplayBroker;
export declare function createReplayBackedRuntime(deps: {
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
}): {
    capabilitiesGet: (...args: never[]) => unknown;
    hostsGet: (...args: never[]) => unknown;
    runtimesList: ((...args: never[]) => unknown) | undefined;
    sessionsList: ((...args: never[]) => unknown) | undefined;
    sessionsGet: ((...args: never[]) => unknown) | undefined;
    sessionsStart: ((...args: never[]) => unknown) | undefined;
    sessionsResume: ((...args: never[]) => unknown) | undefined;
    sessionsStop: ((...args: never[]) => unknown) | undefined;
    sessionsSendInput: ((...args: never[]) => unknown) | undefined;
    sessionsSubscribe: (params: SessionsSubscribeParams) => Promise<SessionsSubscribeResult>;
    sessionsUnsubscribe: (params: SessionsUnsubscribeParams) => Promise<SessionsUnsubscribeResult>;
    approvalsList: ((...args: never[]) => unknown) | undefined;
    approvalsRespond: ((...args: never[]) => unknown) | undefined;
    artifactsList: ((...args: never[]) => unknown) | undefined;
    artifactsGet: ((...args: never[]) => unknown) | undefined;
    diffsGet: ((...args: never[]) => unknown) | undefined;
    drainSubscriptionEvents: (subscriptionId: string, limit?: number) => EventEnvelope<Record<string, unknown>>[];
    onEvent: ((listener: (event: EventEnvelope<Record<string, unknown>>) => void) => () => void) | undefined;
    close: (() => unknown) | undefined;
};
//# sourceMappingURL=replay-broker.d.ts.map