enum ApprovalStatus {
  pending,
  approved,
  rejected,
}

class ApprovalViewModel {
  const ApprovalViewModel._({
    required this.id,
    required this.sessionId,
    required this.isActionable,
    required this.reason,
    required this.status,
  });

  factory ApprovalViewModel.pending({
    required String id,
    required String sessionId,
    required bool isActionable,
    required String reason,
  }) {
    return ApprovalViewModel._(
      id: id,
      sessionId: sessionId,
      isActionable: isActionable,
      reason: reason,
      status: ApprovalStatus.pending,
    );
  }

  final String id;
  final String sessionId;
  final bool isActionable;
  final String reason;
  final ApprovalStatus status;

  ApprovalViewModel copyWith({
    bool? isActionable,
    String? reason,
    ApprovalStatus? status,
  }) {
    return ApprovalViewModel._(
      id: id,
      sessionId: sessionId,
      isActionable: isActionable ?? this.isActionable,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }
}
