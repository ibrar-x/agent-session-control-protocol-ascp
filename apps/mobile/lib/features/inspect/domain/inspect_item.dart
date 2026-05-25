enum InspectItemKind {
  diff,
  artifact,
}

class InspectItem {
  const InspectItem._({
    required this.id,
    required this.kind,
  });

  const InspectItem.diff(String id) : this._(id: id, kind: InspectItemKind.diff);

  const InspectItem.artifact(String id) : this._(id: id, kind: InspectItemKind.artifact);

  final String id;
  final InspectItemKind kind;
}

class ArtifactDetail {
  const ArtifactDetail({
    required this.id,
    required this.name,
    required this.mimeType,
  });

  final String id;
  final String name;
  final String mimeType;
}

class DiffDetail {
  const DiffDetail({
    required this.id,
    required this.summary,
    required this.fileCount,
  });

  final String id;
  final String summary;
  final int fileCount;
}

class InspectState {
  const InspectState({
    required this.items,
    required this.isSupported,
    this.reason,
  });

  final List<InspectItem> items;
  final bool isSupported;
  final String? reason;
}
