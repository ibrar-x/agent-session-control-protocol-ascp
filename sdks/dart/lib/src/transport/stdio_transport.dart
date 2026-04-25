import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../auth/auth.dart';
import 'base_transport.dart';
import 'transport_errors.dart';

final class AscpStdioTransport extends BaseAscpTransport {
  AscpStdioTransport({
    required this.command,
    this.workingDirectory,
    this.environment,
    this.authHooks,
  }) : super('stdio');

  final List<String> command;
  final String? workingDirectory;
  final Map<String, String>? environment;
  final AscpTransportAuthHooks? authHooks;

  Process? _process;
  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<String>? _stderrSubscription;
  String _stderrBuffer = '';
  bool _closing = false;

  Future<Map<String, String>> resolveEnvironment() async {
    final base = <String, String>{...Platform.environment, ...?environment};
    final provider = authHooks?.environment;
    if (provider == null) {
      return base;
    }

    final provided = await provider(
      AscpTransportAuthContext(
        transportKind: kind,
        command: command,
        workingDirectory: workingDirectory,
      ),
    );
    return <String, String>{...base, ...provided};
  }

  @override
  Future<void> closeConnection() async {
    _closing = true;
    await _stdoutSubscription?.cancel();
    await _stderrSubscription?.cancel();
    _stdoutSubscription = null;
    _stderrSubscription = null;

    final process = _process;
    _process = null;
    if (process == null) {
      return;
    }

    process.stdin.close();
    process.kill();
    await process.exitCode;
  }

  @override
  Future<void> openConnection() async {
    if (command.isEmpty) {
      throw AscpTransportException(
        code: AscpTransportErrorCode.configuration,
        transport: kind,
        message: 'stdio transport requires a command.',
        retryable: false,
      );
    }

    if (_process != null) {
      return;
    }

    _closing = false;
    final process = await Process.start(
      command.first,
      command.sublist(1),
      workingDirectory: workingDirectory,
      environment: await resolveEnvironment(),
      runInShell: false,
    );
    _process = process;

    _stdoutSubscription = process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(handleSerializedMessage);

    _stderrSubscription = process.stderr.transform(utf8.decoder).listen((
      chunk,
    ) {
      _stderrBuffer = '$_stderrBuffer$chunk';
      if (_stderrBuffer.length > 4096) {
        _stderrBuffer = _stderrBuffer.substring(_stderrBuffer.length - 4096);
      }
    });

    unawaited(
      process.exitCode.then((code) {
        _process = null;
        if (_closing) {
          return;
        }
        handleConnectionFailure(
          AscpTransportException(
            code: AscpTransportErrorCode.connection,
            transport: kind,
            message: 'stdio transport process exited unexpectedly.',
            details: <String, Object?>{
              'exit_code': code,
              'stderr': _stderrBuffer.isEmpty ? null : _stderrBuffer,
            },
          ),
          message: 'stdio transport process exited unexpectedly.',
        );
      }),
    );
  }

  @override
  Future<void> sendSerialized(String messageText) async {
    final process = _process;
    if (process == null) {
      throw AscpTransportException(
        code: AscpTransportErrorCode.closed,
        transport: kind,
        message: 'stdio transport is not running.',
        retryable: false,
      );
    }

    process.stdin.writeln(messageText);
    await process.stdin.flush();
  }
}
