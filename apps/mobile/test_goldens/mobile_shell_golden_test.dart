import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/continuum_app.dart';
import 'package:mobile/app/mobile_dependencies.dart';
import 'package:mobile/features/sessions/application/session_list_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';

void main() {
  testWidgets('first-run pairing shell golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const ContinuumMobileApp());
    await tester.pump();

    await expectLater(
      find.byType(ContinuumMobileApp),
      matchesGoldenFile('goldens/first_run_pairing_shell.png'),
    );
  });

  testWidgets('trusted sessions shell golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final dependencies = MobileDependencies.memory(
      sessionListController: SessionListController(
        repository: MemorySessionRepository(
          sessions: [
            SessionSummary(
              id: 'sess_running',
              title: 'Mobile companion build',
              status: 'running',
              updatedAt: DateTime.utc(2026, 5, 25, 13),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ContinuumMobileApp(isTrusted: true, dependencies: dependencies),
    );
    await tester.tap(find.text('Sessions').last);
    await tester.pump();
    await tester.pump();

    await expectLater(
      find.byType(ContinuumMobileApp),
      matchesGoldenFile('goldens/trusted_sessions_shell.png'),
    );
  });
}
