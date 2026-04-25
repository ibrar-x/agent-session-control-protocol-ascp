// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AscpSyncSnapshotPayload _$AscpSyncSnapshotPayloadFromJson(
  Map<String, dynamic> json,
) => _AscpSyncSnapshotPayload(
  session: AscpSession.fromJson(json['session'] as Map<String, dynamic>),
  activeRun: json['active_run'] == null
      ? null
      : AscpRun.fromJson(json['active_run'] as Map<String, dynamic>),
  pendingApprovals:
      (json['pending_approvals'] as List<dynamic>?)
          ?.map((e) => AscpApprovalRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AscpApprovalRequest>[],
  summary: json['summary'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AscpSyncSnapshotPayloadToJson(
  _AscpSyncSnapshotPayload instance,
) => <String, dynamic>{
  'session': instance.session.toJson(),
  'active_run': instance.activeRun?.toJson(),
  'pending_approvals': instance.pendingApprovals
      .map((e) => e.toJson())
      .toList(),
  'summary': instance.summary,
};

_AscpSyncSnapshotEvent _$AscpSyncSnapshotEventFromJson(
  Map<String, dynamic> json,
) => _AscpSyncSnapshotEvent(
  id: json['id'] as String,
  type: json['type'] as String,
  ts: json['ts'] as String,
  sessionId: json['session_id'] as String,
  runId: json['run_id'] as String?,
  seq: (json['seq'] as num?)?.toInt(),
  payload: AscpSyncSnapshotPayload.fromJson(
    json['payload'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AscpSyncSnapshotEventToJson(
  _AscpSyncSnapshotEvent instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'ts': instance.ts,
  'session_id': instance.sessionId,
  'run_id': instance.runId,
  'seq': instance.seq,
  'payload': instance.payload.toJson(),
};

_AscpSyncReplayedPayload _$AscpSyncReplayedPayloadFromJson(
  Map<String, dynamic> json,
) => _AscpSyncReplayedPayload(
  fromSeq: (json['from_seq'] as num).toInt(),
  toSeq: (json['to_seq'] as num).toInt(),
  eventCount: (json['event_count'] as num).toInt(),
);

Map<String, dynamic> _$AscpSyncReplayedPayloadToJson(
  _AscpSyncReplayedPayload instance,
) => <String, dynamic>{
  'from_seq': instance.fromSeq,
  'to_seq': instance.toSeq,
  'event_count': instance.eventCount,
};

_AscpSyncReplayedEvent _$AscpSyncReplayedEventFromJson(
  Map<String, dynamic> json,
) => _AscpSyncReplayedEvent(
  id: json['id'] as String,
  type: json['type'] as String,
  ts: json['ts'] as String,
  sessionId: json['session_id'] as String,
  runId: json['run_id'] as String?,
  seq: (json['seq'] as num?)?.toInt(),
  payload: AscpSyncReplayedPayload.fromJson(
    json['payload'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AscpSyncReplayedEventToJson(
  _AscpSyncReplayedEvent instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'ts': instance.ts,
  'session_id': instance.sessionId,
  'run_id': instance.runId,
  'seq': instance.seq,
  'payload': instance.payload.toJson(),
};

_AscpSyncCursorAdvancedPayload _$AscpSyncCursorAdvancedPayloadFromJson(
  Map<String, dynamic> json,
) => _AscpSyncCursorAdvancedPayload(cursor: json['cursor'] as String);

Map<String, dynamic> _$AscpSyncCursorAdvancedPayloadToJson(
  _AscpSyncCursorAdvancedPayload instance,
) => <String, dynamic>{'cursor': instance.cursor};

_AscpSyncCursorAdvancedEvent _$AscpSyncCursorAdvancedEventFromJson(
  Map<String, dynamic> json,
) => _AscpSyncCursorAdvancedEvent(
  id: json['id'] as String,
  type: json['type'] as String,
  ts: json['ts'] as String,
  sessionId: json['session_id'] as String,
  runId: json['run_id'] as String?,
  seq: (json['seq'] as num?)?.toInt(),
  payload: AscpSyncCursorAdvancedPayload.fromJson(
    json['payload'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AscpSyncCursorAdvancedEventToJson(
  _AscpSyncCursorAdvancedEvent instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'ts': instance.ts,
  'session_id': instance.sessionId,
  'run_id': instance.runId,
  'seq': instance.seq,
  'payload': instance.payload.toJson(),
};
