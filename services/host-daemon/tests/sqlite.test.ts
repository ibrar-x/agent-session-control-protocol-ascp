import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { afterEach, describe, expect, it } from "vitest";

import { openDaemonDatabase } from "../src/sqlite.js";

const directoriesToRemove: string[] = [];

afterEach(() => {
  for (const directory of directoriesToRemove.splice(0)) {
    rmSync(directory, { force: true, recursive: true });
  }
});

describe("openDaemonDatabase", () => {
  it("creates the daemon replay tables on first open", () => {
    const directory = mkdtempSync(join(tmpdir(), "ascp-daemon-db-"));
    directoriesToRemove.push(directory);

    const database = openDaemonDatabase(join(directory, "daemon.sqlite"));

    const tables = database
      .prepare("SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name")
      .all() as Array<{ name: string }>;

    expect(tables.map((row) => row.name)).toEqual(
      expect.arrayContaining([
        "daemon_session_cursors",
        "daemon_session_events",
        "daemon_sessions"
      ])
    );
  });
});
