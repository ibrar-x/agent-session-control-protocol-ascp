import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/app/continuum_app.dart';
import 'package:mobile/app/mobile_dependencies.dart';
import 'package:mobile/core/security/local_auth_gate.dart';
import 'package:mobile/core/security/secure_store.dart';
import 'package:mobile/features/pairing/application/pairing_controller.dart';
import 'package:mobile/features/pairing/data/pairing_repository.dart';
import 'package:mobile/features/pairing/presentation/pairing_screen.dart';

void main() {
  runApp(const IntegrationTestApp());
}

class IntegrationTestApp extends StatelessWidget {
  const IntegrationTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final deps = MobileDependencies(
      hostId: 'test_host',
      activeSessionId: 'test_session',
      sessionListController: MobileDependencies.memory().sessionListController,
      approvalQueueController:
          MobileDependencies.memory().approvalQueueController,
      inspectController: MobileDependencies.memory().inspectController,
      settingsController: MobileDependencies.memory().settingsController,
      pairingController: PairingController(
        secureStore: MemorySecureStore(),
        localAuth: const AllowingLocalAuthGate(),
        claimRepository: DaemonPairingRepository(dio: dio),
        repositoryPollInterval: const Duration(milliseconds: 500),
        repositoryMaxPollAttempts: 40,
      ),
      pairingScanner: const _NoopPairingScanner(),
      createSessionSubscriptionRepository: () =>
          MobileDependencies.memory().createSessionSubscriptionRepository(),
    );

    return ProviderScope(
      child: ContinuumMobileApp(dependencies: deps),
    );
  }
}

class _NoopPairingScanner implements PairingScanner {
  const _NoopPairingScanner();

  @override
  Future<String?> scan(dynamic context) async => null;
}
