import { describe, expect, it } from "vitest";

import {
  ASCP_CORE_METHOD_NAMES,
  type CoreMethodName
} from "../src/methods/index.js";
import type { EventEnvelope } from "../src/models/index.js";
import {
  AscpClient,
  AscpProtocolError,
  createAscpClient,
  type AscpClientRequestOptions
} from "../src/client/index.js";
import type {
  AscpTransport,
  AscpTransportSubscription,
  CoreMethodParamsMap
} from "../src/transport/index.js";
import type {
  CoreMethodResponse,
  CoreMethodSuccessResultMap
} from "../src/validation/index.js";

type RecordedRequest = {
  method: CoreMethodName;
  options?: AscpClientRequestOptions;
  params?: CoreMethodParamsMap[CoreMethodName];
};

class EmptySubscription implements AscpTransportSubscription {
  async close(): Promise<void> {}

  async *[Symbol.asyncIterator](): AsyncIterator<EventEnvelope> {}
}

class StubTransport implements AscpTransport {
  readonly kind = "stub";
  readonly requests: RecordedRequest[] = [];
  closed = false;
  connected = false;
  response: CoreMethodResponse<CoreMethodName> | undefined;

  async connect(): Promise<void> {
    this.connected = true;
  }

  async close(): Promise<void> {
    this.closed = true;
  }

  async request<TMethod extends CoreMethodName>(
    method: TMethod,
    params?: CoreMethodParamsMap[TMethod],
    options?: AscpClientRequestOptions
  ): Promise<CoreMethodResponse<TMethod>> {
    this.requests.push({
      method,
      ...(params !== undefined ? { params } : {}),
      ...(options !== undefined ? { options } : {})
    });

    if (this.response === undefined) {
      throw new Error(`No response configured for ${method}.`);
    }

    return this.response as CoreMethodResponse<TMethod>;
  }

  subscribe(): AscpTransportSubscription {
    return new EmptySubscription();
  }
}

const successfulResults: CoreMethodSuccessResultMap = {
  "capabilities.get": {
    protocol_version: "0.1.0",
    host: {
      id: "host_01",
      name: "Local Host"
    },
    runtimes: [],
    transports: ["stdio"],
    capabilities: {
      session_list: true
    }
  },
  "hosts.get": {
    host: {
      id: "host_01",
      name: "Local Host"
    }
  },
  "runtimes.list": {
    runtimes: [
      {
        id: "runtime_01",
        kind: "codex",
        display_name: "Codex",
        version: "1.0.0"
      }
    ]
  },
  "sessions.list": {
    sessions: [],
    next_cursor: null
  },
  "sessions.get": {
    session: {
      id: "sess_01",
      runtime_id: "runtime_01",
      status: "running",
      created_at: "2026-04-24T00:00:00Z",
      updated_at: "2026-04-24T00:00:01Z"
    },
    runs: [],
    pending_approvals: []
  },
  "sessions.start": {
    session: {
      id: "sess_02",
      runtime_id: "runtime_01",
      status: "running",
      created_at: "2026-04-24T00:00:00Z",
      updated_at: "2026-04-24T00:00:01Z"
    }
  },
  "sessions.resume": {
    session: {
      id: "sess_01",
      runtime_id: "runtime_01",
      status: "running",
      created_at: "2026-04-24T00:00:00Z",
      updated_at: "2026-04-24T00:00:01Z"
    },
    replay_supported: true,
    snapshot_emitted: true
  },
  "sessions.stop": {
    session_id: "sess_01",
    status: "stopped"
  },
  "sessions.send_input": {
    session_id: "sess_01",
    accepted: true
  },
  "sessions.subscribe": {
    session_id: "sess_01",
    subscription_id: "sub_01",
    snapshot_emitted: true
  },
  "sessions.unsubscribe": {
    subscription_id: "sub_01",
    unsubscribed: true
  },
  "approvals.list": {
    approvals: [],
    next_cursor: null
  },
  "approvals.respond": {
    approval_id: "approval_01",
    status: "approved"
  },
  "artifacts.list": {
    artifacts: []
  },
  "artifacts.get": {
    artifact: {
      id: "artifact_01",
      session_id: "sess_01",
      kind: "file",
      created_at: "2026-04-24T00:00:00Z"
    }
  },
  "diffs.get": {
    diff: {
      session_id: "sess_01",
      run_id: "run_01",
      files_changed: 1,
      insertions: 2,
      deletions: 1
    }
  }
};

const wrapperCases = [
  ["getCapabilities", "capabilities.get", undefined],
  ["getHost", "hosts.get", undefined],
  ["listRuntimes", "runtimes.list", { kind: "codex" }],
  ["listSessions", "sessions.list", { limit: 10 }],
  ["getSession", "sessions.get", { session_id: "sess_01" }],
  ["startSession", "sessions.start", { runtime_id: "runtime_01" }],
  ["resumeSession", "sessions.resume", { session_id: "sess_01" }],
  ["stopSession", "sessions.stop", { session_id: "sess_01", mode: "graceful" }],
  [
    "sendInput",
    "sessions.send_input",
    { session_id: "sess_01", input: "continue", input_kind: "reply" }
  ],
  [
    "subscribe",
    "sessions.subscribe",
    { session_id: "sess_01", include_snapshot: true, from_seq: 34 }
  ],
  ["unsubscribe", "sessions.unsubscribe", { subscription_id: "sub_01" }],
  ["listApprovals", "approvals.list", { session_id: "sess_01" }],
  [
    "respondApproval",
    "approvals.respond",
    { approval_id: "approval_01", decision: "approved" }
  ],
  ["listArtifacts", "artifacts.list", { session_id: "sess_01" }],
  ["getArtifact", "artifacts.get", { artifact_id: "artifact_01" }],
  ["getDiff", "diffs.get", { session_id: "sess_01", run_id: "run_01" }]
] as const;

describe("typed client surface", () => {
  it("wraps every ASCP core method with protocol-faithful params and result unwrapping", async () => {
    expect(wrapperCases.map(([, method]) => method)).toEqual(ASCP_CORE_METHOD_NAMES);

    for (const [wrapperName, method, params] of wrapperCases) {
      const transport = new StubTransport();
      transport.response = {
        jsonrpc: "2.0",
        id: "req_1",
        result: successfulResults[method]
      };
      const client = createAscpClient({ transport });

      const result = await (client[wrapperName] as (input?: unknown) => Promise<unknown>)(
        params
      );

      expect(result).toBe(successfulResults[method]);
      expect(transport.requests).toEqual([
        {
          method,
          ...(params !== undefined ? { params } : {})
        }
      ]);
    }
  });

  it("passes request options through to the configured transport", async () => {
    const transport = new StubTransport();
    const timeoutMs = 1_500;
    transport.response = {
      jsonrpc: "2.0",
      id: "req_1",
      result: successfulResults["sessions.send_input"]
    };
    const client = new AscpClient({ transport });

    await client.sendInput(
      {
        session_id: "sess_01",
        input: "continue"
      },
      { timeoutMs }
    );

    expect(transport.requests).toEqual([
      {
        method: "sessions.send_input",
        params: {
          session_id: "sess_01",
          input: "continue"
        },
        options: {
          timeoutMs
        }
      }
    ]);
  });

  it("maps ASCP error response envelopes to protocol errors without losing details", async () => {
    const transport = new StubTransport();
    transport.response = {
      jsonrpc: "2.0",
      id: "req_1",
      error: {
        code: "UNAUTHORIZED",
        message: "Missing token",
        retryable: false,
        details: {
          scope: "sessions:list"
        },
        correlation_id: "corr_01"
      }
    };
    const client = createAscpClient({ transport });

    await expect(client.listSessions()).rejects.toMatchObject({
      name: "AscpProtocolError",
      method: "sessions.list",
      code: "UNAUTHORIZED",
      retryable: false,
      correlationId: "corr_01",
      errorObject: {
        code: "UNAUTHORIZED",
        details: {
          scope: "sessions:list"
        }
      },
      response: transport.response
    } satisfies Partial<AscpProtocolError<"sessions.list">>);
  });

  it("delegates connection lifecycle and event subscriptions to the transport", async () => {
    const transport = new StubTransport();
    const client = createAscpClient({ transport });

    await client.connect();
    const subscription = client.events();
    await client.close();

    expect(transport.connected).toBe(true);
    expect(subscription).toBeInstanceOf(EmptySubscription);
    expect(transport.closed).toBe(true);
  });
});
