import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/design_system/continuum_tokens.dart';

void main() {
  test('Continuum tokens preserve source design system colors', () {
    expect(ContinuumColorTokens.bgSurface.toARGB32(), 0xFF29261F);
    expect(ContinuumColorTokens.bgElevated.toARGB32(), 0xFF332F28);
    expect(ContinuumColorTokens.bgOverlay.toARGB32(), 0xFF3D3930);
    expect(ContinuumColorTokens.accent.toARGB32(), 0xFFC07349);
    expect(ContinuumColorTokens.danger.toARGB32(), 0xFFD9512A);
  });
}
