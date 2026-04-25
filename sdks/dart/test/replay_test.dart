import 'dart:async';

import 'package:ascp_sdk_dart/client.dart';
import 'package:ascp_sdk_dart/models.dart';
import 'package:ascp_sdk_dart/replay.dart';
import 'package:ascp_sdk_dart/transport.dart';
import 'package:test/test.dart';

void main() {
  group('replay helper layer', () {
    test(
      'replays historical events from from_seq and preserves replay and cursor boundaries',
      () async {
        final transport = _ReplayTransport();
        final client = AscpClient(transport: transport);

        transport.responses['sessions.subscribe'] =
            const AscpTransportSuccessResponse(
              jsonrpc: '2.0',
              id: 'req_sub_seq_1',
              result: <String, Object?>{
                'subscription_id': 'sub_replay_2',
                'session_id': 'sess_replay_1',
                'snapshot_emitted': false,
              },
            );
        transport.responses['sessions.unsubscribe'] =
            const AscpTransportSuccessResponse(
              jsonrpc: '2.0',
              id: 'req_unsub_seq_1',
              result: <String, Object?>{
                'subscription_id': 'sub_replay_2',
                'unsubscribed': true,
              },
            );

        final request = replayFromSeq(
          sessionId: 'sess_replay_1',
          fromSeq: 104,
          includeSnapshot: false,
        );

        expect(buildReplaySubscribeParams(request), <String, Object?>{
          'session_id': 'sess_replay_1',
          'from_seq': 104,
          'include_snapshot': false,
        });

        final subscription = await subscribeWithReplay(
          client: client,
          request: request,
        );

        transport.emitAll(<AscpEventEnvelope>[
          _event(
            id: 'evt_hist_104',
            type: 'message.user',
            sessionId: 'sess_replay_1',
            seq: 104,
          ),
          _event(
            id: 'evt_hist_105',
            type: 'message.assistant.delta',
            sessionId: 'sess_replay_1',
            seq: 105,
          ),
          _event(
            id: 'evt_hist_106',
            type: 'message.assistant.completed',
            sessionId: 'sess_replay_1',
            seq: 106,
          ),
          _event(
            id: 'evt_replayed_106',
            type: 'sync.replayed',
            sessionId: 'sess_replay_1',
            payload: const <String, Object?>{
              'from_seq': 104,
              'to_seq': 106,
              'event_count': 3,
            },
          ),
          _event(
            id: 'evt_live_107',
            type: 'message.assistant.delta',
            sessionId: 'sess_replay_1',
            seq: 107,
          ),
          _event(
            id: 'evt_cursor_107',
            type: 'sync.cursor_advanced',
            sessionId: 'sess_replay_1',
            payload: const <String, Object?>{'cursor': 'seq:107'},
          ),
        ]);

        final items = await subscription.stream.take(6).toList();

        expect(items.map((item) => item.kind), <String>[
          'replay_event',
          'replay_event',
          'replay_event',
          'replay_complete',
          'live_event',
          'cursor_advanced',
        ]);
        expect(subscription.subscribeResult.subscriptionId, 'sub_replay_2');
        expect(subscription.cursor, 'seq:107');
        expect(subscription.lastReplayed?.payload.eventCount, 3);
        expect(items.last.cursor, 'seq:107');
        expect(items.last.streamPhase, 'live');

        await subscription.close();

        expect(transport.recordedMethods.last, 'sessions.unsubscribe');
      },
    );

    test(
      'preserves snapshot and opaque cursor extensions without overwriting core subscribe params',
      () async {
        final request = replayWithOpaqueCursor(
          sessionId: 'sess_replay_1',
          includeSnapshot: true,
          extensionFields: const <String, Object?>{
            'cursor_token': 'opaque-123',
          },
        );

        expect(buildReplaySubscribeParams(request), <String, Object?>{
          'session_id': 'sess_replay_1',
          'include_snapshot': true,
          'cursor_token': 'opaque-123',
        });

        expect(
          () => replayWithOpaqueCursor(
            sessionId: 'sess_replay_1',
            extensionFields: const <String, Object?>{'from_seq': 104},
          ),
          throwsA(isA<AscpReplayConfigurationException>()),
        );
      },
    );
  });
}

AscpEventEnvelope _event({
  required String id,
  required String type,
  required String sessionId,
  int? seq,
  Map<String, Object?> payload = const <String, Object?>{},
}) {
  return AscpEventEnvelope(
    id: id,
    type: type,
    ts: '2026-04-22T08:16:00Z',
    sessionId: sessionId,
    seq: seq,
    payload: payload,
  );
}

final class _ReplayTransport implements AscpTransport {
  @override
  String get kind => 'stub';

  final StreamController<AscpEventEnvelope> _events =
      StreamController<AscpEventEnvelope>.broadcast();
  final Map<String, AscpTransportResponse> responses =
      <String, AscpTransportResponse>{};
  final List<String> recordedMethods = <String>[];

  @override
  Stream<AscpEventEnvelope> get events => _events.stream;

  @override
  Future<void> close() async {
    await _events.close();
  }

  @override
  Future<void> connect() async {}

  void emitAll(List<AscpEventEnvelope> events) {
    for (final event in events) {
      _events.add(event);
    }
  }

  @override
  Future<AscpTransportResponse> request(
    String method, {
    Map<String, Object?>? params,
    AscpTransportRequestOptions? options,
  }) async {
    recordedMethods.add(method);
    final response = responses[method];
    if (response == null) {
      throw StateError('No response configured for $method.');
    }
    return response;
  }
}
