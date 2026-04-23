import type { AscpInstrumentedTransportOptions } from "./types.js";
import { createInterface, type Interface as ReadLineInterface } from "node:readline";
import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";

import { BaseAscpTransport } from "./base.js";
import { createTransportError } from "./errors.js";

export interface AscpStdioTransportOptions extends AscpInstrumentedTransportOptions {
  command: readonly string[];
  cwd?: string;
  env?: NodeJS.ProcessEnv;
}

export class AscpStdioTransport extends BaseAscpTransport {
  private readonly options: AscpStdioTransportOptions;
  private process: ChildProcessWithoutNullStreams | null = null;
  private stdoutReader: ReadLineInterface | null = null;
  private stderrBuffer = "";

  constructor(options: AscpStdioTransportOptions) {
    super("stdio", options.analytics);
    this.options = options;
  }

  protected async openConnection(): Promise<void> {
    if (this.process !== null) {
      return;
    }

    const [command, ...args] = this.options.command;

    if (command === undefined) {
      throw createTransportError({
        code: "TRANSPORT_CONFIGURATION",
        transport: this.kind,
        message: "stdio transport requires a command.",
        retryable: false
      });
    }

    const child = spawn(command, args, {
      cwd: this.options.cwd,
      env: this.options.env,
      stdio: "pipe"
    });

    this.process = child;
    this.markConnected();

    this.stdoutReader = createInterface({
      input: child.stdout,
      crlfDelay: Infinity
    });

    this.stdoutReader.on("line", (line) => {
      this.handleSerializedMessage(line);
    });

    child.stderr.setEncoding("utf8");
    child.stderr.on("data", (chunk: string) => {
      this.stderrBuffer = `${this.stderrBuffer}${chunk}`.slice(-4_096);
    });

    child.on("error", (error) => {
      this.handleConnectionFailure(error, "stdio transport process failed.");
    });

    child.on("exit", (code, signal) => {
      if (this.process === null) {
        return;
      }

      this.process = null;
      this.stdoutReader?.close();
      this.stdoutReader = null;

      this.handleConnectionFailure(
        createTransportError({
          code: "TRANSPORT_CONNECTION",
          transport: this.kind,
          message: "stdio transport process exited unexpectedly.",
          details: {
            code,
            signal,
            stderr: this.stderrBuffer || undefined
          }
        }),
        "stdio transport process exited unexpectedly."
      );
    });
  }

  protected async closeConnection(): Promise<void> {
    const child = this.process;

    this.process = null;
    this.stdoutReader?.close();
    this.stdoutReader = null;

    if (child === null) {
      return;
    }

    if (!child.stdin.destroyed) {
      child.stdin.end();
    }

    if (!child.killed) {
      child.kill();
    }

    await new Promise<void>((resolve) => {
      child.once("exit", () => {
        resolve();
      });
      child.once("close", () => {
        resolve();
      });
      setTimeout(resolve, 250);
    });
  }

  protected async sendSerialized(messageText: string): Promise<void> {
    const child = this.process;

    if (child === null || child.stdin.destroyed) {
      throw createTransportError({
        code: "TRANSPORT_CLOSED",
        transport: this.kind,
        message: "stdio transport is not writable.",
        retryable: false
      });
    }

    await new Promise<void>((resolve, reject) => {
      child.stdin.write(`${messageText}\n`, (error) => {
        if (error) {
          reject(error);
          return;
        }

        resolve();
      });
    });
  }
}
