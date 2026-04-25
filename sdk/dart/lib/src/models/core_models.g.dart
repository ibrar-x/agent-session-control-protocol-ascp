// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AscpCapabilities _$AscpCapabilitiesFromJson(Map<String, dynamic> json) =>
    _AscpCapabilities(
      sessionList: json['session_list'] as bool?,
      sessionResume: json['session_resume'] as bool?,
      sessionStart: json['session_start'] as bool?,
      sessionStop: json['session_stop'] as bool?,
      streamEvents: json['stream_events'] as bool?,
      transcriptRead: json['transcript_read'] as bool?,
      messageSend: json['message_send'] as bool?,
      approvalRequests: json['approval_requests'] as bool?,
      approvalRespond: json['approval_respond'] as bool?,
      artifacts: json['artifacts'] as bool?,
      diffs: json['diffs'] as bool?,
      terminalPassthrough: json['terminal_passthrough'] as bool?,
      notifications: json['notifications'] as bool?,
      checkpoints: json['checkpoints'] as bool?,
      replay: json['replay'] as bool?,
      multiWorkspace: json['multi_workspace'] as bool?,
    );

Map<String, dynamic> _$AscpCapabilitiesToJson(_AscpCapabilities instance) =>
    <String, dynamic>{
      'session_list': instance.sessionList,
      'session_resume': instance.sessionResume,
      'session_start': instance.sessionStart,
      'session_stop': instance.sessionStop,
      'stream_events': instance.streamEvents,
      'transcript_read': instance.transcriptRead,
      'message_send': instance.messageSend,
      'approval_requests': instance.approvalRequests,
      'approval_respond': instance.approvalRespond,
      'artifacts': instance.artifacts,
      'diffs': instance.diffs,
      'terminal_passthrough': instance.terminalPassthrough,
      'notifications': instance.notifications,
      'checkpoints': instance.checkpoints,
      'replay': instance.replay,
      'multi_workspace': instance.multiWorkspace,
    };

_AscpHost _$AscpHostFromJson(Map<String, dynamic> json) => _AscpHost(
  id: json['id'] as String,
  name: json['name'] as String,
  platform: json['platform'] as String?,
  arch: json['arch'] as String?,
  labels: json['labels'] as Map<String, dynamic>?,
  status: json['status'] as String?,
  transports: (json['transports'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AscpHostToJson(_AscpHost instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'platform': instance.platform,
  'arch': instance.arch,
  'labels': instance.labels,
  'status': instance.status,
  'transports': instance.transports,
};

_AscpRuntime _$AscpRuntimeFromJson(Map<String, dynamic> json) => _AscpRuntime(
  id: json['id'] as String,
  kind: json['kind'] as String,
  displayName: json['display_name'] as String,
  version: json['version'] as String,
  adapterKind: json['adapter_kind'] as String?,
  capabilities: json['capabilities'] == null
      ? null
      : AscpCapabilities.fromJson(json['capabilities'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AscpRuntimeToJson(_AscpRuntime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'display_name': instance.displayName,
      'version': instance.version,
      'adapter_kind': instance.adapterKind,
      'capabilities': instance.capabilities?.toJson(),
    };

_AscpSession _$AscpSessionFromJson(Map<String, dynamic> json) => _AscpSession(
  id: json['id'] as String,
  runtimeId: json['runtime_id'] as String,
  title: json['title'] as String?,
  workspace: json['workspace'] as String?,
  status: json['status'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  lastActivityAt: json['last_activity_at'] as String?,
  summary: json['summary'] as String?,
  activeRunId: json['active_run_id'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AscpSessionToJson(_AscpSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'runtime_id': instance.runtimeId,
      'title': instance.title,
      'workspace': instance.workspace,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'last_activity_at': instance.lastActivityAt,
      'summary': instance.summary,
      'active_run_id': instance.activeRunId,
      'metadata': instance.metadata,
    };

_AscpRun _$AscpRunFromJson(Map<String, dynamic> json) => _AscpRun(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  status: json['status'] as String,
  startedAt: json['started_at'] as String,
  endedAt: json['ended_at'] as String?,
  exitCode: (json['exit_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$AscpRunToJson(_AscpRun instance) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'status': instance.status,
  'started_at': instance.startedAt,
  'ended_at': instance.endedAt,
  'exit_code': instance.exitCode,
};

_AscpApprovalRequest _$AscpApprovalRequestFromJson(Map<String, dynamic> json) =>
    _AscpApprovalRequest(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      runId: json['run_id'] as String?,
      kind: json['kind'] as String,
      status: json['status'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      riskLevel: json['risk_level'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
      resolvedAt: json['resolved_at'] as String?,
    );

Map<String, dynamic> _$AscpApprovalRequestToJson(
  _AscpApprovalRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'run_id': instance.runId,
  'kind': instance.kind,
  'status': instance.status,
  'title': instance.title,
  'description': instance.description,
  'risk_level': instance.riskLevel,
  'payload': instance.payload,
  'created_at': instance.createdAt,
  'resolved_at': instance.resolvedAt,
};

_AscpArtifact _$AscpArtifactFromJson(Map<String, dynamic> json) =>
    _AscpArtifact(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      runId: json['run_id'] as String?,
      kind: json['kind'] as String,
      name: json['name'] as String?,
      uri: json['uri'] as String?,
      mimeType: json['mime_type'] as String?,
      sizeBytes: (json['size_bytes'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AscpArtifactToJson(_AscpArtifact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'run_id': instance.runId,
      'kind': instance.kind,
      'name': instance.name,
      'uri': instance.uri,
      'mime_type': instance.mimeType,
      'size_bytes': instance.sizeBytes,
      'created_at': instance.createdAt,
      'metadata': instance.metadata,
    };

_AscpDiffFile _$AscpDiffFileFromJson(Map<String, dynamic> json) =>
    _AscpDiffFile(
      path: json['path'] as String,
      changeType: json['change_type'] as String,
      insertions: (json['insertions'] as num?)?.toInt(),
      deletions: (json['deletions'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AscpDiffFileToJson(_AscpDiffFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'change_type': instance.changeType,
      'insertions': instance.insertions,
      'deletions': instance.deletions,
    };

_AscpDiffSummary _$AscpDiffSummaryFromJson(Map<String, dynamic> json) =>
    _AscpDiffSummary(
      sessionId: json['session_id'] as String,
      runId: json['run_id'] as String?,
      filesChanged: (json['files_changed'] as num).toInt(),
      insertions: (json['insertions'] as num?)?.toInt(),
      deletions: (json['deletions'] as num?)?.toInt(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => AscpDiffFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AscpDiffSummaryToJson(_AscpDiffSummary instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'run_id': instance.runId,
      'files_changed': instance.filesChanged,
      'insertions': instance.insertions,
      'deletions': instance.deletions,
      'files': instance.files?.map((e) => e.toJson()).toList(),
    };
