import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/continuum_app.dart';
import 'package:mobile/app/mobile_dependencies.dart';
import 'package:mobile/app/mobile_providers.dart';
import 'package:mobile/features/sessions/application/session_list_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';

void main() {
  test('mobile dependencies provider defaults to memory dependencies', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final dependencies = container.read(mobileDependenciesProvider);

    expect(
      dependencies.sessionListController.repository,
      isA<MemorySessionRepository>(),
    );
  });

  test('mobile dependencies provider builds live dependencies from config', () {
    final container = ProviderContainer(
      overrides: [
        mobileRuntimeConfigProvider.overrideWithValue(
          MobileRuntimeConfig.live(
            rpcEndpoint: Uri.parse('http://127.0.0.1:18787/rpc'),
            websocketEndpoint: Uri.parse('ws://127.0.0.1:18787/rpc'),
            daemonAdminBaseUrl: Uri.parse('http://127.0.0.1:18787'),
            hostId: 'host_provider',
            activeSessionId: 'sess_provider',
            currentDeviceId: 'device_provider',
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final dependencies = container.read(mobileDependenciesProvider);

    expect(
      dependencies.sessionListController.repository,
      isA<AscpSessionRepository>(),
    );
    expect(dependencies.hostId, 'host_provider');
    expect(dependencies.activeSessionId, 'sess_provider');
  });

  testWidgets('app reads mobile dependencies from ProviderScope override', (
    tester,
  ) async {
    final dependencies = MobileDependencies.memory(
      sessionListController: SessionListController(
        repository: MemorySessionRepository(
          sessions: [
            SessionSummary(
              id: 'sess_provider_override',
              title: 'Provider override session',
              status: 'running',
              updatedAt: DateTime.utc(2026, 5, 26, 8),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [mobileDependenciesProvider.overrideWithValue(dependencies)],
        child: const ContinuumMobileApp(isTrusted: true),
      ),
    );

    await tester.tap(find.text('Sessions').last);
    await tester.pump();
    await tester.pump();

    expect(find.text('Provider override session'), findsOneWidget);
  });
}
