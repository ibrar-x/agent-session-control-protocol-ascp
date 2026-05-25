import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../../../core/design_system/continuum_tokens.dart';
import '../application/session_detail_controller.dart';
import '../data/session_repository.dart';
import '../domain/timeline_event.dart';

class SessionDetailScreen extends StatefulWidget {
  SessionDetailScreen({
    required this.sessionId,
    SessionDetailController? controller,
    super.key,
  }) : controller =
           controller ??
           SessionDetailController(
             sessionId: sessionId,
             repository: MemorySessionRepository(),
           );

  final String sessionId;
  final SessionDetailController controller;

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  late final Future<void> _load = widget.controller.load();

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session ${widget.sessionId}',
              style: const TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _TimelineList(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                error: snapshot.error,
                timeline: widget.controller.timeline,
              ),
            ),
            const SizedBox(height: 12),
            _InputBar(
              controller: _inputController,
              focusNode: _inputFocusNode,
              onSend: _sendInput,
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendInput() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      return;
    }
    await widget.controller.sendInput(text);
    _inputController.clear();
    if (mounted) {
      setState(() {});
    }
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({
    required this.isLoading,
    required this.error,
    required this.timeline,
  });

  final bool isLoading;
  final Object? error;
  final List<TimelineEvent> timeline;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _MutedCopy('Loading timeline...');
    }
    if (error != null) {
      return const _MutedCopy('Unable to load timeline.');
    }
    if (timeline.isEmpty) {
      return const _MutedCopy('No timeline events yet.');
    }

    return ListView.separated(
      itemCount: timeline.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _TimelineRow(event: timeline[index]),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event});

  final TimelineEvent event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ContinuumColorTokens.bgElevated,
        border: Border.all(color: ContinuumColorTokens.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 42,
              child: Text(
                event.sequence?.toString() ?? '-',
                style: const TextStyle(
                  color: ContinuumColorTokens.mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                event.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ContinuumColorTokens.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ContinuumColorTokens.bgElevated,
              border: Border.all(color: ContinuumColorTokens.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: EditableText(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 14,
              ),
              cursorColor: ContinuumColorTokens.accent,
              backgroundCursorColor: ContinuumColorTokens.border,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSend,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              'Send',
              style: TextStyle(
                color: ContinuumColorTokens.accent,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
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
