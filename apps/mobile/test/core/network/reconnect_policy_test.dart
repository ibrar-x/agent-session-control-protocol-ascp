import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/reconnect_policy.dart';

void main() {
  test('reconnect policy caps exponential delay and adds jitter range', () {
    final policy = ReconnectPolicy(baseMs: 250, maxMs: 8000, jitterRatio: 0.2);

    expect(policy.delayForAttempt(0).inMilliseconds, greaterThanOrEqualTo(200));
    expect(policy.delayForAttempt(0).inMilliseconds, lessThanOrEqualTo(300));
    expect(policy.delayForAttempt(10).inMilliseconds, lessThanOrEqualTo(9600));
  });
}
