import 'dart:io';

import 'package:ascp_sdk_dart/client.dart';
import 'package:ascp_sdk_dart/replay.dart';
import 'package:ascp_sdk_dart/transport.dart';

Future<void> main() async {
  final transport = AscpStdioTransport(
    command: const <String>['python3', '../mock-server/src/mock_server/cli.py'],
    workingDirectory: Directory.current.parent.path,
  );
  final client = AscpClient(transport: transport);

  await client.connect();

  try {
    final capabilities = await client.getCapabilities();
    stdout.writeln(
      'Connected to ${capabilities.host.name} with transports ${capabilities.transports.join(', ')}.',
    );

    final replayRequest = replayFromSeq(
      sessionId: 'sess_abc123',
      fromSeq: 34,
      includeSnapshot: true,
    );
    final replaySubscription = await subscribeWithReplay(
      client: client,
      request: replayRequest,
    );

    try {
      await for (final item in replaySubscription.stream.take(4)) {
        stdout.writeln('${item.kind}: ${item.event.type}');
      }
    } finally {
      await replaySubscription.close();
    }
  } finally {
    await client.close();
  }
}
