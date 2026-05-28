import '../ascp/ascp_method.dart';
import '../ascp/ascp_event.dart';

abstract interface class JsonRpcClient {
  Future<Object?> call({
    required Object id,
    required AscpMethod method,
    Map<String, Object?> params,
  });
}

abstract interface class EventJsonRpcClient implements JsonRpcClient {
  Stream<AscpEventEnvelope> get events;

  Future<void> close();
}
