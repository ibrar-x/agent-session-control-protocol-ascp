import { buildSnapshotMetadata } from "./metadata.js";
function normalizeEvent(event) {
    return {
        id: event.id,
        type: event.type,
        ts: event.ts,
        session_id: event.session_id,
        payload: event.payload,
        ...(event.run_id === undefined ? {} : { run_id: event.run_id })
    };
}
export function createAttachmentManager(deps) {
    const attachedSessions = new Set();
    return {
        async attachSession(sessionId) {
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
//# sourceMappingURL=attachment-manager.js.map