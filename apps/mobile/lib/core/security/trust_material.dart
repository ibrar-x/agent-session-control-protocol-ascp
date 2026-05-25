class TrustMaterial {
  const TrustMaterial({
    required this.hostId,
    required this.deviceId,
    required this.secret,
  });

  final String hostId;
  final String deviceId;
  final String secret;
}
