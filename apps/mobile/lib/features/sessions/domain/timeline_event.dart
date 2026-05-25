class TimelineEvent {
  const TimelineEvent({
    required this.sequence,
    required this.id,
    required this.label,
  });

  final int? sequence;
  final String id;
  final String label;
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
