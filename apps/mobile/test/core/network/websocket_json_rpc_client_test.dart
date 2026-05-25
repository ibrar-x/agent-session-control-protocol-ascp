import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/ascp/ascp_error.dart';
import 'package:mobile/core/ascp/ascp_event.dart';
import 'package:mobile/core/ascp/ascp_method.dart';
import 'package:mobile/core/network/http_json_rpc_client.dart';
import 'package:mobile/core/network/websocket_json_rpc_client.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  test('WebSocket JSON-RPC client correlates responses by id', () async {
    final channel = _FakeWebSocketChannel();
    final client = WebSocketJsonRpcClient(channel: channel);

    final pending = client.call(id: 'req_1', method: AscpMethod.sessionsSubscribe);
    channel.serverSend({
      'jsonrpc': '2.0',
      'id': 'req_1',
      'result': {'subscription_id': 'sub_1'},
    });

    expect(await pending, {'subscription_id': 'sub_1'});
    expect(jsonDecode(channel.sent.single as String), {
      'jsonrpc': '2.0',
      'id': 'req_1',
      'method': 'sessions.subscribe',
      'params': <String, Object?>{},
    });

    await client.close();
  });

  test('WebSocket JSON-RPC client emits event envelopes', () async {
    final channel = _FakeWebSocketChannel();
    final client = WebSocketJsonRpcClient(channel: channel);

    final eventFuture = client.events.first;
    channel.serverSend({
      'id': 'evt_1',
      'type': 'sync.replayed',
      'ts': '2026-05-25T11:00:00Z',
      'session_id': 'sess_1',
      'payload': {'from_seq': 4, 'to_seq': 8},
    });

    final event = await eventFuture;
    expect(event.type, AscpEventType.syncReplayed);
    expect(event.payload, {'from_seq': 4, 'to_seq': 8});

    await client.close();
  });

  test('WebSocket JSON-RPC client completes protocol errors as exceptions', () async {
    final channel = _FakeWebSocketChannel();
    final client = WebSocketJsonRpcClient(channel: channel);

    final pending = client.call(id: 'req_1', method: AscpMethod.approvalsRespond);
    channel.serverSend({
      'jsonrpc': '2.0',
      'id': 'req_1',
      'error': {
        'code': 'UNSUPPORTED',
        'message': 'approval_respond capability is false',
        'retryable': false,
      },
    });

    await expectLater(
      pending,
      throwsA(
        isA<AscpJsonRpcException>().having(
          (error) => error.error.code,
          'code',
          AscpErrorCode.unsupported,
        ),
      ),
    );

    await client.close();
  });
}

class _FakeWebSocketChannel extends StreamChannelMixin implements WebSocketChannel {
  final _incoming = StreamController<Object?>();
  final _outgoing = StreamController<Object?>();
  final List<Object?> sent = [];

  _FakeWebSocketChannel() {
    _outgoing.stream.listen(sent.add);
  }

  void serverSend(Map<String, Object?> json) {
    _incoming.add(jsonEncode(json));
  }

  @override
  Stream get stream => _incoming.stream;

  @override
  WebSocketSink get sink => _FakeWebSocketSink(_outgoing);

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  String? get protocol => null;

  @override
  Future<void> get ready => Future.value();
}

class _FakeWebSocketSink implements WebSocketSink {
  _FakeWebSocketSink(this._controller);

  final StreamController<Object?> _controller;

  @override
  void add(Object? data) {
    _controller.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  @override
  Future<void> addStream(Stream stream) => _controller.addStream(stream);

  @override
  Future<void> close([int? closeCode, String? closeReason]) => _controller.close();

  @override
  Future<void> get done => _controller.done;
}
