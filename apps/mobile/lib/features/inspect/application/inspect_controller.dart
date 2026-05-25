import '../data/inspect_repository.dart';
import '../domain/inspect_item.dart';

class InspectController {
  const InspectController({
    required this.repository,
    this.isSupported = true,
    this.unsupportedReason,
  });

  final InspectRepository repository;
  final bool isSupported;
  final String? unsupportedReason;

  Future<InspectState> load() async {
    if (!isSupported) {
      return InspectState(
        items: const [],
        isSupported: false,
        reason: unsupportedReason ?? 'artifact and diff capabilities are unavailable',
      );
    }
    return InspectState(
      items: prioritizeInspectItems(await repository.listItems()),
      isSupported: true,
    );
  }

  Future<ArtifactDetail> getArtifact(String artifactId) {
    return repository.getArtifact(artifactId);
  }

  Future<DiffDetail> getDiff(String diffId) {
    return repository.getDiff(diffId);
  }
}

List<InspectItem> prioritizeInspectItems(List<InspectItem> items) {
  final ordered = [...items]
    ..sort((a, b) {
      final byKind = a.kind.index.compareTo(b.kind.index);
      if (byKind != 0) {
        return byKind;
      }
      return a.id.compareTo(b.id);
    });
  return ordered;
}
