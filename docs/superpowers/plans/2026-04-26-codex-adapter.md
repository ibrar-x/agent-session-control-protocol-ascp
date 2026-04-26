# Codex Adapter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a truthful TypeScript Codex runtime adapter for ASCP that uses the official `codex app-server` surface, reuses the existing TypeScript SDK for small generic ASCP helpers, and keeps all Codex-specific transport and mapping logic inside `adapters/codex/`.

**Architecture:** Build `adapters/codex/` as a Node 22 workspace package with a stdio JSON-RPC client for `codex app-server`, deterministic ASCP ID and entity mappers, a service layer that emits ASCP-shaped method results, and tests that prove conservative capability fallback. Add only small generic SDK helpers where they are reusable across adapters and remain free of Codex-specific assumptions.

**Tech Stack:** TypeScript, Node.js 22, npm workspaces, Vitest, Bash, JSON-RPC, Markdown

---

### Task 1: Scope The Branch In Repository State

**Files:**
- Modify: `plans.md`
- Modify: `docs/superpowers/plans/2026-04-26-codex-adapter.md`

- [x] **Step 1: Rewrite the active branch plan in `plans.md`**

Use the `feature/codex-adapter` scope that keeps the official app-server surface, truthful capability resolution, and TypeScript SDK reuse explicit.

```md
- Feature name: Codex adapter
- Branch: `feature/codex-adapter`
- Goal: implement a truthful downstream TypeScript adapter under `adapters/codex/`
- Source inputs:
  - `docs/superpowers/specs/2026-04-26-codex-adapter-design.md`
  - `sdks/typescript/`
  - observed `codex app-server` schemas and live runtime probes
```

- [x] **Step 2: Replace the earlier draft with the TypeScript plan in this file**

The final header must match this structure exactly:

```md
# Codex Adapter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a truthful TypeScript Codex runtime adapter for ASCP that uses the official `codex app-server` surface, reuses the existing TypeScript SDK for small generic ASCP helpers, and keeps all Codex-specific transport and mapping logic inside `adapters/codex/`.
**Architecture:** Build `adapters/codex/` as a Node 22 workspace package with a stdio JSON-RPC client for `codex app-server`, deterministic ASCP ID and entity mappers, a service layer that emits ASCP-shaped method results, and tests that prove conservative capability fallback. Add only small generic SDK helpers where they are reusable across adapters and remain free of Codex-specific assumptions.
**Tech Stack:** TypeScript, Node.js 22, npm workspaces, Vitest, Bash, JSON-RPC, Markdown
```

- [x] **Step 3: Verify the plan files describe the TypeScript boundary**

Run: `sed -n '1,220p' plans.md && printf '\n---\n' && sed -n '1,80p' docs/superpowers/plans/2026-04-26-codex-adapter.md`

Expected: both files describe a TypeScript adapter over `codex app-server`, and the earlier non-TypeScript package paths are gone

### Task 2: Scaffold The Adapter Workspace And Red-State Validator

**Files:**
- Modify: `adapters/codex/package.json`
- Modify: `adapters/codex/README.md`
- Create: `adapters/codex/tsconfig.json`
- Create: `adapters/codex/vitest.config.ts`
- Create: `adapters/codex/src/index.ts`
- Create: `adapters/codex/tests/validate-codex-adapter.mjs`
- Create: `tooling/scripts/validate_codex_adapter.sh`

- [x] **Step 1: Write the failing validator first**

Add a validator that asserts the adapter package exposes the planned source files and scripts before any implementation exists.

```js
import { existsSync, readFileSync } from "node:fs";

const requiredFiles = [
  "adapters/codex/src/app-server-client.ts",
  "adapters/codex/src/discovery.ts",
  "adapters/codex/src/capabilities.ts",
  "adapters/codex/src/session-mapper.ts",
  "adapters/codex/src/service.ts",
  "adapters/codex/tests/discovery.test.ts",
  "adapters/codex/tests/service.test.ts"
];

for (const file of requiredFiles) {
  if (!existsSync(file)) {
    throw new Error(`Missing required adapter file: ${file}`);
  }
}

const pkg = JSON.parse(readFileSync("adapters/codex/package.json", "utf8"));
if (!pkg.scripts?.test || !pkg.scripts?.build) {
  throw new Error("Adapter package must expose build and test scripts.");
}
```

- [x] **Step 2: Add the TypeScript workspace package metadata and configs**

Replace the current minimal package with a real workspace package that depends on the TypeScript SDK and Vitest tooling.

```json
{
  "name": "@ascp/adapter-codex",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "engines": {
    "node": ">=22.0.0"
  },
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "test": "vitest run",
    "check": "npm run build && npm run test"
  },
  "dependencies": {
    "ascp-sdk-typescript": "file:../../sdks/typescript"
  },
  "devDependencies": {
    "@types/node": "^24.9.1",
    "typescript": "^5.9.3",
    "vitest": "^3.2.4"
  }
}
```

```ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["tests/**/*.test.ts"]
  }
});
```

- [x] **Step 3: Add the shell entrypoint and confirm red state**

Write the validator shell script in the existing repo pattern:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

node adapters/codex/tests/validate-codex-adapter.mjs
```

Run: `bash tooling/scripts/validate_codex_adapter.sh`

Expected: FAIL with missing `app-server-client.ts`, `service.ts`, and test paths because the real adapter has not been created yet

### Task 3: Add Small Generic SDK Helpers That The Adapter Can Reuse

**Files:**
- Create: `sdks/typescript/src/methods/envelopes.ts`
- Create: `sdks/typescript/src/events/builders.ts`
- Modify: `sdks/typescript/src/methods/index.ts`
- Modify: `sdks/typescript/src/events/index.ts`
- Modify: `sdks/typescript/src/index.ts`
- Create: `sdks/typescript/test/envelopes.test.ts`

- [x] **Step 1: Write failing SDK tests for generic envelope and event builders**

Add tests that prove the helpers remain ASCP-generic and do not mention Codex.

```ts
import { describe, expect, it } from "vitest";
import { createSuccessResponse, createEventEnvelope } from "../src/index.js";

describe("generic ASCP builders", () => {
  it("creates a success response envelope", () => {
    expect(
      createSuccessResponse("req-1", { session_id: "sess_1", accepted: true })
    ).toEqual({
      jsonrpc: "2.0",
      id: "req-1",
      result: { session_id: "sess_1", accepted: true }
    });
  });

  it("creates an event envelope with ASCP field names", () => {
    expect(
      createEventEnvelope({
        id: "evt_1",
        type: "run.started",
        ts: "2026-04-26T10:00:00Z",
        session_id: "sess_1",
        payload: { run_id: "run_1" }
      })
    ).toMatchObject({
      id: "evt_1",
      type: "run.started",
      session_id: "sess_1"
    });
  });
});
```

- [x] **Step 2: Implement the minimal generic helpers**

Keep the helpers small and transport-neutral:

```ts
import type { FlexibleObject, RequestId, ResponseEnvelope, EventEnvelope } from "../models/types.js";

export function createSuccessResponse<TResult extends FlexibleObject>(
  id: RequestId,
  result: TResult
): ResponseEnvelope<TResult> {
  return {
    jsonrpc: "2.0",
    id,
    result
  };
}

export function createEventEnvelope<TPayload extends FlexibleObject>(
  event: EventEnvelope<TPayload>
): EventEnvelope<TPayload> {
  return event;
}
```

- [x] **Step 3: Export the helpers and run the SDK tests**

Run: `npm --workspace sdks/typescript run test -- test/envelopes.test.ts`

Expected: PASS with generic helpers exported from `src/index.ts` and no Codex-specific strings inside the SDK helper files

### Task 4: Implement The Codex App-Server Client, Discovery, And Capability Resolution

**Files:**
- Create: `adapters/codex/src/app-server-client.ts`
- Create: `adapters/codex/src/discovery.ts`
- Create: `adapters/codex/src/capabilities.ts`
- Create: `adapters/codex/tests/discovery.test.ts`
- Create: `adapters/codex/tests/capabilities.test.ts`

- [x] **Step 1: Write failing tests for app-server discovery and conservative capabilities**

Cover runtime availability, version detection, and capability fallback for replay and artifacts.

```ts
import { describe, expect, it } from "vitest";
import { resolveCodexCapabilities } from "../src/capabilities.js";

describe("resolveCodexCapabilities", () => {
  it("marks replay unsupported when no official replay surface is observed", () => {
    expect(
      resolveCodexCapabilities({
        threadList: true,
        threadResume: true,
        turnStart: true,
        turnDiffUpdated: true,
        approvalRequests: true,
        approvalRespond: false
      }).replay
    ).toBe(false);
  });
});
```

- [x] **Step 2: Implement the stdio JSON-RPC client over `codex app-server`**

Keep it adapter-specific and small:

```ts
export interface CodexJsonRpcMessage {
  jsonrpc?: "2.0";
  id?: string | number;
  method?: string;
  params?: unknown;
  result?: unknown;
  error?: unknown;
}

export class CodexAppServerClient {
  async initialize(): Promise<{ userAgent: string; codexHome: string }> {
    return this.request("initialize", {
      clientInfo: { name: "ascp-codex-adapter", version: "0.1.0" },
      capabilities: {}
    });
  }

  async threadList(limit = 20): Promise<unknown> {
    return this.request("thread/list", { limit, useStateDbOnly: true });
  }
}
```

- [x] **Step 3: Implement discovery and truthful capability resolution**

Discovery should return facts, not ASCP objects:

```ts
export interface CodexDiscovery {
  runtimeAvailable: boolean;
  runtimeId: "codex_local";
  version: string | null;
  appServerMethods: string[];
  notifications: string[];
  supportsApprovalRequests: boolean;
  supportsApprovalRespond: boolean;
  supportsTurnDiffs: boolean;
}
```

Capability resolution should be conservative:

```ts
return {
  session_list: discovery.appServerMethods.includes("thread/list"),
  session_resume: discovery.appServerMethods.includes("thread/resume"),
  session_start: discovery.appServerMethods.includes("thread/start"),
  message_send: discovery.appServerMethods.includes("turn/start"),
  stream_events: discovery.notifications.length > 0,
  approval_requests: discovery.supportsApprovalRequests,
  approval_respond: discovery.supportsApprovalRespond,
  diffs: discovery.supportsTurnDiffs,
  artifacts: false,
  replay: false
};
```

- [x] **Step 4: Run the focused discovery tests**

Run: `npm --workspace @ascp/adapter-codex run test -- tests/discovery.test.ts tests/capabilities.test.ts`

Expected: PASS with `runtime_id = codex_local`, `replay = false`, and `artifacts = false` unless the tests explicitly observe an official surface that justifies them

### Task 5: Implement Deterministic IDs And Session/Run Mapping

**Files:**
- Create: `adapters/codex/src/ids.ts`
- Create: `adapters/codex/src/session-mapper.ts`
- Create: `adapters/codex/tests/ids.test.ts`
- Create: `adapters/codex/tests/session-mapper.test.ts`

- [x] **Step 1: Write failing tests for the adapter ID strategy**

```ts
import { describe, expect, it } from "vitest";
import { toApprovalId, toRunId, toSessionId } from "../src/ids.js";

describe("Codex adapter ids", () => {
  it("builds deterministic ids", () => {
    expect(toSessionId("thread_123")).toBe("codex:thread_123");
    expect(toRunId("thread_123", "turn_9")).toBe("codex:thread_123:turn_9");
    expect(toApprovalId("apr_7")).toBe("codex:apr_7");
  });
});
```

- [x] **Step 2: Write failing tests for thread and turn normalization**

```ts
expect(mapThreadToSession(thread)).toMatchObject({
  id: "codex:019dc70f",
  runtime_id: "codex_local",
  status: "idle",
  workspace: "/tmp/worktree",
  metadata: { source: "codex" }
});

expect(mapTurnToRun(turn, "codex:019dc70f")).toMatchObject({
  id: "codex:019dc70f:turn_1",
  session_id: "codex:019dc70f",
  status: "running"
});
```

- [x] **Step 3: Implement conservative status mapping**

Use an explicit mapping function instead of scattering status logic:

```ts
export function mapThreadStatus(status: { type: string; activeFlags?: string[] }): SessionStatus {
  if (status.type === "idle") return "idle";
  if (status.type === "systemError") return "failed";
  if (status.type === "active" && status.activeFlags?.includes("waitingOnApproval")) {
    return "waiting_approval";
  }
  if (status.type === "active") return "running";
  return "disconnected";
}
```

- [x] **Step 4: Run the mapper tests**

Run: `npm --workspace @ascp/adapter-codex run test -- tests/ids.test.ts tests/session-mapper.test.ts`

Expected: PASS with exact ASCP field names and deterministic adapter-owned IDs

### Task 6: Implement The Supported Session Method Surface

**Files:**
- Create: `adapters/codex/src/service.ts`
- Create: `adapters/codex/tests/service.test.ts`

- [ ] **Step 1: Write failing tests for `sessions.list`, `sessions.get`, `sessions.resume`, and `sessions.send_input`**

```ts
expect(await service.sessionsList({ runtime_id: "codex_local" })).toMatchObject({
  sessions: [{ runtime_id: "codex_local" }]
});

await expect(service.sessionsGet({ session_id: "codex:missing" })).rejects.toMatchObject({
  code: "NOT_FOUND"
});

expect(await service.sessionsSendInput({
  session_id: "codex:thread_1",
  input: "continue"
})).toEqual({
  session_id: "codex:thread_1",
  accepted: true
});
```

- [ ] **Step 2: Implement the service methods using SDK envelope helpers**

Keep the service layer ASCP-shaped and adapter-specific:

```ts
import { createSuccessResponse } from "ascp-sdk-typescript";

export class CodexAdapterService {
  async sessionsList(params: SessionsListParams): Promise<SessionsListResult> {
    const threads = await this.client.threadList(params.limit ?? 20);
    return {
      sessions: threads.data.map(mapThreadToSession),
      next_cursor: null
    };
  }
}
```

- [ ] **Step 3: Map `sessions.send_input` onto `turn/start` and `turn/steer`**

Use the active turn when known; otherwise start a new turn:

```ts
if (activeTurnId) {
  await this.client.turnSteer(threadId, activeTurnId, input);
} else {
  await this.client.turnStart(threadId, input);
}

return {
  session_id,
  accepted: true
};
```

- [ ] **Step 4: Run the service tests**

Run: `npm --workspace @ascp/adapter-codex run test -- tests/service.test.ts`

Expected: PASS with honest `NOT_FOUND` and `UNSUPPORTED` fallback where the Codex surface does not support the ASCP action

### Task 7: Implement Event Normalization, Approval Mapping, And Diff Support

**Files:**
- Create: `adapters/codex/src/events.ts`
- Create: `adapters/codex/src/approvals.ts`
- Create: `adapters/codex/tests/events.test.ts`
- Create: `adapters/codex/tests/approvals.test.ts`

- [ ] **Step 1: Write failing tests for message, run, approval, and diff normalization**

```ts
expect(mapNotificationToEvents({
  method: "turn/started",
  params: { threadId: "thread_1", turn: { id: "turn_1", status: "in_progress" } }
})[0]).toMatchObject({ type: "run.started" });

expect(mapNotificationToEvents({
  method: "turn/diff/updated",
  params: { threadId: "thread_1", turnId: "turn_1", diff: "--- a\\n+++ b" }
})[0]).toMatchObject({ type: "diff.updated" });
```

```ts
expect(mapApprovalRequest(serverRequest)).toMatchObject({
  kind: "command",
  status: "pending",
  session_id: "codex:thread_1"
});
```

- [ ] **Step 2: Implement event mapping with extension-safe fallbacks**

```ts
if (message.method === "turn/started") {
  return [createEventEnvelope({
    id: `evt:${message.params.threadId}:${message.params.turn.id}:started`,
    type: "run.started",
    ts: new Date().toISOString(),
    session_id: toSessionId(message.params.threadId),
    run_id: toRunId(message.params.threadId, message.params.turn.id),
    payload: { run: mapTurnToRun(message.params.turn, toSessionId(message.params.threadId)) }
  })];
}
```

For unmapped Codex detail, preserve it additively:

```ts
payload: {
  run_id,
  x_codex_notification: message.params
}
```

- [ ] **Step 3: Implement approval request mapping and conservative response behavior**

Until the official response path is fully wired, approvals should degrade honestly:

```ts
export function canRespondToApprovals(discovery: CodexDiscovery): boolean {
  return discovery.supportsApprovalRespond;
}

if (!canRespondToApprovals(this.discovery)) {
  throw createAdapterError("UNSUPPORTED", "Codex approval response path is not available.");
}
```

- [ ] **Step 4: Run the event and approval tests**

Run: `npm --workspace @ascp/adapter-codex run test -- tests/events.test.ts tests/approvals.test.ts`

Expected: PASS with `message.assistant.delta`, `run.started`, `approval.requested`, and `diff.updated` normalized from official Codex notifications or requests

### Task 8: Document, Validate, And Checkpoint The Adapter Slice

**Files:**
- Modify: `adapters/codex/README.md`
- Modify: `adapters/codex/tests/validate-codex-adapter.mjs`
- Modify: `tooling/scripts/validate_codex_adapter.sh`
- Modify: `docs/status.md`
- Modify: `plans.md`

- [ ] **Step 1: Document the supported and unsupported Codex surface**

The README should state the support matrix directly:

```md
## Supported ASCP surface

- `sessions.list`
- `sessions.get`
- `sessions.resume`
- `sessions.send_input`
- stream event normalization over official `codex app-server` notifications
- pending approval mapping where official approval requests are emitted
- best-effort `diffs.get` from official turn diff updates

## Unsupported or conservative fallbacks

- `replay=false`
- `artifacts=false`
- `approval_respond=false` until the official Codex response path is exercised end-to-end
```

- [ ] **Step 2: Make the validator green**

Extend the validator to check for the README claims and the final test files:

```js
const readme = readFileSync("adapters/codex/README.md", "utf8");
if (!readme.includes("replay=false")) {
  throw new Error("README must document replay fallback.");
}
```

Run: `bash tooling/scripts/validate_codex_adapter.sh`

Expected: PASS with all required adapter files present and the README documenting truthful unsupported surfaces

- [ ] **Step 3: Run the final adapter and SDK checks**

Run: `npm --workspace sdks/typescript run test -- test/envelopes.test.ts && npm --workspace @ascp/adapter-codex run check && bash tooling/scripts/validate_codex_adapter.sh`

Expected: PASS with SDK helper tests green, adapter workspace tests green, and the repository validator green

- [ ] **Step 4: Update repository checkpoint files**

Record the completed adapter feature in the branch tracking files:

```md
### 2026-04-26 - Codex adapter

- Branch: `feature/codex-adapter`
- Summary: implemented a truthful TypeScript adapter over `codex app-server`
- Documentation updated: `plans.md`, `docs/status.md`, `adapters/codex/README.md`
- Next likely step: validate merge readiness and integrate the adapter branch
```

Run: `sed -n '1,260p' plans.md && printf '\n---\n' && sed -n '1,120p' docs/status.md`

Expected: `plans.md` shows the adapter tasks as done and `docs/status.md` contains a new Codex adapter checkpoint entry
