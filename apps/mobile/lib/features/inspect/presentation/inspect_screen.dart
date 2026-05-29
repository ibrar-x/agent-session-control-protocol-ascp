import 'package:flutter/widgets.dart';

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
        return DecoratedBox(
          decoration: const BoxDecoration(color: Color(0xFF100d08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              Expanded(
                child: _Body(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  error: snapshot.error,
                  state: state,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 14, 18, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inspect artifacts and diffs',
            style: TextStyle(
              color: Color(0xFFf0e8dc),
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Session artifacts & changes',
            style: TextStyle(
              color: Color(0xFF6a5a48),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
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
      return const Center(child: _MutedCopy('Loading inspect metadata...'));
    }
    if (error != null) {
      return const Center(
        child: _MutedCopy('Unable to load inspect metadata.'),
      );
    }
    final current = state;
    if (current == null) {
      return const SizedBox.shrink();
    }
    if (!current.isSupported) {
      return Center(
        child: _MutedCopy(current.reason ?? 'Inspect is unavailable.'),
      );
    }
    if (current.items.isEmpty) {
      return const Center(child: _MutedCopy('No artifacts or diffs yet.'));
    }

    return _ItemList(items: current.items);
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items});

  final List<InspectItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _ItemCard(item: items[index]),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final InspectItem item;

  @override
  Widget build(BuildContext context) {
    final isDiff = item.kind == InspectItemKind.diff;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1510),
        border: Border.all(color: const Color(0xFF2e2820)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _KindBadge(isDiff: isDiff),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.id,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFf0e8dc),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KindBadge extends StatelessWidget {
  const _KindBadge({required this.isDiff});

  final bool isDiff;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDiff ? const Color(0xFF0d1e10) : const Color(0xFF1a1510),
        border: Border.all(
          color: isDiff ? const Color(0xFF2d6a3a) : const Color(0xFF2e2820),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          isDiff ? 'DIFF' : 'ARTIFACT',
          style: TextStyle(
            color: isDiff ? const Color(0xFF4a9a5a) : const Color(0xFF8a7860),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF8a7860),
          fontSize: 14,
          height: 1.45,
        ),
      ),
    );
  }
}
