enum PriorityWorkKind {
  connection,
  session,
  approval,
  replay,
}

class PriorityWorkItem {
  const PriorityWorkItem({
    required this.kind,
    required this.title,
    required this.detail,
    required this.rank,
  });

  final PriorityWorkKind kind;
  final String title;
  final String detail;
  final int rank;
}
