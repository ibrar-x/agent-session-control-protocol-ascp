import '../../../core/ascp/ascp_method.dart';
import '../../../core/network/json_rpc_client.dart';
import '../domain/approval_view_model.dart';

enum ApprovalDecision {
  approved,
  rejected,
}

abstract interface class ApprovalRepository {
  Future<List<ApprovalViewModel>> listApprovals();

  Future<void> respond({
    required String approvalId,
    required ApprovalDecision decision,
  });
}

class MemoryApprovalRepository implements ApprovalRepository {
  MemoryApprovalRepository({List<ApprovalViewModel> approvals = const []})
      : _approvals = [...approvals];

  final List<ApprovalViewModel> _approvals;
  final List<String> responses = [];

  @override
  Future<List<ApprovalViewModel>> listApprovals() async => [..._approvals];

  @override
  Future<void> respond({
    required String approvalId,
    required ApprovalDecision decision,
  }) async {
    responses.add('$approvalId:${decision.name}');
  }
}

class AscpApprovalRepository implements ApprovalRepository {
  const AscpApprovalRepository({required this.client});

  final JsonRpcClient client;

  @override
  Future<List<ApprovalViewModel>> listApprovals() async {
    final result = await client.call(id: 'approvals.list', method: AscpMethod.approvalsList);
    if (result is! Map) {
      return const [];
    }
    final approvals = result['approvals'];
    if (approvals is! List) {
      return const [];
    }
    return approvals.whereType<Map>().map((approval) {
      final json = Map<String, Object?>.from(approval);
      return ApprovalViewModel.pending(
        id: json['id'] as String? ?? '',
        sessionId: json['session_id'] as String? ?? '',
        isActionable: json['actionable'] as bool? ?? true,
        reason: json['reason'] as String? ?? '',
      );
    }).toList();
  }

  @override
  Future<void> respond({
    required String approvalId,
    required ApprovalDecision decision,
  }) async {
    await client.call(
      id: 'approvals.respond',
      method: AscpMethod.approvalsRespond,
      params: {
        'approval_id': approvalId,
        'decision': decision.name,
      },
    );
  }
}
