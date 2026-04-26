#!/usr/bin/env node

import {
  getLiveSmokeUsage,
  parseLiveSmokeCommand,
  runInteractiveLiveSmoke,
  runLiveSmokeCommand,
  validateLiveSmokeCommand,
  writeLiveSmokeResult
} from "../dist/live-smoke.js";
import {
  CodexAdapterService,
  CodexAppServerClient,
  discoverCodexRuntime
} from "../dist/index.js";

const argv = process.argv.slice(2);

if (argv.length > 0 && (argv[0] === "help" || argv[0] === "--help" || argv[0] === "-h")) {
  process.stdout.write(`${getLiveSmokeUsage()}\n`);
  process.exit(0);
}

const client = new CodexAppServerClient();
const service = new CodexAdapterService(client);
const deps = {
  discover: () => discoverCodexRuntime(client),
  listSessions: (params) => service.sessionsList(params),
  getSession: (params) => service.sessionsGet(params),
  resumeSession: (params) => service.sessionsResume(params),
  sendInput: (params) => service.sessionsSendInput(params)
};

try {
  const parsed = parseLiveSmokeCommand(argv);

  if (parsed.mode === "interactive") {
    await runInteractiveLiveSmoke({
      input: process.stdin,
      output: process.stdout,
      deps
    });
  } else {
    const result = await runLiveSmokeCommand(validateLiveSmokeCommand(parsed), deps);
    writeLiveSmokeResult(process.stdout, result);
  }
} catch (error) {
  const message = error instanceof Error ? error.message : String(error);
  process.stderr.write(`${message}\n`);

  if (argv.length > 0) {
    process.stderr.write(`${getLiveSmokeUsage()}\n`);
  }

  process.exitCode = 1;
} finally {
  await client.close();
}
