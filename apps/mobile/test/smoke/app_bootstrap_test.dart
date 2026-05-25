import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app_bootstrap.dart';

void main() {
  test('app bootstrap exposes required startup services', () {
    final bootstrap = createAppBootstrap();

    expect(bootstrap.hasRouter, isTrue);
    expect(bootstrap.hasSecureStore, isTrue);
    expect(bootstrap.hasTransportClients, isTrue);
  });
}
