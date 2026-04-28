import type { EventEnvelope } from "ascp-sdk-typescript";

import { buildSnapshotMetadata } from "./metadata.js";
import type { CursorStore } from "./stores/cursor-store.js";
import type { EventStore, PersistedEventInput } from "./stores/event-store.js";
import type { SessionStore } from "./stores/session-store.js";

export interface AttachmentManagerRuntime {
  sessionsGet(params: {
    session_id: string;
    include_pending_approvals?: boolean;
    include_pending_inputs?: boolean;
  }): Promise<{
    session: Record<string, unknown> & { runtime_id: string };
    active_run?: Record<string, unknown> | null;
    pending_approvals?: Record<string, unknown>[];
    pending_inputs?: Record<string, unknown>[];
  }>;
  onEvent?(listener: (event: EventEnvelope<Record<string, unknown>>) => void): () => void;
}

export interface AttachmentManager {
  attachSession(sessionId: string): Promise<void>;
}

function normalizeEvent(
  event: EventEnvelope<Record<string, unknown>>
): PersistedEventInput<Record<string, unknown>> {
  return {
    id: event.id,
    type: event.type,
    ts: event.ts,
    session_id: event.session_id,
    payload: event.payload,
    ...(event.run_id === undefined ? {} : { run_id: event.run_id })
  };
}

export function createAttachmentManager(deps: {
  runtime: AttachmentManagerRuntime;
  sessionStore: SessionStore;
  eventStore: EventStore;
  cursorStore: CursorStore;
}): AttachmentManager {
  const attachedSessions = new Set<string>();

  return {
    async attachSession(sessionId: string): Promise<void> {
      if (attachedSessions.has(sessionId)) {
        return;
      }

      const state = await deps.runtime.sessionsGet({
        session_id: sessionId,
        include_pending_approvals: true,
        include_pending_inputs: true
      });

      const metadata = buildSnapshotMetadata({
        snapshotOrigin: "seeded_snapshot",
        attachmentStatus: "attached",
        activeRun: state.active_run,
        pendingApprovals: state.pending_approvals ?? [],
        pendingInputs: state.pending_inputs ?? []
      });

      deps.sessionStore.upsertSeededSnapshot({
        sessionId,
        runtimeId: state.session.runtime_id,
        session: state.session,
        activeRun: state.active_run ?? null,
        pendingApprovals: state.pending_approvals ?? [],
        pendingInputs: state.pending_inputs ?? [],
        ...metadata
      });

      deps.cursorStore.initializeSeededCursor(sessionId);

      deps.runtime.onEvent?.((event) => {
        if (event.session_id !== sessionId) {
          return;
        }

        const persisted = deps.eventStore.append(normalizeEvent(event));
        deps.cursorStore.recordLivePosition({
          sessionId,
          lastSeq: persisted.seq,
          lastEventId: persisted.id
        });
      });

      attachedSessions.add(sessionId);
    }
  };
}
