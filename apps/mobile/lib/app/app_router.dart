String resolveInitialLocation({
  required bool isTrusted,
  required String requestedPath,
}) {
  if (!isTrusted && requestedPath != AppRoute.pairing.path) {
    return AppRoute.pairing.path;
  }
  if (requestedPath.isEmpty || requestedPath == '/') {
    return isTrusted ? AppRoute.home.path : AppRoute.pairing.path;
  }
  return requestedPath;
}

enum AppRoute {
  pairing('/pairing'),
  home('/home'),
  sessions('/sessions'),
  approvals('/approvals'),
  inspect('/inspect'),
  settings('/settings');

  const AppRoute(this.path);

  final String path;
}
