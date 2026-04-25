export const ASCP_ERROR_CODES = [
  "INVALID_REQUEST",
  "UNAUTHORIZED",
  "FORBIDDEN",
  "NOT_FOUND",
  "CONFLICT",
  "UNSUPPORTED",
  "RATE_LIMITED",
  "ADAPTER_ERROR",
  "RUNTIME_ERROR",
  "TRANSIENT_UNAVAILABLE",
  "INTERNAL_ERROR"
] as const;

export type ErrorCode = (typeof ASCP_ERROR_CODES)[number];

export interface ErrorObject {
  code: ErrorCode;
  message: string;
  retryable: boolean;
  details?: Record<string, unknown> | null;
  correlation_id?: string;
  [key: string]: unknown;
}
