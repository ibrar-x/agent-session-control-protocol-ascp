import 'package:flutter/widgets.dart';

import '../../../core/design_system/continuum_tokens.dart';
import '../application/session_list_controller.dart';
import '../data/session_repository.dart';
import '../domain/timeline_event.dart';

class SessionListScreen extends StatelessWidget {
  SessionListScreen({SessionListController? controller, super.key})
    : controller =
          controller ??
          SessionListController(repository: MemorySessionRepository());

  final SessionListController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SessionSummary>>(
      future: controller.load(),
      builder: (context, snapshot) {
        final sessions = snapshot.data;
        return _SessionScreenFrame(
          title: 'Sessions',
          child: _SessionListBody(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            error: snapshot.error,
            sessions: sessions ?? const [],
          ),
        );
      },
    );
  }
}

class _SessionScreenFrame extends StatelessWidget {
  const _SessionScreenFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ContinuumColorTokens.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: child),
      ],
    );
  }
}

class _SessionListBody extends StatelessWidget {
  const _SessionListBody({
    required this.isLoading,
    required this.error,
    required this.sessions,
  });

  final bool isLoading;
  final Object? error;
  final List<SessionSummary> sessions;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _MutedCopy('Loading sessions...');
    }
    if (error != null) {
      return const _MutedCopy('Unable to load sessions.');
    }
    if (sessions.isEmpty) {
      return const _MutedCopy('No active sessions');
    }

    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _SessionRow(session: sessions[index]),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final SessionSummary session;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ContinuumColorTokens.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    session.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ContinuumColorTokens.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              session.status,
              style: const TextStyle(
                color: ContinuumColorTokens.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
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
