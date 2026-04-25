import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/core_models.dart';

part 'sync_events.freezed.dart';
part 'sync_events.g.dart';

@freezed
abstract class AscpSyncSnapshotPayload with _$AscpSyncSnapshotPayload {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSyncSnapshotPayload({
    required AscpSession session,
    @JsonKey(name: 'active_run') AscpRun? activeRun,
    @JsonKey(name: 'pending_approvals')
    @Default(<AscpApprovalRequest>[])
    List<AscpApprovalRequest> pendingApprovals,
    Map<String, Object?>? summary,
  }) = _AscpSyncSnapshotPayload;

  factory AscpSyncSnapshotPayload.fromJson(Map<String, Object?> json) =>
      _$AscpSyncSnapshotPayloadFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSyncSnapshotEvent with _$AscpSyncSnapshotEvent {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSyncSnapshotEvent({
    required String id,
    required String type,
    required String ts,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    int? seq,
    required AscpSyncSnapshotPayload payload,
  }) = _AscpSyncSnapshotEvent;

  factory AscpSyncSnapshotEvent.fromJson(Map<String, Object?> json) =>
      _$AscpSyncSnapshotEventFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSyncReplayedPayload with _$AscpSyncReplayedPayload {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSyncReplayedPayload({
    @JsonKey(name: 'from_seq') required int fromSeq,
    @JsonKey(name: 'to_seq') required int toSeq,
    @JsonKey(name: 'event_count') required int eventCount,
  }) = _AscpSyncReplayedPayload;

  factory AscpSyncReplayedPayload.fromJson(Map<String, Object?> json) =>
      _$AscpSyncReplayedPayloadFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSyncReplayedEvent with _$AscpSyncReplayedEvent {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSyncReplayedEvent({
    required String id,
    required String type,
    required String ts,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    int? seq,
    required AscpSyncReplayedPayload payload,
  }) = _AscpSyncReplayedEvent;

  factory AscpSyncReplayedEvent.fromJson(Map<String, Object?> json) =>
      _$AscpSyncReplayedEventFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSyncCursorAdvancedPayload
    with _$AscpSyncCursorAdvancedPayload {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSyncCursorAdvancedPayload({required String cursor}) =
      _AscpSyncCursorAdvancedPayload;

  factory AscpSyncCursorAdvancedPayload.fromJson(Map<String, Object?> json) =>
      _$AscpSyncCursorAdvancedPayloadFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSyncCursorAdvancedEvent with _$AscpSyncCursorAdvancedEvent {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSyncCursorAdvancedEvent({
    required String id,
    required String type,
    required String ts,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    int? seq,
    required AscpSyncCursorAdvancedPayload payload,
  }) = _AscpSyncCursorAdvancedEvent;

  factory AscpSyncCursorAdvancedEvent.fromJson(Map<String, Object?> json) =>
      _$AscpSyncCursorAdvancedEventFromJson(json.cast<String, dynamic>());
}
