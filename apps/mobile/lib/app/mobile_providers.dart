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

  factory MobileRuntimeConfig.fromEnvironment({
    String Function(String key) read = _readEnvironment,
  }) {
    final mode = read('CONTINUUM_MOBILE_MODE').trim().toLowerCase();
    if (mode != 'live') {
      return const MobileRuntimeConfig.memory();
    }

    final rpcEndpoint = Uri.tryParse(
      read('CONTINUUM_ASCP_RPC_ENDPOINT').trim(),
    );
    final websocketEndpoint = Uri.tryParse(
      read('CONTINUUM_ASCP_WS_ENDPOINT').trim(),
    );
    final daemonAdminBaseUrl = Uri.tryParse(
      read('CONTINUUM_DAEMON_ADMIN_BASE_URL').trim(),
    );
    final hostId = read('CONTINUUM_HOST_ID').trim();
    final activeSessionId = read('CONTINUUM_ACTIVE_SESSION_ID').trim();
    final currentDeviceId = read('CONTINUUM_DEVICE_ID').trim();

    if (rpcEndpoint == null ||
        websocketEndpoint == null ||
        daemonAdminBaseUrl == null ||
        hostId.isEmpty ||
        activeSessionId.isEmpty) {
      return const MobileRuntimeConfig.memory();
    }

    return MobileRuntimeConfig.live(
      rpcEndpoint: rpcEndpoint,
      websocketEndpoint: websocketEndpoint,
      daemonAdminBaseUrl: daemonAdminBaseUrl,
      hostId: hostId,
      activeSessionId: activeSessionId,
      currentDeviceId: currentDeviceId.isEmpty ? null : currentDeviceId,
    );
  }

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

String _readEnvironment(String key) {
  return switch (key) {
    'CONTINUUM_MOBILE_MODE' => const String.fromEnvironment(
      'CONTINUUM_MOBILE_MODE',
    ),
    'CONTINUUM_ASCP_RPC_ENDPOINT' => const String.fromEnvironment(
      'CONTINUUM_ASCP_RPC_ENDPOINT',
    ),
    'CONTINUUM_ASCP_WS_ENDPOINT' => const String.fromEnvironment(
      'CONTINUUM_ASCP_WS_ENDPOINT',
    ),
    'CONTINUUM_DAEMON_ADMIN_BASE_URL' => const String.fromEnvironment(
      'CONTINUUM_DAEMON_ADMIN_BASE_URL',
    ),
    'CONTINUUM_HOST_ID' => const String.fromEnvironment('CONTINUUM_HOST_ID'),
    'CONTINUUM_ACTIVE_SESSION_ID' => const String.fromEnvironment(
      'CONTINUUM_ACTIVE_SESSION_ID',
    ),
    'CONTINUUM_DEVICE_ID' => const String.fromEnvironment(
      'CONTINUUM_DEVICE_ID',
    ),
    _ => '',
  };
}

final mobileRuntimeConfigProvider = Provider<MobileRuntimeConfig>(
  (ref) => MobileRuntimeConfig.fromEnvironment(),
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
