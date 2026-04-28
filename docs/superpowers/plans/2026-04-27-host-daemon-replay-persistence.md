# Host Daemon Replay Persistence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add SQLite-backed seeded baseline, event persistence, cursor advancement, and replay serving to `services/host-daemon` without changing frozen ASCP semantics.

**Architecture:** `services/host-daemon` owns SQLite stores plus an `attachment_manager` and `replay_broker`; `adapters/codex` remains runtime truth for reads and live events; `packages/host-service` remains transport-only. Build order is strict: persistent stores and `attachment_manager` first, then replay serving, then detached/partial-state polish and docs.

**Tech Stack:** TypeScript, Node.js 25 built-in `node:sqlite`, Vitest, existing `@ascp/adapter-codex`, existing `@ascp/host-service`

---

## File Map

### New files

- `services/host-daemon/src/sqlite.ts` — SQLite bootstrap, schema setup, database path resolution
- `services/host-daemon/src/metadata.ts` — snapshot completeness and attachment metadata helpers
- `services/host-daemon/src/stores/session-store.ts` — latest seeded/current session baseline persistence
- `services/host-daemon/src/stores/event-store.ts` — append-only normalized `EventEnvelope` persistence
- `services/host-daemon/src/stores/cursor-store.ts` — replay origin and durable cursor state
- `services/host-daemon/src/attachment-manager.ts` — seed baseline, attach live capture, normalize every inbound event, persist, advance cursor
- `services/host-daemon/src/replay-broker.ts` — serve `sync.snapshot`, replay stored events, emit `sync.replayed`, live fanout adapter
- `services/host-daemon/tests/sqlite.test.ts`
- `services/host-daemon/tests/metadata.test.ts`
- `services/host-daemon/tests/session-store.test.ts`
- `services/host-daemon/tests/event-store.test.ts`
- `services/host-daemon/tests/cursor-store.test.ts`
- `services/host-daemon/tests/attachment-manager.test.ts`
- `services/host-daemon/tests/replay-broker.test.ts`
- `services/host-daemon/tests/integration-replay.test.ts`

### Modified files

- `services/host-daemon/package.json` — keep daemon package wiring aligned with the chosen SQLite runtime
- `services/host-daemon/src/index.ts` — export new modules
- `services/host-daemon/src/main.ts` — wire SQLite bootstrap, stores, `attachment_manager`, and `replay_broker`
- `services/host-daemon/src/runtime-registry.ts` — expose enough runtime shape for seeding/attachment without pushing persistence into adapter
- `services/host-daemon/README.md` — explain replay persistence behavior and detached/partial snapshot semantics
- `internal/plans.md` — replace bootstrap slice with replay persistence slice plan
- `internal/status.md` — add checkpoint after slice completion

### Existing code to inspect while implementing

- `adapters/codex/src/service.ts` — current in-memory replay queue behavior and event sequencing
- `adapters/codex/src/host-runtime.ts` — current runtime boundary
- `packages/host-service/src/index.ts` — transport contract and subscription flow
- `services/host-daemon/src/main.ts` — current daemon bootstrap

## Task 1: Add SQLite bootstrap and store contracts

**Files:**
- Create: `services/host-daemon/src/sqlite.ts`
- Create: `services/host-daemon/src/stores/session-store.ts`
- Create: `services/host-daemon/src/stores/event-store.ts`
- Create: `services/host-daemon/src/stores/cursor-store.ts`
- Modify: `services/host-daemon/package.json`
- Test: `services/host-daemon/tests/sqlite.test.ts`
- Test: `services/host-daemon/tests/session-store.test.ts`
- Test: `services/host-daemon/tests/event-store.test.ts`
- Test: `services/host-daemon/tests/cursor-store.test.ts`

- [ ] **Step 1: Add failing SQLite bootstrap test**

```ts
import { describe, expect, it } from "vitest";
import { mkdtempSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";

import { openDaemonDatabase } from "../src/sqlite.js";

describe("openDaemonDatabase", () => {
  it("creates the daemon replay tables on first open", () => {
    const directory = mkdtempSync(join(tmpdir(), "ascp-daemon-db-"));
    const database = openDaemonDatabase(join(directory, "daemon.sqlite"));

    const tables = database
      .prepare("SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name")
      .all() as Array<{ name: string }>;

    expect(tables.map((row) => row.name)).toEqual(
      expect.arrayContaining([
        "daemon_sessions",
        "daemon_session_events",
        "daemon_session_cursors"
      ])
    );
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/sqlite.test.ts`

Expected: FAIL with `Cannot find module '../src/sqlite.js'`

- [ ] **Step 3: Add failing session store test**

```ts
import { describe, expect, it } from "vitest";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { createSessionStore } from "../src/stores/session-store.js";
import { openDaemonDatabase } from "../src/sqlite.js";

describe("session store", () => {
  it("persists a seeded baseline with completeness and attachment metadata", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createSessionStore(database);

    store.upsertSeededSnapshot({
      sessionId: "codex:thread-1",
      runtimeId: "codex_local",
      session: {
        id: "codex:thread-1",
        runtime_id: "codex_local",
        status: "running",
        created_at: "2026-04-27T00:00:00.000Z",
        updated_at: "2026-04-27T00:00:00.000Z"
      },
      activeRun: null,
      pendingApprovals: [],
      pendingInputs: [],
      snapshotOrigin: "seeded_snapshot",
      completeness: "partial",
      missingFields: ["active_run"],
      missingReasons: { active_run: "runtime_omitted" },
      attachmentStatus: "attached"
    });

    expect(store.getSnapshot("codex:thread-1")?.completeness).toBe("partial");
    expect(store.getSnapshot("codex:thread-1")?.attachmentStatus).toBe("attached");
  });
});
```

- [ ] **Step 4: Run test to verify it fails**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/session-store.test.ts`

Expected: FAIL because `createSessionStore` is undefined or missing

- [ ] **Step 5: Add failing event and cursor store tests**

```ts
import { describe, expect, it } from "vitest";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { openDaemonDatabase } from "../src/sqlite.js";
import { createEventStore } from "../src/stores/event-store.js";
import { createCursorStore } from "../src/stores/cursor-store.js";

describe("event and cursor stores", () => {
  it("appends normalized events and advances durable cursor state", () => {
    const database = openDaemonDatabase(":memory:");
    const eventStore = createEventStore(database);
    const cursorStore = createCursorStore(database);

    eventStore.append(
      createEventEnvelope({
        id: "event-1",
        type: "message.user",
        ts: "2026-04-27T00:00:00.000Z",
        session_id: "codex:thread-1",
        payload: { text: "hello" }
      })
    );

    cursorStore.recordLivePosition({
      sessionId: "codex:thread-1",
      lastSeq: 1,
      lastEventId: "event-1"
    });

    expect(eventStore.listAfterSeq("codex:thread-1", 0)).toHaveLength(1);
    expect(cursorStore.getCursor("codex:thread-1")?.lastSeq).toBe(1);
  });
});
```

- [ ] **Step 6: Run tests to verify they fail**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/event-store.test.ts tests/cursor-store.test.ts`

Expected: FAIL because store modules do not exist yet

- [ ] **Step 7: Add minimal dependency and SQLite implementation**

```ts
import { DatabaseSync } from "node:sqlite";

export function openDaemonDatabase(path: string): DatabaseSync {
  const database = new DatabaseSync(path);
  database.exec(`
    CREATE TABLE IF NOT EXISTS daemon_sessions (
      session_id TEXT PRIMARY KEY,
      runtime_id TEXT NOT NULL,
      session_json TEXT NOT NULL,
      active_run_json TEXT,
      pending_approvals_json TEXT NOT NULL,
      pending_inputs_json TEXT NOT NULL,
      snapshot_origin TEXT NOT NULL,
      completeness TEXT NOT NULL,
      missing_fields_json TEXT NOT NULL,
      missing_reasons_json TEXT NOT NULL,
      attachment_status TEXT NOT NULL,
      seeded_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );
    CREATE TABLE IF NOT EXISTS daemon_session_events (
      session_id TEXT NOT NULL,
      seq INTEGER NOT NULL,
      event_id TEXT NOT NULL UNIQUE,
      event_type TEXT NOT NULL,
      event_ts TEXT NOT NULL,
      event_json TEXT NOT NULL,
      persisted_at TEXT NOT NULL,
      PRIMARY KEY (session_id, seq)
    );
    CREATE TABLE IF NOT EXISTS daemon_session_cursors (
      session_id TEXT PRIMARY KEY,
      origin TEXT NOT NULL,
      last_seq INTEGER,
      last_event_id TEXT,
      cursor_json TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );
  `);
  return database;
}
```

Implement `eventStore.append(...)` so it assigns the next durable per-session `seq` during persistence rather than requiring tests or callers to provide `seq` in the fixture input.

- [ ] **Step 8: Run store tests to verify they pass**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/sqlite.test.ts tests/session-store.test.ts tests/event-store.test.ts tests/cursor-store.test.ts`

Expected: PASS

- [ ] **Step 9: Commit**

```bash
git add services/host-daemon/package.json services/host-daemon/src/sqlite.ts services/host-daemon/src/stores/session-store.ts services/host-daemon/src/stores/event-store.ts services/host-daemon/src/stores/cursor-store.ts services/host-daemon/tests/sqlite.test.ts services/host-daemon/tests/session-store.test.ts services/host-daemon/tests/event-store.test.ts services/host-daemon/tests/cursor-store.test.ts
git commit -m "feat(host-daemon): add sqlite replay stores"
```

## Task 2: Add snapshot metadata and attachment manager

**Files:**
- Create: `services/host-daemon/src/metadata.ts`
- Create: `services/host-daemon/src/attachment-manager.ts`
- Modify: `services/host-daemon/src/runtime-registry.ts`
- Modify: `services/host-daemon/src/index.ts`
- Test: `services/host-daemon/tests/metadata.test.ts`
- Test: `services/host-daemon/tests/attachment-manager.test.ts`

- [ ] **Step 1: Add failing metadata test**

```ts
import { describe, expect, it } from "vitest";
import { buildSnapshotMetadata } from "../src/metadata.js";

describe("buildSnapshotMetadata", () => {
  it("marks seeded baselines as partial when required fields are missing", () => {
    expect(
      buildSnapshotMetadata({
        snapshotOrigin: "seeded_snapshot",
        attachmentStatus: "attached",
        activeRun: undefined,
        pendingApprovals: [],
        pendingInputs: []
      })
    ).toEqual({
      snapshotOrigin: "seeded_snapshot",
      completeness: "partial",
      missingFields: ["active_run"],
      missingReasons: { active_run: "runtime_omitted" },
      attachmentStatus: "attached"
    });
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/metadata.test.ts`

Expected: FAIL with missing module error

- [ ] **Step 3: Add failing attachment manager test**

```ts
import { describe, expect, it, vi } from "vitest";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { createAttachmentManager } from "../src/attachment-manager.js";
import { openDaemonDatabase } from "../src/sqlite.js";
import { createSessionStore } from "../src/stores/session-store.js";
import { createEventStore } from "../src/stores/event-store.js";
import { createCursorStore } from "../src/stores/cursor-store.js";

describe("attachment manager", () => {
  it("seeds a baseline, persists normalized live events, and advances cursor state with zero subscribers", async () => {
    const database = openDaemonDatabase(":memory:");
    const sessionStore = createSessionStore(database);
    const eventStore = createEventStore(database);
    const cursorStore = createCursorStore(database);
    const listeners: Array<(event: ReturnType<typeof createEventEnvelope>) => void> = [];

    const runtime = {
      sessionsGet: vi.fn(async () => ({
        session: {
          id: "codex:thread-1",
          runtime_id: "codex_local",
          status: "running",
          created_at: "2026-04-27T00:00:00.000Z",
          updated_at: "2026-04-27T00:00:00.000Z"
        },
        pending_approvals: [],
        pending_inputs: []
      })),
      onEvent: vi.fn((listener) => {
        listeners.push(listener);
        return () => {};
      })
    };

    const manager = createAttachmentManager({
      runtime,
      sessionStore,
      eventStore,
      cursorStore
    });

    await manager.attachSession("codex:thread-1");

    listeners[0]?.(
      createEventEnvelope({
        id: "event-1",
        type: "message.user",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-1",
        payload: { text: "hi" }
      })
    );

    expect(sessionStore.getSnapshot("codex:thread-1")?.attachmentStatus).toBe("attached");
    expect(eventStore.listAfterSeq("codex:thread-1", 0)[0]?.seq).toBe(1);
    expect(cursorStore.getCursor("codex:thread-1")?.lastSeq).toBe(1);
  });
});
```

- [ ] **Step 4: Run test to verify it fails**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/attachment-manager.test.ts`

Expected: FAIL because `createAttachmentManager` does not exist

- [ ] **Step 5: Implement metadata and attachment manager minimally**

```ts
export function buildSnapshotMetadata(input: {
  snapshotOrigin: "seeded_snapshot" | "live_stream";
  attachmentStatus: "attached" | "detached";
  activeRun?: unknown;
  pendingApprovals: unknown[];
  pendingInputs: unknown[];
}) {
  const missingFields: string[] = [];
  const missingReasons: Record<string, string> = {};

  if (input.activeRun === undefined) {
    missingFields.push("active_run");
    missingReasons.active_run = "runtime_omitted";
  }

  return {
    snapshotOrigin: input.snapshotOrigin,
    completeness: missingFields.length === 0 ? "complete" : "partial",
    missingFields,
    missingReasons,
    attachmentStatus: input.attachmentStatus
  } as const;
}
```

```ts
export function createAttachmentManager(deps: {
  runtime: {
    sessionsGet(params: { session_id: string; include_pending_approvals?: boolean; include_pending_inputs?: boolean }): Promise<any>;
    onEvent?(listener: (event: EventEnvelope<Record<string, unknown>>) => void): () => void;
  };
  sessionStore: ReturnType<typeof createSessionStore>;
  eventStore: ReturnType<typeof createEventStore>;
  cursorStore: ReturnType<typeof createCursorStore>;
}) {
  return {
    async attachSession(sessionId: string) {
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
        if (event.session_id !== sessionId) return;
        const normalized = deps.eventStore.normalize(event);
        const persisted = deps.eventStore.append(normalized);
        deps.cursorStore.recordLivePosition({
          sessionId,
          lastSeq: persisted.seq!,
          lastEventId: persisted.id
        });
      });
    }
  };
}
```

- [ ] **Step 6: Run tests to verify they pass**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/metadata.test.ts tests/attachment-manager.test.ts`

Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add services/host-daemon/src/metadata.ts services/host-daemon/src/attachment-manager.ts services/host-daemon/src/runtime-registry.ts services/host-daemon/src/index.ts services/host-daemon/tests/metadata.test.ts services/host-daemon/tests/attachment-manager.test.ts
git commit -m "feat(host-daemon): add attachment manager"
```

## Task 3: Add replay broker and host-daemon integration

**Files:**
- Create: `services/host-daemon/src/replay-broker.ts`
- Modify: `services/host-daemon/src/main.ts`
- Modify: `services/host-daemon/src/index.ts`
- Test: `services/host-daemon/tests/replay-broker.test.ts`
- Test: `services/host-daemon/tests/integration-replay.test.ts`

- [ ] **Step 1: Add failing replay broker test**

```ts
import { describe, expect, it } from "vitest";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { openDaemonDatabase } from "../src/sqlite.js";
import { createSessionStore } from "../src/stores/session-store.js";
import { createEventStore } from "../src/stores/event-store.js";
import { createReplayBroker } from "../src/replay-broker.js";

describe("replay broker", () => {
  it("serves a snapshot with completeness metadata, replayed stored events, and sync.replayed", () => {
    const database = openDaemonDatabase(":memory:");
    const sessionStore = createSessionStore(database);
    const eventStore = createEventStore(database);

    sessionStore.upsertSeededSnapshot({
      sessionId: "codex:thread-1",
      runtimeId: "codex_local",
      session: {
        id: "codex:thread-1",
        runtime_id: "codex_local",
        status: "running",
        created_at: "2026-04-27T00:00:00.000Z",
        updated_at: "2026-04-27T00:00:00.000Z"
      },
      activeRun: null,
      pendingApprovals: [],
      pendingInputs: [],
      snapshotOrigin: "seeded_snapshot",
      completeness: "partial",
      missingFields: ["active_run"],
      missingReasons: { active_run: "runtime_omitted" },
      attachmentStatus: "attached"
    });

    eventStore.append(
      createEventEnvelope({
        id: "event-1",
        type: "message.user",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-1",
        payload: { text: "hi" }
      })
    );

    const broker = createReplayBroker({ sessionStore, eventStore });
    const events = broker.subscribe({
      sessionId: "codex:thread-1",
      includeSnapshot: true,
      fromSeq: 0
    });

    expect(events[0]?.type).toBe("sync.snapshot");
    expect(events[0]?.payload.metadata?.completeness).toBe("partial");
    expect(events[1]?.type).toBe("message.user");
    expect(events[2]?.type).toBe("sync.replayed");
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/replay-broker.test.ts`

Expected: FAIL because `createReplayBroker` is missing

- [ ] **Step 3: Add failing integration test for daemon wiring**

```ts
import { describe, expect, it, vi } from "vitest";

import { startHostDaemon } from "../src/main.js";

describe("host-daemon integration", () => {
  it("wires replay persistence dependencies into daemon startup", async () => {
    const listen = vi.fn(async () => {});
    const close = vi.fn(async () => {});

    const daemon = await startHostDaemon({
      config: { host: "127.0.0.1", port: 8765, runtime: "codex" },
      runtimeRegistry: { createRuntime: vi.fn(() => ({ capabilitiesGet: vi.fn(), hostsGet: vi.fn() })) },
      createHostService: vi.fn(() => ({ url: "ws://127.0.0.1:8765", listen, close }))
    });

    expect(daemon.url).toBe("ws://127.0.0.1:8765");
    await daemon.close();
  });
});
```

- [ ] **Step 4: Run integration test to verify it still passes or fails for the right missing wiring**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/integration-replay.test.ts`

Expected: either PASS as a smoke test or FAIL only after you tighten assertions for missing replay bootstrap dependencies

- [ ] **Step 5: Implement minimal replay broker**

```ts
export function createReplayBroker(deps: {
  sessionStore: ReturnType<typeof createSessionStore>;
  eventStore: ReturnType<typeof createEventStore>;
}) {
  return {
    subscribe(input: { sessionId: string; includeSnapshot: boolean; fromSeq?: number; fromEventId?: string }) {
      const events: EventEnvelope<Record<string, unknown>>[] = [];
      const snapshot = deps.sessionStore.getSnapshot(input.sessionId);
      const replayRequested = input.fromSeq !== undefined || input.fromEventId !== undefined;

      if (input.includeSnapshot && snapshot !== null) {
        events.push(
          createEventEnvelope({
            id: `daemon:snapshot:${input.sessionId}:${Date.now()}`,
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

      const replayEvents = input.fromEventId
        ? deps.eventStore.listAfterEventId(input.sessionId, input.fromEventId)
        : deps.eventStore.listAfterSeq(input.sessionId, input.fromSeq ?? 0);

      events.push(...replayEvents);

      if (replayRequested && replayEvents.length > 0) {
        events.push(
          createEventEnvelope({
            id: `daemon:replayed:${input.sessionId}:${Date.now()}`,
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

      return events;
    }
  };
}
```

- [ ] **Step 6: Update daemon bootstrap wiring**

```ts
const database = openDaemonDatabase(resolveDatabasePath(config));
const sessionStore = createSessionStore(database);
const eventStore = createEventStore(database);
const cursorStore = createCursorStore(database);
const attachmentManager = createAttachmentManager({ runtime, sessionStore, eventStore, cursorStore });
const replayBroker = createReplayBroker({ sessionStore, eventStore });
```

- [ ] **Step 7: Run replay tests to verify they pass**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/replay-broker.test.ts tests/integration-replay.test.ts`

Expected: PASS

- [ ] **Step 8: Commit**

```bash
git add services/host-daemon/src/replay-broker.ts services/host-daemon/src/main.ts services/host-daemon/src/index.ts services/host-daemon/tests/replay-broker.test.ts services/host-daemon/tests/integration-replay.test.ts
git commit -m "feat(host-daemon): add replay broker"
```

## Task 4: Detached sessions, docs, and full verification

**Files:**
- Modify: `services/host-daemon/src/replay-broker.ts`
- Modify: `services/host-daemon/README.md`
- Modify: `internal/plans.md`
- Modify: `internal/status.md`
- Test: `services/host-daemon/tests/replay-broker.test.ts`
- Test: `services/host-daemon/tests/integration-replay.test.ts`

- [ ] **Step 1: Add failing detached-session test**

```ts
it("surfaces detached seeded baselines and still allows replay of previously stored events", () => {
  const database = openDaemonDatabase(":memory:");
  const sessionStore = createSessionStore(database);
  const eventStore = createEventStore(database);

  sessionStore.upsertSeededSnapshot({
    sessionId: "codex:thread-2",
    runtimeId: "codex_local",
    session: {
      id: "codex:thread-2",
      runtime_id: "codex_local",
      status: "idle",
      created_at: "2026-04-27T00:00:00.000Z",
      updated_at: "2026-04-27T00:00:00.000Z"
    },
    activeRun: null,
    pendingApprovals: [],
    pendingInputs: [],
    snapshotOrigin: "seeded_snapshot",
    completeness: "complete",
    missingFields: [],
    missingReasons: {},
    attachmentStatus: "detached"
  });

  eventStore.append(
    createEventEnvelope({
      id: "event-detached-1",
      type: "message.user",
      ts: "2026-04-27T00:00:01.000Z",
      session_id: "codex:thread-2",
      payload: { text: "historic" }
    })
  );

  const broker = createReplayBroker({ sessionStore, eventStore });
  const events = broker.subscribe({ sessionId: "codex:thread-2", includeSnapshot: true, fromSeq: 0 });

  expect(events[0]?.payload.metadata.attachment_status).toBe("detached");
  expect(events[1]?.type).toBe("message.user");
  expect(events[2]?.type).toBe("sync.replayed");
});
```

- [ ] **Step 2: Run test to verify current behavior fails or needs tightening**

Run: `npm --workspace @ascp/host-daemon exec vitest run tests/replay-broker.test.ts`

Expected: either FAIL until detached replay behavior is explicit or PASS once assertions are updated to the final contract

- [ ] **Step 3: Implement detached-session behavior without suppressing valid replay**

```ts
const metadata = {
  snapshot_origin: snapshot.snapshotOrigin,
  completeness: snapshot.completeness,
  missing_fields: snapshot.missingFields,
  missing_reasons: snapshot.missingReasons,
  attachment_status: snapshot.attachmentStatus
};
```

Do **not** add an early return that suppresses replay solely because `attachment_status` is `detached`. Detached sessions may still have valid replayable stored events from an earlier attachment. The truth contract is:

- snapshot metadata always includes `attachment_status`
- detached-only seeded sessions with no stored events return only `sync.snapshot`
- detached sessions with stored events may still replay those stored events and then emit `sync.replayed`

Update README text to say detached-only seeded sessions may serve `sync.snapshot` without claiming replay history until real stored events exist, while detached sessions with previously stored events may still replay that stored history truthfully.

- [ ] **Step 4: Run focused package verification**

Run: `npm --workspace @ascp/host-daemon run check`

Expected: PASS

- [ ] **Step 5: Run adjacent adapter verification**

Run: `npm --workspace @ascp/adapter-codex exec vitest run tests/host-runtime.test.ts tests/service.test.ts`

Expected: PASS

- [ ] **Step 6: Update branch checkpoint docs**

Add a new active slice entry in `internal/status.md` summarizing:

- SQLite replay stores added
- attachment manager persists events without subscribers
- replay broker serves completeness and detached metadata
- next likely step is auth/trust hooks or relay-readiness

Update `internal/plans.md` task statuses to completed and set the next likely step accordingly.

- [ ] **Step 7: Commit**

```bash
git add services/host-daemon/src/replay-broker.ts services/host-daemon/README.md internal/plans.md internal/status.md services/host-daemon/tests/replay-broker.test.ts services/host-daemon/tests/integration-replay.test.ts
git commit -m "feat(host-daemon): persist replay state in sqlite"
```

## Full Verification

- [ ] Run `npm --workspace @ascp/host-daemon run check`
- [ ] Run `npm --workspace @ascp/adapter-codex exec vitest run tests/host-runtime.test.ts tests/service.test.ts`
- [ ] Run `git status --short` and confirm only intended files changed

## Spec Coverage Check

- SQLite persistence: Task 1
- Seeded baseline floor: Task 2
- Completeness metadata contract: Tasks 2 and 3
- Daemon-owned normalization: Task 2
- Durable cursor advancement without subscribers: Task 2
- Persistence-backed replay serving: Task 3
- Detached indexed session handling: Task 4
- Documentation and checkpoint recovery: Task 4

## Placeholder Scan

Checked for: `TODO`, `TBD`, “implement later”, and vague “handle appropriately” language. None remain in this plan.

## Type Consistency Check

- Snapshot origin values stay `seeded_snapshot | live_stream`
- Attachment status stays `attached | detached`
- Completeness stays `complete | partial`
- Replay broker metadata keys stay `snapshot_origin`, `completeness`, `missing_fields`, `missing_reasons`, `attachment_status`
- Event `seq` assignment belongs to `eventStore.append(...)`, not to fixture construction
