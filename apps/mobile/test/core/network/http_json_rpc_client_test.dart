import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/ascp/ascp_error.dart';
import 'package:mobile/core/ascp/ascp_method.dart';
import 'package:mobile/core/network/http_json_rpc_client.dart';

void main() {
  test('HTTP JSON-RPC client returns result payload', () async {
    final dio = Dio()
      ..httpClientAdapter = _FakeAdapter((request) {
        expect(request.method, 'POST');
        return ResponseBody.fromString(
          '{"jsonrpc":"2.0","id":"req_1","result":{"ok":true}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

    final client = HttpJsonRpcClient(dio: dio, endpoint: Uri.parse('https://host.test/rpc'));

    final result = await client.call(
      id: 'req_1',
      method: AscpMethod.capabilitiesGet,
    );

    expect(result, {'ok': true});
  });

  test('HTTP JSON-RPC client maps protocol error response', () async {
    final dio = Dio()
      ..httpClientAdapter = _FakeAdapter((request) {
        return ResponseBody.fromString(
          '{"jsonrpc":"2.0","id":"req_1","error":{"code":"UNAUTHORIZED","message":"Missing token","retryable":false}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

    final client = HttpJsonRpcClient(dio: dio, endpoint: Uri.parse('https://host.test/rpc'));

    expect(
      () => client.call(id: 'req_1', method: AscpMethod.sessionsList),
      throwsA(
        isA<AscpJsonRpcException>().having(
          (error) => error.error.code,
          'code',
          AscpErrorCode.unauthorized,
        ),
      ),
    );
  });
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final ResponseBody Function(RequestOptions request) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }
}
