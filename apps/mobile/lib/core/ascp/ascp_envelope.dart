import 'ascp_error.dart';
import 'ascp_method.dart';

class AscpRequest {
  const AscpRequest({
    required this.id,
    required this.method,
    this.params = const {},
    this.rawMethod,
  });

  factory AscpRequest.fromJson(Map<String, Object?> json) {
    final methodValue = _expectString(json, 'method');
    return AscpRequest(
      id: json['id'],
      method: AscpMethod.fromValue(methodValue),
      rawMethod: methodValue,
      params: _mapOrEmpty(json['params'], 'params'),
    );
  }

  final Object? id;
  final AscpMethod method;
  final String? rawMethod;
  final Map<String, Object?> params;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'jsonrpc': '2.0',
      if (id != null) 'id': id,
      'method': rawMethod ?? method.value,
      'params': params,
    };
  }
}

class AscpResponse {
  const AscpResponse.success({
    required this.id,
    required this.result,
  }) : error = null;

  const AscpResponse.failure({
    required this.id,
    required this.error,
  }) : result = null;

  factory AscpResponse.fromJson(Map<String, Object?> json) {
    if (json['jsonrpc'] != '2.0') {
      throw const FormatException('Expected JSON-RPC 2.0 response.');
    }

    final hasResult = json.containsKey('result');
    final hasError = json.containsKey('error');
    if (hasResult == hasError) {
      throw const FormatException('Response must include exactly one of result or error.');
    }

    if (hasError) {
      final errorJson = json['error'];
      if (errorJson is! Map) {
        throw const FormatException('Expected error object.');
      }
      return AscpResponse.failure(
        id: json['id'],
        error: AscpError.fromJson(Map<String, Object?>.from(errorJson)),
      );
    }

    return AscpResponse.success(id: json['id'], result: json['result']);
  }

  final Object? id;
  final Object? result;
  final AscpError? error;

  bool get isSuccess => error == null;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'jsonrpc': '2.0',
      'id': id,
      if (isSuccess) 'result': result else 'error': error!.toJson(),
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

Map<String, Object?> _mapOrEmpty(Object? value, String key) {
  if (value == null) {
    return const {};
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  throw FormatException('Expected object field "$key".');
}
