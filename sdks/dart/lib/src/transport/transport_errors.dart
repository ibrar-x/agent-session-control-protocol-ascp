final class AscpTransportErrorCode {
  const AscpTransportErrorCode._();

  static const String aborted = 'TRANSPORT_ABORTED';
  static const String closed = 'TRANSPORT_CLOSED';
  static const String configuration = 'TRANSPORT_CONFIGURATION';
  static const String connection = 'TRANSPORT_CONNECTION';
  static const String io = 'TRANSPORT_IO';
  static const String protocol = 'TRANSPORT_PROTOCOL';
  static const String timeout = 'TRANSPORT_TIMEOUT';
}

final class AscpTransportException implements Exception {
  const AscpTransportException({
    required this.code,
    required this.transport,
    required this.message,
    this.details,
    this.retryable = true,
    this.cause,
  });

  final String code;
  final String transport;
  final String message;
  final Map<String, Object?>? details;
  final bool retryable;
  final Object? cause;

  @override
  String toString() => 'AscpTransportException($code, $transport): $message';
}
