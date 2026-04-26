# Codex Live Smoke Script Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a checked-in Codex adapter live-test script that supports both an interactive terminal flow and direct CLI subcommands against the real `codex app-server`.

**Architecture:** Keep the executable wrapper thin. Put parsing, usage, output rendering, and action dispatch helpers in a normal TypeScript module under `adapters/codex/src/`, and use a small `.mjs` launcher under `adapters/codex/scripts/` to call into the compiled module. Reuse the existing `CodexAppServerClient`, `discoverCodexRuntime`, and `CodexAdapterService` rather than inventing a second runtime path.

**Tech Stack:** TypeScript, Node.js 22, npm workspaces, Vitest, readline/promises, Markdown

---

### Task 1: Scope The Branch In Repository State

**Files:**
- Modify: `plans.md`
- Create: `docs/superpowers/plans/2026-04-26-codex-live-smoke-script.md`

- [ ] **Step 1: Rewrite `plans.md` for the live smoke script branch**

Set the branch state to:

```md
- Feature name: Codex live smoke script
- Branch: `feature/codex-live-smoke-script`
- Goal: add a checked-in live test script for the Codex adapter that supports both an interactive terminal flow and direct CLI subcommands
```

- [ ] **Step 2: Save this implementation plan in the superpowers plans directory**

Path:

```text
docs/superpowers/plans/2026-04-26-codex-live-smoke-script.md
```

- [ ] **Step 3: Verify both plan files**

Run:

```bash
sed -n '1,220p' plans.md
printf '\n---\n'
sed -n '1,260p' docs/superpowers/plans/2026-04-26-codex-live-smoke-script.md
```

Expected: both files describe the `feature/codex-live-smoke-script` scope and only this script feature.

### Task 2: Add A Testable Live Smoke Module First

**Files:**
- Create: `adapters/codex/src/live-smoke.ts`
- Create: `adapters/codex/tests/live-smoke.test.ts`

- [ ] **Step 1: Write the failing parsing and validation tests**

Create these core tests first:

```ts
import { describe, expect, it } from "vitest";
import {
  parseLiveSmokeCommand,
  validateLiveSmokeCommand
} from "../src/live-smoke.js";

describe("parseLiveSmokeCommand", () => {
  it("defaults to interactive mode with no args", () => {
    expect(parseLiveSmokeCommand([])).toEqual({
      mode: "interactive"
    });
  });

  it("parses list with a numeric limit", () => {
    expect(parseLiveSmokeCommand(["list", "--limit", "5"])).toEqual({
      mode: "command",
      command: "list",
      limit: 5
    });
  });

  it("parses get with runs enabled", () => {
    expect(parseLiveSmokeCommand(["get", "codex:thread_1", "--runs"])).toEqual({
      mode: "command",
      command: "get",
      sessionId: "codex:thread_1",
      includeRuns: true
    });
  });
});

describe("validateLiveSmokeCommand", () => {
  it("rejects get without a session id", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "get"
      })
    ).toThrow("The get command requires a session_id.");
  });

  it("rejects send-input without text", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "send-input",
        sessionId: "codex:thread_1"
      })
    ).toThrow("The send-input command requires input text.");
  });
});
```

- [ ] **Step 2: Run the new test file to confirm red state**

Run:

```bash
npm --workspace @ascp/adapter-codex run test -- tests/live-smoke.test.ts
```

Expected: FAIL because `live-smoke.ts` does not exist yet.

- [ ] **Step 3: Implement the minimal parsing and validation helpers**

Implement a small typed command model like:

```ts
export type LiveSmokeCommand =
  | { mode: "interactive" }
  | { mode: "command"; command: "discover" }
  | { mode: "command"; command: "list"; limit?: number }
  | { mode: "command"; command: "get"; sessionId?: string; includeRuns?: boolean }
  | { mode: "command"; command: "resume"; sessionId?: string }
  | { mode: "command"; command: "send-input"; sessionId?: string; inputText?: string };
```

and parser/validator functions:

```ts
export function parseLiveSmokeCommand(argv: string[]): LiveSmokeCommand {
  if (argv.length === 0) {
    return { mode: "interactive" };
  }

  // parse one command at a time without introducing a CLI framework
}

export function validateLiveSmokeCommand(command: LiveSmokeCommand): LiveSmokeCommand {
  // throw clear usage errors for missing session IDs and input text
  return command;
}
```

- [ ] **Step 4: Re-run the focused test file**

Run:

```bash
npm --workspace @ascp/adapter-codex run test -- tests/live-smoke.test.ts
```

Expected: PASS.

- [ ] **Step 5: Commit the parser and validation slice**

```bash
git add adapters/codex/src/live-smoke.ts adapters/codex/tests/live-smoke.test.ts
git commit -m "feat(codex): add live smoke command parsing"
```

### Task 3: Add Command Dispatch Over The Existing Adapter Service

**Files:**
- Modify: `adapters/codex/src/live-smoke.ts`
- Modify: `adapters/codex/tests/live-smoke.test.ts`

- [ ] **Step 1: Write failing tests for dispatch behavior**

Add a fake adapter dependency and dispatch tests:

```ts
it("dispatches discover through runtime discovery", async () => {
  const calls: string[] = [];

  const result = await runLiveSmokeCommand(
    { mode: "command", command: "discover" },
    {
      discover: async () => {
        calls.push("discover");
        return { runtimeAvailable: true, runtimeId: "codex_local" };
      }
    }
  );

  expect(calls).toEqual(["discover"]);
  expect(result.kind).toBe("discovery");
});

it("dispatches get with includeRuns", async () => {
  const calls: Array<Record<string, unknown>> = [];

  await runLiveSmokeCommand(
    {
      mode: "command",
      command: "get",
      sessionId: "codex:thread_1",
      includeRuns: true
    },
    {
      getSession: async (params) => {
        calls.push(params);
        return { session: { id: "codex:thread_1" }, runs: [] };
      }
    }
  );

  expect(calls).toEqual([
    {
      session_id: "codex:thread_1",
      include_runs: true
    }
  ]);
});
```

- [ ] **Step 2: Run the focused tests and confirm they fail for missing dispatch**

Run:

```bash
npm --workspace @ascp/adapter-codex run test -- tests/live-smoke.test.ts
```

Expected: FAIL because `runLiveSmokeCommand` and dependency wiring do not exist yet.

- [ ] **Step 3: Implement dispatch helpers and result formatting models**

Add small reusable interfaces:

```ts
export interface LiveSmokeDependencies {
  discover: () => Promise<unknown>;
  listSessions: (params: { limit?: number }) => Promise<unknown>;
  getSession: (params: { session_id: string; include_runs?: boolean }) => Promise<unknown>;
  resumeSession: (params: { session_id: string }) => Promise<unknown>;
  sendInput: (params: { session_id: string; input: string }) => Promise<unknown>;
}
```

and a dispatcher:

```ts
export async function runLiveSmokeCommand(
  command: LiveSmokeCommand,
  deps: LiveSmokeDependencies
): Promise<{ kind: string; data: unknown }> {
  // switch on command.command and call the matching dependency
}
```

- [ ] **Step 4: Re-run the focused tests**

Run:

```bash
npm --workspace @ascp/adapter-codex run test -- tests/live-smoke.test.ts
```

Expected: PASS.

- [ ] **Step 5: Commit the dispatch slice**

```bash
git add adapters/codex/src/live-smoke.ts adapters/codex/tests/live-smoke.test.ts
git commit -m "feat(codex): add live smoke dispatch helpers"
```

### Task 4: Add The Interactive Flow And Executable Script Wrapper

**Files:**
- Create: `adapters/codex/scripts/live-smoke.mjs`
- Modify: `adapters/codex/src/live-smoke.ts`
- Modify: `adapters/codex/package.json`

- [ ] **Step 1: Write a failing test for the usage text and supported commands**

Add a small expectation that the module exposes a stable usage string:

```ts
import { getLiveSmokeUsage } from "../src/live-smoke.js";

it("renders usage for all supported commands", () => {
  expect(getLiveSmokeUsage()).toContain("discover");
  expect(getLiveSmokeUsage()).toContain("send-input");
  expect(getLiveSmokeUsage()).toContain("npm --workspace @ascp/adapter-codex run live");
});
```

- [ ] **Step 2: Run the focused test file to verify red state**

Run:

```bash
npm --workspace @ascp/adapter-codex run test -- tests/live-smoke.test.ts
```

Expected: FAIL because the usage helper is missing.

- [ ] **Step 3: Implement interactive helpers in `live-smoke.ts`**

Add helpers for:

- printing a support banner
- rendering compact session summaries
- confirming mutating actions
- looping the action menu

Keep the TTY-specific code small:

```ts
export async function runInteractiveLiveSmoke(options: {
  input: NodeJS.ReadableStream;
  output: NodeJS.WritableStream;
  deps: LiveSmokeDependencies;
}): Promise<void> {
  // guided discovery -> list -> choose session -> action -> optional loop
}
```

- [ ] **Step 4: Add the executable wrapper and npm script**

Add:

```json
"live": "node ./scripts/live-smoke.mjs"
```

and a wrapper script that:

- imports the compiled module from `../dist/live-smoke.js`
- creates a real `CodexAppServerClient`
- creates a `CodexAdapterService`
- wires dependencies to:
  - `discoverCodexRuntime`
  - `sessionsList`
  - `sessionsGet`
  - `sessionsResume`
  - `sessionsSendInput`
- runs interactive mode for no args
- runs validated subcommand mode for explicit args
- exits non-zero on command-mode failure

- [ ] **Step 5: Build and run the script in read-only mode**

Run:

```bash
npm --workspace @ascp/adapter-codex run build
npm --workspace @ascp/adapter-codex run live -- discover
npm --workspace @ascp/adapter-codex run live -- list --limit 3
```

Expected:

- build passes
- discover prints runtime information
- list prints recent ASCP-shaped sessions

- [ ] **Step 6: Commit the executable slice**

```bash
git add adapters/codex/package.json adapters/codex/scripts/live-smoke.mjs adapters/codex/src/live-smoke.ts
git commit -m "feat(codex): add executable live smoke script"
```

### Task 5: Document, Verify, And Checkpoint The Script

**Files:**
- Modify: `adapters/codex/README.md`
- Modify: `plans.md`
- Modify: `docs/status.md`

- [ ] **Step 1: Document interactive and subcommand usage**

Add a README section like:

```md
## Live runtime smoke testing

```bash
npm --workspace @ascp/adapter-codex run live
npm --workspace @ascp/adapter-codex run live -- discover
npm --workspace @ascp/adapter-codex run live -- list --limit 5
npm --workspace @ascp/adapter-codex run live -- get codex:thread_id --runs
```
```

Also state clearly that the script does not expose subscribe, replay, artifacts, or approval response.

- [ ] **Step 2: Run the focused and full verification commands**

Run:

```bash
npm --workspace @ascp/adapter-codex run test -- tests/live-smoke.test.ts
npm --workspace @ascp/adapter-codex run check
bash tooling/scripts/validate_codex_adapter.sh
```

Expected:

- the new script tests pass
- the full adapter suite passes
- the repository validator still passes

- [ ] **Step 3: Run one real runtime smoke check**

Run:

```bash
npm --workspace @ascp/adapter-codex run live -- discover
npm --workspace @ascp/adapter-codex run live -- list --limit 3
```

Expected: both commands succeed against the real `codex app-server`.

- [ ] **Step 4: Update checkpoint files**

Add a `docs/status.md` entry for the live smoke script branch and mark the `plans.md` tasks complete.

- [ ] **Step 5: Commit the docs and verification checkpoint**

```bash
git add adapters/codex/README.md plans.md docs/status.md
git commit -m "docs: checkpoint codex live smoke script"
```
