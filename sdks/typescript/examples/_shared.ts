import { dirname, resolve } from "node:path";
import { pathToFileURL } from "node:url";
import { fileURLToPath } from "node:url";

import { AscpClient } from "ascp-sdk-typescript/client";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const EXAMPLES_DIR = dirname(fileURLToPath(import.meta.url));
const SDK_DIR = resolve(EXAMPLES_DIR, "..");
const REPO_DIR = resolve(SDK_DIR, "../..");
const MOCK_SERVER_CLI = resolve(REPO_DIR, "services/mock-server/src/mock_server/cli.py");

export function isDirectExecution(moduleUrl: string): boolean {
  const entrypoint = process.argv[1];

  if (entrypoint === undefined) {
    return false;
  }

  return pathToFileURL(entrypoint).href === moduleUrl;
}

export function printJson(value: unknown): void {
  process.stdout.write(`${JSON.stringify(value, null, 2)}\n`);
}

export async function createConnectedClient(): Promise<AscpClient> {
  const client = new AscpClient({
    transport: new AscpStdioTransport({
      command: ["python3", MOCK_SERVER_CLI],
      cwd: REPO_DIR
    })
  });

  await client.connect();

  return client;
}
