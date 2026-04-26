import { describe, expect, it } from "vitest";

import { canRespondToApprovals, mapApprovalRequest, mapApprovalRequestToEvent } from "../src/approvals.js";

const NOW = "2026-04-26T12:00:00Z";

describe("mapApprovalRequest", () => {
  it("maps command execution requests into canonical ASCP approvals", () => {
    const approval = mapApprovalRequest(
      {
        method: "item/commandExecution/requestApproval",
        params: {
          approvalId: "apr_1",
          itemId: "item_1",
          threadId: "thread_1",
          turnId: "turn_1",
          command: "npm test",
          cwd: "/tmp/app",
          reason: "Agent wants to run tests"
        }
      },
      {
        now: () => NOW
      }
    );

    expect(approval).toEqual({
      id: "codex:apr_1",
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      kind: "command",
      status: "pending",
      title: "Approve shell command",
      description: "Agent wants to run tests",
      risk_level: "medium",
      payload: {
        item_id: "item_1",
        command: "npm test",
        cwd: "/tmp/app"
      },
      created_at: NOW
    });
  });

  it("maps permissions requests into approval.requested events", () => {
    const event = mapApprovalRequestToEvent(
      {
        method: "item/permissions/requestApproval",
        params: {
          itemId: "item_9",
          threadId: "thread_1",
          turnId: "turn_1",
          cwd: "/tmp/app",
          permissions: ["network"],
          reason: "Agent needs network access"
        }
      },
      {
        now: () => NOW
      }
    );

    expect(event).toEqual({
      id: "codex:event:approval_requested:thread_1:turn_1:item_9",
      type: "approval.requested",
      ts: NOW,
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      payload: {
        approval: {
          id: "codex:item_9",
          session_id: "codex:thread_1",
          run_id: "codex:thread_1:turn_1",
          kind: "network",
          status: "pending",
          title: "Approve elevated permissions",
          description: "Agent needs network access",
          risk_level: "high",
          payload: {
            item_id: "item_9",
            cwd: "/tmp/app",
            permissions: ["network"]
          },
          created_at: NOW
        }
      }
    });
  });

  it("reports approval response support conservatively", () => {
    expect(canRespondToApprovals({ supportsApprovalRespond: false })).toBe(false);
    expect(canRespondToApprovals({ supportsApprovalRespond: true })).toBe(true);
  });
});
