import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mobile_dependencies.dart';

class MobileRuntimeConfig {
  const MobileRuntimeConfig._({
    required this.mode,
    this.rpcEndpoint,
    this.websocketEndpoint,
    this.daemonAdminBaseUrl,
    this.hostId = 'host_1',
    this.activeSessionId = 'session_1',
    this.currentDeviceId,
  });

  const MobileRuntimeConfig.memory() : this._(mode: MobileRuntimeMode.memory);

  const MobileRuntimeConfig.live({
    required Uri rpcEndpoint,
    required Uri websocketEndpoint,
    required Uri daemonAdminBaseUrl,
    required String hostId,
    required String activeSessionId,
    String? currentDeviceId,
  }) : this._(
         mode: MobileRuntimeMode.live,
         rpcEndpoint: rpcEndpoint,
         websocketEndpoint: websocketEndpoint,
         daemonAdminBaseUrl: daemonAdminBaseUrl,
         hostId: hostId,
         activeSessionId: activeSessionId,
         currentDeviceId: currentDeviceId,
       );

  final MobileRuntimeMode mode;
  final Uri? rpcEndpoint;
  final Uri? websocketEndpoint;
  final Uri? daemonAdminBaseUrl;
  final String hostId;
  final String activeSessionId;
  final String? currentDeviceId;

  bool get isLive => mode == MobileRuntimeMode.live;
}

enum MobileRuntimeMode { memory, live }

final mobileRuntimeConfigProvider = Provider<MobileRuntimeConfig>(
  (ref) => const MobileRuntimeConfig.memory(),
);

final mobileDependenciesProvider = Provider<MobileDependencies>((ref) {
  final config = ref.watch(mobileRuntimeConfigProvider);
  if (!config.isLive) {
    return MobileDependencies.memory(
      hostId: config.hostId,
      activeSessionId: config.activeSessionId,
    );
  }

  final rpcEndpoint = config.rpcEndpoint;
  final websocketEndpoint = config.websocketEndpoint;
  final daemonAdminBaseUrl = config.daemonAdminBaseUrl;
  if (rpcEndpoint == null ||
      websocketEndpoint == null ||
      daemonAdminBaseUrl == null) {
    throw StateError('Live mobile runtime config requires all endpoints.');
  }

  return MobileDependencies.live(
    rpcEndpoint: rpcEndpoint,
    websocketEndpoint: websocketEndpoint,
    daemonAdminBaseUrl: daemonAdminBaseUrl,
    hostId: config.hostId,
    activeSessionId: config.activeSessionId,
    currentDeviceId: config.currentDeviceId,
  );
});
