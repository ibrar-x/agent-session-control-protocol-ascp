import 'dart:async';
import 'dart:convert';

import '../models/envelopes.dart';
import '../models/json_types.dart';
import 'transport.dart';
import 'transport_errors.dart';

final class _PendingRequest {
  _PendingRequest({required this.method, required this.completer, this.timer});

  final String method;
  final Completer<AscpTransportResponse> completer;
  final Timer? timer;

  void dispose() {
    timer?.cancel();
  }
}

abstract class BaseAscpTransport implements AscpTransport {
  BaseAscpTransport(this.kind);

  @override
  final String kind;

  final StreamController<AscpEventEnvelope> _events =
      StreamController<AscpEventEnvelope>.broadcast();
  final Map<Object?, _PendingRequest> _pendingRequests =
      <Object?, _PendingRequest>{};
  int _nextRequestId = 1;
  bool _closed = false;
  bool _connected = false;
  Future<void>? _connectFuture;

  @override
  Stream<AscpEventEnvelope> get events => _events.stream;

  @override
  Future<void> connect() {
    if (_closed) {
      return Future<void>.error(
        AscpTransportException(
          code: AscpTransportErrorCode.closed,
          transport: kind,
          message: '$kind transport is already closed.',
          retryable: false,
        ),
      );
    }

    if (_connected) {
      return Future<void>.value();
    }

    final existing = _connectFuture;
    if (existing != null) {
      return existing;
    }

    final future = openConnection()
        .then((_) {
          _connected = true;
        })
        .catchError((Object error, StackTrace stackTrace) {
          throw _normalizeTransportException(
            error,
            code: AscpTransportErrorCode.connection,
            message: 'Failed to connect $kind transport.',
          );
        })
        .whenComplete(() {
          _connectFuture = null;
        });

    _connectFuture = future;
    return future;
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }

    _closed = true;
    _connected = false;
    _failPendingRequests(
      AscpTransportException(
        code: AscpTransportErrorCode.closed,
        transport: kind,
        message: '$kind transport closed.',
        retryable: false,
      ),
    );
    await closeConnection();
    await _events.close();
  }

  @override
  Future<AscpTransportResponse> request(
    String method, {
    AscpJsonMap? params,
    AscpTransportRequestOptions? options,
  }) async {
    await connect();

    final requestId = _nextRequestId++;
    final completer = Completer<AscpTransportResponse>();
    Timer? timer;

    final timeout = options?.timeout;
    if (timeout != null) {
      timer = Timer(timeout, () {
        final pending = _pendingRequests.remove(requestId);
        pending?.dispose();
        if (pending != null && !pending.completer.isCompleted) {
          pending.completer.completeError(
            AscpTransportException(
              code: AscpTransportErrorCode.timeout,
              transport: kind,
              message:
                  '$method request timed out after ${timeout.inMilliseconds}ms.',
              details: <String, Object?>{
                'method': method,
                'timeout_ms': timeout.inMilliseconds,
              },
            ),
          );
        }
      });
    }

    _pendingRequests[requestId] = _PendingRequest(
      method: method,
      completer: completer,
      timer: timer,
    );

    final requestEnvelope = AscpRequestEnvelope(
      jsonrpc: '2.0',
      id: requestId,
      method: method,
      params: params,
    );

    try {
      await sendSerialized(jsonEncode(requestEnvelope.toJson()));
    } catch (error) {
      final pending = _pendingRequests.remove(requestId);
      pending?.dispose();
      throw _normalizeTransportException(
        error,
        code: AscpTransportErrorCode.io,
        message: 'Failed to send $method over $kind transport.',
        details: <String, Object?>{'method': method},
      );
    }

    return completer.future;
  }

  void handleSerializedMessage(String messageText) {
    Object? decoded;
    try {
      decoded = jsonDecode(messageText);
    } catch (error) {
      final exception = _normalizeTransportException(
        error,
        code: AscpTransportErrorCode.protocol,
        message: 'Received malformed JSON over $kind transport.',
        details: <String, Object?>{'raw': messageText},
      );
      _failPendingRequests(exception);
      _events.addError(exception);
      return;
    }

    final json = _coerceJsonMap(
      decoded,
      code: AscpTransportErrorCode.protocol,
      message: 'Received a non-object payload over $kind transport.',
    );

    if (json.containsKey('jsonrpc') &&
        (json.containsKey('result') || json.containsKey('error'))) {
      _handleResponse(json);
      return;
    }

    try {
      _events.add(AscpEventEnvelope.fromJson(json));
    } catch (error) {
      final exception = _normalizeTransportException(
        error,
        code: AscpTransportErrorCode.protocol,
        message: 'Received an invalid event envelope over $kind transport.',
      );
      _failPendingRequests(exception);
      _events.addError(exception);
    }
  }

  void handleConnectionFailure(
    Object error, {
    required String message,
    Map<String, Object?>? details,
  }) {
    if (_closed) {
      return;
    }

    _connected = false;
    final exception = _normalizeTransportException(
      error,
      code: AscpTransportErrorCode.connection,
      message: message,
      details: details,
    );
    _failPendingRequests(exception);
    _events.addError(exception);
  }

  AscpTransportException _normalizeTransportException(
    Object error, {
    required String code,
    required String message,
    Map<String, Object?>? details,
    bool retryable = true,
  }) {
    if (error is AscpTransportException) {
      return error;
    }

    return AscpTransportException(
      code: code,
      transport: kind,
      message: message,
      details: details,
      retryable: retryable,
      cause: error,
    );
  }

  AscpJsonMap _coerceJsonMap(
    Object? value, {
    required String code,
    required String message,
  }) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return value.cast<String, Object?>();
    }
    throw AscpTransportException(
      code: code,
      transport: kind,
      message: message,
      retryable: false,
    );
  }

  void _failPendingRequests(AscpTransportException exception) {
    final entries = _pendingRequests.entries.toList(growable: false);
    _pendingRequests.clear();
    for (final entry in entries) {
      entry.value.dispose();
      if (!entry.value.completer.isCompleted) {
        entry.value.completer.completeError(exception);
      }
    }
  }

  void _handleResponse(AscpJsonMap json) {
    final requestId = json['id'];
    final pending = _pendingRequests.remove(requestId);
    if (pending == null) {
      return;
    }

    pending.dispose();

    if (json.containsKey('error')) {
      pending.completer.complete(AscpTransportErrorResponse.fromJson(json));
      return;
    }

    pending.completer.complete(AscpTransportSuccessResponse.fromJson(json));
  }

  Future<void> closeConnection();
  Future<void> openConnection();
  Future<void> sendSerialized(String messageText);
}
