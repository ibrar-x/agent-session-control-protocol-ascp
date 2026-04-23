import WebSocket, { type RawData } from "ws";

import { BaseAscpTransport } from "./base.js";
import { createTransportError } from "./errors.js";

export interface AscpWebSocketTransportOptions {
  handshakeTimeoutMs?: number;
  headers?: Record<string, string>;
  protocols?: string | string[];
  url: string;
}

export class AscpWebSocketTransport extends BaseAscpTransport {
  private readonly options: AscpWebSocketTransportOptions;
  private socket: WebSocket | null = null;

  constructor(options: AscpWebSocketTransportOptions) {
    super("websocket");
    this.options = options;
  }

  protected async openConnection(): Promise<void> {
    if (this.socket !== null) {
      return;
    }

    const socket = new WebSocket(this.options.url, this.options.protocols, {
      handshakeTimeout: this.options.handshakeTimeoutMs,
      headers: this.options.headers
    });

    this.socket = socket;

    await new Promise<void>((resolve, reject) => {
      const onOpen = () => {
        cleanup();
        this.markConnected();
        resolve();
      };

      const onError = (error: Error) => {
        cleanup();
        this.socket = null;
        reject(error);
      };

      const cleanup = () => {
        socket.off("open", onOpen);
        socket.off("error", onError);
      };

      socket.once("open", onOpen);
      socket.once("error", onError);
    });

    socket.on("message", (data: RawData) => {
      this.handleSerializedMessage(this.toText(data));
    });

    socket.on("error", (error: Error) => {
      this.handleIoFailure(error, "websocket transport emitted an error.");
    });

    socket.on("close", (code: number, reason: Buffer) => {
      if (this.socket === null) {
        return;
      }

      this.socket = null;

      this.handleConnectionFailure(
        createTransportError({
          code: "TRANSPORT_CONNECTION",
          transport: this.kind,
          message: "websocket transport closed unexpectedly.",
          details: {
            code,
            reason: reason.toString("utf8")
          }
        }),
        "websocket transport closed unexpectedly."
      );
    });
  }

  protected async closeConnection(): Promise<void> {
    const socket = this.socket;
    this.socket = null;

    if (socket === null) {
      return;
    }

    if (
      socket.readyState === WebSocket.CLOSING ||
      socket.readyState === WebSocket.CLOSED
    ) {
      return;
    }

    await new Promise<void>((resolve) => {
      socket.once("close", () => {
        resolve();
      });
      socket.close();
      setTimeout(resolve, 250);
    });
  }

  protected async sendSerialized(messageText: string): Promise<void> {
    const socket = this.socket;

    if (socket === null || socket.readyState !== WebSocket.OPEN) {
      throw createTransportError({
        code: "TRANSPORT_CLOSED",
        transport: this.kind,
        message: "websocket transport is not open.",
        retryable: false
      });
    }

    await new Promise<void>((resolve, reject) => {
      socket.send(messageText, (error?: Error) => {
        if (error) {
          reject(error);
          return;
        }

        resolve();
      });
    });
  }

  private toText(data: WebSocket.RawData): string {
    if (typeof data === "string") {
      return data;
    }

    if (data instanceof ArrayBuffer) {
      return Buffer.from(data).toString("utf8");
    }

    if (Array.isArray(data)) {
      return Buffer.concat(data.map((chunk) => Buffer.from(chunk))).toString("utf8");
    }

    return data.toString("utf8");
  }
}
