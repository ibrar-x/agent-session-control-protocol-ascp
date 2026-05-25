import 'dart:math';

class ReconnectPolicy {
  ReconnectPolicy({
    required this.baseMs,
    required this.maxMs,
    required this.jitterRatio,
    Random? random,
  }) : _random = random ?? Random(0);

  final int baseMs;
  final int maxMs;
  final double jitterRatio;
  final Random _random;

  Duration delayForAttempt(int attempt) {
    final exponent = attempt < 0 ? 0 : attempt;
    final cappedBase = min(maxMs, baseMs * pow(2, exponent)).round();
    final jitterWindow = cappedBase * jitterRatio;
    final jitter = (_random.nextDouble() * jitterWindow * 2) - jitterWindow;
    final delayedMs = max(0, cappedBase + jitter).round();
    return Duration(milliseconds: delayedMs);
  }
}
