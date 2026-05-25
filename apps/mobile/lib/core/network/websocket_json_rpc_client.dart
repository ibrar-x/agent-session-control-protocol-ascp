import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../ascp/ascp_envelope.dart';
import '../ascp/ascp_event.dart';
import '../ascp/ascp_method.dart';
import 'http_json_rpc_client.dart';

class WebSocketJsonRpcClient {
  WebSocketJsonRpcClient({required WebSocketChannel channel}) : _channel = channel {
    _subscription = _channel.stream.listen(
      _handleMessage,
      onError: _failAll,
      onDone: () => _failAll(StateError('WebSocket closed.')),
    );
  }

  final WebSocketChannel _channel;
  final _events = StreamController<AscpEventEnvelope>.broadcast();
  final _pending = <Object, Completer<Object?>>{};
  late final StreamSubscription<Object?> _subscription;

  Stream<AscpEventEnvelope> get events => _events.stream;

  Future<Object?> call({
    required Object id,
    required AscpMethod method,
    Map<String, Object?> params = const {},
  }) {
    final completer = Completer<Object?>();
    _pending[id] = completer;
    final request = AscpRequest(id: id, method: method, params: params);
    _channel.sink.add(jsonEncode(request.toJson()));
    return completer.future;
  }

  Future<void> close() async {
    await _subscription.cancel();
    await _events.close();
    await _channel.sink.close();
  }

  void _handleMessage(Object? message) {
    final decoded = _decodeObject(message);
    if (decoded.containsKey('jsonrpc')) {
      final response = AscpResponse.fromJson(decoded);
      final completer = _pending.remove(response.id);
      if (completer == null) {
        return;
      }
      final error = response.error;
      if (error != null) {
        completer.completeError(AscpJsonRpcException(error));
      } else {
        completer.complete(response.result);
      }
      return;
    }

    _events.add(AscpEventEnvelope.fromJson(decoded));
  }

  Map<String, Object?> _decodeObject(Object? message) {
    final decoded = switch (message) {
      final String text => jsonDecode(text),
      final List<int> bytes => jsonDecode(utf8.decode(bytes)),
      final Map object => object,
      _ => throw const FormatException('Expected JSON object message.'),
    };
    if (decoded is! Map) {
      throw const FormatException('Expected JSON object message.');
    }
    return Map<String, Object?>.from(decoded);
  }

  void _failAll(Object error, [StackTrace? stackTrace]) {
    for (final completer in _pending.values) {
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    }
    _pending.clear();
  }
}
