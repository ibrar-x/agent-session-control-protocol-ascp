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
    return DecoratedBox(
      decoration: const BoxDecoration(color: ContinuumColorTokens.bgSurface),
      child: FutureBuilder<_SettingsViewState>(
        future: _load(),
        builder: (context, snapshot) {
          final state = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(),
              Expanded(
                child: _SettingsBody(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  error: snapshot.error,
                  state: state,
                  controller: controller,
                ),
              ),
            ],
          );
        },
      ),
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings and trusted devices',
            style: TextStyle(
              color: ContinuumColorTokens.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Sessio mobile',
            style: const TextStyle(
              color: ContinuumColorTokens.mutedText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
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
      return const Center(child: _MutedCopy('Loading settings...'));
    }
    if (widget.error != null) {
      return const Center(child: _MutedCopy('Unable to load settings.'));
    }
    final diagnostics = widget.state?.diagnostics;
    if (diagnostics == null) {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        _UserSummaryCard(),
        const SizedBox(height: 10),
        _SectionHeader(label: 'Trusted devices'),
        _SettingCard(
          children: [
            for (final device in _devices)
              _DeviceRow(device: device, onRevoke: () => _revoke(device)),
            if (_devices.isEmpty)
              const _DisplayRow(
                glyph: '◌',
                label: 'No trusted devices',
                value: '',
                glyphBg: ContinuumColorTokens.bgOverlay,
                glyphColor: ContinuumColorTokens.mutedText,
              ),
          ],
        ),
        const SizedBox(height: 6),
        _SectionHeader(label: 'Appearance'),
        _SettingCard(
          children: [
            _NavRow(
              glyph: '◐',
              label: 'Theme',
              value: 'System',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
            ),
            _NavRow(
              glyph: '▦',
              label: 'Display density',
              value: 'Comfortable',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
            ),
          ],
        ),
        const SizedBox(height: 6),
        _SectionHeader(label: 'Notifications'),
        _SettingCard(
          children: [
            _ToggleRow(
              glyph: '⚑',
              label: 'Approval alerts',
              sublabel: 'Notify when agents need review',
              glyphBg: ContinuumColorTokens.accent.withValues(alpha: 0.15),
              glyphColor: ContinuumColorTokens.accent,
              value: true,
            ),
            _ToggleRow(
              glyph: '◉',
              label: 'Session updates',
              sublabel: 'Progress and completion events',
              glyphBg: ContinuumColorTokens.success.withValues(alpha: 0.15),
              glyphColor: ContinuumColorTokens.success,
              value: true,
            ),
            _ToggleRow(
              glyph: '▤',
              label: 'Completed summaries',
              sublabel: 'Summary after each session ends',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
              value: false,
            ),
          ],
        ),
        const SizedBox(height: 6),
        _SectionHeader(label: 'Connection'),
        _SettingCard(
          children: [
            _NavRow(
              glyph: '⏱',
              label: 'Timeout',
              value: '30 seconds',
              glyphBg: ContinuumColorTokens.accent.withValues(alpha: 0.15),
              glyphColor: ContinuumColorTokens.accent,
            ),
            _NavRow(
              glyph: '◎',
              label: 'Relay preference',
              value: 'Local first',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
            ),
            _ToggleRow(
              glyph: '↻',
              label: 'Reconnect automatically',
              sublabel: 'Resume on network restore',
              glyphBg: ContinuumColorTokens.success.withValues(alpha: 0.15),
              glyphColor: ContinuumColorTokens.success,
              value: true,
            ),
          ],
        ),
        const SizedBox(height: 6),
        _SectionHeader(label: 'Security'),
        _SettingCard(
          children: [
            _ToggleRow(
              glyph: '⚿',
              label: 'Require biometric unlock',
              sublabel: 'FaceID before opening Sessio',
              glyphBg: ContinuumColorTokens.accent.withValues(alpha: 0.15),
              glyphColor: ContinuumColorTokens.accent,
              value: true,
            ),
            _NavRow(
              glyph: '↑',
              label: 'Export logs',
              value: null,
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
            ),
          ],
        ),
        const SizedBox(height: 6),
        _SectionHeader(label: 'Diagnostics'),
        _SettingCard(
          children: [
            _DisplayRow(
              glyph: '#',
              label: 'App version',
              value: '0.1.0',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
            ),
            _DisplayRow(
              glyph: '⇋',
              label: 'Bridge protocol',
              value: 'ASCP',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
            ),
            _DisplayRow(
              glyph: '◷',
              label: 'Last sync',
              value: 'Just now',
              glyphBg: ContinuumColorTokens.bgOverlay,
              glyphColor: ContinuumColorTokens.mutedText,
              valueColor: ContinuumColorTokens.success,
            ),
          ],
        ),
        const SizedBox(height: 6),
        _DestructiveCard(
          children: [
            _DestructiveRow(glyph: '⊘', label: 'Revoke all trusted devices'),
            _DestructiveRow(glyph: '⊗', label: 'Clear local session cache'),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'These actions are immediate and cannot be undone.',
          textAlign: TextAlign.center,
          style: TextStyle(color: ContinuumColorTokens.mutedText, fontSize: 11),
        ),
        const SizedBox(height: 16),
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

class _UserSummaryCard extends StatelessWidget {
  const _UserSummaryCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ContinuumColorTokens.bgElevated,
        border: Border.all(color: ContinuumColorTokens.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        child: Row(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: ContinuumColorTokens.accent,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: Text(
                    'MI',
                    style: TextStyle(
                      color: ContinuumColorTokens.accentForeground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Muhammad',
                    style: TextStyle(
                      color: ContinuumColorTokens.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'MacBook Pro · Local',
                    style: const TextStyle(
                      color: ContinuumColorTokens.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: ContinuumColorTokens.success.withValues(alpha: 0.15),
                border: Border.all(
                  color: ContinuumColorTokens.success.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: ContinuumColorTokens.success,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(width: 5, height: 5),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Trusted',
                      style: TextStyle(
                        color: ContinuumColorTokens.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: ContinuumColorTokens.mutedText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ContinuumColorTokens.bgElevated,
        border: Border.all(color: ContinuumColorTokens.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          return Column(
            children: [widget, if (index < children.length - 1) _CardDivider()],
          );
        }).toList(),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ContinuumColorTokens.border, width: 0.5),
        ),
      ),
      child: const SizedBox(height: 1),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device, required this.onRevoke});

  final TrustedDevice device;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: ContinuumColorTokens.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: Text(
                  '⌘',
                  style: TextStyle(
                    color: ContinuumColorTokens.accent,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.displayName,
                  style: const TextStyle(
                    color: ContinuumColorTokens.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'connected',
                  style: TextStyle(
                    color: ContinuumColorTokens.success,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onRevoke,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ContinuumColorTokens.danger.withValues(alpha: 0.12),
                border: Border.all(
                  color: ContinuumColorTokens.danger.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Revoke',
                  style: TextStyle(
                    color: ContinuumColorTokens.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.glyph,
    required this.label,
    required this.value,
    required this.glyphBg,
    required this.glyphColor,
  });

  final String glyph;
  final String label;
  final String? value;
  final Color glyphBg;
  final Color glyphColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: glyphBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Center(
                    child: Text(
                      glyph,
                      style: TextStyle(color: glyphColor, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (value != null) ...[
                Text(
                  value!,
                  style: const TextStyle(
                    color: ContinuumColorTokens.mutedText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Text(
                '›',
                style: TextStyle(
                  color: ContinuumColorTokens.border,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.glyph,
    required this.label,
    required this.sublabel,
    required this.glyphBg,
    required this.glyphColor,
    required this.value,
  });

  final String glyph;
  final String label;
  final String sublabel;
  final Color glyphBg;
  final Color glyphColor;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: glyphBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Center(
                    child: Text(
                      glyph,
                      style: TextStyle(color: glyphColor, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: ContinuumColorTokens.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      color: ContinuumColorTokens.mutedText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _Toggle(value: value),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: value
            ? ContinuumColorTokens.accent
            : ContinuumColorTokens.border,
        borderRadius: BorderRadius.circular(999),
      ),
      child: SizedBox(
        width: 44,
        height: 24,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: value
                    ? ContinuumColorTokens.accentForeground
                    : ContinuumColorTokens.mutedText,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 20, height: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _DisplayRow extends StatelessWidget {
  const _DisplayRow({
    required this.glyph,
    required this.label,
    required this.value,
    required this.glyphBg,
    required this.glyphColor,
    this.valueColor,
  });

  final String glyph;
  final String label;
  final String value;
  final Color glyphBg;
  final Color glyphColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: glyphBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Center(
                    child: Text(
                      glyph,
                      style: TextStyle(color: glyphColor, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? ContinuumColorTokens.mutedText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DestructiveCard extends StatelessWidget {
  const _DestructiveCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ContinuumColorTokens.bgElevated,
        border: Border.all(
          color: ContinuumColorTokens.danger.withValues(alpha: 0.25),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          return Column(
            children: [
              widget,
              if (index < children.length - 1)
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ContinuumColorTokens.danger.withValues(
                          alpha: 0.1,
                        ),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: const SizedBox(height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DestructiveRow extends StatelessWidget {
  const _DestructiveRow({required this.glyph, required this.label});

  final String glyph;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Text(
            glyph,
            style: const TextStyle(
              color: ContinuumColorTokens.danger,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: ContinuumColorTokens.danger,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MutedCopy extends StatelessWidget {
  const _MutedCopy(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: ContinuumColorTokens.mutedText,
          fontSize: 14,
          height: 1.45,
        ),
      ),
    );
  }
}
