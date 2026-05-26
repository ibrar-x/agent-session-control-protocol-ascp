enum AscpMethod {
  capabilitiesGet('capabilities.get'),
  hostsGet('hosts.get'),
  runtimesList('runtimes.list'),
  sessionsList('sessions.list'),
  sessionsGet('sessions.get'),
  sessionsStart('sessions.start'),
  sessionsResume('sessions.resume'),
  sessionsStop('sessions.stop'),
  sessionsSendInput('sessions.send_input'),
  sessionsSubscribe('sessions.subscribe'),
  sessionsUnsubscribe('sessions.unsubscribe'),
  approvalsList('approvals.list'),
  approvalsRespond('approvals.respond'),
  artifactsList('artifacts.list'),
  artifactsGet('artifacts.get'),
  diffsGet('diffs.get'),
  unknown('');

  const AscpMethod(this.value);

  final String value;

  static AscpMethod fromValue(String value) {
    for (final method in AscpMethod.values) {
      if (method.value == value) {
        return method;
      }
    }
    return AscpMethod.unknown;
  }
}
