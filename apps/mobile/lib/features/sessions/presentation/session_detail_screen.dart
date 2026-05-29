import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  late final Future<void> _load = widget.controller.load(
    onEvent: () {
      if (mounted) {
        setState(() {});
      }
    },
  );

  @override
  void dispose() {
    unawaited(widget.controller.dispose());
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
              'Live feed',
              style: const TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.sessionId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ContinuumColorTokens.mutedText,
                fontSize: 12,
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
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _TimelineRow(event: timeline[index]),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event});

  final TimelineEvent event;

  @override
  Widget build(BuildContext context) {
    final style = _TimelineEventStyle.fromLabel(event.label);
    final isUser = style.kind == _TimelineEventKind.userMessage;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style.background,
            border: Border.all(color: style.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: style.kind == _TimelineEventKind.terminal
                ? _TerminalEventContent(event: event, style: style)
                : _TimelineEventContent(event: event, style: style),
          ),
        ),
      ),
    );
  }
}

class _TimelineEventContent extends StatelessWidget {
  const _TimelineEventContent({required this.event, required this.style});

  final TimelineEvent event;
  final _TimelineEventStyle style;

  @override
  Widget build(BuildContext context) {
    final title = _eventTitle(event.label);
    final detail = _eventDetail(event.label);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EventGlyph(style: style),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: style.titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (event.sequence != null) ...[
              const SizedBox(width: 8),
              _SequencePill(sequence: event.sequence!, color: style.accent),
            ],
          ],
        ),
        if (detail.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            detail,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: style.detailColor,
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (style.kind == _TimelineEventKind.approval) ...[
          const SizedBox(height: 12),
          const _ApprovalActions(),
        ],
      ],
    );
  }
}

class _TerminalEventContent extends StatelessWidget {
  const _TerminalEventContent({required this.event, required this.style});

  final TimelineEvent event;
  final _TimelineEventStyle style;

  @override
  Widget build(BuildContext context) {
    final detail = _eventDetail(event.label);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _EventGlyph(style: style),
            const SizedBox(width: 8),
            const Text(
              'Terminal',
              style: TextStyle(
                color: ContinuumColorTokens.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            if (event.sequence != null)
              _SequencePill(
                sequence: event.sequence!,
                color: ContinuumColorTokens.mono,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          detail.isEmpty ? event.label : detail,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: ContinuumColorTokens.mono,
            fontSize: 12,
            height: 1.35,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class _EventGlyph extends StatelessWidget {
  const _EventGlyph({required this.style});

  final _TimelineEventStyle style;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Text(
          style.glyph,
          style: TextStyle(
            color: style.accent,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SequencePill extends StatelessWidget {
  const _SequencePill({required this.sequence, required this.color});

  final int sequence;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          '#$sequence',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ApprovalActions extends StatelessWidget {
  const _ApprovalActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _ActionChip(label: 'Deny', color: ContinuumColorTokens.danger),
        SizedBox(width: 8),
        _ActionChip(label: 'Approve', color: ContinuumColorTokens.success),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

enum _TimelineEventKind {
  userMessage,
  agentMessage,
  tool,
  approval,
  terminal,
  generic,
}

class _TimelineEventStyle {
  const _TimelineEventStyle({
    required this.kind,
    required this.background,
    required this.border,
    required this.accent,
    required this.titleColor,
    required this.detailColor,
    required this.glyph,
  });

  final _TimelineEventKind kind;
  final Color background;
  final Color border;
  final Color accent;
  final Color titleColor;
  final Color detailColor;
  final String glyph;

  static _TimelineEventStyle fromLabel(String label) {
    final normalized = label.toLowerCase();
    if (normalized.startsWith('message.user') ||
        normalized.startsWith('user.')) {
      return const _TimelineEventStyle(
        kind: _TimelineEventKind.userMessage,
        background: Color(0xFF47372D),
        border: Color(0xFF6A4B36),
        accent: ContinuumColorTokens.accent,
        titleColor: ContinuumColorTokens.textPrimary,
        detailColor: ContinuumColorTokens.textPrimary,
        glyph: 'U',
      );
    }
    if (normalized.startsWith('message.agent') ||
        normalized.startsWith('message.assistant') ||
        normalized.contains('thinking')) {
      return const _TimelineEventStyle(
        kind: _TimelineEventKind.agentMessage,
        background: ContinuumColorTokens.bgSurface,
        border: ContinuumColorTokens.border,
        accent: ContinuumColorTokens.mono,
        titleColor: ContinuumColorTokens.textPrimary,
        detailColor: ContinuumColorTokens.mutedText,
        glyph: 'A',
      );
    }
    if (normalized.contains('approval')) {
      return const _TimelineEventStyle(
        kind: _TimelineEventKind.approval,
        background: Color(0xFF40352B),
        border: Color(0xFF8C5A2E),
        accent: ContinuumColorTokens.warning,
        titleColor: ContinuumColorTokens.warning,
        detailColor: ContinuumColorTokens.textPrimary,
        glyph: '!',
      );
    }
    if (normalized.startsWith('terminal') ||
        normalized.contains('terminal.') ||
        normalized.contains('stdout') ||
        normalized.contains('stderr')) {
      return const _TimelineEventStyle(
        kind: _TimelineEventKind.terminal,
        background: Color(0xFF1E1B16),
        border: ContinuumColorTokens.border,
        accent: ContinuumColorTokens.mono,
        titleColor: ContinuumColorTokens.textPrimary,
        detailColor: ContinuumColorTokens.mono,
        glyph: '>',
      );
    }
    if (normalized.startsWith('tool.') || normalized.contains('tool')) {
      final blocked =
          normalized.contains('blocked') || normalized.contains('failed');
      return _TimelineEventStyle(
        kind: _TimelineEventKind.tool,
        background: ContinuumColorTokens.bgElevated,
        border: blocked
            ? ContinuumColorTokens.danger.withValues(alpha: 0.45)
            : ContinuumColorTokens.border,
        accent: blocked
            ? ContinuumColorTokens.danger
            : ContinuumColorTokens.success,
        titleColor: ContinuumColorTokens.textPrimary,
        detailColor: ContinuumColorTokens.mutedText,
        glyph: blocked ? 'X' : 'T',
      );
    }
    return const _TimelineEventStyle(
      kind: _TimelineEventKind.generic,
      background: ContinuumColorTokens.bgElevated,
      border: ContinuumColorTokens.border,
      accent: ContinuumColorTokens.accent,
      titleColor: ContinuumColorTokens.textPrimary,
      detailColor: ContinuumColorTokens.mutedText,
      glyph: '*',
    );
  }
}

String _eventTitle(String label) {
  final detail = _eventDetail(label);
  if (label.startsWith('message.user')) {
    return 'You';
  }
  if (label.startsWith('message.agent') ||
      label.startsWith('message.assistant')) {
    return 'Agent';
  }
  if (label.toLowerCase().contains('approval')) {
    return 'Approval requested';
  }
  if (label.toLowerCase().contains('tool')) {
    return label.split(' ').first;
  }
  if (label.toLowerCase().startsWith('terminal')) {
    return 'Terminal';
  }
  return detail.isEmpty ? label : label.split(' ').first;
}

String _eventDetail(String label) {
  final separator = label.indexOf(' ');
  if (separator == -1 || separator == label.length - 1) {
    return '';
  }
  return label.substring(separator + 1);
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
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ContinuumColorTokens.bgSurface,
                  border: Border.all(
                    color: focusNode.hasFocus
                        ? ContinuumColorTokens.accent
                        : ContinuumColorTokens.border,
                  ),
                  borderRadius: BorderRadius.circular(ContinuumRadiusTokens.lg),
                  boxShadow: focusNode.hasFocus
                      ? [
                          BoxShadow(
                            color: ContinuumColorTokens.accent.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 0,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: EditableText(
                    controller: controller,
                    focusNode: focusNode,
                    style: const TextStyle(
                      color: ContinuumColorTokens.textPrimary,
                      fontSize: 15,
                      height: 1.35,
                    ),
                    cursorColor: ContinuumColorTokens.accent,
                    backgroundCursorColor: ContinuumColorTokens.border,
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSend,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ContinuumColorTokens.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SizedBox(
                  height: 40,
                  width: 60,
                  child: Center(
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: ContinuumColorTokens.accentForeground,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
