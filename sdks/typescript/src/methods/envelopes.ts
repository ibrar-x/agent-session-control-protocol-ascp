import type {
  FlexibleObject,
  RequestId,
  ResponseEnvelope
} from "../models/types.js";

export function createSuccessResponse<TResult extends FlexibleObject>(
  id: RequestId,
  result: TResult
): ResponseEnvelope<TResult> {
  return {
    jsonrpc: "2.0",
    id,
    result
  };
}
