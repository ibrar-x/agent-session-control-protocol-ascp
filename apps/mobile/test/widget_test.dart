import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/continuum_app.dart';

void main() {
  testWidgets('renders Continuum mobile shell', (tester) async {
    await tester.pumpWidget(const ContinuumMobileApp());

    expect(find.text('Continuum'), findsOneWidget);
    expect(find.text('Pair New Device'), findsOneWidget);
    expect(find.text('Scan QR code'), findsOneWidget);
    expect(find.text('Enter code manually'), findsOneWidget);
    expect(find.text('ASCP companion'), findsOneWidget);
  });
}
