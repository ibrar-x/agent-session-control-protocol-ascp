# TypeScript SDK Replay Branch Reference

This document captures the implementation context for `feature/typescript-sdk-replay`.

Use it when you need to understand how the replay surface should be used, why it preserves snapshot and replay boundaries explicitly, how opaque cursor pass-through works, and what the examples/tests branch should build next.

## Branch Identity

- Branch: `feature/typescript-sdk-replay`
- Current repository state: implemented locally on the replay branch

## What This Branch Added

The replay branch added a thin replay layer to `sdk/typescript/`.

It introduced:

- an exported `ascp-sdk-typescript/replay` entry point
- `replayFromSeq(...)` request builder for replay by inclusive `from_seq`
- `replayAfterEventId(...)` request builder for replay after an exclusive `from_event_id` anchor
- `replayWithOpaqueCursor(...)` for additive opaque cursor pass-through outside the frozen core request params
- `buildReplaySubscribeParams(...)` so consumers can inspect the exact subscribe payload before it is sent
- `subscribeWithReplay(...)` and `AscpReplaySubscription`
- replay stream items that classify `sync.snapshot`, historical replay events, `sync.replayed`, live continuation events, and `sync.cursor_advanced`
- cursor tracking through explicit `sync.cursor_advanced` events only
- focused runtime and type-level replay tests driven by the upstream replay fixtures

## What It Intentionally Did Not Add

This branch did not implement:

- transport changes or new transports
- mock-server end-to-end examples
- inferred opaque cursor values derived from `seq`
- combined synthetic DTOs that hide the original `EventEnvelope`
- protocol-core changes to `sessions.subscribe`, sync events, or replay semantics
- Dart SDK behavior

Those remain out of scope so the replay layer stays thin and protocol-faithful.

## Upstream Inputs That Shaped The Branch

The branch was built from these inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../spec/replay.md`
- `../../spec/events.md`
- `../../examples/events/`
- `../../conformance/fixtures/replay/`
- `../branches/typescript-sdk-client.md`

These inputs fixed the branch boundary:

- `spec/replay.md` defined the meaning of `from_seq`, `from_event_id`, `sync.replayed`, and `sync.cursor_advanced`
- `spec/events.md` locked the distinction between `sync.snapshot` as current-state material and replayed historical events as original envelopes
- the replay fixtures supplied exact ordering and cursor expectations for the helper tests
- the client branch established that replay should build on `AscpClient.subscribe`, `AscpClient.unsubscribe`, and `AscpClient.events` instead of changing wrapper shapes

## How To Use The Replay Surface

From `sdk/typescript/`:

```bash
npm install
npm run build
npm test -- replay.test.ts
npm run test:types
```

The public replay entry point is:

- `ascp-sdk-typescript/replay`

Representative usage:

```ts
import {
  replayFromSeq,
  subscribeWithReplay
} from "ascp-sdk-typescript/replay";
import { AscpClient } from "ascp-sdk-typescript/client";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const client = new AscpClient({
  transport: new AscpStdioTransport({
    command: ["python3", "../mock-server/src/mock_server/cli.py"]
  })
});

await client.connect();

const request = replayFromSeq({
  session_id: "sess_abc123",
  from_seq: 205,
  include_snapshot: true
});

const subscription = await subscribeWithReplay(client, request);

try {
  for await (const item of subscription) {
    switch (item.kind) {
      case "snapshot":
        console.log("snapshot", item.event.payload.session.status);
        break;
      case "replay_event":
        console.log("historical", item.event.type);
        break;
      case "replay_complete":
        console.log("replayed", item.event.payload.event_count);
        break;
      case "live_event":
        console.log("live", item.event.type);
        break;
      case "cursor_advanced":
        console.log("cursor", item.cursor, item.stream_phase);
        break;
    }
  }
} finally {
  await subscription.close();
  await client.close();
}
```

For opaque cursor pass-through, keep the core subscribe params unchanged and provide the extension separately:

```ts
import {
  replayWithOpaqueCursor,
  subscribeWithReplay
} from "ascp-sdk-typescript/replay";

const request = replayWithOpaqueCursor({
  params: {
    session_id: "sess_abc123",
    include_snapshot: false
  },
  params_extension: {
    cursor: "opaque:sess_abc123:410"
  }
});

const subscription = await subscribeWithReplay(client, request);
```

## Replay Shape And Cursor Design

The replay layer keeps the original subscribe params and event envelopes visible.

The request builders return exact protocol-shaped params:

- `replayFromSeq(...)` keeps `from_seq`
- `replayAfterEventId(...)` keeps `from_event_id`
- `replayWithOpaqueCursor(...)` keeps core params separate from the additive extension

The stream helper classifies the transport stream into explicit item kinds instead of collapsing everything into a merged "recovery result". That design keeps three protocol distinctions visible:

- `sync.snapshot` is current-state material
- replayed historical events are original event envelopes
- `sync.replayed` is the boundary marker between replay and live continuation

Cursor tracking is intentionally narrow. The helper updates `subscription.cursor` only when a valid `sync.cursor_advanced` event appears. It does not synthesize cursor tokens from `seq`, because the upstream replay rules treat opaque cursors as implementation-defined tokens, not derived sequence aliases.

## Alternatives Rejected

### Collapse snapshot, replay, and live events into one synthetic recovery object

Rejected because it hides the protocol distinction that upstream ASCP makes explicit. Consumers often need to treat snapshots, historical replay, and live continuation differently.

### Add an opaque `cursor` field back onto the core `SessionsSubscribeParams` type

Rejected because the detailed spec and replay spec define opaque cursor handling as additive to the frozen core params. The replay helper accepts extensions separately so downstream code can see when it is leaving the core contract.

### Infer opaque resume tokens from sequence numbers

Rejected because `seq` and opaque cursors are different protocol concepts. Hosts emit `sync.cursor_advanced` when a usable opaque token exists.

### Reimplement transport subscriptions in the replay layer

Rejected because the transport and client layers already own connection, request, and base event-stream behavior. The replay branch adds classification and cleanup on top of those existing contracts.

## Verification Evidence

The branch was verified with:

- `npm test -- replay.test.ts`
- `npm run test:types`
- `npm run build`
- `npm test`
- `npm run check`
- `git diff --check`

The focused replay tests prove:

- `from_seq` requests preserve historical replay ordering and replay-boundary semantics
- `from_event_id` requests behave as exclusive anchors
- snapshots remain distinct from replayed history and live continuation
- opaque cursor extensions pass through without overwriting frozen core params
- unsubscribe cleanup happens when the replay subscription closes

## Limits And Handoff

Known limits:

- the helper filters by `session_id`, so multiple concurrent subscriptions for the same session on one transport are not distinguished by subscription id
- the replay branch does not add end-to-end mock-server examples yet
- the helper validates sync control events when it needs them, but it still leaves non-control event payloads as original envelopes rather than exact-core-event DTOs

The examples/tests branch should build on:

- `AscpClient`
- `subscribeWithReplay(...)`
- the fixture-aligned replay item kinds
- `subscription.cursor`, `subscription.last_snapshot`, and `subscription.last_replayed`
- the existing stdio mock-server integration path
