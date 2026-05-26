import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/network/http_json_rpc_client.dart';
import 'package:mobile/features/approvals/application/approval_queue_controller.dart';
import 'package:mobile/features/approvals/data/approval_repository.dart';
import 'package:mobile/features/approvals/domain/approval_view_model.dart';

void main() {
  test('approval derived from unsupported runtime is visible but not actionable', () {
    final approval = ApprovalViewModel.pending(
      id: 'appr_1',
      sessionId: 'sess_1',
      isActionable: false,
      reason: 'approval_respond capability is false',
    );

    expect(approval.id, 'appr_1');
    expect(approval.sessionId, 'sess_1');
    expect(approval.status, ApprovalStatus.pending);
    expect(approval.isActionable, isFalse);
    expect(approval.reason, contains('approval_respond'));
  });

  test('approval queue sorts actionable pending approvals first', () async {
    final controller = ApprovalQueueController(
      repository: MemoryApprovalRepository(
        approvals: [
          ApprovalViewModel.pending(
            id: 'appr_2',
            sessionId: 'sess_1',
            isActionable: false,
            reason: 'approval_respond capability is false',
          ),
          ApprovalViewModel.pending(
            id: 'appr_1',
            sessionId: 'sess_1',
            isActionable: true,
            reason: 'Command needs approval',
          ),
        ],
      ),
    );

    final queue = await controller.loadQueue();

    expect(queue.map((approval) => approval.id), ['appr_1', 'appr_2']);
  });

  test('approval response delegates approved decision and updates status', () async {
    final repository = MemoryApprovalRepository();
    final controller = ApprovalQueueController(repository: repository);
    final approval = ApprovalViewModel.pending(
      id: 'appr_1',
      sessionId: 'sess_1',
      isActionable: true,
      reason: 'Command needs approval',
    );

    final updated = await controller.respond(
      approval: approval,
      decision: ApprovalDecision.approved,
    );

    expect(repository.responses, ['appr_1:approved']);
    expect(updated.status, ApprovalStatus.approved);
  });

  test('non-actionable approval response is ignored but remains visible', () async {
    final repository = MemoryApprovalRepository();
    final controller = ApprovalQueueController(repository: repository);
    final approval = ApprovalViewModel.pending(
      id: 'appr_1',
      sessionId: 'sess_1',
      isActionable: false,
      reason: 'approval_respond capability is false',
    );

    final updated = await controller.respond(
      approval: approval,
      decision: ApprovalDecision.rejected,
    );

    expect(repository.responses, isEmpty);
    expect(updated.isActionable, isFalse);
    expect(updated.status, ApprovalStatus.pending);
  });

  test('ASCP approval repository maps approvals.list response', () async {
    final dio = Dio()
      ..httpClientAdapter = _FakeAdapter(
        '{"jsonrpc":"2.0","id":"approvals.list","result":{"approvals":[{"id":"appr_1","session_id":"sess_1","actionable":false,"reason":"approval_respond capability is false"}]}}',
      );
    final repository = AscpApprovalRepository(
      client: HttpJsonRpcClient(dio: dio, endpoint: Uri.parse('http://host/rpc')),
    );

    final approvals = await repository.listApprovals();

    expect(approvals.single.id, 'appr_1');
    expect(approvals.single.isActionable, isFalse);
  });

  test('ASCP approval repository delegates respond method', () async {
    final adapter = _RecordingAdapter(
      '{"jsonrpc":"2.0","id":"approvals.respond","result":{"accepted":true}}',
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final repository = AscpApprovalRepository(
      client: HttpJsonRpcClient(dio: dio, endpoint: Uri.parse('http://host/rpc')),
    );

    await repository.respond(
      approvalId: 'appr_1',
      decision: ApprovalDecision.rejected,
    );

    expect(adapter.requestBody, contains('approvals.respond'));
    expect(adapter.requestBody, contains('rejected'));
  });
}

class _FakeAdapter implements HttpClientAdapter {
  const _FakeAdapter(this.body);

  final String body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _RecordingAdapter extends _FakeAdapter {
  _RecordingAdapter(super.body);

  String requestBody = '';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final chunks = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        chunks.addAll(chunk);
      }
    }
    requestBody = String.fromCharCodes(chunks);
    return super.fetch(options, requestStream, cancelFuture);
  }
}
