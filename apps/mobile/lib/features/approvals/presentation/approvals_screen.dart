import 'package:flutter/widgets.dart';

import '../../../core/design_system/continuum_tokens.dart';
import '../application/approval_queue_controller.dart';
import '../data/approval_repository.dart';
import '../domain/approval_view_model.dart';

class ApprovalsScreen extends StatelessWidget {
  ApprovalsScreen({ApprovalQueueController? controller, super.key})
    : controller =
          controller ??
          ApprovalQueueController(repository: MemoryApprovalRepository());

  final ApprovalQueueController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ApprovalViewModel>>(
      future: controller.loadQueue(),
      builder: (context, snapshot) {
        final approvals = snapshot.data ?? const <ApprovalViewModel>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Approvals',
              style: TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _ApprovalBody(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                error: snapshot.error,
                approvals: approvals,
                controller: controller,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ApprovalBody extends StatefulWidget {
  const _ApprovalBody({
    required this.isLoading,
    required this.error,
    required this.approvals,
    required this.controller,
  });

  final bool isLoading;
  final Object? error;
  final List<ApprovalViewModel> approvals;
  final ApprovalQueueController controller;

  @override
  State<_ApprovalBody> createState() => _ApprovalBodyState();
}

class _ApprovalBodyState extends State<_ApprovalBody> {
  late List<ApprovalViewModel> _approvals = widget.approvals;

  @override
  void didUpdateWidget(covariant _ApprovalBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.approvals != widget.approvals) {
      _approvals = widget.approvals;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const _MutedCopy('Loading approvals...');
    }
    if (widget.error != null) {
      return const _MutedCopy('Unable to load approvals.');
    }
    if (_approvals.isEmpty) {
      return const _MutedCopy('No pending approvals');
    }

    return ListView.separated(
      itemCount: _approvals.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _ApprovalRow(
        approval: _approvals[index],
        onDecision: (decision) => _respond(index, decision),
      ),
    );
  }

  Future<void> _respond(int index, ApprovalDecision decision) async {
    final updated = await widget.controller.respond(
      approval: _approvals[index],
      decision: decision,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _approvals = [
        for (final entry in _approvals.indexed)
          if (entry.$1 == index) updated else entry.$2,
      ];
    });
  }
}

class _ApprovalRow extends StatelessWidget {
  const _ApprovalRow({required this.approval, required this.onDecision});

  final ApprovalViewModel approval;
  final ValueChanged<ApprovalDecision> onDecision;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              approval.reason,
              style: const TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${approval.sessionId} · ${approval.status.name}',
              style: const TextStyle(
                color: ContinuumColorTokens.mutedText,
                fontSize: 12,
              ),
            ),
            if (approval.isActionable &&
                approval.status == ApprovalStatus.pending)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    _DecisionButton(
                      label: 'Approve',
                      onTap: () => onDecision(ApprovalDecision.approved),
                    ),
                    const SizedBox(width: 10),
                    _DecisionButton(
                      label: 'Reject',
                      onTap: () => onDecision(ApprovalDecision.rejected),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: ContinuumColorTokens.accent,
          fontSize: 13,
          fontWeight: FontWeight.w800,
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
