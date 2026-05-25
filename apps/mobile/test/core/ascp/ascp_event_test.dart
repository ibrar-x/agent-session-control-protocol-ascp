import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/ascp/ascp_event.dart';

void main() {
  test('event names stay exact', () {
    expect(AscpEventType.sessionStatusChanged.value, 'session.status_changed');
    expect(AscpEventType.messageAssistantDelta.value, 'message.assistant.delta');
    expect(AscpEventType.approvalRequested.value, 'approval.requested');
    expect(AscpEventType.syncReplayed.value, 'sync.replayed');
    expect(AscpEventType.errorFatal.value, 'error.fatal');
  });

  test('event envelope preserves unknown payload fields', () {
    final event = AscpEventEnvelope.fromJson({
      'id': 'evt_1',
      'type': 'session.updated',
      'ts': '2026-05-25T11:00:00Z',
      'session_id': 'sess_1',
      'run_id': 'run_1',
      'seq': 42,
      'payload': {
        'session_id': 'sess_1',
        'status': 'running',
        'x_future_field': {'kept': true},
      },
    });

    expect(event.type, AscpEventType.sessionUpdated);
    expect(event.sequence, 42);
    expect(event.payload['x_future_field'], {'kept': true});
    expect(event.toJson()['payload'], containsPair('x_future_field', {'kept': true}));
  });

  test('unknown event type is accepted as extension-safe value', () {
    final event = AscpEventEnvelope.fromJson({
      'id': 'evt_2',
      'type': 'x.vendor.custom',
      'ts': '2026-05-25T11:00:00Z',
      'session_id': 'sess_1',
      'payload': {'ok': true},
    });

    expect(event.type, AscpEventType.unknown);
    expect(event.rawType, 'x.vendor.custom');
    expect(event.toJson()['type'], 'x.vendor.custom');
  });
}
