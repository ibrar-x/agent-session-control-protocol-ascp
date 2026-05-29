import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/continuum_theme.dart';
import '../core/design_system/continuum_tokens.dart';
import '../features/approvals/presentation/approvals_screen.dart';
import '../features/inspect/presentation/inspect_screen.dart';
import '../features/pairing/presentation/pairing_screen.dart';
import '../features/sessions/application/session_detail_controller.dart';
import '../features/sessions/domain/timeline_event.dart';
import '../features/sessions/presentation/session_list_screen.dart';
import '../features/sessions/presentation/session_detail_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../ui/shadcn/components/display/badge/badge.dart' as shadcn;
import '../ui/shadcn/components/layout/card/card.dart' as shadcn;
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
      color: ContinuumColorTokens.bgSurface,
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
      _ => _HomePanel(tab: tab),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                selectedSession != null && tab.label == 'Sessions'
                    ? selectedSession!.title
                    : tab.label,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (selectedSession != null && tab.label == 'Sessions') ...[
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
            ],
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

class _HomePanel extends StatelessWidget {
  const _HomePanel({required this.tab});

  final _ShellTab tab;

  @override
  Widget build(BuildContext context) {
    return shadcn.Card(
      filled: true,
      fillColor: ContinuumColorTokens.bgElevated,
      borderColor: ContinuumColorTokens.border,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tab.title,
            style: const TextStyle(
              color: ContinuumColorTokens.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tab.detail,
            style: const TextStyle(
              color: ContinuumColorTokens.mutedText,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
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
        color: ContinuumColorTokens.bgElevated,
        border: Border(top: BorderSide(color: ContinuumColorTokens.border)),
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
          color: selected ? ContinuumColorTokens.bgOverlay : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected
                ? ContinuumColorTokens.textPrimary
                : ContinuumColorTokens.mutedText,
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
      color: ContinuumColorTokens.bgSurface,
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
                  color: ContinuumColorTokens.mutedText,
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
              color: ContinuumColorTokens.textPrimary,
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
