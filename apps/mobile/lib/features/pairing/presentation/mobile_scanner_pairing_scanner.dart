import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/design_system/continuum_tokens.dart';
import 'pairing_screen.dart';

class MobileScannerPairingScanner implements PairingScanner {
  const MobileScannerPairingScanner();

  @override
  Future<String?> scan(BuildContext context) {
    return Navigator.of(context).push<String>(
      PageRouteBuilder<String>(
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _MobileScannerPairingPage();
        },
      ),
    );
  }
}

String? extractPairingPayloadFromCapture(BarcodeCapture capture) {
  for (final barcode in capture.barcodes) {
    final raw = barcode.rawValue;
    if (raw != null && raw.isNotEmpty) {
      return raw;
    }
    final display = barcode.displayValue;
    if (display != null && display.isNotEmpty) {
      return display;
    }
  }
  return null;
}

class _MobileScannerPairingPage extends StatefulWidget {
  const _MobileScannerPairingPage();

  @override
  State<_MobileScannerPairingPage> createState() =>
      _MobileScannerPairingPageState();
}

class _MobileScannerPairingPageState extends State<_MobileScannerPairingPage> {
  late final MobileScannerController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ContinuumColorTokens.bgSurface,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: MobileScanner(
                controller: _controller,
                fit: BoxFit.cover,
                onDetect: _handleCapture,
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ContinuumColorTokens.bgOverlay.withValues(alpha: 0.92),
                  border: Border.all(color: ContinuumColorTokens.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    'Scan host pairing code',
                    style: TextStyle(
                      color: ContinuumColorTokens.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop<String>(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ContinuumColorTokens.bgOverlay,
                    border: Border.all(color: ContinuumColorTokens.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ContinuumColorTokens.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCapture(BarcodeCapture capture) {
    if (_completed) {
      return;
    }
    final payload = extractPairingPayloadFromCapture(capture);
    if (payload == null) {
      return;
    }
    _completed = true;
    Navigator.of(context).pop(payload);
  }
}
