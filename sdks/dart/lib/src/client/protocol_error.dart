import '../errors/protocol_error.dart';
import '../transport/transport.dart';

final class AscpProtocolException implements Exception {
  const AscpProtocolException({required this.method, required this.response});

  final String method;
  final AscpTransportErrorResponse response;

  AscpProtocolError get errorObject => response.error;
  String get code => response.error.code;
  bool get retryable => response.error.retryable;
  String? get correlationId => response.error.correlationId;

  @override
  String toString() =>
      'AscpProtocolException($method, $code): ${response.error.message}';
}
