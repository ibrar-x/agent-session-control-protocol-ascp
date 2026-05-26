class TrustedDevice {
  const TrustedDevice({
    required this.id,
    required this.displayName,
    required this.isCurrentDevice,
  });

  const TrustedDevice.current({
    required String id,
    required String displayName,
  }) : this(id: id, displayName: displayName, isCurrentDevice: true);

  final String id;
  final String displayName;
  final bool isCurrentDevice;

  bool get requiresLocalAuthForRevoke => isCurrentDevice;
}
