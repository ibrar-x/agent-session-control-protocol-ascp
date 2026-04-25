import 'dart:async';

import 'package:ascp_sdk_dart/client.dart';
import 'package:ascp_sdk_dart/errors.dart';
import 'package:ascp_sdk_dart/methods.dart';
import 'package:ascp_sdk_dart/models.dart';
import 'package:ascp_sdk_dart/transport.dart';
import 'package:test/test.dart';

void main() {
  group('typed Dart client surface', () {
    test(
      'wraps the ASCP core method set with protocol-faithful params and typed results',
      () async {
        expect(ascpCoreMethodNames, <String>[
          'capabilities.get',
          'hosts.get',
          'runtimes.list',
          'sessions.list',
          'sessions.get',
          'sessions.start',
          'sessions.resume',
          'sessions.stop',
          'sessions.send_input',
          'sessions.subscribe',
          'sessions.unsubscribe',
          'approvals.list',
          'approvals.respond',
          'artifacts.list',
          'artifacts.get',
          'diffs.get',
        ]);

        final cases = <_ClientCase>[
          _ClientCase(
            method: 'capabilities.get',
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_cap_1',
                result: <String, Object?>{
                  'protocol_version': '0.1.0',
                  'host': <String, Object?>{
                    'id': 'host_01',
                    'name': 'MacBook Pro',
                  },
                  'transports': <String>['websocket', 'relay'],
                  'capabilities': <String, Object?>{
                    'session_list': true,
                    'session_resume': true,
                    'stream_events': true,
                  },
                  'runtimes': <Object?>[],
                },
              );
            },
            invoke: (client) => client.getCapabilities(),
            expectResult: (result) {
              expect(result, isA<AscpCapabilitiesDocument>());
              expect(
                (result as AscpCapabilitiesDocument).protocolVersion,
                '0.1.0',
              );
            },
          ),
          _ClientCase(
            method: 'hosts.get',
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_host_1',
                result: <String, Object?>{
                  'host': <String, Object?>{
                    'id': 'host_01',
                    'name': 'MacBook Pro',
                    'platform': 'macos',
                    'arch': 'arm64',
                    'status': 'online',
                  },
                },
              );
            },
            invoke: (client) => client.getHost(),
            expectResult: (result) {
              expect(result, isA<AscpHostsGetResult>());
              expect((result as AscpHostsGetResult).host.platform, 'macos');
            },
          ),
          _ClientCase(
            method: 'runtimes.list',
            expectedParams: const <String, Object?>{
              'kind': 'codex',
              'adapter_kind': 'native',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_rt_1',
                result: <String, Object?>{
                  'runtimes': <Object?>[
                    <String, Object?>{
                      'id': 'codex_local',
                      'kind': 'codex',
                      'display_name': 'Codex CLI',
                      'version': '0.1.x',
                      'adapter_kind': 'native',
                    },
                  ],
                },
              );
            },
            invoke: (client) => client.listRuntimes(
              const AscpRuntimesListParams(
                kind: 'codex',
                adapterKind: 'native',
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpRuntimesListResult>());
              expect(
                (result as AscpRuntimesListResult).runtimes.single.id,
                'codex_local',
              );
            },
          ),
          _ClientCase(
            method: 'sessions.list',
            expectedParams: const <String, Object?>{
              'runtime_id': 'codex_local',
              'status': 'running',
              'limit': 20,
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_list_1',
                result: <String, Object?>{
                  'sessions': <Object?>[
                    <String, Object?>{
                      'id': 'sess_abc123',
                      'runtime_id': 'codex_local',
                      'title': 'Fix failing Flutter integration tests',
                      'status': 'running',
                      'created_at': '2026-04-21T10:00:00Z',
                      'updated_at': '2026-04-21T10:12:00Z',
                    },
                  ],
                  'next_cursor': null,
                },
              );
            },
            invoke: (client) => client.listSessions(
              const AscpSessionsListParams(
                runtimeId: 'codex_local',
                status: 'running',
                limit: 20,
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsListResult>());
              expect(
                (result as AscpSessionsListResult).sessions.single.id,
                'sess_abc123',
              );
            },
          ),
          _ClientCase(
            method: 'sessions.get',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'include_runs': true,
              'include_pending_approvals': true,
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_get_1',
                result: <String, Object?>{
                  'session': <String, Object?>{
                    'id': 'sess_abc123',
                    'runtime_id': 'codex_local',
                    'title': 'Fix failing Flutter integration tests',
                    'status': 'running',
                    'created_at': '2026-04-21T10:00:00Z',
                    'updated_at': '2026-04-21T10:12:00Z',
                  },
                  'runs': <Object?>[
                    <String, Object?>{
                      'id': 'run_9',
                      'session_id': 'sess_abc123',
                      'status': 'running',
                      'started_at': '2026-04-21T10:05:00Z',
                    },
                  ],
                  'pending_approvals': <Object?>[
                    <String, Object?>{
                      'id': 'apr_77',
                      'session_id': 'sess_abc123',
                      'kind': 'command',
                      'status': 'pending',
                      'created_at': '2026-04-21T10:06:00Z',
                    },
                  ],
                },
              );
            },
            invoke: (client) => client.getSession(
              const AscpSessionsGetParams(
                sessionId: 'sess_abc123',
                includeRuns: true,
                includePendingApprovals: true,
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsGetResult>());
              expect((result as AscpSessionsGetResult).runs.single.id, 'run_9');
            },
          ),
          _ClientCase(
            method: 'sessions.start',
            expectedParams: const <String, Object?>{
              'runtime_id': 'codex_local',
              'workspace': '/Users/me/app',
              'title': 'Investigate checkout test failures',
              'initial_prompt':
                  'Find the cause of checkout flow integration test failures.',
              'metadata': <String, Object?>{'source': 'mobile'},
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_start_1',
                result: <String, Object?>{
                  'session': <String, Object?>{
                    'id': 'sess_new_1',
                    'runtime_id': 'codex_local',
                    'title': 'Investigate checkout test failures',
                    'workspace': '/Users/me/app',
                    'status': 'running',
                    'created_at': '2026-04-21T10:20:00Z',
                    'updated_at': '2026-04-21T10:20:00Z',
                  },
                },
              );
            },
            invoke: (client) => client.startSession(
              const AscpSessionsStartParams(
                runtimeId: 'codex_local',
                workspace: '/Users/me/app',
                title: 'Investigate checkout test failures',
                initialPrompt:
                    'Find the cause of checkout flow integration test failures.',
                metadata: <String, Object?>{'source': 'mobile'},
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsStartResult>());
              expect(
                (result as AscpSessionsStartResult).session.workspace,
                '/Users/me/app',
              );
            },
          ),
          _ClientCase(
            method: 'sessions.resume',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'runtime_id': 'codex_local',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_resume_1',
                result: <String, Object?>{
                  'session': <String, Object?>{
                    'id': 'sess_abc123',
                    'runtime_id': 'codex_local',
                    'status': 'running',
                    'created_at': '2026-04-21T10:00:00Z',
                    'updated_at': '2026-04-21T10:21:00Z',
                  },
                  'snapshot_emitted': true,
                  'replay_supported': true,
                },
              );
            },
            invoke: (client) => client.resumeSession(
              const AscpSessionsResumeParams(
                sessionId: 'sess_abc123',
                runtimeId: 'codex_local',
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsResumeResult>());
              expect(
                (result as AscpSessionsResumeResult).replaySupported,
                isTrue,
              );
            },
          ),
          _ClientCase(
            method: 'sessions.stop',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'mode': 'graceful',
              'reason': 'User cancelled the run',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_stop_1',
                result: <String, Object?>{
                  'session_id': 'sess_abc123',
                  'status': 'stopped',
                },
              );
            },
            invoke: (client) => client.stopSession(
              const AscpSessionsStopParams(
                sessionId: 'sess_abc123',
                mode: 'graceful',
                reason: 'User cancelled the run',
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsStopResult>());
              expect((result as AscpSessionsStopResult).status, 'stopped');
            },
          ),
          _ClientCase(
            method: 'sessions.send_input',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'input': 'Continue, but focus on the checkout API mock.',
              'input_kind': 'instruction',
              'metadata': <String, Object?>{'source': 'mobile_ui'},
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_input_1',
                result: <String, Object?>{
                  'accepted': true,
                  'session_id': 'sess_abc123',
                },
              );
            },
            invoke: (client) => client.sendInput(
              const AscpSessionsSendInputParams(
                sessionId: 'sess_abc123',
                input: 'Continue, but focus on the checkout API mock.',
                inputKind: 'instruction',
                metadata: <String, Object?>{'source': 'mobile_ui'},
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsSendInputResult>());
              expect((result as AscpSessionsSendInputResult).accepted, isTrue);
            },
          ),
          _ClientCase(
            method: 'sessions.subscribe',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'from_seq': 104,
              'include_snapshot': true,
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_sub_1',
                result: <String, Object?>{
                  'subscription_id': 'sub_01',
                  'session_id': 'sess_abc123',
                  'snapshot_emitted': true,
                },
              );
            },
            invoke: (client) => client.subscribe(
              const AscpSessionsSubscribeParams(
                sessionId: 'sess_abc123',
                fromSeq: 104,
                includeSnapshot: true,
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsSubscribeResult>());
              expect(
                (result as AscpSessionsSubscribeResult).subscriptionId,
                'sub_01',
              );
            },
          ),
          _ClientCase(
            method: 'sessions.unsubscribe',
            expectedParams: const <String, Object?>{
              'subscription_id': 'sub_01',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_unsub_1',
                result: <String, Object?>{
                  'subscription_id': 'sub_01',
                  'unsubscribed': true,
                },
              );
            },
            invoke: (client) => client.unsubscribe(
              const AscpSessionsUnsubscribeParams(subscriptionId: 'sub_01'),
            ),
            expectResult: (result) {
              expect(result, isA<AscpSessionsUnsubscribeResult>());
              expect(
                (result as AscpSessionsUnsubscribeResult).unsubscribed,
                isTrue,
              );
            },
          ),
          _ClientCase(
            method: 'approvals.list',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'status': 'pending',
              'limit': 10,
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_appr_list_1',
                result: <String, Object?>{
                  'approvals': <Object?>[
                    <String, Object?>{
                      'id': 'apr_77',
                      'session_id': 'sess_abc123',
                      'kind': 'command',
                      'status': 'pending',
                      'created_at': '2026-04-21T10:06:00Z',
                    },
                  ],
                  'next_cursor': null,
                },
              );
            },
            invoke: (client) => client.listApprovals(
              const AscpApprovalsListParams(
                sessionId: 'sess_abc123',
                status: 'pending',
                limit: 10,
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpApprovalsListResult>());
              expect(
                (result as AscpApprovalsListResult).approvals.single.id,
                'apr_77',
              );
            },
          ),
          _ClientCase(
            method: 'approvals.respond',
            expectedParams: const <String, Object?>{
              'approval_id': 'apr_77',
              'decision': 'approved',
              'note': 'Looks safe',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_appr_1',
                result: <String, Object?>{
                  'approval_id': 'apr_77',
                  'status': 'approved',
                },
              );
            },
            invoke: (client) => client.respondApproval(
              const AscpApprovalsRespondParams(
                approvalId: 'apr_77',
                decision: 'approved',
                note: 'Looks safe',
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpApprovalsRespondResult>());
              expect((result as AscpApprovalsRespondResult).status, 'approved');
            },
          ),
          _ClientCase(
            method: 'artifacts.list',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'run_id': 'run_9',
              'kind': 'diff',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_art_list_1',
                result: <String, Object?>{
                  'artifacts': <Object?>[
                    <String, Object?>{
                      'id': 'art_3',
                      'session_id': 'sess_abc123',
                      'run_id': 'run_9',
                      'kind': 'diff',
                      'created_at': '2026-04-21T10:10:00Z',
                    },
                  ],
                },
              );
            },
            invoke: (client) => client.listArtifacts(
              const AscpArtifactsListParams(
                sessionId: 'sess_abc123',
                runId: 'run_9',
                kind: 'diff',
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpArtifactsListResult>());
              expect(
                (result as AscpArtifactsListResult).artifacts.single.id,
                'art_3',
              );
            },
          ),
          _ClientCase(
            method: 'artifacts.get',
            expectedParams: const <String, Object?>{'artifact_id': 'art_3'},
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_art_get_1',
                result: <String, Object?>{
                  'artifact': <String, Object?>{
                    'id': 'art_3',
                    'session_id': 'sess_abc123',
                    'kind': 'diff',
                    'uri': 'artifact://sess_abc123/art_3',
                    'mime_type': 'text/x-diff',
                    'created_at': '2026-04-21T10:10:00Z',
                  },
                },
              );
            },
            invoke: (client) => client.getArtifact(
              const AscpArtifactsGetParams(artifactId: 'art_3'),
            ),
            expectResult: (result) {
              expect(result, isA<AscpArtifactsGetResult>());
              expect(
                (result as AscpArtifactsGetResult).artifact.mimeType,
                'text/x-diff',
              );
            },
          ),
          _ClientCase(
            method: 'diffs.get',
            expectedParams: const <String, Object?>{
              'session_id': 'sess_abc123',
              'run_id': 'run_9',
            },
            configure: (transport) {
              transport.response = const AscpTransportSuccessResponse(
                jsonrpc: '2.0',
                id: 'req_diff_1',
                result: <String, Object?>{
                  'diff': <String, Object?>{
                    'session_id': 'sess_abc123',
                    'run_id': 'run_9',
                    'files_changed': 4,
                    'insertions': 73,
                    'deletions': 19,
                    'files': <Object?>[],
                  },
                },
              );
            },
            invoke: (client) => client.getDiff(
              const AscpDiffsGetParams(
                sessionId: 'sess_abc123',
                runId: 'run_9',
              ),
            ),
            expectResult: (result) {
              expect(result, isA<AscpDiffsGetResult>());
              expect((result as AscpDiffsGetResult).diff.filesChanged, 4);
            },
          ),
        ];

        for (final testCase in cases) {
          final transport = _StubTransport();
          testCase.configure(transport);
          final client = AscpClient(transport: transport);

          final result = await testCase.invoke(client);

          expect(transport.requests.single.method, testCase.method);
          expect(transport.requests.single.params, testCase.expectedParams);
          testCase.expectResult(result);
        }
      },
    );

    test(
      'passes request options through to the configured transport',
      () async {
        final transport = _StubTransport()
          ..response = const AscpTransportSuccessResponse(
            jsonrpc: '2.0',
            id: 'req_input_1',
            result: <String, Object?>{
              'accepted': true,
              'session_id': 'sess_abc123',
            },
          );
        final client = AscpClient(transport: transport);
        const options = AscpTransportRequestOptions(
          timeout: Duration(milliseconds: 1500),
        );

        await client.sendInput(
          const AscpSessionsSendInputParams(
            sessionId: 'sess_abc123',
            input: 'continue',
          ),
          options: options,
        );

        expect(transport.requests.single.options, same(options));
      },
    );

    test('maps ASCP error responses into protocol exceptions', () async {
      final transport = _StubTransport()
        ..response = AscpTransportErrorResponse(
          jsonrpc: '2.0',
          id: 'req_stop_1',
          error: const AscpProtocolError(
            code: 'CONFLICT',
            message: 'Session is already stopped.',
            retryable: false,
            correlationId: 'corr_123',
          ),
        );
      final client = AscpClient(transport: transport);

      await expectLater(
        () => client.stopSession(
          const AscpSessionsStopParams(sessionId: 'sess_abc123'),
        ),
        throwsA(
          isA<AscpProtocolException>()
              .having((error) => error.method, 'method', 'sessions.stop')
              .having((error) => error.code, 'code', 'CONFLICT')
              .having(
                (error) => error.correlationId,
                'correlationId',
                'corr_123',
              ),
        ),
      );
    });
  });
}

final class _ClientCase {
  const _ClientCase({
    required this.method,
    required this.configure,
    required this.invoke,
    required this.expectResult,
    this.expectedParams,
  });

  final String method;
  final void Function(_StubTransport transport) configure;
  final Future<Object> Function(AscpClient client) invoke;
  final void Function(Object result) expectResult;
  final Map<String, Object?>? expectedParams;
}

final class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.params,
    required this.options,
  });

  final String method;
  final Map<String, Object?>? params;
  final AscpTransportRequestOptions? options;
}

final class _StubTransport implements AscpTransport {
  @override
  String get kind => 'stub';

  @override
  final Stream<AscpEventEnvelope> events =
      const Stream<AscpEventEnvelope>.empty();

  final List<_RecordedRequest> requests = <_RecordedRequest>[];
  AscpTransportResponse? response;

  @override
  Future<void> close() async {}

  @override
  Future<void> connect() async {}

  @override
  Future<AscpTransportResponse> request(
    String method, {
    Map<String, Object?>? params,
    AscpTransportRequestOptions? options,
  }) async {
    requests.add(
      _RecordedRequest(method: method, params: params, options: options),
    );

    if (response == null) {
      throw StateError('No response configured for $method.');
    }

    return response!;
  }
}
