import { once } from "node:events";
import { dirname, resolve } from "node:path";
import { spawn } from "node:child_process";
import { fileURLToPath } from "node:url";

import { afterEach, describe, expect, it } from "vitest";

import { AscpClient } from "../src/client/index.js";
import {
  replayFromSeq,
  subscribeWithReplay,
  type AscpReplayStreamItem
} from "../src/replay/index.js";
import { AscpStdioTransport } from "../src/transport/index.js";

const TEST_DIR = dirname(fileURLToPath(import.meta.url));
const SDK_DIR = resolve(TEST_DIR, "..");
const REPO_DIR = resolve(SDK_DIR, "..");
const MOCK_SERVER_CLI = resolve(REPO_DIR, "../mock-server/src/mock_server/cli.py");
const EXAMPLES_DIR = resolve(SDK_DIR, "examples");

const openClosers = new Set<{ close(): Promise<void> }>();

afterEach(async () => {
  for (const closer of [...openClosers].reverse()) {
    await closer.close();
  }

  openClosers.clear();
});

function trackClosable<T extends { close(): Promise<void> }>(closable: T): T {
  openClosers.add(closable);
  return closable;
}

function createClient(): AscpClient {
  const transport = trackClosable(
    new AscpStdioTransport({
      command: ["python3", MOCK_SERVER_CLI],
      cwd: REPO_DIR
    })
  );

  return new AscpClient({ transport });
}

async function runExample(scriptName: string): Promise<unknown> {
  const child = spawn(
    process.execPath,
    ["--experimental-strip-types", resolve(EXAMPLES_DIR, scriptName)],
    {
      cwd: SDK_DIR,
      stdio: ["ignore", "pipe", "pipe"]
    }
  );

  const stdout: Buffer[] = [];
  const stderr: Buffer[] = [];

  child.stdout.on("data", (chunk: Buffer) => {
    stdout.push(chunk);
  });
  child.stderr.on("data", (chunk: Buffer) => {
    stderr.push(chunk);
  });

  const [exitCode] = (await once(child, "close")) as [number | null];

  expect({
    exitCode,
    stderr: Buffer.concat(stderr).toString("utf8")
  }).toEqual({
    exitCode: 0,
    stderr: ""
  });

  return JSON.parse(Buffer.concat(stdout).toString("utf8")) as unknown;
}

describe("mock-server integration and examples", () => {
  it("proves the published client and replay surfaces against the upstream mock server", async () => {
    const client = createClient();
    await client.connect();

    const replay = trackClosable(
      await subscribeWithReplay(
        client,
        replayFromSeq({
          session_id: "sess_abc123",
          from_seq: 34,
          include_snapshot: true
        })
      )
    );

    try {
      const capabilities = await client.getCapabilities();
      const runtimes = await client.listRuntimes({ kind: "codex" });
      const sessions = await client.listSessions({ limit: 10 });
      const session = await client.getSession({
        session_id: "sess_abc123",
        include_pending_approvals: true
      });
      const approvals = await client.listApprovals({
        session_id: "sess_abc123",
        status: "pending"
      });
      const artifacts = await client.listArtifacts({
        session_id: "sess_abc123"
      });
      const artifact = await client.getArtifact({
        artifact_id: "art_3"
      });
      const diff = await client.getDiff({
        session_id: "sess_abc123",
        run_id: "run_9"
      });

      const replayKinds: string[] = [];

      for await (const item of replay) {
        replayKinds.push(item.kind);

        if (item.kind === "cursor_advanced") {
          break;
        }
      }

      await client.sendInput({
        session_id: "sess_abc123",
        input: "Continue with the deterministic next step."
      });

      const liveKinds: string[] = [];
      for await (const item of replay) {
        liveKinds.push(item.kind);

        if (liveKinds.length === 3) {
          break;
        }
      }

      expect(capabilities.protocol_version).toBe("0.1.0");
      expect(runtimes.runtimes[0]?.id).toBe("codex_local");
      expect(sessions.sessions[0]?.id).toBe("sess_abc123");
      expect(session.pending_approvals[0]?.id).toBe("apr_77");
      expect(approvals.approvals[0]?.status).toBe("pending");
      expect(artifacts.artifacts[0]?.id).toBe("art_3");
      expect(artifact.artifact.kind).toBe("diff");
      expect(diff.diff.files_changed).toBe(4);
      expect(replayKinds).toEqual([
        "snapshot",
        "replay_event",
        "replay_event",
        "replay_event",
        "replay_event",
        "replay_complete",
        "cursor_advanced"
      ]);
      expect(replay.cursor).toBe("seq:38");
      expect(liveKinds).toEqual(["live_event", "live_event", "live_event"]);
    } finally {
      await replay.close();
      await client.close();
      openClosers.delete(replay);
      openClosers.delete(client.transport);
    }
  });

  it("runs the subscribe and replay example as a standalone script", async () => {
    await expect(runExample("subscribe-replay.ts")).resolves.toMatchObject({
      sessionId: "sess_abc123",
      snapshotStatus: "running",
      replayEventTypes: [
        "message.assistant.delta",
        "message.assistant.completed",
        "artifact.created",
        "diff.ready"
      ],
      liveEventTypes: [
        "message.user",
        "message.assistant.started",
        "message.assistant.completed"
      ],
      cursor: "seq:38"
    });
  });

  it("runs the approval example as a standalone script", async () => {
    await expect(runExample("approval-flow.ts")).resolves.toMatchObject({
      approvalId: "apr_77",
      pendingBefore: 1,
      resolvedStatus: "approved",
      emittedEventTypes: ["approval.updated", "approval.approved"]
    });
  });

  it("runs the artifact and diff example as a standalone script", async () => {
    await expect(runExample("artifact-diff.ts")).resolves.toMatchObject({
      sessionId: "sess_abc123",
      artifactIds: ["art_3"],
      artifactKind: "diff",
      diffFilesChanged: 4
    });
  });
});
