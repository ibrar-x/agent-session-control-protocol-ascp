class TimelineEvent {
  const TimelineEvent({
    required this.sequence,
    required this.id,
    String? label,
    this.type,
    this.payload = const {},
    this.role,
    this.content,
    this.toolName,
    this.status,
    this.modelId,
  }) : _label = label;

  factory TimelineEvent.fromAscp({
    required int? sequence,
    required String id,
    required String type,
    required Map<String, Object?> payload,
  }) {
    final content = _firstString(payload, const [
      'content',
      'text',
      'message',
      'delta',
      'stdout',
      'stderr',
      'summary',
    ]);
    return TimelineEvent(
      sequence: sequence,
      id: id,
      type: type,
      payload: payload,
      role: _firstString(payload, const ['role', 'speaker', 'actor']),
      content: content,
      toolName: _firstString(payload, const ['tool_name', 'name', 'command']),
      status: _firstString(payload, const ['status', 'state']),
      modelId: _firstString(payload, const ['model', 'model_id']),
    );
  }

  final int? sequence;
  final String id;
  final String? _label;
  final String? type;
  final Map<String, Object?> payload;
  final String? role;
  final String? content;
  final String? toolName;
  final String? status;
  final String? modelId;

  String get label {
    final explicit = _label;
    if (explicit != null) {
      return explicit;
    }
    final eventType = type ?? 'event';
    final detail = primaryDetail;
    return detail.isEmpty ? eventType : '$eventType $detail';
  }

  String get title {
    final eventType = type ?? _label?.split(' ').first ?? 'event';
    final normalized = eventType.toLowerCase();
    if (kind == TimelineEventKind.userMessage) return 'You';
    if (kind == TimelineEventKind.agentMessage) return 'Agent';
    if (kind == TimelineEventKind.approval) return 'Approval requested';
    if (kind == TimelineEventKind.terminal) return 'Terminal';
    if (kind == TimelineEventKind.tool) return toolName ?? eventType;
    if (normalized.contains('model')) return modelId ?? eventType;
    return eventType;
  }

  String get primaryDetail {
    final direct = content ?? toolName ?? status;
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }
    final label = _label;
    if (label == null) {
      return '';
    }
    final separator = label.indexOf(' ');
    if (separator == -1 || separator == label.length - 1) {
      return '';
    }
    return label.substring(separator + 1);
  }

  TimelineEventKind get kind {
    final normalized = label.toLowerCase();
    final normalizedType = (type ?? '').toLowerCase();
    final normalizedRole = (role ?? '').toLowerCase();
    if (normalizedType.startsWith('message.user') ||
        normalizedRole == 'user' ||
        normalized.startsWith('user.')) {
      return TimelineEventKind.userMessage;
    }
    if (normalizedType.startsWith('message.agent') ||
        normalizedType.startsWith('message.assistant') ||
        normalizedRole == 'assistant' ||
        normalizedRole == 'agent' ||
        normalizedType.contains('thinking') ||
        normalized.contains('thinking')) {
      return TimelineEventKind.agentMessage;
    }
    if (normalizedType.contains('approval') ||
        normalized.contains('approval')) {
      return TimelineEventKind.approval;
    }
    if (normalizedType.startsWith('terminal') ||
        normalizedType.contains('terminal.') ||
        normalizedType.contains('stdout') ||
        normalizedType.contains('stderr') ||
        normalized.contains('terminal.') ||
        normalized.contains('stdout') ||
        normalized.contains('stderr')) {
      return TimelineEventKind.terminal;
    }
    if (normalizedType.startsWith('tool.') ||
        normalizedType.contains('tool') ||
        normalized.contains('tool')) {
      return TimelineEventKind.tool;
    }
    return TimelineEventKind.generic;
  }

  bool get isBlocked {
    final normalized = label.toLowerCase();
    return normalized.contains('blocked') ||
        normalized.contains('failed') ||
        status == 'blocked' ||
        status == 'failed';
  }
}

enum TimelineEventKind {
  userMessage,
  agentMessage,
  tool,
  approval,
  terminal,
  generic,
}

class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.title,
    required this.status,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String status;
  final DateTime updatedAt;
}

String? _firstString(Map<String, Object?> payload, List<String> keys) {
  for (final key in keys) {
    final value = payload[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
  }
  return null;
}
