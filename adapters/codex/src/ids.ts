const CODEX_ID_PREFIX = "codex";

export function toSessionId(threadId: string): string {
  return `${CODEX_ID_PREFIX}:${threadId}`;
}

export function toRunId(threadId: string, turnId: string): string {
  return `${toSessionId(threadId)}:${turnId}`;
}

export function toApprovalId(approvalId: string): string {
  return `${CODEX_ID_PREFIX}:${approvalId}`;
}
