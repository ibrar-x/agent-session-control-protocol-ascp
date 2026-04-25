import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../auth/auth.dart';
import 'base_transport.dart';
import 'transport_errors.dart';

final class AscpWebSocketTransport extends BaseAscpTransport {
  AscpWebSocketTransport({
    required this.url,
    this.protocols,
    this.connectTimeout,
    this.headers,
    this.authHooks,
  }) : super('websocket');

  final Uri url;
  final Iterable<String>? protocols;
  final Duration? connectTimeout;
  final Map<String, String>? headers;
  final AscpTransportAuthHooks? authHooks;

  WebSocket? _socket;
  StreamSubscription<dynamic>? _subscription;
  bool _closing = false;

  Future<Map<String, String>> resolveHeaders() async {
    final mergedHeaders = <String, String>{...?headers};
    final provider = authHooks?.headers;
    if (provider == null) {
      return mergedHeaders;
    }

    final provided = await provider(
      AscpTransportAuthContext(transportKind: kind, url: url),
    );
    return <String, String>{...mergedHeaders, ...provided};
  }

  @override
  Future<void> closeConnection() async {
    _closing = true;
    await _subscription?.cancel();
    _subscription = null;
    final socket = _socket;
    _socket = null;
    await socket?.close();
  }

  @override
  Future<void> openConnection() async {
    if (_socket != null) {
      return;
    }

    _closing = false;
    final connectFuture = WebSocket.connect(
      url.toString(),
      headers: await resolveHeaders(),
      protocols: protocols,
    );
    final socket = connectTimeout == null
        ? await connectFuture
        : await connectFuture.timeout(connectTimeout!);
    _socket = socket;

    _subscription = socket.listen(
      (message) {
        if (message is String) {
          handleSerializedMessage(message);
          return;
        }
        if (message is List<int>) {
          handleSerializedMessage(utf8.decode(message));
          return;
        }
        handleSerializedMessage(message.toString());
      },
      onError: (Object error, StackTrace stackTrace) {
        if (_closing) {
          return;
        }
        handleConnectionFailure(
          error,
          message: 'websocket transport emitted an error.',
        );
      },
      onDone: () {
        _socket = null;
        if (_closing) {
          return;
        }
        handleConnectionFailure(
          AscpTransportException(
            code: AscpTransportErrorCode.connection,
            transport: kind,
            message: 'websocket transport closed unexpectedly.',
          ),
          message: 'websocket transport closed unexpectedly.',
        );
      },
      cancelOnError: false,
    );
  }

  @override
  Future<void> sendSerialized(String messageText) async {
    final socket = _socket;
    if (socket == null) {
      throw AscpTransportException(
        code: AscpTransportErrorCode.closed,
        transport: kind,
        message: 'websocket transport is not connected.',
        retryable: false,
      );
    }

    socket.add(messageText);
  }
}
