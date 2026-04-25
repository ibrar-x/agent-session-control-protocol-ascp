import 'dart:async';

import 'package:ascp_sdk_dart/client.dart';
import 'package:ascp_sdk_dart/methods.dart';
import 'package:ascp_sdk_dart/models.dart';
import 'package:ascp_sdk_dart/transport.dart';
import 'package:ascp_sdk_dart/validation.dart';
import 'package:test/test.dart';

void main() {
  group('validation hooks', () {
    test(
      'validate outgoing params, incoming result payloads, and streamed events',
      () async {
        final observed = <String>[];
        final transport = _ValidationTransport();
        final client = AscpClient(
          transport: transport,
          validationHooks: AscpValidationHooks(
            validateParams: (method, params) {
              observed.add('params:$method:${params['session_id']}');
            },
            validateResult: (method, result) {
              observed.add('result:$method:${result.keys.join(',')}');
            },
            validateEvent: (event) {
              observed.add('event:${event.type}');
            },
          ),
        );

        transport.response = const AscpTransportSuccessResponse(
          jsonrpc: '2.0',
          id: 'req_get_1',
          result: <String, Object?>{
            'session': <String, Object?>{
              'id': 'sess_abc123',
              'runtime_id': 'codex_local',
              'status': 'running',
              'created_at': '2026-04-21T10:00:00Z',
              'updated_at': '2026-04-21T10:12:00Z',
            },
            'runs': <Object?>[],
            'pending_approvals': <Object?>[],
          },
        );
        final eventFuture = client.events.first;
        transport.emit(
          const AscpEventEnvelope(
            id: 'evt_1',
            type: 'message.assistant.delta',
            ts: '2026-04-21T10:07:00Z',
            sessionId: 'sess_abc123',
            payload: <String, Object?>{
              'message_id': 'msg_12',
              'delta': 'I found the failing assertion...',
            },
          ),
        );

        final sessionResult = await client.getSession(
          const AscpSessionsGetParams(sessionId: 'sess_abc123'),
        );
        final event = await eventFuture;

        expect(sessionResult.session.id, 'sess_abc123');
        expect(event.type, 'message.assistant.delta');
        expect(
          observed,
          containsAll([
            'params:sessions.get:sess_abc123',
            startsWith('result:sessions.get:'),
            'event:message.assistant.delta',
          ]),
        );
      },
    );

    test(
      'throws a validation exception when a method result is not a JSON object',
      () async {
        final transport = _ValidationTransport()
          ..response = const AscpTransportSuccessResponse(
            jsonrpc: '2.0',
            id: 'req_cap_1',
            result: 'not-an-object',
          );
        final client = AscpClient(transport: transport);

        await expectLater(
          client.getCapabilities,
          throwsA(
            isA<AscpValidationException>().having(
              (error) => error.context,
              'context',
              'capabilities.get result',
            ),
          ),
        );
      },
    );
  });
}

final class _ValidationTransport implements AscpTransport {
  @override
  String get kind => 'validation-stub';

  final StreamController<AscpEventEnvelope> _events =
      StreamController<AscpEventEnvelope>.broadcast();
  AscpTransportResponse? response;

  @override
  Stream<AscpEventEnvelope> get events => _events.stream;

  @override
  Future<void> close() async {
    await _events.close();
  }

  @override
  Future<void> connect() async {}

  void emit(AscpEventEnvelope event) {
    _events.add(event);
  }

  @override
  Future<AscpTransportResponse> request(
    String method, {
    Map<String, Object?>? params,
    AscpTransportRequestOptions? options,
  }) async {
    if (response == null) {
      throw StateError('No response configured for $method.');
    }
    return response!;
  }
}
