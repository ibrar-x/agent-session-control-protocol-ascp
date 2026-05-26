import 'package:flutter/widgets.dart';

import '../../../core/design_system/continuum_tokens.dart';
import '../../../core/security/local_auth_gate.dart';
import '../application/settings_controller.dart';
import '../data/settings_repository.dart';
import '../domain/transport_diagnostics.dart';
import '../domain/trusted_device.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({SettingsController? controller, super.key})
    : controller =
          controller ??
          SettingsController(
            repository: MemorySettingsRepository(),
            localAuth: const AllowingLocalAuthGate(),
          );

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SettingsViewState>(
      future: _load(),
      builder: (context, snapshot) {
        final state = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings and trusted devices',
              style: TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _SettingsBody(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                error: snapshot.error,
                state: state,
                controller: controller,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<_SettingsViewState> _load() async {
    final diagnostics = await controller.readDiagnostics();
    final devices = await controller.listTrustedDevices();
    return _SettingsViewState(diagnostics: diagnostics, devices: devices);
  }
}

class _SettingsViewState {
  const _SettingsViewState({required this.diagnostics, required this.devices});

  final TransportDiagnostics diagnostics;
  final List<TrustedDevice> devices;
}

class _SettingsBody extends StatefulWidget {
  const _SettingsBody({
    required this.isLoading,
    required this.error,
    required this.state,
    required this.controller,
  });

  final bool isLoading;
  final Object? error;
  final _SettingsViewState? state;
  final SettingsController controller;

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  List<TrustedDevice> _devices = const [];

  @override
  void didUpdateWidget(covariant _SettingsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final devices = widget.state?.devices;
    if (devices != null && devices != oldWidget.state?.devices) {
      _devices = devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const _MutedCopy('Loading trusted devices...');
    }
    if (widget.error != null) {
      return const _MutedCopy('Unable to load settings.');
    }
    final diagnostics = widget.state?.diagnostics;
    if (diagnostics == null) {
      return const SizedBox.shrink();
    }

    return ListView(
      children: [
        _DiagnosticsRow(diagnostics: diagnostics),
        const SizedBox(height: 14),
        if (_devices.isEmpty)
          const _MutedCopy('No trusted devices')
        else
          for (final device in _devices)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DeviceRow(
                device: device,
                onRevoke: () => _revoke(device),
              ),
            ),
      ],
    );
  }

  Future<void> _revoke(TrustedDevice device) async {
    final revoked = await widget.controller.revokeDevice(device);
    if (!mounted || !revoked) {
      return;
    }
    setState(() {
      _devices = [
        for (final current in _devices)
          if (current.id != device.id) current,
      ];
    });
  }
}

class _DiagnosticsRow extends StatelessWidget {
  const _DiagnosticsRow({required this.diagnostics});

  final TransportDiagnostics diagnostics;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ContinuumColorTokens.bgElevated,
        border: Border.all(color: ContinuumColorTokens.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                diagnostics.hostId,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              diagnostics.state,
              style: TextStyle(
                color: diagnostics.isDegraded
                    ? ContinuumColorTokens.warning
                    : ContinuumColorTokens.accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device, required this.onRevoke});

  final TrustedDevice device;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ContinuumColorTokens.bgElevated,
        border: Border.all(color: ContinuumColorTokens.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                device.displayName,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRevoke,
              child: const Text(
                'Revoke',
                style: TextStyle(
                  color: ContinuumColorTokens.danger,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MutedCopy extends StatelessWidget {
  const _MutedCopy(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ContinuumColorTokens.mutedText,
        fontSize: 14,
        height: 1.45,
      ),
    );
  }
}
