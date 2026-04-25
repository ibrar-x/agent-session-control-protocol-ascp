export const ASCP_TRANSPORT_ERROR_CODES = [
  "TRANSPORT_ABORTED",
  "TRANSPORT_CLOSED",
  "TRANSPORT_CONFIGURATION",
  "TRANSPORT_CONNECTION",
  "TRANSPORT_IO",
  "TRANSPORT_PROTOCOL",
  "TRANSPORT_TIMEOUT"
] as const;

export type AscpTransportErrorCode =
  (typeof ASCP_TRANSPORT_ERROR_CODES)[number];

export interface AscpTransportErrorOptions {
  code: AscpTransportErrorCode;
  transport: string;
  message: string;
  cause?: unknown;
  details?: Record<string, unknown>;
  retryable?: boolean;
}

export class AscpTransportError extends Error {
  readonly code: AscpTransportErrorCode;
  readonly transport: string;
  readonly details: Record<string, unknown> | undefined;
  readonly retryable: boolean;

  constructor(options: AscpTransportErrorOptions) {
    super(options.message, options.cause !== undefined ? { cause: options.cause } : {});
    this.name = "AscpTransportError";
    this.code = options.code;
    this.transport = options.transport;
    this.details = options.details;
    this.retryable = options.retryable ?? options.code !== "TRANSPORT_CONFIGURATION";
  }
}

export interface NormalizeTransportErrorOptions {
  code: AscpTransportErrorCode;
  transport: string;
  message: string;
  details?: Record<string, unknown>;
  retryable?: boolean;
}

export function createTransportError(
  options: AscpTransportErrorOptions
): AscpTransportError {
  return new AscpTransportError(options);
}

export function normalizeTransportError(
  error: unknown,
  options: NormalizeTransportErrorOptions
): AscpTransportError {
  if (error instanceof AscpTransportError) {
    return error;
  }

  return new AscpTransportError({
    ...options,
    cause: error
  });
}
