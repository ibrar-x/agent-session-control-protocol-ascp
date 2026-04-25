import 'dart:async';

final class AscpTransportAuthContext {
  const AscpTransportAuthContext({
    required this.transportKind,
    this.command,
    this.workingDirectory,
    this.url,
  });

  final String transportKind;
  final List<String>? command;
  final String? workingDirectory;
  final Uri? url;
}

typedef AscpAuthHeadersProvider =
    FutureOr<Map<String, String>> Function(AscpTransportAuthContext context);
typedef AscpAuthEnvironmentProvider =
    FutureOr<Map<String, String>> Function(AscpTransportAuthContext context);

final class AscpTransportAuthHooks {
  const AscpTransportAuthHooks({this.headers, this.environment});

  final AscpAuthHeadersProvider? headers;
  final AscpAuthEnvironmentProvider? environment;
}
