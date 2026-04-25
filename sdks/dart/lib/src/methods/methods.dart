import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/core_models.dart';
import '../models/json_types.dart';

part 'methods.freezed.dart';
part 'methods.g.dart';

const List<String> ascpCoreMethodNames = <String>[
  'capabilities.get',
  'hosts.get',
  'runtimes.list',
  'sessions.list',
  'sessions.get',
  'sessions.start',
  'sessions.resume',
  'sessions.stop',
  'sessions.send_input',
  'sessions.subscribe',
  'sessions.unsubscribe',
  'approvals.list',
  'approvals.respond',
  'artifacts.list',
  'artifacts.get',
  'diffs.get',
];

@freezed
abstract class AscpCapabilitiesDocument with _$AscpCapabilitiesDocument {
  @JsonSerializable(explicitToJson: true)
  const factory AscpCapabilitiesDocument({
    @JsonKey(name: 'protocol_version') required String protocolVersion,
    required AscpHost host,
    required List<String> transports,
    required AscpCapabilities capabilities,
    required List<AscpRuntime> runtimes,
  }) = _AscpCapabilitiesDocument;

  factory AscpCapabilitiesDocument.fromJson(AscpJsonMap json) =>
      _$AscpCapabilitiesDocumentFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpHostsGetResult with _$AscpHostsGetResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpHostsGetResult({required AscpHost host}) =
      _AscpHostsGetResult;

  factory AscpHostsGetResult.fromJson(AscpJsonMap json) =>
      _$AscpHostsGetResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpRuntimesListParams with _$AscpRuntimesListParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpRuntimesListParams({
    String? kind,
    @JsonKey(name: 'adapter_kind') String? adapterKind,
  }) = _AscpRuntimesListParams;

  factory AscpRuntimesListParams.fromJson(AscpJsonMap json) =>
      _$AscpRuntimesListParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpRuntimesListResult with _$AscpRuntimesListResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpRuntimesListResult({required List<AscpRuntime> runtimes}) =
      _AscpRuntimesListResult;

  factory AscpRuntimesListResult.fromJson(AscpJsonMap json) =>
      _$AscpRuntimesListResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsListParams with _$AscpSessionsListParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsListParams({
    @JsonKey(name: 'runtime_id') String? runtimeId,
    String? status,
    String? workspace,
    @JsonKey(name: 'updated_after') String? updatedAfter,
    @JsonKey(name: 'search_text') String? searchText,
    int? limit,
    String? cursor,
  }) = _AscpSessionsListParams;

  factory AscpSessionsListParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsListParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsListResult with _$AscpSessionsListResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsListResult({
    required List<AscpSession> sessions,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _AscpSessionsListResult;

  factory AscpSessionsListResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsListResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsGetParams with _$AscpSessionsGetParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsGetParams({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'include_runs') bool? includeRuns,
    @JsonKey(name: 'include_pending_approvals') bool? includePendingApprovals,
  }) = _AscpSessionsGetParams;

  factory AscpSessionsGetParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsGetParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsGetResult with _$AscpSessionsGetResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsGetResult({
    required AscpSession session,
    @Default(<AscpRun>[]) List<AscpRun> runs,
    @JsonKey(name: 'pending_approvals')
    @Default(<AscpApprovalRequest>[])
    List<AscpApprovalRequest> pendingApprovals,
  }) = _AscpSessionsGetResult;

  factory AscpSessionsGetResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsGetResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsStartParams with _$AscpSessionsStartParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsStartParams({
    @JsonKey(name: 'runtime_id') required String runtimeId,
    String? workspace,
    String? title,
    @JsonKey(name: 'initial_prompt') String? initialPrompt,
    Map<String, Object?>? metadata,
  }) = _AscpSessionsStartParams;

  factory AscpSessionsStartParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsStartParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsStartResult with _$AscpSessionsStartResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsStartResult({required AscpSession session}) =
      _AscpSessionsStartResult;

  factory AscpSessionsStartResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsStartResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsResumeParams with _$AscpSessionsResumeParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsResumeParams({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'runtime_id') String? runtimeId,
  }) = _AscpSessionsResumeParams;

  factory AscpSessionsResumeParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsResumeParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsResumeResult with _$AscpSessionsResumeResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsResumeResult({
    required AscpSession session,
    @JsonKey(name: 'snapshot_emitted') bool? snapshotEmitted,
    @JsonKey(name: 'replay_supported') bool? replaySupported,
  }) = _AscpSessionsResumeResult;

  factory AscpSessionsResumeResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsResumeResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsStopParams with _$AscpSessionsStopParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsStopParams({
    @JsonKey(name: 'session_id') required String sessionId,
    String? mode,
    String? reason,
  }) = _AscpSessionsStopParams;

  factory AscpSessionsStopParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsStopParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsStopResult with _$AscpSessionsStopResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsStopResult({
    @JsonKey(name: 'session_id') required String sessionId,
    required String status,
  }) = _AscpSessionsStopResult;

  factory AscpSessionsStopResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsStopResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsSendInputParams with _$AscpSessionsSendInputParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsSendInputParams({
    @JsonKey(name: 'session_id') required String sessionId,
    required String input,
    @JsonKey(name: 'input_kind') String? inputKind,
    Map<String, Object?>? metadata,
  }) = _AscpSessionsSendInputParams;

  factory AscpSessionsSendInputParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsSendInputParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsSendInputResult with _$AscpSessionsSendInputResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsSendInputResult({
    @JsonKey(name: 'session_id') required String sessionId,
    required bool accepted,
  }) = _AscpSessionsSendInputResult;

  factory AscpSessionsSendInputResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsSendInputResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsSubscribeParams with _$AscpSessionsSubscribeParams {
  const AscpSessionsSubscribeParams._();

  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsSubscribeParams({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'from_seq') int? fromSeq,
    @JsonKey(name: 'from_event_id') String? fromEventId,
    @JsonKey(name: 'include_snapshot') bool? includeSnapshot,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(<String, Object?>{})
    Map<String, Object?> extensionFields,
  }) = _AscpSessionsSubscribeParams;

  factory AscpSessionsSubscribeParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsSubscribeParamsFromJson(json.cast<String, dynamic>());

  AscpJsonMap toTransportJson() {
    const reservedKeys = <String>{
      'session_id',
      'from_seq',
      'from_event_id',
      'include_snapshot',
    };
    final json = toJson();

    for (final entry in extensionFields.entries) {
      if (reservedKeys.contains(entry.key)) {
        throw ArgumentError.value(
          entry.key,
          'extensionFields',
          'Extension fields must not overwrite core subscribe params.',
        );
      }
      json[entry.key] = entry.value;
    }

    return json;
  }
}

@freezed
abstract class AscpSessionsSubscribeResult with _$AscpSessionsSubscribeResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsSubscribeResult({
    @JsonKey(name: 'subscription_id') required String subscriptionId,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'snapshot_emitted') bool? snapshotEmitted,
  }) = _AscpSessionsSubscribeResult;

  factory AscpSessionsSubscribeResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsSubscribeResultFromJson(json.cast<String, dynamic>());
}

typedef AscpSessionSubscriptionAccepted = AscpSessionsSubscribeResult;

@freezed
abstract class AscpSessionsUnsubscribeParams
    with _$AscpSessionsUnsubscribeParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpSessionsUnsubscribeParams({
    @JsonKey(name: 'subscription_id') required String subscriptionId,
  }) = _AscpSessionsUnsubscribeParams;

  factory AscpSessionsUnsubscribeParams.fromJson(AscpJsonMap json) =>
      _$AscpSessionsUnsubscribeParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpSessionsUnsubscribeResult
    with _$AscpSessionsUnsubscribeResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionsUnsubscribeResult({
    @JsonKey(name: 'subscription_id') required String subscriptionId,
    required bool unsubscribed,
  }) = _AscpSessionsUnsubscribeResult;

  factory AscpSessionsUnsubscribeResult.fromJson(AscpJsonMap json) =>
      _$AscpSessionsUnsubscribeResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpApprovalsListParams with _$AscpApprovalsListParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpApprovalsListParams({
    @JsonKey(name: 'session_id') String? sessionId,
    String? status,
    int? limit,
    String? cursor,
  }) = _AscpApprovalsListParams;

  factory AscpApprovalsListParams.fromJson(AscpJsonMap json) =>
      _$AscpApprovalsListParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpApprovalsListResult with _$AscpApprovalsListResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpApprovalsListResult({
    required List<AscpApprovalRequest> approvals,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _AscpApprovalsListResult;

  factory AscpApprovalsListResult.fromJson(AscpJsonMap json) =>
      _$AscpApprovalsListResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpApprovalsRespondParams with _$AscpApprovalsRespondParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpApprovalsRespondParams({
    @JsonKey(name: 'approval_id') required String approvalId,
    required String decision,
    String? note,
  }) = _AscpApprovalsRespondParams;

  factory AscpApprovalsRespondParams.fromJson(AscpJsonMap json) =>
      _$AscpApprovalsRespondParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpApprovalsRespondResult with _$AscpApprovalsRespondResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpApprovalsRespondResult({
    @JsonKey(name: 'approval_id') required String approvalId,
    required String status,
  }) = _AscpApprovalsRespondResult;

  factory AscpApprovalsRespondResult.fromJson(AscpJsonMap json) =>
      _$AscpApprovalsRespondResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpArtifactsListParams with _$AscpArtifactsListParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpArtifactsListParams({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    String? kind,
  }) = _AscpArtifactsListParams;

  factory AscpArtifactsListParams.fromJson(AscpJsonMap json) =>
      _$AscpArtifactsListParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpArtifactsListResult with _$AscpArtifactsListResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpArtifactsListResult({
    required List<AscpArtifact> artifacts,
  }) = _AscpArtifactsListResult;

  factory AscpArtifactsListResult.fromJson(AscpJsonMap json) =>
      _$AscpArtifactsListResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpArtifactsGetParams with _$AscpArtifactsGetParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpArtifactsGetParams({
    @JsonKey(name: 'artifact_id') required String artifactId,
  }) = _AscpArtifactsGetParams;

  factory AscpArtifactsGetParams.fromJson(AscpJsonMap json) =>
      _$AscpArtifactsGetParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpArtifactsGetResult with _$AscpArtifactsGetResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpArtifactsGetResult({required AscpArtifact artifact}) =
      _AscpArtifactsGetResult;

  factory AscpArtifactsGetResult.fromJson(AscpJsonMap json) =>
      _$AscpArtifactsGetResultFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpDiffsGetParams with _$AscpDiffsGetParams {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory AscpDiffsGetParams({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') required String runId,
  }) = _AscpDiffsGetParams;

  factory AscpDiffsGetParams.fromJson(AscpJsonMap json) =>
      _$AscpDiffsGetParamsFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpDiffsGetResult with _$AscpDiffsGetResult {
  @JsonSerializable(explicitToJson: true)
  const factory AscpDiffsGetResult({required AscpDiffSummary diff}) =
      _AscpDiffsGetResult;

  factory AscpDiffsGetResult.fromJson(AscpJsonMap json) =>
      _$AscpDiffsGetResultFromJson(json.cast<String, dynamic>());
}
