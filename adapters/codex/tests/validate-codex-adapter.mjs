import { existsSync, readFileSync } from "node:fs";

const requiredFiles = [
  "adapters/codex/src/app-server-client.ts",
  "adapters/codex/src/approvals.ts",
  "adapters/codex/src/discovery.ts",
  "adapters/codex/src/capabilities.ts",
  "adapters/codex/src/events.ts",
  "adapters/codex/src/session-mapper.ts",
  "adapters/codex/src/service.ts",
  "adapters/codex/tests/approvals.test.ts",
  "adapters/codex/tests/discovery.test.ts",
  "adapters/codex/tests/events.test.ts",
  "adapters/codex/tests/service.test.ts"
];

for (const file of requiredFiles) {
  if (!existsSync(file)) {
    throw new Error(`Missing required adapter file: ${file}`);
  }
}

const pkg = JSON.parse(readFileSync("adapters/codex/package.json", "utf8"));
const readme = readFileSync("adapters/codex/README.md", "utf8");

if (!pkg.scripts?.test || !pkg.scripts?.build || !pkg.scripts?.check) {
  throw new Error("Adapter package must expose build, test, and check scripts.");
}

for (const requiredClaim of [
  "stream_events=false",
  "approval_respond=false",
  "artifacts=false",
  "replay=false"
]) {
  if (!readme.includes(requiredClaim)) {
    throw new Error(`README must document truthful fallback: ${requiredClaim}`);
  }
}
