import 'trust_material.dart';

abstract interface class SecureStore {
  Future<void> writeTrustMaterial(TrustMaterial material);

  Future<TrustMaterial?> readTrustMaterial();
}

class MemorySecureStore implements SecureStore {
  TrustMaterial? _material;

  @override
  Future<TrustMaterial?> readTrustMaterial() async => _material;

  @override
  Future<void> writeTrustMaterial(TrustMaterial material) async {
    _material = material;
  }
}
