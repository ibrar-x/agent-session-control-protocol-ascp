import {
  AscpClient,
  AscpProtocolError,
  createAscpClient,
  type AscpClientOptions
} from "../src/client/index.js";
import type {
  CapabilitiesGetResult,
  SessionsSendInputResult,
  SessionsSubscribeParams
} from "../src/methods/index.js";
import type { ErrorCode } from "../src/errors/index.js";
import type { AscpTransport } from "../src/transport/index.js";

declare function expectType<T>(value: T): void;
declare const transport: AscpTransport;

const options: AscpClientOptions = { transport };
const client = createAscpClient(options);
const constructed = new AscpClient(options);

expectType<Promise<CapabilitiesGetResult>>(client.getCapabilities());
expectType<Promise<SessionsSendInputResult>>(
  constructed.sendInput({ session_id: "sess_01", input: "continue" })
);

const subscribeParams: SessionsSubscribeParams = {
  session_id: "sess_01",
  include_snapshot: true,
  from_seq: 34
};

expectType<SessionsSubscribeParams>(subscribeParams);
expectType<AscpTransport>(client.transport);

const protocolError = new AscpProtocolError({
  method: "sessions.list",
  response: {
    jsonrpc: "2.0",
    id: "req_1",
    error: {
      code: "UNAUTHORIZED",
      message: "Missing token",
      retryable: false
    }
  }
});

expectType<ErrorCode>(protocolError.code);
