enum AscpErrorCode {
  invalidRequest('INVALID_REQUEST'),
  unauthorized('UNAUTHORIZED'),
  forbidden('FORBIDDEN'),
  notFound('NOT_FOUND'),
  conflict('CONFLICT'),
  unsupported('UNSUPPORTED'),
  rateLimited('RATE_LIMITED'),
  adapterError('ADAPTER_ERROR'),
  runtimeError('RUNTIME_ERROR'),
  transientUnavailable('TRANSIENT_UNAVAILABLE'),
  internalError('INTERNAL_ERROR'),
  unknown('');

  const AscpErrorCode(this.value);

  final String value;

  static AscpErrorCode fromValue(String value) {
    for (final code in AscpErrorCode.values) {
      if (code.value == value) {
        return code;
      }
    }
    return AscpErrorCode.unknown;
  }
}

class AscpError {
  const AscpError({
    required this.code,
    required this.message,
    required this.retryable,
    this.details,
    this.correlationId,
    this.rawCode,
    this.extra = const {},
  });

  factory AscpError.fromJson(Map<String, Object?> json) {
    final codeValue = _expectString(json, 'code');
    final knownFields = <String>{
      'code',
      'message',
      'retryable',
      'details',
      'correlation_id',
    };

    return AscpError(
      code: AscpErrorCode.fromValue(codeValue),
      rawCode: codeValue,
      message: _expectString(json, 'message'),
      retryable: _expectBool(json, 'retryable'),
      details: json['details'],
      correlationId: json['correlation_id'] as String?,
      extra: Map.unmodifiable(
        Map.fromEntries(json.entries.where((entry) => !knownFields.contains(entry.key))),
      ),
    );
  }

  final AscpErrorCode code;
  final String? rawCode;
  final String message;
  final bool retryable;
  final Object? details;
  final String? correlationId;
  final Map<String, Object?> extra;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'code': rawCode ?? code.value,
      'message': message,
      'retryable': retryable,
      if (details != null) 'details': details,
      if (correlationId != null) 'correlation_id': correlationId,
      ...extra,
    };
  }
}

String _expectString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String) {
    return value;
  }
  throw FormatException('Expected string field "$key".');
}

bool _expectBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  throw FormatException('Expected boolean field "$key".');
}
