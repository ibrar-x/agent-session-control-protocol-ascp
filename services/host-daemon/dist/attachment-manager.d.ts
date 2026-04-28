import type { EventEnvelope } from "ascp-sdk-typescript";
import type { CursorStore } from "./stores/cursor-store.js";
import type { EventStore } from "./stores/event-store.js";
import type { SessionStore } from "./stores/session-store.js";
export interface AttachmentManagerRuntime {
    sessionsGet(params: {
        session_id: string;
        include_pending_approvals?: boolean;
        include_pending_inputs?: boolean;
    }): Promise<{
        session: Record<string, unknown> & {
            runtime_id: string;
        };
        active_run?: Record<string, unknown> | null;
        pending_approvals?: Record<string, unknown>[];
        pending_inputs?: Record<string, unknown>[];
    }>;
    onEvent?(listener: (event: EventEnvelope<Record<string, unknown>>) => void): () => void;
}
export interface AttachmentManager {
    attachSession(sessionId: string): Promise<void>;
}
export declare function createAttachmentManager(deps: {
    runtime: AttachmentManagerRuntime;
    sessionStore: SessionStore;
    eventStore: EventStore;
    cursorStore: CursorStore;
}): AttachmentManager;
//# sourceMappingURL=attachment-manager.d.ts.map