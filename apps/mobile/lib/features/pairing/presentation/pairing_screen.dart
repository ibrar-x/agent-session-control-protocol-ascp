import 'package:flutter/widgets.dart';

import '../../../core/design_system/continuum_tokens.dart';
import '../../../ui/shadcn/components/form/input_otp/input_otp.dart' as shadcn;
import '../../../ui/shadcn/shared/theme/theme.dart' as shadcn;
import '../application/pairing_controller.dart';
import '../domain/pairing_state.dart';

abstract interface class PairingScanner {
  Future<String?> scan(BuildContext context);
}

class PairingScreen extends StatefulWidget {
  const PairingScreen({
    required this.controller,
    required this.scanner,
    this.onContinue,
    super.key,
  });

  final PairingController controller;
  final PairingScanner scanner;
  final VoidCallback? onContinue;

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  String _pairingCode = '';
  bool _claiming = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        final compact = height < 720;
        final scannerHeight = (height * (compact ? 0.28 : 0.31)).clamp(
          150.0,
          238.0,
        );
        return ColoredBox(
          color: const Color(0xFF100D08),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 24 : 28,
              compact ? 10 : 18,
              compact ? 24 : 28,
              compact ? 14 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PairingHero(state: state, compact: compact),
                SizedBox(height: compact ? 12 : 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _scan,
                  child: _ScannerFrame(height: scannerHeight),
                ),
                SizedBox(height: compact ? 12 : 16),
                const _OrDivider(),
                SizedBox(height: compact ? 10 : 14),
                _CodeEntry(
                  value: _pairingCode,
                  compact: compact,
                  onChanged: (value) => setState(() => _pairingCode = value),
                  onSubmitted: (_) => _submitManual(),
                ),
                SizedBox(height: compact ? 12 : 16),
                _ClaimButton(
                  label: state.isTrusted
                      ? 'Continue'
                      : _claiming
                      ? 'Claiming device'
                      : 'Claim device',
                  enabled: state.isTrusted || _pairingCode.length == 6,
                  height: compact ? 48 : 54,
                  onTap: state.isTrusted
                      ? (widget.onContinue ?? () {})
                      : _submitManual,
                ),
                SizedBox(height: compact ? 10 : 16),
                Center(
                  child: Text(
                    _statusLabel(state),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: state.isFailed
                          ? ContinuumColorTokens.danger
                          : const Color(0xFF9D9286),
                      fontSize: compact ? 13 : 14,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!compact) ...[
                  const Spacer(),
                  const Text(
                    'Only approve hosts you recognize. Sessio never pairs without confirmation on the host machine.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8A7F73),
                      fontSize: 14,
                      height: 1.32,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _scan() async {
    setState(widget.controller.startScanning);
    final payload = await widget.scanner.scan(context);
    if (payload == null) {
      return;
    }
    await _submit(payload);
  }

  Future<void> _submitManual() {
    return _submit(_pairingCode);
  }

  Future<void> _submit(String payload) async {
    if (payload.trim().isEmpty) {
      setState(widget.controller.startManualInput);
      return;
    }
    setState(() => _claiming = true);
    await widget.controller.submitPayload(payload);
    if (mounted) {
      setState(() => _claiming = false);
    }
  }

  String _statusLabel(PairingScreenState state) {
    if (_claiming || state.isPolling) {
      return '● Waiting for host approval...';
    }
    if (state.isTrusted) {
      return '● Host approved this device.';
    }
    if (state.isFailed) {
      return _failureLabel(state.failure);
    }
    return '● Enter the 6-digit host code';
  }

  String _failureLabel(PairingFailure? failure) {
    return switch (failure) {
      PairingFailure.rejectedByHost => 'Rejected by host',
      PairingFailure.expired => 'Pairing code expired',
      PairingFailure.revoked => 'Pairing revoked',
      PairingFailure.unreachableHost => 'Host unreachable',
      PairingFailure.malformedPayload => 'Invalid pairing code',
      PairingFailure.localAuthDenied => 'Local authentication denied',
      null => 'Pairing failed',
    };
  }
}

class _PairingHero extends StatelessWidget {
  const _PairingHero({required this.state, required this.compact});

  final PairingScreenState state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[const _BackPlate(), const SizedBox(width: 18)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pair a host',
                style: TextStyle(
                  color: const Color(0xFFF9F2EA),
                  fontSize: compact ? 30 : 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                state.isTrusted
                    ? 'This device is now approved by the host.'
                    : 'Scan the QR code shown in Sessio Bridge or enter the pairing code manually.',
                style: TextStyle(
                  color: const Color(0xFF9D9286),
                  fontSize: compact ? 15 : 17,
                  height: 1.24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScannerFrame extends StatelessWidget {
  const _ScannerFrame({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0906),
        border: Border.all(color: const Color(0xFF2A221B)),
        borderRadius: BorderRadius.circular(28),
      ),
      child: SizedBox(
        height: height,
        child: Stack(
          children: const [
            Positioned.fill(child: _ScannerCorners()),
            Center(child: _ScanBeam()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 34,
              child: Text(
                'Align QR code within frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9D9286),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Text(
                'Scan QR code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF4F463D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerCorners extends StatelessWidget {
  const _ScannerCorners();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CornerPainter());
  }
}

class _ScanBeam extends StatelessWidget {
  const _ScanBeam();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF75E8F2),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF75E8F2).withValues(alpha: 0.70),
            blurRadius: 22,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const SizedBox(width: 270, height: 3),
    );
  }
}

class _CodeEntry extends StatelessWidget {
  const _CodeEntry({
    required this.value,
    required this.compact,
    required this.onChanged,
    required this.onSubmitted,
  });

  final String value;
  final bool compact;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final initialValue = List<int?>.generate(
      6,
      (index) => index < value.length ? value.codeUnitAt(index) : null,
    );
    return Center(
      child: shadcn.ComponentTheme<shadcn.InputOTPTheme>(
        data: shadcn.InputOTPTheme(height: compact ? 42 : 48, spacing: 8),
        child: shadcn.InputOTP(
          initialValue: initialValue,
          children: [
            for (var index = 0; index < 6; index++)
              shadcn.InputOTPChild.character(allowDigit: true),
          ],
          onChanged: (codepoints) {
            final next = codepoints.otpToString();
            if (next != value) {
              onChanged(next);
            }
          },
          onSubmitted: (codepoints) => onSubmitted(codepoints.otpToString()),
        ),
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.height,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFC47C50) : const Color(0xFF494039),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: enabled
                    ? const Color(0xFF150E08)
                    : const Color(0xFF9D9286),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SizedBox(
            height: 1,
            child: ColoredBox(color: Color(0xFF4B4239)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'or enter code',
            style: TextStyle(
              color: Color(0xFF9D9286),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 1,
            child: ColoredBox(color: Color(0xFF4B4239)),
          ),
        ),
      ],
    );
  }
}

class _BackPlate extends StatelessWidget {
  const _BackPlate();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF211B16),
        border: Border.all(color: const Color(0xFF342A22)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const SizedBox(width: 72, height: 72),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF020201)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    const length = 36.0;
    const inset = 2.0;
    canvas.drawLine(const Offset(inset, 60), const Offset(inset, 20), paint);
    canvas.drawLine(const Offset(inset, 20), const Offset(42, 20), paint);
    canvas.drawLine(
      Offset(size.width - inset, 60),
      Offset(size.width - inset, 20),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, 20),
      Offset(size.width - 42, 20),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - 60),
      Offset(inset, size.height - 20),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - 20),
      Offset(length + inset, size.height - 20),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - 60),
      Offset(size.width - inset, size.height - 20),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - 20),
      Offset(size.width - length - inset, size.height - 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
