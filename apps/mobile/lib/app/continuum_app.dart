import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/continuum_theme.dart';
import '../core/design_system/continuum_tokens.dart';
import '../features/approvals/domain/approval_view_model.dart';
import '../features/approvals/presentation/approvals_screen.dart';
import '../features/inspect/presentation/inspect_screen.dart';
import '../features/pairing/presentation/pairing_screen.dart';
import '../features/sessions/application/session_detail_controller.dart';
import '../features/sessions/domain/timeline_event.dart';
import '../features/sessions/presentation/session_list_screen.dart';
import '../features/sessions/presentation/session_detail_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../ui/shadcn/components/display/badge/badge.dart' as shadcn;
import '../ui/shadcn/shared/theme/theme.dart' as shadcn;
import 'mobile_dependencies.dart';
import 'mobile_providers.dart';

class ContinuumMobileApp extends ConsumerStatefulWidget {
  const ContinuumMobileApp({
    super.key,
    this.isTrusted = false,
    this.dependencies,
  });

  final bool isTrusted;
  final MobileDependencies? dependencies;

  @override
  ConsumerState<ContinuumMobileApp> createState() => _ContinuumMobileAppState();
}

class _ContinuumMobileAppState extends ConsumerState<ContinuumMobileApp> {
  late bool _isTrusted;

  @override
  void initState() {
    super.initState();
    _isTrusted = widget.isTrusted;
    if (!_isTrusted) {
      _restoreStoredTrust();
    }
  }

  @override
  Widget build(BuildContext context) {
    final explicitDependencies = widget.dependencies;
    final resolvedDependencies = explicitDependencies ?? _readDependencies(ref);

    return WidgetsApp(
      title: 'Continuum',
      color: ContinuumColorTokens.accent,
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
        );
      },
      home: shadcn.Theme(
        data: buildContinuumTheme(),
        child: _isTrusted
            ? ContinuumTrustedShell(dependencies: resolvedDependencies)
            : ContinuumFirstRunShell(
                dependencies: resolvedDependencies,
                onTrusted: () => setState(() => _isTrusted = true),
              ),
      ),
    );
  }

  Future<void> _restoreStoredTrust() async {
    final dependencies =
        widget.dependencies ?? _readDependencies(ref, listen: false);
    final material = await dependencies.pairingController.secureStore
        .readTrustMaterial();
    if (!mounted || material == null) {
      return;
    }
    setState(() => _isTrusted = true);
  }

  MobileDependencies _readDependencies(WidgetRef ref, {bool listen = true}) {
    try {
      return listen
          ? ref.watch(mobileDependenciesProvider)
          : ref.read(mobileDependenciesProvider);
    } on StateError {
      return MobileDependencies.memory();
    }
  }
}

class ContinuumTrustedShell extends StatefulWidget {
  const ContinuumTrustedShell({super.key, this.dependencies});

  final MobileDependencies? dependencies;

  @override
  State<ContinuumTrustedShell> createState() => _ContinuumTrustedShellState();
}

class _ContinuumTrustedShellState extends State<ContinuumTrustedShell> {
  int _index = 0;
  SessionSummary? _selectedSession;
  late final MobileDependencies _dependencies;

  static const _tabs = <_ShellTab>[
    _ShellTab('Home', 'Trusted host', 'Connected to an ASCP host.'),
    _ShellTab(
      'Sessions',
      'Live sessions',
      'Observe, resume, and control agent sessions.',
    ),
    _ShellTab(
      'Approvals',
      'Approval queue',
      'Review pending host approval requests.',
    ),
    _ShellTab(
      'Inspect',
      'Artifacts and diffs',
      'Open outputs, patches, logs, and diff metadata.',
    ),
    _ShellTab(
      'Settings',
      'Trusted device',
      'Manage transport, biometrics, and local trust.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dependencies = widget.dependencies ?? MobileDependencies.memory();
  }

  @override
  Widget build(BuildContext context) {
    final active = _tabs[_index];
    return ColoredBox(
      color: SessionColors.pageBackground,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _TrustedTabView(
                  tab: active,
                  dependencies: _dependencies,
                  selectedSession: _selectedSession,
                  onSessionSelected: (session) =>
                      setState(() => _selectedSession = session),
                  onSessionBack: () => setState(() => _selectedSession = null),
                ),
              ),
            ),
            _BottomNav(
              index: _index,
              tabs: _tabs,
              onSelected: (index) => setState(() {
                _index = index;
                if (_tabs[index].label != 'Sessions') {
                  _selectedSession = null;
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustedTabView extends StatelessWidget {
  const _TrustedTabView({
    required this.tab,
    required this.dependencies,
    required this.selectedSession,
    required this.onSessionSelected,
    required this.onSessionBack,
  });

  final _ShellTab tab;
  final MobileDependencies dependencies;
  final SessionSummary? selectedSession;
  final ValueChanged<SessionSummary> onSessionSelected;
  final VoidCallback onSessionBack;

  @override
  Widget build(BuildContext context) {
    final isSessionDetail = selectedSession != null && tab.label == 'Sessions';

    final feature = switch (tab.label) {
      'Sessions' =>
        selectedSession == null
            ? SessionListScreen(
                controller: dependencies.sessionListController,
                onSessionSelected: onSessionSelected,
              )
            : SessionDetailScreen(
                sessionId: selectedSession!.id,
                controller: SessionDetailController(
                  sessionId: selectedSession!.id,
                  repository: dependencies.sessionListController.repository,
                  subscriptionRepository: dependencies
                      .createSessionSubscriptionRepository(),
                ),
              ),
      'Approvals' => ApprovalsScreen(
        controller: dependencies.approvalQueueController,
      ),
      'Inspect' => InspectScreen(controller: dependencies.inspectController),
      'Settings' => SettingsScreen(controller: dependencies.settingsController),
      _ => _HomeDashboard(dependencies: dependencies),
    };

    if (!isSessionDetail) {
      return feature;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                selectedSession!.title,
                style: const TextStyle(
                  color: SessionColors.textDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSessionBack,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: ContinuumColorTokens.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            shadcn.SecondaryBadge(
              child: const Text('Connected', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: feature),
      ],
    );
  }
}

class _DashboardData {
  const _DashboardData({
    required this.sessions,
    required this.runningCount,
    required this.pendingCount,
  });

  final List<SessionSummary> sessions;
  final int runningCount;
  final int pendingCount;
}

class _HomeDashboard extends StatefulWidget {
  const _HomeDashboard({required this.dependencies});

  final MobileDependencies dependencies;

  @override
  State<_HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<_HomeDashboard> {
  late final Future<_DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DashboardHeader(),
              const SizedBox(height: 16),
              _DashboardConnectionCard(hostId: widget.dependencies.hostId),
              const SizedBox(height: 14),
              _DashboardSummaryCards(
                activeSessions: data?.runningCount ?? 0,
                pendingApprovals: data?.pendingCount ?? 0,
              ),
              if (data != null && data.sessions.isNotEmpty) ...[
                const SizedBox(height: 18),
                const _DashboardSectionHeader(label: 'Recent sessions'),
                const SizedBox(height: 8),
                for (final session in data.sessions.take(3))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _DashboardSessionRow(session: session),
                  ),
              ],
              const SizedBox(height: 18),
              const _DashboardSectionHeader(label: 'Paired devices'),
              const SizedBox(height: 8),
              for (final device in _dashboardDevices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _DashboardDeviceRow(device: device),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<_DashboardData> _loadData() async {
    final sessions = await widget.dependencies.sessionListController.load();
    final approvals = await widget.dependencies.approvalQueueController
        .loadQueue();
    return _DashboardData(
      sessions: sessions,
      runningCount: sessions.where((s) => s.status == 'running').length,
      pendingCount: approvals
          .where((a) => a.status == ApprovalStatus.pending)
          .length,
    );
  }

  static const _dashboardDevices = [
    _DashboardDeviceData(
      name: 'MacBook Pro',
      status: 'connected',
      trust: 'Trusted',
    ),
    _DashboardDeviceData(
      name: 'iPhone 15',
      status: 'connecting',
      trust: 'Trusted',
    ),
    _DashboardDeviceData(
      name: 'Mac Mini',
      status: 'disconnected',
      trust: 'Trusted',
    ),
  ];
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continuum',
                style: TextStyle(
                  color: SessionColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'ASCP Protocol Controller',
                style: TextStyle(color: SessionColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        _DashboardStatusChip(
          color: ContinuumColorTokens.success,
          label: 'Connected',
          showDot: true,
        ),
      ],
    );
  }
}

class _DashboardStatusChip extends StatelessWidget {
  const _DashboardStatusChip({
    required this.color,
    required this.label,
    this.showDot = false,
  });

  final Color color;
  final String label;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        borderRadius: BorderRadius.circular(ContinuumRadiusTokens.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              DecoratedBox(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const SizedBox(width: 6, height: 6),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardConnectionCard extends StatelessWidget {
  const _DashboardConnectionCard({required this.hostId});

  final String hostId;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SessionColors.cardSurface,
        border: Border.all(color: SessionColors.borderCard),
        borderRadius: BorderRadius.circular(ContinuumRadiusTokens.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: SessionColors.warmSurface,
                    border: Border.all(color: SessionColors.borderCard),
                    borderRadius: BorderRadius.circular(
                      ContinuumRadiusTokens.sm + 2,
                    ),
                  ),
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Text(
                        '⌘',
                        style: TextStyle(
                          color: SessionColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hostId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: SessionColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.15,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Connected via local relay',
                        style: TextStyle(
                          color: SessionColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _DashboardStatusChip(
                  color: ContinuumColorTokens.accent,
                  label: 'Trusted',
                  showDot: true,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: SessionColors.borderLight,
                      width: 0.5,
                    ),
                  ),
                ),
                child: const SizedBox(height: 1),
              ),
            ),
            Row(
              children: [
                const Text(
                  'Trusted host',
                  style: TextStyle(
                    color: SessionColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                Text(
                  '✓',
                  style: TextStyle(
                    color: ContinuumColorTokens.success,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardSummaryCards extends StatelessWidget {
  const _DashboardSummaryCards({
    required this.activeSessions,
    required this.pendingApprovals,
  });

  final int activeSessions;
  final int pendingApprovals;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DashboardSummaryCard(
            glyph: '▶',
            glyphColor: ContinuumColorTokens.success,
            glyphBg: ContinuumColorTokens.success.withValues(alpha: 0.10),
            value: activeSessions,
            label: 'Active Sessions',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DashboardSummaryCard(
            glyph: '⏱',
            glyphColor: ContinuumColorTokens.warning,
            glyphBg: ContinuumColorTokens.warning.withValues(alpha: 0.10),
            value: pendingApprovals,
            label: 'Pending Approvals',
          ),
        ),
      ],
    );
  }
}

class _DashboardSummaryCard extends StatelessWidget {
  const _DashboardSummaryCard({
    required this.glyph,
    required this.glyphColor,
    required this.glyphBg,
    required this.value,
    required this.label,
  });

  final String glyph;
  final Color glyphColor;
  final Color glyphBg;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SessionColors.cardSurface,
        border: Border.all(color: SessionColors.borderCard),
        borderRadius: BorderRadius.circular(ContinuumRadiusTokens.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: glyphBg,
                borderRadius: BorderRadius.circular(ContinuumRadiusTokens.sm),
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
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                color: glyphColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: SessionColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardSectionHeader extends StatelessWidget {
  const _DashboardSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: SessionColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _DashboardSessionRow extends StatelessWidget {
  const _DashboardSessionRow({required this.session});

  final SessionSummary session;

  @override
  Widget build(BuildContext context) {
    final statusColor = _dashboardStatusColor(session.status);
    final glyph = _dashboardStatusGlyph(session.status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: SessionColors.cardSurface,
        border: Border.all(color: SessionColors.borderCard),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Center(
                  child: Text(
                    glyph,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: SessionColors.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: SessionColors.textMuted,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            _DashboardStatusChip(
              color: statusColor,
              label: session.status.replaceAll('_', ' '),
              showDot: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardDeviceData {
  const _DashboardDeviceData({
    required this.name,
    required this.status,
    required this.trust,
  });

  final String name;
  final String status;
  final String trust;
}

class _DashboardDeviceRow extends StatelessWidget {
  const _DashboardDeviceRow({required this.device});

  final _DashboardDeviceData device;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (device.status) {
      'connected' => ContinuumColorTokens.success,
      'connecting' => ContinuumColorTokens.warning,
      _ => ContinuumColorTokens.mutedText,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: SessionColors.cardSurface,
        border: Border.all(color: SessionColors.borderCard),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Text(
              '⌘',
              style: TextStyle(color: SessionColors.textMuted, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                device.name,
                style: const TextStyle(
                  color: SessionColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _DashboardStatusChip(
              color: statusColor,
              label: device.status,
              showDot: true,
            ),
          ],
        ),
      ),
    );
  }
}

Color _dashboardStatusColor(String status) {
  return switch (status) {
    'running' => ContinuumColorTokens.success,
    'waiting_approval' || 'waiting_input' => ContinuumColorTokens.warning,
    'idle' => ContinuumColorTokens.accent,
    'completed' => ContinuumColorTokens.mutedText,
    _ => ContinuumColorTokens.danger,
  };
}

String _dashboardStatusGlyph(String status) {
  return switch (status) {
    'running' => '▶',
    'waiting_approval' => '!',
    'waiting_input' => '?',
    'idle' => '◉',
    'completed' => '✓',
    'failed' => '✕',
    'stopped' => '■',
    _ => '—',
  };
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.index,
    required this.tabs,
    required this.onSelected,
  });

  final int index;
  final List<_ShellTab> tabs;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SessionColors.cardSurface,
        border: Border(top: BorderSide(color: SessionColors.borderLight)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            for (final entry in tabs.indexed)
              Expanded(
                child: _NavButton(
                  label: entry.$2.label,
                  selected: entry.$1 == index,
                  onTap: () => onSelected(entry.$1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SessionColors.warmSurface : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? SessionColors.textDark : SessionColors.textMuted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ShellTab {
  const _ShellTab(this.label, this.title, this.detail);

  final String label;
  final String title;
  final String detail;
}

class ContinuumFirstRunShell extends StatefulWidget {
  const ContinuumFirstRunShell({super.key, this.dependencies, this.onTrusted});

  final MobileDependencies? dependencies;
  final VoidCallback? onTrusted;

  @override
  State<ContinuumFirstRunShell> createState() => _ContinuumFirstRunShellState();
}

class _ContinuumFirstRunShellState extends State<ContinuumFirstRunShell> {
  late final MobileDependencies _dependencies;

  @override
  void initState() {
    super.initState();
    _dependencies = widget.dependencies ?? MobileDependencies.memory();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SessionColors.pageBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 24),
              PairingScreen(
                controller: _dependencies.pairingController,
                scanner: _dependencies.pairingScanner,
                onContinue: widget.onTrusted,
              ),
              const Spacer(),
              const Text(
                'ASCP companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SessionColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Text(
            'Continuum',
            style: TextStyle(
              color: SessionColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        shadcn.SecondaryBadge(
          child: const Text('Unpaired', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
