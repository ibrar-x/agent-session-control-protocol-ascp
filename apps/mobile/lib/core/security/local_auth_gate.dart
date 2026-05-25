abstract interface class LocalAuthGate {
  Future<bool> confirm(String reason);
}

class AllowingLocalAuthGate implements LocalAuthGate {
  const AllowingLocalAuthGate();

  @override
  Future<bool> confirm(String reason) async => true;
}
