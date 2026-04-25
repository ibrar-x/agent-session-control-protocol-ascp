import '../errors/protocol_error.dart';
import '../models/envelopes.dart';
import '../models/json_types.dart';

final class AscpTransportRequestOptions {
  const AscpTransportRequestOptions({this.timeout});

  final Duration? timeout;
}

sealed class AscpTransportResponse {
  const AscpTransportResponse({required this.jsonrpc, required this.id});

  final String jsonrpc;
  final Object? id;
}

final class AscpTransportSuccessResponse extends AscpTransportResponse {
  const AscpTransportSuccessResponse({
    required super.jsonrpc,
    required super.id,
    required this.result,
  });

  final Object? result;

  factory AscpTransportSuccessResponse.fromJson(AscpJsonMap json) =>
      AscpTransportSuccessResponse(
        jsonrpc: json['jsonrpc'] as String? ?? '2.0',
        id: json['id'],
        result: json['result'],
      );
}

final class AscpTransportErrorResponse extends AscpTransportResponse {
  const AscpTransportErrorResponse({
    required super.jsonrpc,
    required super.id,
    required this.error,
  });

  final AscpProtocolError error;

  factory AscpTransportErrorResponse.fromJson(AscpJsonMap json) =>
      AscpTransportErrorResponse(
        jsonrpc: json['jsonrpc'] as String? ?? '2.0',
        id: json['id'],
        error: AscpProtocolError.fromJson(
          (json['error'] as Map).cast<String, Object?>(),
        ),
      );
}

abstract interface class AscpTransport {
  String get kind;
  Stream<AscpEventEnvelope> get events;

  Future<void> connect();
  Future<void> close();
  Future<AscpTransportResponse> request(
    String method, {
    AscpJsonMap? params,
    AscpTransportRequestOptions? options,
  });
}
