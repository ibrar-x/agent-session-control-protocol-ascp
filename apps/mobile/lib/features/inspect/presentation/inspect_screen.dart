import 'package:flutter/widgets.dart';

import '../../../core/design_system/continuum_tokens.dart';
import '../application/inspect_controller.dart';
import '../data/inspect_repository.dart';
import '../domain/inspect_item.dart';

class InspectScreen extends StatelessWidget {
  InspectScreen({InspectController? controller, super.key})
    : controller =
          controller ??
          InspectController(repository: MemoryInspectRepository());

  final InspectController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InspectState>(
      future: controller.load(),
      builder: (context, snapshot) {
        final state = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inspect artifacts and diffs',
              style: TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _InspectBody(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                error: snapshot.error,
                state: state,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InspectBody extends StatelessWidget {
  const _InspectBody({
    required this.isLoading,
    required this.error,
    required this.state,
  });

  final bool isLoading;
  final Object? error;
  final InspectState? state;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _MutedCopy('Loading inspect metadata...');
    }
    if (error != null) {
      return const _MutedCopy('Unable to load inspect metadata.');
    }
    final current = state;
    if (current == null) {
      return const SizedBox.shrink();
    }
    if (!current.isSupported) {
      return _MutedCopy(current.reason ?? 'Inspect is unavailable.');
    }
    if (current.items.isEmpty) {
      return const _MutedCopy('No artifacts or diffs yet.');
    }

    return ListView.separated(
      itemCount: current.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _InspectRow(item: current.items[index]),
    );
  }
}

class _InspectRow extends StatelessWidget {
  const _InspectRow({required this.item});

  final InspectItem item;

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
                item.id,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              item.kind.name,
              style: const TextStyle(
                color: ContinuumColorTokens.accent,
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
