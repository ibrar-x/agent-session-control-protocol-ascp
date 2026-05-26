import '../../../core/security/local_auth_gate.dart';
import '../data/settings_repository.dart';
import '../domain/transport_diagnostics.dart';
import '../domain/trusted_device.dart';

class SettingsController {
  const SettingsController({
    required this.repository,
    required this.localAuth,
  });

  final SettingsRepository repository;
  final LocalAuthGate localAuth;

  Future<List<TrustedDevice>> listTrustedDevices() {
    return repository.listTrustedDevices();
  }

  Future<TransportDiagnostics> readDiagnostics() {
    return repository.readDiagnostics();
  }

  Future<bool> revokeDevice(TrustedDevice device) async {
    if (device.requiresLocalAuthForRevoke) {
      final confirmed = await localAuth.confirm('Revoke this trusted device');
      if (!confirmed) {
        return false;
      }
    }
    await repository.revokeTrustedDevice(device.id);
    return true;
  }
}
