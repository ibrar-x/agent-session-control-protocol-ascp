import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/security/local_auth_gate.dart';
import 'package:mobile/core/security/secure_store.dart';
import 'package:mobile/core/security/trust_material.dart';
import 'package:mobile/features/pairing/application/pairing_controller.dart';
import 'package:mobile/features/pairing/data/pairing_repository.dart';
import 'package:mobile/features/pairing/domain/pairing_state.dart';
import 'package:mobile/features/pairing/presentation/pairing_screen.dart';

class _FakeSecureStore implements SecureStore {
  @override
  Future<TrustMaterial?> readTrustMaterial() async => null;

  @override
  Future<void> writeTrustMaterial(TrustMaterial material) async {}
}

class _AllowingAuth implements LocalAuthGate {
  @override
  Future<bool> confirm(String reason) async => true;
}

class _DeterministicPoll implements PairingPollSimulator {
  final PairingPollState _state;
  _DeterministicPoll(this._state);

  @override
  PairingPollState simulatePoll(PairingClaim claim) => _state;
}

class _StubScanner implements PairingScanner {
  @override
  Future<String?> scan(BuildContext context) async =>
      'continuum://pair?host=http%3A%2F%2F127.0.0.1%3A8765&code=STUB';
}

class _NullScanner implements PairingScanner {
  @override
  Future<String?> scan(BuildContext context) async => null;
}

Future<void> _enterPairingCode(WidgetTester tester, String code) async {
  await tester.enterText(find.byType(EditableText).first, code);
  await tester.pump();
}

Widget _pairingHarness(PairingScreen screen) {
  return WidgetsApp(
    color: const Color(0xFF100D08),
    pageRouteBuilder: <T>(settings, builder) {
      return PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) {
          return builder(context);
        },
      );
    },
    home: screen,
  );
}

void main() {
  testWidgets('pairing screen renders idle with scan and manual buttons', (
    tester,
  ) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.pending),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    expect(find.text('Pair a host'), findsOneWidget);
    expect(find.text('Scan QR code'), findsOneWidget);
    expect(find.text('● Enter the 6-digit host code'), findsOneWidget);
    expect(find.byType(EditableText), findsNWidgets(6));
  });

  testWidgets('pairing screen shows scanning placeholder when scan tapped', (
    tester,
  ) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.pending),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await tester.tap(find.text('Scan QR code'));
    await tester.pump();

    expect(find.text('Pair a host'), findsOneWidget);
    expect(find.text('Scan QR code'), findsOneWidget);
    expect(find.text('Claim device'), findsOneWidget);
  });

  testWidgets('pairing screen shows shadcn OTP entry', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.pending),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    expect(find.byType(EditableText), findsNWidgets(6));
    expect(find.text('Claim device'), findsOneWidget);
  });

  testWidgets('pairing screen accepts submitted payload', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.approved),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '123456');
    await tester.pumpAndSettle();

    expect(controller.state.isTrusted, isTrue);
  });

  testWidgets('pairing screen shows trusted state when poll approved', (
    tester,
  ) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.approved),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '111111');
    await tester.pumpAndSettle();

    expect(find.text('● Host approved this device.'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('pairing screen shows pending host approval state', (
    tester,
  ) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.pending),
    );

    await controller.submitPayload(
      'continuum://pair?host=http%3A%2F%2F127.0.0.1%3A8765&code=PENDING',
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    expect(find.text('● Waiting for host approval...'), findsOneWidget);
    expect(find.text('Scan QR code'), findsOneWidget);
    expect(find.byType(EditableText), findsNWidgets(6));
  });

  testWidgets('pairing screen notifies parent when trusted continue tapped', (
    tester,
  ) async {
    var continued = false;
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.approved),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(
          controller: controller,
          scanner: _NullScanner(),
          onContinue: () => continued = true,
        ),
      ),
    );

    await _enterPairingCode(tester, '111111');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(continued, isTrue);
  });

  testWidgets('pairing screen shows rejected error with claim affordance', (
    tester,
  ) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.rejected),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '222222');
    await tester.pumpAndSettle();

    expect(find.text('Rejected by host'), findsOneWidget);
    expect(find.text('Claim device'), findsOneWidget);
  });

  testWidgets('pairing failure keeps manual input available', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.rejected),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '222222');
    await tester.pumpAndSettle();

    expect(find.text('2'), findsNWidgets(6));
  });

  testWidgets('pairing screen shows expired error', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.expired),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '333333');
    await tester.pumpAndSettle();

    expect(find.text('Pairing code expired'), findsOneWidget);
  });

  testWidgets('pairing screen shows revoked error', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.revoked),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '444444');
    await tester.pumpAndSettle();

    expect(find.text('Pairing revoked'), findsOneWidget);
  });

  testWidgets('pairing screen shows unreachable error', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.unreachable),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await _enterPairingCode(tester, '555555');
    await tester.pumpAndSettle();

    expect(find.text('Host unreachable'), findsOneWidget);
  });

  testWidgets('pairing screen shows malformed error on invalid input', (
    tester,
  ) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.pending),
    );

    await controller.submitPayload('totally-invalid');

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    expect(find.text('Invalid pairing code'), findsOneWidget);
  });

  testWidgets('mock scanner returns simulated QR payload without real camera', (
    tester,
  ) async {
    final scanner = _StubScanner();
    late final String? result;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () async => result = await scanner.scan(context),
              child: const Text('Scan'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Scan'));
    await tester.pump();

    expect(result, isNotNull);
    expect(result, contains('continuum://pair'));
    expect(result, contains('STUB'));
  });

  testWidgets('cancel returns to idle from scanning', (tester) async {
    final controller = PairingController(
      secureStore: _FakeSecureStore(),
      localAuth: _AllowingAuth(),
      pollSimulator: _DeterministicPoll(PairingPollState.pending),
    );

    await tester.pumpWidget(
      _pairingHarness(
        PairingScreen(controller: controller, scanner: _NullScanner()),
      ),
    );

    await tester.tap(find.text('Scan QR code'));
    await tester.pump();

    expect(find.text('Pair a host'), findsOneWidget);
    expect(find.text('Scan QR code'), findsOneWidget);
  });
}
