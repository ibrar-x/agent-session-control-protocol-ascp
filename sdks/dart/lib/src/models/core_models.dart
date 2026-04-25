import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_models.freezed.dart';
part 'core_models.g.dart';

@freezed
abstract class AscpCapabilities with _$AscpCapabilities {
  @JsonSerializable(explicitToJson: true)
  const factory AscpCapabilities({
    @JsonKey(name: 'session_list') bool? sessionList,
    @JsonKey(name: 'session_resume') bool? sessionResume,
    @JsonKey(name: 'session_start') bool? sessionStart,
    @JsonKey(name: 'session_stop') bool? sessionStop,
    @JsonKey(name: 'stream_events') bool? streamEvents,
    @JsonKey(name: 'transcript_read') bool? transcriptRead,
    @JsonKey(name: 'message_send') bool? messageSend,
    @JsonKey(name: 'approval_requests') bool? approvalRequests,
    @JsonKey(name: 'approval_respond') bool? approvalRespond,
    bool? artifacts,
    bool? diffs,
    @JsonKey(name: 'terminal_passthrough') bool? terminalPassthrough,
    bool? notifications,
    bool? checkpoints,
    bool? replay,
    @JsonKey(name: 'multi_workspace') bool? multiWorkspace,
  }) = _AscpCapabilities;

  factory AscpCapabilities.fromJson(Map<String, Object?> json) =>
      _$AscpCapabilitiesFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpHost with _$AscpHost {
  @JsonSerializable(explicitToJson: true)
  const factory AscpHost({
    required String id,
    required String name,
    String? platform,
    String? arch,
    Map<String, Object?>? labels,
    String? status,
    List<String>? transports,
  }) = _AscpHost;

  factory AscpHost.fromJson(Map<String, Object?> json) =>
      _$AscpHostFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpRuntime with _$AscpRuntime {
  @JsonSerializable(explicitToJson: true)
  const factory AscpRuntime({
    required String id,
    required String kind,
    @JsonKey(name: 'display_name') required String displayName,
    required String version,
    @JsonKey(name: 'adapter_kind') String? adapterKind,
    AscpCapabilities? capabilities,
  }) = _AscpRuntime;

  factory AscpRuntime.fromJson(Map<String, Object?> json) =>
      _$AscpRuntimeFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSession with _$AscpSession {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSession({
    required String id,
    @JsonKey(name: 'runtime_id') required String runtimeId,
    String? title,
    String? workspace,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'last_activity_at') String? lastActivityAt,
    String? summary,
    @JsonKey(name: 'active_run_id') String? activeRunId,
    Map<String, Object?>? metadata,
  }) = _AscpSession;

  factory AscpSession.fromJson(Map<String, Object?> json) =>
      _$AscpSessionFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpRun with _$AscpRun {
  @JsonSerializable(explicitToJson: true)
  const factory AscpRun({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    required String status,
    @JsonKey(name: 'started_at') required String startedAt,
    @JsonKey(name: 'ended_at') String? endedAt,
    @JsonKey(name: 'exit_code') int? exitCode,
  }) = _AscpRun;

  factory AscpRun.fromJson(Map<String, Object?> json) =>
      _$AscpRunFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpApprovalRequest with _$AscpApprovalRequest {
  @JsonSerializable(explicitToJson: true)
  const factory AscpApprovalRequest({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    required String kind,
    required String status,
    String? title,
    String? description,
    @JsonKey(name: 'risk_level') String? riskLevel,
    Map<String, Object?>? payload,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'resolved_at') String? resolvedAt,
  }) = _AscpApprovalRequest;

  factory AscpApprovalRequest.fromJson(Map<String, Object?> json) =>
      _$AscpApprovalRequestFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpArtifact with _$AscpArtifact {
  @JsonSerializable(explicitToJson: true)
  const factory AscpArtifact({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    required String kind,
    String? name,
    String? uri,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'size_bytes') int? sizeBytes,
    @JsonKey(name: 'created_at') required String createdAt,
    Map<String, Object?>? metadata,
  }) = _AscpArtifact;

  factory AscpArtifact.fromJson(Map<String, Object?> json) =>
      _$AscpArtifactFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpDiffFile with _$AscpDiffFile {
  @JsonSerializable(explicitToJson: true)
  const factory AscpDiffFile({
    required String path,
    @JsonKey(name: 'change_type') required String changeType,
    int? insertions,
    int? deletions,
  }) = _AscpDiffFile;

  factory AscpDiffFile.fromJson(Map<String, Object?> json) =>
      _$AscpDiffFileFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpDiffSummary with _$AscpDiffSummary {
  @JsonSerializable(explicitToJson: true)
  const factory AscpDiffSummary({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    @JsonKey(name: 'files_changed') required int filesChanged,
    int? insertions,
    int? deletions,
    List<AscpDiffFile>? files,
  }) = _AscpDiffSummary;

  factory AscpDiffSummary.fromJson(Map<String, Object?> json) =>
      _$AscpDiffSummaryFromJson(json.cast<String, dynamic>());
}
