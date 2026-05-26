enum AscpSessionStatus {
  idle('idle'),
  running('running'),
  waitingInput('waiting_input'),
  waitingApproval('waiting_approval'),
  completed('completed'),
  failed('failed'),
  stopped('stopped'),
  disconnected('disconnected'),
  unknown('');

  const AscpSessionStatus(this.value);

  final String value;

  static AscpSessionStatus fromValue(String value) {
    for (final status in AscpSessionStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return AscpSessionStatus.unknown;
  }
}

enum AscpApprovalStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  expired('expired'),
  cancelled('cancelled'),
  unknown('');

  const AscpApprovalStatus(this.value);

  final String value;
}

enum AscpTransportState {
  idle('idle'),
  connecting('connecting'),
  connected('connected'),
  reconnecting('reconnecting'),
  offline('offline'),
  authFailed('authFailed'),
  revoked('revoked'),
  unsupported('unsupported');

  const AscpTransportState(this.value);

  final String value;
}
