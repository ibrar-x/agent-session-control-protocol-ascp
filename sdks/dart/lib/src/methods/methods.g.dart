// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'methods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AscpCapabilitiesDocument _$AscpCapabilitiesDocumentFromJson(
  Map<String, dynamic> json,
) => _AscpCapabilitiesDocument(
  protocolVersion: json['protocol_version'] as String,
  host: AscpHost.fromJson(json['host'] as Map<String, dynamic>),
  transports: (json['transports'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  capabilities: AscpCapabilities.fromJson(
    json['capabilities'] as Map<String, dynamic>,
  ),
  runtimes: (json['runtimes'] as List<dynamic>)
      .map((e) => AscpRuntime.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AscpCapabilitiesDocumentToJson(
  _AscpCapabilitiesDocument instance,
) => <String, dynamic>{
  'protocol_version': instance.protocolVersion,
  'host': instance.host.toJson(),
  'transports': instance.transports,
  'capabilities': instance.capabilities.toJson(),
  'runtimes': instance.runtimes.map((e) => e.toJson()).toList(),
};

_AscpHostsGetResult _$AscpHostsGetResultFromJson(Map<String, dynamic> json) =>
    _AscpHostsGetResult(
      host: AscpHost.fromJson(json['host'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AscpHostsGetResultToJson(_AscpHostsGetResult instance) =>
    <String, dynamic>{'host': instance.host.toJson()};

_AscpRuntimesListParams _$AscpRuntimesListParamsFromJson(
  Map<String, dynamic> json,
) => _AscpRuntimesListParams(
  kind: json['kind'] as String?,
  adapterKind: json['adapter_kind'] as String?,
);

Map<String, dynamic> _$AscpRuntimesListParamsToJson(
  _AscpRuntimesListParams instance,
) => <String, dynamic>{
  'kind': ?instance.kind,
  'adapter_kind': ?instance.adapterKind,
};

_AscpRuntimesListResult _$AscpRuntimesListResultFromJson(
  Map<String, dynamic> json,
) => _AscpRuntimesListResult(
  runtimes: (json['runtimes'] as List<dynamic>)
      .map((e) => AscpRuntime.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AscpRuntimesListResultToJson(
  _AscpRuntimesListResult instance,
) => <String, dynamic>{
  'runtimes': instance.runtimes.map((e) => e.toJson()).toList(),
};

_AscpSessionsListParams _$AscpSessionsListParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsListParams(
  runtimeId: json['runtime_id'] as String?,
  status: json['status'] as String?,
  workspace: json['workspace'] as String?,
  updatedAfter: json['updated_after'] as String?,
  searchText: json['search_text'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
  cursor: json['cursor'] as String?,
);

Map<String, dynamic> _$AscpSessionsListParamsToJson(
  _AscpSessionsListParams instance,
) => <String, dynamic>{
  'runtime_id': ?instance.runtimeId,
  'status': ?instance.status,
  'workspace': ?instance.workspace,
  'updated_after': ?instance.updatedAfter,
  'search_text': ?instance.searchText,
  'limit': ?instance.limit,
  'cursor': ?instance.cursor,
};

_AscpSessionsListResult _$AscpSessionsListResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsListResult(
  sessions: (json['sessions'] as List<dynamic>)
      .map((e) => AscpSession.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$AscpSessionsListResultToJson(
  _AscpSessionsListResult instance,
) => <String, dynamic>{
  'sessions': instance.sessions.map((e) => e.toJson()).toList(),
  'next_cursor': instance.nextCursor,
};

_AscpSessionsGetParams _$AscpSessionsGetParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsGetParams(
  sessionId: json['session_id'] as String,
  includeRuns: json['include_runs'] as bool?,
  includePendingApprovals: json['include_pending_approvals'] as bool?,
);

Map<String, dynamic> _$AscpSessionsGetParamsToJson(
  _AscpSessionsGetParams instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'include_runs': ?instance.includeRuns,
  'include_pending_approvals': ?instance.includePendingApprovals,
};

_AscpSessionsGetResult _$AscpSessionsGetResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsGetResult(
  session: AscpSession.fromJson(json['session'] as Map<String, dynamic>),
  runs:
      (json['runs'] as List<dynamic>?)
          ?.map((e) => AscpRun.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AscpRun>[],
  pendingApprovals:
      (json['pending_approvals'] as List<dynamic>?)
          ?.map((e) => AscpApprovalRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AscpApprovalRequest>[],
);

Map<String, dynamic> _$AscpSessionsGetResultToJson(
  _AscpSessionsGetResult instance,
) => <String, dynamic>{
  'session': instance.session.toJson(),
  'runs': instance.runs.map((e) => e.toJson()).toList(),
  'pending_approvals': instance.pendingApprovals
      .map((e) => e.toJson())
      .toList(),
};

_AscpSessionsStartParams _$AscpSessionsStartParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsStartParams(
  runtimeId: json['runtime_id'] as String,
  workspace: json['workspace'] as String?,
  title: json['title'] as String?,
  initialPrompt: json['initial_prompt'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AscpSessionsStartParamsToJson(
  _AscpSessionsStartParams instance,
) => <String, dynamic>{
  'runtime_id': instance.runtimeId,
  'workspace': ?instance.workspace,
  'title': ?instance.title,
  'initial_prompt': ?instance.initialPrompt,
  'metadata': ?instance.metadata,
};

_AscpSessionsStartResult _$AscpSessionsStartResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsStartResult(
  session: AscpSession.fromJson(json['session'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AscpSessionsStartResultToJson(
  _AscpSessionsStartResult instance,
) => <String, dynamic>{'session': instance.session.toJson()};

_AscpSessionsResumeParams _$AscpSessionsResumeParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsResumeParams(
  sessionId: json['session_id'] as String,
  runtimeId: json['runtime_id'] as String?,
);

Map<String, dynamic> _$AscpSessionsResumeParamsToJson(
  _AscpSessionsResumeParams instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'runtime_id': ?instance.runtimeId,
};

_AscpSessionsResumeResult _$AscpSessionsResumeResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsResumeResult(
  session: AscpSession.fromJson(json['session'] as Map<String, dynamic>),
  snapshotEmitted: json['snapshot_emitted'] as bool?,
  replaySupported: json['replay_supported'] as bool?,
);

Map<String, dynamic> _$AscpSessionsResumeResultToJson(
  _AscpSessionsResumeResult instance,
) => <String, dynamic>{
  'session': instance.session.toJson(),
  'snapshot_emitted': instance.snapshotEmitted,
  'replay_supported': instance.replaySupported,
};

_AscpSessionsStopParams _$AscpSessionsStopParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsStopParams(
  sessionId: json['session_id'] as String,
  mode: json['mode'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$AscpSessionsStopParamsToJson(
  _AscpSessionsStopParams instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'mode': ?instance.mode,
  'reason': ?instance.reason,
};

_AscpSessionsStopResult _$AscpSessionsStopResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsStopResult(
  sessionId: json['session_id'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$AscpSessionsStopResultToJson(
  _AscpSessionsStopResult instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'status': instance.status,
};

_AscpSessionsSendInputParams _$AscpSessionsSendInputParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsSendInputParams(
  sessionId: json['session_id'] as String,
  input: json['input'] as String,
  inputKind: json['input_kind'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AscpSessionsSendInputParamsToJson(
  _AscpSessionsSendInputParams instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'input': instance.input,
  'input_kind': ?instance.inputKind,
  'metadata': ?instance.metadata,
};

_AscpSessionsSendInputResult _$AscpSessionsSendInputResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsSendInputResult(
  sessionId: json['session_id'] as String,
  accepted: json['accepted'] as bool,
);

Map<String, dynamic> _$AscpSessionsSendInputResultToJson(
  _AscpSessionsSendInputResult instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'accepted': instance.accepted,
};

_AscpSessionsSubscribeParams _$AscpSessionsSubscribeParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsSubscribeParams(
  sessionId: json['session_id'] as String,
  fromSeq: (json['from_seq'] as num?)?.toInt(),
  fromEventId: json['from_event_id'] as String?,
  includeSnapshot: json['include_snapshot'] as bool?,
);

Map<String, dynamic> _$AscpSessionsSubscribeParamsToJson(
  _AscpSessionsSubscribeParams instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'from_seq': ?instance.fromSeq,
  'from_event_id': ?instance.fromEventId,
  'include_snapshot': ?instance.includeSnapshot,
};

_AscpSessionsSubscribeResult _$AscpSessionsSubscribeResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsSubscribeResult(
  subscriptionId: json['subscription_id'] as String,
  sessionId: json['session_id'] as String,
  snapshotEmitted: json['snapshot_emitted'] as bool?,
);

Map<String, dynamic> _$AscpSessionsSubscribeResultToJson(
  _AscpSessionsSubscribeResult instance,
) => <String, dynamic>{
  'subscription_id': instance.subscriptionId,
  'session_id': instance.sessionId,
  'snapshot_emitted': instance.snapshotEmitted,
};

_AscpSessionsUnsubscribeParams _$AscpSessionsUnsubscribeParamsFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsUnsubscribeParams(
  subscriptionId: json['subscription_id'] as String,
);

Map<String, dynamic> _$AscpSessionsUnsubscribeParamsToJson(
  _AscpSessionsUnsubscribeParams instance,
) => <String, dynamic>{'subscription_id': instance.subscriptionId};

_AscpSessionsUnsubscribeResult _$AscpSessionsUnsubscribeResultFromJson(
  Map<String, dynamic> json,
) => _AscpSessionsUnsubscribeResult(
  subscriptionId: json['subscription_id'] as String,
  unsubscribed: json['unsubscribed'] as bool,
);

Map<String, dynamic> _$AscpSessionsUnsubscribeResultToJson(
  _AscpSessionsUnsubscribeResult instance,
) => <String, dynamic>{
  'subscription_id': instance.subscriptionId,
  'unsubscribed': instance.unsubscribed,
};

_AscpApprovalsListParams _$AscpApprovalsListParamsFromJson(
  Map<String, dynamic> json,
) => _AscpApprovalsListParams(
  sessionId: json['session_id'] as String?,
  status: json['status'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
  cursor: json['cursor'] as String?,
);

Map<String, dynamic> _$AscpApprovalsListParamsToJson(
  _AscpApprovalsListParams instance,
) => <String, dynamic>{
  'session_id': ?instance.sessionId,
  'status': ?instance.status,
  'limit': ?instance.limit,
  'cursor': ?instance.cursor,
};

_AscpApprovalsListResult _$AscpApprovalsListResultFromJson(
  Map<String, dynamic> json,
) => _AscpApprovalsListResult(
  approvals: (json['approvals'] as List<dynamic>)
      .map((e) => AscpApprovalRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$AscpApprovalsListResultToJson(
  _AscpApprovalsListResult instance,
) => <String, dynamic>{
  'approvals': instance.approvals.map((e) => e.toJson()).toList(),
  'next_cursor': instance.nextCursor,
};

_AscpApprovalsRespondParams _$AscpApprovalsRespondParamsFromJson(
  Map<String, dynamic> json,
) => _AscpApprovalsRespondParams(
  approvalId: json['approval_id'] as String,
  decision: json['decision'] as String,
  note: json['note'] as String?,
);

Map<String, dynamic> _$AscpApprovalsRespondParamsToJson(
  _AscpApprovalsRespondParams instance,
) => <String, dynamic>{
  'approval_id': instance.approvalId,
  'decision': instance.decision,
  'note': ?instance.note,
};

_AscpApprovalsRespondResult _$AscpApprovalsRespondResultFromJson(
  Map<String, dynamic> json,
) => _AscpApprovalsRespondResult(
  approvalId: json['approval_id'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$AscpApprovalsRespondResultToJson(
  _AscpApprovalsRespondResult instance,
) => <String, dynamic>{
  'approval_id': instance.approvalId,
  'status': instance.status,
};

_AscpArtifactsListParams _$AscpArtifactsListParamsFromJson(
  Map<String, dynamic> json,
) => _AscpArtifactsListParams(
  sessionId: json['session_id'] as String,
  runId: json['run_id'] as String?,
  kind: json['kind'] as String?,
);

Map<String, dynamic> _$AscpArtifactsListParamsToJson(
  _AscpArtifactsListParams instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'run_id': ?instance.runId,
  'kind': ?instance.kind,
};

_AscpArtifactsListResult _$AscpArtifactsListResultFromJson(
  Map<String, dynamic> json,
) => _AscpArtifactsListResult(
  artifacts: (json['artifacts'] as List<dynamic>)
      .map((e) => AscpArtifact.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AscpArtifactsListResultToJson(
  _AscpArtifactsListResult instance,
) => <String, dynamic>{
  'artifacts': instance.artifacts.map((e) => e.toJson()).toList(),
};

_AscpArtifactsGetParams _$AscpArtifactsGetParamsFromJson(
  Map<String, dynamic> json,
) => _AscpArtifactsGetParams(artifactId: json['artifact_id'] as String);

Map<String, dynamic> _$AscpArtifactsGetParamsToJson(
  _AscpArtifactsGetParams instance,
) => <String, dynamic>{'artifact_id': instance.artifactId};

_AscpArtifactsGetResult _$AscpArtifactsGetResultFromJson(
  Map<String, dynamic> json,
) => _AscpArtifactsGetResult(
  artifact: AscpArtifact.fromJson(json['artifact'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AscpArtifactsGetResultToJson(
  _AscpArtifactsGetResult instance,
) => <String, dynamic>{'artifact': instance.artifact.toJson()};

_AscpDiffsGetParams _$AscpDiffsGetParamsFromJson(Map<String, dynamic> json) =>
    _AscpDiffsGetParams(
      sessionId: json['session_id'] as String,
      runId: json['run_id'] as String,
    );

Map<String, dynamic> _$AscpDiffsGetParamsToJson(_AscpDiffsGetParams instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'run_id': instance.runId,
    };

_AscpDiffsGetResult _$AscpDiffsGetResultFromJson(Map<String, dynamic> json) =>
    _AscpDiffsGetResult(
      diff: AscpDiffSummary.fromJson(json['diff'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AscpDiffsGetResultToJson(_AscpDiffsGetResult instance) =>
    <String, dynamic>{'diff': instance.diff.toJson()};
