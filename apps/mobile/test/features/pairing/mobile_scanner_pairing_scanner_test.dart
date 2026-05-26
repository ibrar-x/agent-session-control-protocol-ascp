import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/pairing/presentation/mobile_scanner_pairing_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  test('extracts the first raw pairing payload from a barcode capture', () {
    final payload = extractPairingPayloadFromCapture(
      const BarcodeCapture(
        barcodes: [
          Barcode(
            displayValue: 'ignored-display',
            rawValue: 'continuum://pair?code=QR',
          ),
        ],
      ),
    );

    expect(payload, 'continuum://pair?code=QR');
  });

  test('falls back to display value when raw value is missing', () {
    final payload = extractPairingPayloadFromCapture(
      const BarcodeCapture(
        barcodes: [Barcode(displayValue: 'continuum://pair?code=DISPLAY')],
      ),
    );

    expect(payload, 'continuum://pair?code=DISPLAY');
  });

  test('returns null when a capture has no barcode payload', () {
    final payload = extractPairingPayloadFromCapture(
      const BarcodeCapture(barcodes: [Barcode()]),
    );

    expect(payload, isNull);
  });
}
