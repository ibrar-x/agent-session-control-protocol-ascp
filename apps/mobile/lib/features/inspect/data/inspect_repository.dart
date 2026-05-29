import '../../../core/ascp/ascp_method.dart';
import '../../../core/ascp/ascp_error.dart';
import '../../../core/network/http_json_rpc_client.dart';
import '../../../core/network/json_rpc_client.dart';
import '../domain/inspect_item.dart';

abstract interface class InspectRepository {
  Future<List<InspectItem>> listItems();

  Future<ArtifactDetail> getArtifact(String artifactId);

  Future<DiffDetail> getDiff(String diffId);
}

class MemoryInspectRepository implements InspectRepository {
  MemoryInspectRepository({
    List<InspectItem> items = const [],
    Map<String, ArtifactDetail> artifacts = const {},
    Map<String, DiffDetail> diffs = const {},
  }) : _items = [...items],
       _artifacts = Map.of(artifacts),
       _diffs = Map.of(diffs);

  final List<InspectItem> _items;
  final Map<String, ArtifactDetail> _artifacts;
  final Map<String, DiffDetail> _diffs;
  final List<String> artifactReads = [];
  final List<String> diffReads = [];

  @override
  Future<List<InspectItem>> listItems() async => [..._items];

  @override
  Future<ArtifactDetail> getArtifact(String artifactId) async {
    artifactReads.add(artifactId);
    final artifact = _artifacts[artifactId];
    if (artifact == null) {
      throw StateError('Unknown artifact: $artifactId');
    }
    return artifact;
  }

  @override
  Future<DiffDetail> getDiff(String diffId) async {
    diffReads.add(diffId);
    final diff = _diffs[diffId];
    if (diff == null) {
      throw StateError('Unknown diff: $diffId');
    }
    return diff;
  }
}

class AscpInspectRepository implements InspectRepository {
  const AscpInspectRepository({required this.client, required this.sessionId});

  final JsonRpcClient client;
  final String sessionId;

  @override
  Future<List<InspectItem>> listItems() async {
    final Object? artifacts;
    try {
      artifacts = await client.call(
        id: 'artifacts.list',
        method: AscpMethod.artifactsList,
        params: {'session_id': sessionId},
      );
    } on AscpJsonRpcException catch (error) {
      if (_isEmptyInspectState(error.error.code)) {
        return const [];
      }
      rethrow;
    }
    final items = <InspectItem>[];
    if (artifacts is Map && artifacts['artifacts'] is List) {
      for (final artifact
          in (artifacts['artifacts'] as List).whereType<Map>()) {
        final id = artifact['id'] as String?;
        if (id != null) {
          items.add(InspectItem.artifact(id));
        }
      }
    }
    return items;
  }

  @override
  Future<ArtifactDetail> getArtifact(String artifactId) async {
    final result = await client.call(
      id: 'artifacts.get',
      method: AscpMethod.artifactsGet,
      params: {'artifact_id': artifactId},
    );
    if (result is! Map) {
      throw const FormatException('Expected artifact response object.');
    }
    final artifact = result['artifact'];
    if (artifact is! Map) {
      throw const FormatException('Expected artifact object.');
    }
    final json = Map<String, Object?>.from(artifact);
    return ArtifactDetail(
      id: json['id'] as String? ?? artifactId,
      name: json['name'] as String? ?? artifactId,
      mimeType: json['mime_type'] as String? ?? 'application/octet-stream',
    );
  }

  @override
  Future<DiffDetail> getDiff(String diffId) async {
    final result = await client.call(
      id: 'diffs.get',
      method: AscpMethod.diffsGet,
      params: {'diff_id': diffId},
    );
    if (result is! Map) {
      throw const FormatException('Expected diff response object.');
    }
    final diff = result['diff'];
    if (diff is! Map) {
      throw const FormatException('Expected diff object.');
    }
    final json = Map<String, Object?>.from(diff);
    return DiffDetail(
      id: json['id'] as String? ?? diffId,
      summary: json['summary'] as String? ?? '',
      fileCount: json['file_count'] as int? ?? 0,
    );
  }
}

bool _isEmptyInspectState(AscpErrorCode code) {
  return code == AscpErrorCode.notFound || code == AscpErrorCode.unsupported;
}
