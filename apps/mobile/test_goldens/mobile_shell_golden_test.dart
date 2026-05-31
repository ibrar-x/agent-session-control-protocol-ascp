import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/continuum_app.dart';
import 'package:mobile/app/mobile_dependencies.dart';
import 'package:mobile/core/security/local_auth_gate.dart';
import 'package:mobile/features/approvals/application/approval_queue_controller.dart';
import 'package:mobile/features/approvals/data/approval_repository.dart';
import 'package:mobile/features/approvals/domain/approval_view_model.dart';

import 'package:mobile/features/settings/application/settings_controller.dart';
import 'package:mobile/features/settings/data/settings_repository.dart';
import 'package:mobile/features/settings/domain/transport_diagnostics.dart';
import 'package:mobile/features/settings/domain/trusted_device.dart';
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

  testWidgets('trusted approvals shell golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final dependencies = MobileDependencies.memory(
      approvalQueueController: ApprovalQueueController(
        repository: MemoryApprovalRepository(
          approvals: [
            ApprovalViewModel.pending(
              id: 'approval_cmd',
              sessionId: 'sess_running',
              isActionable: true,
              reason: 'Allow shell command in Mobile companion build',
            ),
            ApprovalViewModel.pending(
              id: 'approval_readonly',
              sessionId: 'sess_review',
              isActionable: false,
              reason: 'Review read-only repository context',
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ContinuumMobileApp(isTrusted: true, dependencies: dependencies),
    );
    await tester.tap(find.text('Approvals').last);
    await tester.pump();
    await tester.pump();

    await expectLater(
      find.byType(ContinuumMobileApp),
      matchesGoldenFile('goldens/trusted_approvals_shell.png'),
    );
  });

  testWidgets('trusted devices shell golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));

    await tester.pumpWidget(
      ContinuumMobileApp(isTrusted: true),
    );
    await tester.tap(find.text('Devices').last);
    await tester.pump();
    await tester.pump();

    await expectLater(
      find.byType(ContinuumMobileApp),
      matchesGoldenFile('goldens/trusted_devices_shell.png'),
    );
  });

  testWidgets('trusted settings shell golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final dependencies = MobileDependencies.memory(
      settingsController: SettingsController(
        repository: MemorySettingsRepository(
          devices: const [
            TrustedDevice.current(
              id: 'device_mobile',
              displayName: 'Ibrar iPhone',
            ),
            TrustedDevice(
              id: 'device_tablet',
              displayName: 'QA tablet',
              isCurrentDevice: false,
            ),
          ],
          diagnostics: const TransportDiagnostics(
            hostId: 'host_local',
            state: 'connected',
            replayEnabled: true,
          ),
        ),
        localAuth: const AllowingLocalAuthGate(),
      ),
    );

    await tester.pumpWidget(
      ContinuumMobileApp(isTrusted: true, dependencies: dependencies),
    );
    await tester.tap(find.text('Settings').last);
    await tester.pump();
    await tester.pump();

    await expectLater(
      find.byType(ContinuumMobileApp),
      matchesGoldenFile('goldens/trusted_settings_shell.png'),
    );
  });
}
