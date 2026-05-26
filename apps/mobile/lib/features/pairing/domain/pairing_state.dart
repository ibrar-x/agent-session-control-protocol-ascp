import '../../../../core/security/trust_material.dart';

class PairingClaim {
  const PairingClaim({
    required this.hostUrl,
    required this.code,
    required this.claimedAt,
  });

  final Uri hostUrl;
  final String code;
  final DateTime claimedAt;
}

enum PairingPollState {
  pending,
  approved,
  rejected,
  expired,
  revoked,
  unreachable,
}

enum PairingFailure {
  malformedPayload,
  unreachableHost,
  rejectedByHost,
  expired,
  revoked,
  localAuthDenied,
}

class PairingResult {
  const PairingResult._({this.trustMaterial, this.failure});

  factory PairingResult.success(TrustMaterial material) =>
      PairingResult._(trustMaterial: material);

  factory PairingResult.failure(PairingFailure failure) =>
      PairingResult._(failure: failure);

  final TrustMaterial? trustMaterial;
  final PairingFailure? failure;

  bool get isSuccess => trustMaterial != null;
  bool get isFailure => failure != null;
}

class PairingScreenState {
  const PairingScreenState._({
    this.isScanning = false,
    this.isManualInput = false,
    this.claim,
    this.pollState,
    this.failure,
    this.trustMaterial,
  });

  const PairingScreenState.idle() : this._();

  const PairingScreenState.scanning() : this._(isScanning: true);

  const PairingScreenState.manualInput() : this._(isManualInput: true);

  const PairingScreenState.claiming(PairingClaim claim)
      : this._(claim: claim);

  const PairingScreenState.polling(PairingClaim claim, PairingPollState poll)
      : this._(claim: claim, pollState: poll);

  const PairingScreenState.failed(PairingFailure failure)
      : this._(failure: failure);

  const PairingScreenState.trusted(TrustMaterial material)
      : this._(trustMaterial: material);

  final bool isScanning;
  final bool isManualInput;
  final PairingClaim? claim;
  final PairingPollState? pollState;
  final PairingFailure? failure;
  final TrustMaterial? trustMaterial;

  bool get isIdle =>
      !isScanning &&
      !isManualInput &&
      claim == null &&
      failure == null &&
      trustMaterial == null;

  bool get isClaiming =>
      claim != null &&
      pollState == null &&
      failure == null &&
      trustMaterial == null;

  bool get isPolling =>
      claim != null &&
      pollState != null &&
      failure == null &&
      trustMaterial == null;

  bool get isFailed => failure != null;

  bool get isTrusted => trustMaterial != null;
}

enum PairingStatus {
  pendingClaim,
  pendingHostApproval,
  approved,
  rejected,
  expired,
  revoked,
  malformed,
}

enum PairingVisibleStep {
  claiming,
  waitingForHost,
  trusted,
  rejected,
  expired,
  revoked,
  malformed,
}

extension PairingStatusVisibleStep on PairingStatus {
  PairingVisibleStep get nextVisibleStep {
    switch (this) {
      case PairingStatus.pendingClaim:
        return PairingVisibleStep.claiming;
      case PairingStatus.pendingHostApproval:
        return PairingVisibleStep.waitingForHost;
      case PairingStatus.approved:
        return PairingVisibleStep.trusted;
      case PairingStatus.rejected:
        return PairingVisibleStep.rejected;
      case PairingStatus.expired:
        return PairingVisibleStep.expired;
      case PairingStatus.revoked:
        return PairingVisibleStep.revoked;
      case PairingStatus.malformed:
        return PairingVisibleStep.malformed;
    }
  }
}
