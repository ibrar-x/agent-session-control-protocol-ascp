import type {
  FlexibleObject,
  RequestId,
  SuccessResponseEnvelope
} from "../models/types.js";

export function createSuccessResponse<TResult extends FlexibleObject>(
  id: RequestId,
  result: TResult
): SuccessResponseEnvelope<TResult> {
  return {
    jsonrpc: "2.0",
    id,
    result
  };
}
