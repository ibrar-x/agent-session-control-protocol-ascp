export type DaemonRuntimeKind = "codex";
export type DaemonAuthTransport = "loopback" | "tls";

export interface HostDaemonConfig {
  adminPort: number;
  authTransport: DaemonAuthTransport;
  databasePath: string;
  host: string;
  port: number;
  runtime: DaemonRuntimeKind;
}

const DEFAULT_ADMIN_PORT = 8766;
const DEFAULT_AUTH_TRANSPORT: DaemonAuthTransport = "loopback";
const DEFAULT_DATABASE_PATH = ".ascp/host-daemon.sqlite";
const DEFAULT_HOST = "127.0.0.1";
const DEFAULT_PORT = 8765;
const DEFAULT_RUNTIME: DaemonRuntimeKind = "codex";

function parsePort(raw: string | undefined): number {
  const value = Number(raw);

  if (!Number.isInteger(value) || value < 0) {
    throw new Error(`Invalid ASCP_PORT value: ${raw}`);
  }

  return value;
}

function parseRuntime(raw: string | undefined): DaemonRuntimeKind {
  if (raw === undefined || raw.length === 0) {
    return DEFAULT_RUNTIME;
  }

  if (raw === "codex") {
    return raw;
  }

  throw new Error(`Unsupported ASCP_RUNTIME value: ${raw}`);
}

function parseAuthTransport(raw: string | undefined): DaemonAuthTransport {
  if (raw === undefined || raw.length === 0) {
    return DEFAULT_AUTH_TRANSPORT;
  }

  if (raw === "loopback" || raw === "tls") {
    return raw;
  }

  throw new Error(`Unsupported ASCP_AUTH_TRANSPORT value: ${raw}`);
}

function validateLocalBinding(host: string, authTransport: DaemonAuthTransport): void {
  if (authTransport !== "loopback") {
    return;
  }

  if (host === "127.0.0.1" || host === "localhost" || host === "::1") {
    return;
  }

  throw new Error(`ASCP auth transport loopback requires a local-only host binding: ${host}`);
}

export function resolveDaemonConfig(
  env: NodeJS.ProcessEnv,
  defaults: Partial<HostDaemonConfig> = {}
): HostDaemonConfig {
  const rawPort = env.ASCP_PORT;
  const host = env.ASCP_HOST ?? defaults.host ?? DEFAULT_HOST;
  const authTransport = parseAuthTransport(env.ASCP_AUTH_TRANSPORT ?? defaults.authTransport);
  validateLocalBinding(host, authTransport);

  return {
    adminPort:
      env.ASCP_ADMIN_PORT === undefined
        ? defaults.adminPort ?? DEFAULT_ADMIN_PORT
        : parsePort(env.ASCP_ADMIN_PORT),
    authTransport,
    databasePath: env.ASCP_DATABASE_PATH ?? defaults.databasePath ?? DEFAULT_DATABASE_PATH,
    host,
    port: rawPort === undefined ? defaults.port ?? DEFAULT_PORT : parsePort(rawPort),
    runtime: parseRuntime(env.ASCP_RUNTIME ?? defaults.runtime)
  };
}
