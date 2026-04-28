export interface HostDaemonLogger {
  info(message: string, details?: Record<string, unknown>): void;
  error(message: string, details?: Record<string, unknown>): void;
}

function writeLine(
  writer: (chunk: string) => boolean,
  level: "info" | "error",
  message: string,
  details?: Record<string, unknown>
): void {
  writer(
    `${JSON.stringify({
      level,
      message,
      ...(details ?? {})
    })}\n`
  );
}

export function createConsoleLogger(): HostDaemonLogger {
  return {
    info(message, details) {
      writeLine(process.stdout.write.bind(process.stdout), "info", message, details);
    },
    error(message, details) {
      writeLine(process.stderr.write.bind(process.stderr), "error", message, details);
    }
  };
}
