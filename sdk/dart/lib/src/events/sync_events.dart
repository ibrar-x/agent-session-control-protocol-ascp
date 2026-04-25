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
    required List<AscpApprovalRequest> pendingApprovals,
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
