import 'package:ascp_sdk_dart/ascp_sdk_dart.dart';

void main() {
  final session = AscpSession.fromJson(<String, Object?>{
    'id': 'sess_abc123',
    'runtime_id': 'codex_local',
    'status': 'running',
    'created_at': '2026-04-21T10:00:00Z',
    'updated_at': '2026-04-21T10:12:00Z',
  });

  final event = AscpEventEnvelope.fromJson(<String, Object?>{
    'id': 'evt_9001',
    'type': 'message.assistant.delta',
    'ts': '2026-04-21T10:07:00Z',
    'session_id': session.id,
    'payload': <String, Object?>{
      'message_id': 'msg_12',
      'delta': 'I found the failing assertion...',
    },
  });

  print(session.toJson());
  print(event.toJson());
}
