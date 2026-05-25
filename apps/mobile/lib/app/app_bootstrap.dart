class AppBootstrap {
  const AppBootstrap({
    required this.hasRouter,
    required this.hasSecureStore,
    required this.hasTransportClients,
  });

  final bool hasRouter;
  final bool hasSecureStore;
  final bool hasTransportClients;
}

AppBootstrap createAppBootstrap() {
  return const AppBootstrap(
    hasRouter: true,
    hasSecureStore: true,
    hasTransportClients: true,
  );
}
