import 'package:dio/dio.dart';

import '../ascp/ascp_envelope.dart';
import '../ascp/ascp_error.dart';
import '../ascp/ascp_method.dart';

class HttpJsonRpcClient {
  HttpJsonRpcClient({
    required Dio dio,
    required this.endpoint,
  }) : _dio = dio;

  final Dio _dio;
  final Uri endpoint;

  Future<Object?> call({
    required Object id,
    required AscpMethod method,
    Map<String, Object?> params = const {},
  }) async {
    final request = AscpRequest(id: id, method: method, params: params);
    final response = await _dio.postUri<Object?>(
      endpoint,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    final body = response.data;
    if (body is! Map) {
      throw const FormatException('Expected JSON-RPC response object.');
    }

    final envelope = AscpResponse.fromJson(Map<String, Object?>.from(body));
    if (envelope.error != null) {
      throw AscpJsonRpcException(envelope.error!);
    }
    return envelope.result;
  }
}

class AscpJsonRpcException implements Exception {
  const AscpJsonRpcException(this.error);

  final AscpError error;

  @override
  String toString() => 'AscpJsonRpcException(${error.code.value}: ${error.message})';
}
