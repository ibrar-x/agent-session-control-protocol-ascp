import '../data/approval_repository.dart';
import '../domain/approval_view_model.dart';

class ApprovalQueueController {
  const ApprovalQueueController({required this.repository});

  final ApprovalRepository repository;

  Future<List<ApprovalViewModel>> loadQueue() async {
    final approvals = await repository.listApprovals();
    approvals.sort((a, b) {
      final byActionable = _actionableRank(a).compareTo(_actionableRank(b));
      if (byActionable != 0) {
        return byActionable;
      }
      return a.id.compareTo(b.id);
    });
    return approvals;
  }

  Future<ApprovalViewModel> respond({
    required ApprovalViewModel approval,
    required ApprovalDecision decision,
  }) async {
    if (!approval.isActionable) {
      return approval;
    }
    await repository.respond(approvalId: approval.id, decision: decision);
    return approval.copyWith(
      status: switch (decision) {
        ApprovalDecision.approved => ApprovalStatus.approved,
        ApprovalDecision.rejected => ApprovalStatus.rejected,
      },
    );
  }

  int _actionableRank(ApprovalViewModel approval) {
    return approval.isActionable ? 0 : 1;
  }
}
