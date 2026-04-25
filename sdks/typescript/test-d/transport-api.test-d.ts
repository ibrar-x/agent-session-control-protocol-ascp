import type {
  AscpStdioTransport,
  AscpTransport,
  AscpTransportSubscription,
  AscpWebSocketTransport
} from "../src/transport/index.js";
import type { CoreMethodResponseMap } from "../src/validation/index.js";

declare const genericTransport: AscpTransport;
declare const stdioTransport: AscpStdioTransport;
declare const webSocketTransport: AscpWebSocketTransport;

const capabilitiesResponse = await genericTransport.request("capabilities.get");
const subscribeResponse = await genericTransport.request("sessions.subscribe", {
  session_id: "sess_123",
  include_snapshot: true
});
const subscription: AscpTransportSubscription = genericTransport.subscribe();

const typedCapabilitiesResponse: CoreMethodResponseMap["capabilities.get"] =
  capabilitiesResponse;
const typedSubscribeResponse: CoreMethodResponseMap["sessions.subscribe"] =
  subscribeResponse;

void typedCapabilitiesResponse;
void typedSubscribeResponse;
void subscription;
void stdioTransport;
void webSocketTransport;
