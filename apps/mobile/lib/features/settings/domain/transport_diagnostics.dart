class TransportDiagnostics {
  const TransportDiagnostics({
    required this.hostId,
    required this.state,
    required this.replayEnabled,
    this.lastError,
  });

  final String hostId;
  final String state;
  final bool replayEnabled;
  final String? lastError;

  bool get isDegraded => state != 'connected' || !replayEnabled || lastError != null;
}
