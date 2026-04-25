import { createConnectedClient, isDirectExecution, printJson } from "./_shared.ts";

export interface ApprovalFlowExampleSummary {
  approvalId: string;
  pendingBefore: number;
  resolvedStatus: string;
  approvedAfter: number;
  emittedEventTypes: string[];
}

export async function runApprovalFlowExample(): Promise<ApprovalFlowExampleSummary> {
  const client = await createConnectedClient();
  const events = client.events();

  try {
    const pending = await client.listApprovals({
      session_id: "sess_abc123",
      status: "pending"
    });
    const approval = pending.approvals[0];

    if (approval === undefined) {
      throw new Error("Mock server returned no pending approvals for sess_abc123.");
    }

    const response = await client.respondApproval({
      approval_id: approval.id,
      decision: "approved"
    });

    const emittedEventTypes: string[] = [];
    for await (const event of events) {
      if (event.session_id !== approval.session_id) {
        continue;
      }

      emittedEventTypes.push(event.type);

      if (emittedEventTypes.length === 2) {
        break;
      }
    }

    const approved = await client.listApprovals({
      session_id: "sess_abc123",
      status: "approved"
    });

    return {
      approvalId: approval.id,
      pendingBefore: pending.approvals.length,
      resolvedStatus: response.status,
      approvedAfter: approved.approvals.length,
      emittedEventTypes
    };
  } finally {
    await events.close();
    await client.close();
  }
}

if (isDirectExecution(import.meta.url)) {
  runApprovalFlowExample()
    .then((summary) => {
      printJson(summary);
    })
    .catch((error: unknown) => {
      const message = error instanceof Error ? error.stack ?? error.message : String(error);
      process.stderr.write(`${message}\n`);
      process.exitCode = 1;
    });
}
