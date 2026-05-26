import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/ascp/ascp_envelope.dart';
import 'package:mobile/core/ascp/ascp_error.dart';
import 'package:mobile/core/ascp/ascp_method.dart';
import 'package:mobile/core/ascp/ascp_models.dart';

void main() {
  test('ASCP core method names stay exact', () {
    expect(AscpMethod.capabilitiesGet.value, 'capabilities.get');
    expect(AscpMethod.hostsGet.value, 'hosts.get');
    expect(AscpMethod.runtimesList.value, 'runtimes.list');
    expect(AscpMethod.sessionsList.value, 'sessions.list');
    expect(AscpMethod.sessionsSubscribe.value, 'sessions.subscribe');
    expect(AscpMethod.approvalsRespond.value, 'approvals.respond');
    expect(AscpMethod.artifactsGet.value, 'artifacts.get');
    expect(AscpMethod.diffsGet.value, 'diffs.get');
  });

  test('request serializes as JSON-RPC 2.0', () {
    final request = AscpRequest(
      id: 'req_1',
      method: AscpMethod.sessionsGet,
      params: const {'session_id': 'sess_1'},
    );

    expect(request.toJson(), {
      'jsonrpc': '2.0',
      'id': 'req_1',
      'method': 'sessions.get',
      'params': {'session_id': 'sess_1'},
    });
  });

  test('response rejects result and error coexistence', () {
    expect(
      () => AscpResponse.fromJson({
        'jsonrpc': '2.0',
        'id': 'req_1',
        'result': <String, Object?>{},
        'error': {
          'code': 'INTERNAL_ERROR',
          'message': 'Unexpected failure',
          'retryable': false,
        },
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('error object preserves extension details', () {
    final error = AscpError.fromJson({
      'code': 'UNSUPPORTED',
      'message': 'approval_respond capability is false',
      'retryable': false,
      'correlation_id': 'corr_1',
      'details': {'capability': 'approval_respond'},
      'x_vendor': {'hint': 'read only'},
    });

    expect(error.code, AscpErrorCode.unsupported);
    expect(error.correlationId, 'corr_1');
    expect(error.details, {'capability': 'approval_respond'});
    expect(error.extra['x_vendor'], {'hint': 'read only'});
    expect(error.toJson()['x_vendor'], {'hint': 'read only'});
  });

  test('session statuses preserve exact protocol names', () {
    expect(AscpSessionStatus.waitingApproval.value, 'waiting_approval');
    expect(AscpSessionStatus.disconnected.value, 'disconnected');
  });
}
