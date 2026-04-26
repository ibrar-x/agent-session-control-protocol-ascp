import { createAscpHostService } from "@ascp/host-service";
import { CodexAppServerClient, createCodexHostRuntime } from "../dist/index.js";

function parsePort(args) {
  for (let index = 0; index < args.length; index += 1) {
    const token = args[index];

    if (token === "--port") {
      const raw = args[index + 1];
      const value = raw === undefined ? NaN : Number(raw);

      if (!Number.isInteger(value) || value < 0) {
        throw new Error(`Invalid --port value: ${String(raw)}`);
      }

      return value;
    }
  }

  return 8765;
}

async function main() {
  const port = parsePort(process.argv.slice(2));
  const client = new CodexAppServerClient();
  const runtime = createCodexHostRuntime(client);
  const host = createAscpHostService({
    runtime,
    port
  });

  await host.listen();

  process.stdout.write(`${JSON.stringify({ url: host.url }, null, 2)}\n`);

  const shutdown = async () => {
    await host.close();
    process.exit(0);
  };

  process.once("SIGINT", shutdown);
  process.once("SIGTERM", shutdown);
}

main().catch((error) => {
  const message = error instanceof Error ? error.stack ?? error.message : String(error);
  process.stderr.write(`${message}\n`);
  process.exit(1);
});
