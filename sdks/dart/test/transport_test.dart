import 'dart:io';

import 'package:ascp_sdk_dart/models.dart';
import 'package:ascp_sdk_dart/transport.dart';
import 'package:test/test.dart';

void main() {
  group('transport layer', () {
    test(
      'reaches the upstream mock server through the stdio transport',
      () async {
        final transport = AscpStdioTransport(
          command: const <String>[
            'python3',
            '../../services/mock-server/src/mock_server/cli.py',
          ],
          workingDirectory: Directory.current.path,
        );
        addTearDown(transport.close);

        await transport.connect();

        final response = await transport.request('capabilities.get');

        expect(response, isA<AscpTransportSuccessResponse>());
        expect(
          ((response as AscpTransportSuccessResponse).result
              as Map<String, Object?>)['host'],
          isA<Map<String, Object?>>(),
        );
      },
    );

    test(
      'streams session events after a subscribe request over stdio',
      () async {
        final transport = AscpStdioTransport(
          command: const <String>[
            'python3',
            '../../services/mock-server/src/mock_server/cli.py',
          ],
          workingDirectory: Directory.current.path,
        );
        addTearDown(transport.close);

        await transport.connect();

        final observedEvents = <AscpEventEnvelope>[];
        final subscription = transport.events.listen(observedEvents.add);
        addTearDown(subscription.cancel);
        final response = await transport.request(
          'sessions.subscribe',
          params: const <String, Object?>{
            'session_id': 'sess_abc123',
            'include_snapshot': true,
            'from_seq': 34,
          },
        );

        expect(response, isA<AscpTransportSuccessResponse>());
        await _waitFor(
          () => observedEvents.any((event) => event.type == 'sync.replayed'),
        );

        final observedTypes = observedEvents.map((event) => event.type).toSet();

        expect(observedEvents.first.type, 'sync.snapshot');
        expect(observedTypes, contains('sync.replayed'));
      },
    );

    test('uses auth hooks for environment and websocket headers', () async {
      AscpTransportAuthContext? stdioContext;
      final stdioTransport = AscpStdioTransport(
        command: const <String>[
          'python3',
          '-c',
          'import os; print(os.getenv("ASCP_TOKEN", ""))',
        ],
        authHooks: AscpTransportAuthHooks(
          environment: (context) {
            stdioContext = context;
            return const <String, String>{'ASCP_TOKEN': 'secret-token'};
          },
        ),
      );
      addTearDown(stdioTransport.close);

      expect(
        await stdioTransport.resolveEnvironment(),
        containsPair('ASCP_TOKEN', 'secret-token'),
      );
      expect(stdioContext?.transportKind, 'stdio');

      AscpTransportAuthContext? websocketContext;
      final webSocketTransport = AscpWebSocketTransport(
        url: Uri.parse('ws://127.0.0.1:65535'),
        authHooks: AscpTransportAuthHooks(
          headers: (context) {
            websocketContext = context;
            return const <String, String>{'Authorization': 'Bearer token'};
          },
        ),
      );

      expect(
        await webSocketTransport.resolveHeaders(),
        containsPair('Authorization', 'Bearer token'),
      );
      expect(websocketContext?.transportKind, 'websocket');
    });
  });
}

Future<void> _waitFor(
  bool Function() predicate, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('Timed out waiting for the expected transport events.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}
