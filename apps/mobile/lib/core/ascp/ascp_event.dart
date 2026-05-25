enum AscpEventType {
  sessionCreated('session.created'),
  sessionUpdated('session.updated'),
  sessionStatusChanged('session.status_changed'),
  sessionDeleted('session.deleted'),
  runStarted('run.started'),
  runPaused('run.paused'),
  runResumed('run.resumed'),
  runCompleted('run.completed'),
  runFailed('run.failed'),
  runCancelled('run.cancelled'),
  messageUser('message.user'),
  messageAssistantStarted('message.assistant.started'),
  messageAssistantDelta('message.assistant.delta'),
  messageAssistantCompleted('message.assistant.completed'),
  messageSystem('message.system'),
  toolStarted('tool.started'),
  toolStdout('tool.stdout'),
  toolStderr('tool.stderr'),
  toolCompleted('tool.completed'),
  toolFailed('tool.failed'),
  terminalOpened('terminal.opened'),
  terminalOutput('terminal.output'),
  terminalClosed('terminal.closed'),
  terminalResizeRequested('terminal.resize_requested'),
  approvalRequested('approval.requested'),
  approvalUpdated('approval.updated'),
  approvalApproved('approval.approved'),
  approvalRejected('approval.rejected'),
  approvalExpired('approval.expired'),
  artifactCreated('artifact.created'),
  artifactUpdated('artifact.updated'),
  diffReady('diff.ready'),
  diffUpdated('diff.updated'),
  connectionStateChanged('connection.state_changed'),
  syncSnapshot('sync.snapshot'),
  syncReplayed('sync.replayed'),
  syncCursorAdvanced('sync.cursor_advanced'),
  errorTransient('error.transient'),
  errorFatal('error.fatal'),
  unknown('');

  const AscpEventType(this.value);

  final String value;

  static AscpEventType fromValue(String value) {
    for (final type in AscpEventType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return AscpEventType.unknown;
  }
}

class AscpEventEnvelope {
  const AscpEventEnvelope({
    required this.id,
    required this.type,
    required this.rawType,
    required this.timestamp,
    required this.sessionId,
    required this.payload,
    this.runId,
    this.sequence,
  });

  factory AscpEventEnvelope.fromJson(Map<String, Object?> json) {
    final typeValue = _expectString(json, 'type');
    return AscpEventEnvelope(
      id: _expectString(json, 'id'),
      type: AscpEventType.fromValue(typeValue),
      rawType: typeValue,
      timestamp: DateTime.parse(_expectString(json, 'ts')).toUtc(),
      sessionId: _expectString(json, 'session_id'),
      runId: json['run_id'] as String?,
      sequence: _intOrNull(json['seq'], 'seq'),
      payload: _expectMap(json, 'payload'),
    );
  }

  final String id;
  final AscpEventType type;
  final String rawType;
  final DateTime timestamp;
  final String sessionId;
  final String? runId;
  final int? sequence;
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'type': rawType,
      'ts': timestamp.toUtc().toIso8601String(),
      'session_id': sessionId,
      if (runId != null) 'run_id': runId,
      if (sequence != null) 'seq': sequence,
      'payload': payload,
    };
  }
}

String _expectString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String) {
    return value;
  }
  throw FormatException('Expected string field "$key".');
}

Map<String, Object?> _expectMap(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  throw FormatException('Expected object field "$key".');
}

int? _intOrNull(Object? value, String key) {
  if (value == null || value is int) {
    return value as int?;
  }
  throw FormatException('Expected integer field "$key".');
}
