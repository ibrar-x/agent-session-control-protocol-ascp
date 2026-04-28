import { runDaemonProcess } from "./main.js";

async function main(): Promise<void> {
  const daemon = await runDaemonProcess();

  const shutdown = async () => {
    await daemon.close();
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
