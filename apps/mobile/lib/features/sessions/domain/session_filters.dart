import '../../../core/ascp/ascp_models.dart';

class SessionFilters {
  const SessionFilters({
    this.statuses = const {},
    this.query = '',
  });

  final Set<AscpSessionStatus> statuses;
  final String query;

  bool accepts({
    AscpSessionStatus? status,
    String? statusName,
    required String title,
  }) {
    final statusValue = status ?? AscpSessionStatus.fromValue(statusName ?? '');
    final statusMatches = statuses.isEmpty || statuses.contains(statusValue);
    final queryMatches = query.isEmpty || title.toLowerCase().contains(query.toLowerCase());
    return statusMatches && queryMatches;
  }
}
