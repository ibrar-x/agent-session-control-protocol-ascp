import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/database/continuum_database.dart';
import 'package:mobile/features/inspect/domain/inspect_item.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';

void main() {
  test('stores replay cursor per host and session', () async {
    final db = ContinuumDatabase.inMemory();

    await db.saveReplayCursor(
      hostId: 'host_1',
      sessionId: 'sess_1',
      sequence: 42,
    );

    expect(
      await db.readReplayCursor(hostId: 'host_1', sessionId: 'sess_1'),
      42,
    );
    await db.close();
  });

  test('stores session summaries per host', () async {
    final db = ContinuumDatabase.inMemory();
    final updatedAt = DateTime.utc(2026, 5, 25, 12);

    await db.saveSessionSummaries(
      hostId: 'host_1',
      sessions: [
        SessionSummary(
          id: 'sess_1',
          title: 'Build mobile',
          status: 'running',
          updatedAt: updatedAt,
        ),
      ],
    );

    final cached = await db.readSessionSummaries(hostId: 'host_1');

    expect(cached.single.id, 'sess_1');
    expect(cached.single.title, 'Build mobile');
    expect(cached.single.status, 'running');
    expect(cached.single.updatedAt, updatedAt);
    await db.close();
  });

  test('stores artifact and diff metadata per host and session', () async {
    final db = ContinuumDatabase.inMemory();

    await db.saveArtifactDetail(
      hostId: 'host_1',
      sessionId: 'sess_1',
      artifact: const ArtifactDetail(
        id: 'artifact_1',
        name: 'Report',
        mimeType: 'text/markdown',
      ),
    );
    await db.saveDiffDetail(
      hostId: 'host_1',
      sessionId: 'sess_1',
      diff: const DiffDetail(
        id: 'diff_1',
        summary: '2 files changed',
        fileCount: 2,
      ),
    );

    final artifact = await db.readArtifactDetail(
      hostId: 'host_1',
      sessionId: 'sess_1',
      artifactId: 'artifact_1',
    );
    final diff = await db.readDiffDetail(
      hostId: 'host_1',
      sessionId: 'sess_1',
      diffId: 'diff_1',
    );

    expect(artifact?.name, 'Report');
    expect(artifact?.mimeType, 'text/markdown');
    expect(diff?.summary, '2 files changed');
    expect(diff?.fileCount, 2);
    await db.close();
  });
}
