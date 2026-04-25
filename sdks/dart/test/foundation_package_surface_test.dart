import 'dart:convert';
import 'dart:io';

import 'package:ascp_sdk_dart/ascp_sdk_dart.dart';
import 'package:ascp_sdk_dart/client.dart' as client_library;
import 'package:ascp_sdk_dart/errors.dart' as errors_library;
import 'package:ascp_sdk_dart/events.dart' as events_library;
import 'package:ascp_sdk_dart/methods.dart' as methods_library;
import 'package:ascp_sdk_dart/models.dart' as models_library;
import 'package:ascp_sdk_dart/replay.dart' as replay_library;
import 'package:ascp_sdk_dart/transport.dart' as transport_library;
import 'package:ascp_sdk_dart/validation.dart' as validation_library;
import 'package:test/test.dart';

void main() {
  group('Dart SDK foundation package surface', () {
    test('all planned libraries are importable', () {
      expect(client_library.AscpClient, isNotNull);
      expect(errors_library.AscpProtocolError, isNotNull);
      expect(events_library.AscpSyncSnapshotEvent, isNotNull);
      expect(methods_library.AscpSessionSubscriptionAccepted, isNotNull);
      expect(models_library.AscpSession, isNotNull);
      expect(replay_library.replayFromSeq, isNotNull);
      expect(transport_library.AscpTransportSuccessResponse, isNotNull);
      expect(validation_library.AscpValidationHooks, isNotNull);
    });

    test(
      'decodes the upstream Session example with protocol field names intact',
      () async {
        final json = await _readJson('../../../protocol/examples/core/session.json');

        final session = AscpSession.fromJson(json);

        expect(session.id, 'sess_abc123');
        expect(session.runtimeId, 'codex_local');
        expect(session.metadata, containsPair('source', 'codex'));
        expect(session.toJson()['runtime_id'], 'codex_local');
      },
    );

    test('decodes the upstream event envelope example', () async {
      final json = await _readJson('../../../protocol/examples/events/event-envelope.json');

      final event = AscpEventEnvelope.fromJson(json);

      expect(event.id, 'evt_9001');
      expect(event.type, 'message.assistant.delta');
      expect(event.sessionId, 'sess_abc123');
      expect(event.payload['delta'], 'I found the failing assertion...');
      expect(event.toJson()['session_id'], 'sess_abc123');
    });

    test('decodes the upstream subscribe success result', () async {
      final json = await _readJson(
        '../../../protocol/examples/responses/sessions-subscribe.json',
      );

      final response =
          AscpMethodSuccessResponse<AscpSessionSubscriptionAccepted>.fromJson(
            json,
            (resultJson) => AscpSessionSubscriptionAccepted.fromJson(
              resultJson as Map<String, Object?>,
            ),
          );

      expect(response.jsonrpc, '2.0');
      expect(response.id, 'req_sub_1');
      expect(response.result.subscriptionId, 'sub_01');
      expect(response.result.snapshotEmitted, isTrue);
    });

    test(
      'decodes the upstream sync snapshot event into a typed payload',
      () async {
        final json = await _readJson(
          '../../../protocol/examples/events/sync-snapshot.json',
        );

        final event = AscpSyncSnapshotEvent.fromJson(json);

        expect(event.type, 'sync.snapshot');
        expect(event.payload.session.id, 'sess_abc123');
        expect(event.payload.activeRun?.id, 'run_9');
        expect(event.payload.pendingApprovals, isEmpty);
      },
    );
  });
}

Future<Map<String, Object?>> _readJson(String relativePath) async {
  final file = File(relativePath);
  final content = await file.readAsString();

  return jsonDecode(content) as Map<String, Object?>;
}
