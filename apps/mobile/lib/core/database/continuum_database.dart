import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../features/inspect/domain/inspect_item.dart';
import '../../features/sessions/domain/timeline_event.dart';
import 'migrations.dart';

part 'continuum_database.g.dart';

class ReplayCursors extends Table {
  TextColumn get hostId => text()();

  TextColumn get sessionId => text()();

  IntColumn get sequence => integer()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {hostId, sessionId};
}

class CachedSessions extends Table {
  TextColumn get hostId => text()();

  TextColumn get sessionId => text()();

  TextColumn get title => text()();

  TextColumn get status => text()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {hostId, sessionId};
}

class CachedArtifacts extends Table {
  TextColumn get hostId => text()();

  TextColumn get sessionId => text()();

  TextColumn get artifactId => text()();

  TextColumn get name => text()();

  TextColumn get mimeType => text()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {hostId, sessionId, artifactId};
}

class CachedDiffs extends Table {
  TextColumn get hostId => text()();

  TextColumn get sessionId => text()();

  TextColumn get diffId => text()();

  TextColumn get summary => text()();

  IntColumn get fileCount => integer()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {hostId, sessionId, diffId};
}

@DriftDatabase(
  tables: [ReplayCursors, CachedSessions, CachedArtifacts, CachedDiffs],
)
class ContinuumDatabase extends _$ContinuumDatabase {
  ContinuumDatabase(super.executor);

  ContinuumDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => currentContinuumDatabaseSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(cachedSessions);
        await migrator.createTable(cachedArtifacts);
        await migrator.createTable(cachedDiffs);
      }
    },
  );

  Future<void> saveReplayCursor({
    required String hostId,
    required String sessionId,
    required int sequence,
  }) async {
    await into(replayCursors).insertOnConflictUpdate(
      ReplayCursorsCompanion.insert(
        hostId: hostId,
        sessionId: sessionId,
        sequence: sequence,
      ),
    );
  }

  Future<int?> readReplayCursor({
    required String hostId,
    required String sessionId,
  }) async {
    final query = select(replayCursors)
      ..where(
        (row) => row.hostId.equals(hostId) & row.sessionId.equals(sessionId),
      );
    return (await query.getSingleOrNull())?.sequence;
  }

  Future<void> saveSessionSummaries({
    required String hostId,
    required List<SessionSummary> sessions,
  }) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        cachedSessions,
        sessions.map(
          (session) => CachedSessionsCompanion.insert(
            hostId: hostId,
            sessionId: session.id,
            title: session.title,
            status: session.status,
            updatedAt: session.updatedAt,
          ),
        ),
      );
    });
  }

  Future<List<SessionSummary>> readSessionSummaries({
    required String hostId,
  }) async {
    final query = select(cachedSessions)
      ..where((row) => row.hostId.equals(hostId))
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.updatedAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows
        .map(
          (row) => SessionSummary(
            id: row.sessionId,
            title: row.title,
            status: row.status,
            updatedAt: row.updatedAt.toUtc(),
          ),
        )
        .toList(growable: false);
  }

  Future<void> saveArtifactDetail({
    required String hostId,
    required String sessionId,
    required ArtifactDetail artifact,
  }) async {
    await into(cachedArtifacts).insertOnConflictUpdate(
      CachedArtifactsCompanion.insert(
        hostId: hostId,
        sessionId: sessionId,
        artifactId: artifact.id,
        name: artifact.name,
        mimeType: artifact.mimeType,
      ),
    );
  }

  Future<ArtifactDetail?> readArtifactDetail({
    required String hostId,
    required String sessionId,
    required String artifactId,
  }) async {
    final query = select(cachedArtifacts)
      ..where(
        (row) =>
            row.hostId.equals(hostId) &
            row.sessionId.equals(sessionId) &
            row.artifactId.equals(artifactId),
      );
    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }
    return ArtifactDetail(
      id: row.artifactId,
      name: row.name,
      mimeType: row.mimeType,
    );
  }

  Future<void> saveDiffDetail({
    required String hostId,
    required String sessionId,
    required DiffDetail diff,
  }) async {
    await into(cachedDiffs).insertOnConflictUpdate(
      CachedDiffsCompanion.insert(
        hostId: hostId,
        sessionId: sessionId,
        diffId: diff.id,
        summary: diff.summary,
        fileCount: diff.fileCount,
      ),
    );
  }

  Future<DiffDetail?> readDiffDetail({
    required String hostId,
    required String sessionId,
    required String diffId,
  }) async {
    final query = select(cachedDiffs)
      ..where(
        (row) =>
            row.hostId.equals(hostId) &
            row.sessionId.equals(sessionId) &
            row.diffId.equals(diffId),
      );
    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }
    return DiffDetail(
      id: row.diffId,
      summary: row.summary,
      fileCount: row.fileCount,
    );
  }
}
