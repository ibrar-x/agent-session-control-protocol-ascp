import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/network/http_json_rpc_client.dart';
import 'package:mobile/features/inspect/application/inspect_controller.dart';
import 'package:mobile/features/inspect/data/inspect_repository.dart';
import 'package:mobile/features/inspect/domain/inspect_item.dart';

void main() {
  test('inspect priority groups diffs before passive artifacts', () {
    final items = prioritizeInspectItems([
      const InspectItem.artifact('artifact_1'),
      const InspectItem.diff('diff_1'),
    ]);

    expect(items.first.id, 'diff_1');
  });

  test('inspect controller delegates artifact get', () async {
    final repository = MemoryInspectRepository(
      artifacts: const {
        'artifact_1': ArtifactDetail(
          id: 'artifact_1',
          name: 'report.md',
          mimeType: 'text/markdown',
        ),
      },
    );
    final controller = InspectController(repository: repository);

    final artifact = await controller.getArtifact('artifact_1');

    expect(artifact.name, 'report.md');
    expect(repository.artifactReads, ['artifact_1']);
  });

  test('inspect controller delegates diff get', () async {
    final repository = MemoryInspectRepository(
      diffs: const {
        'diff_1': DiffDetail(id: 'diff_1', summary: '2 files changed', fileCount: 2),
      },
    );
    final controller = InspectController(repository: repository);

    final diff = await controller.getDiff('diff_1');

    expect(diff.fileCount, 2);
    expect(repository.diffReads, ['diff_1']);
  });

  test('inspect controller exposes unsupported degraded state', () async {
    final controller = InspectController(
      repository: MemoryInspectRepository(),
      isSupported: false,
      unsupportedReason: 'artifact capability is false',
    );

    final state = await controller.load();

    expect(state.isSupported, isFalse);
    expect(state.reason, contains('artifact'));
    expect(state.items, isEmpty);
  });

  test('ASCP inspect repository maps artifact detail', () async {
    final dio = Dio()
      ..httpClientAdapter = const _FakeAdapter(
        '{"jsonrpc":"2.0","id":"artifacts.get","result":{"artifact":{"id":"artifact_1","name":"report.md","mime_type":"text/markdown"}}}',
      );
    final repository = AscpInspectRepository(
      client: HttpJsonRpcClient(dio: dio, endpoint: Uri.parse('http://host/rpc')),
      sessionId: 'sess_1',
    );

    final artifact = await repository.getArtifact('artifact_1');

    expect(artifact.name, 'report.md');
    expect(artifact.mimeType, 'text/markdown');
  });

  test('ASCP inspect repository maps diff detail', () async {
    final dio = Dio()
      ..httpClientAdapter = const _FakeAdapter(
        '{"jsonrpc":"2.0","id":"diffs.get","result":{"diff":{"id":"diff_1","summary":"2 files changed","file_count":2}}}',
      );
    final repository = AscpInspectRepository(
      client: HttpJsonRpcClient(dio: dio, endpoint: Uri.parse('http://host/rpc')),
      sessionId: 'sess_1',
    );

    final diff = await repository.getDiff('diff_1');

    expect(diff.summary, '2 files changed');
    expect(diff.fileCount, 2);
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
