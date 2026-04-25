import 'dart:io';

const _expectedPublicLibraries = <String>[
  'ascp_sdk_dart.dart',
  'client.dart',
  'errors.dart',
  'events.dart',
  'methods.dart',
  'models.dart',
  'replay.dart',
  'transport.dart',
  'validation.dart',
];

const _expectedRootExports = <String>[
  'client.dart',
  'errors.dart',
  'events.dart',
  'methods.dart',
  'models.dart',
  'replay.dart',
  'transport.dart',
  'validation.dart',
];

void main() {
  final failures = <String>[];

  _checkRequiredReleaseFiles(failures);
  _checkPubspec(failures);
  _checkPublicLibraries(failures);
  _checkExamplesUsePublicImports(failures);

  if (failures.isNotEmpty) {
    stderr.writeln('Dart package boundary check failed:');
    for (final failure in failures) {
      stderr.writeln('- $failure');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Dart package boundary check passed.');
}

void _checkRequiredReleaseFiles(List<String> failures) {
  for (final path in <String>['README.md', 'CHANGELOG.md', 'LICENSE']) {
    if (!File(path).existsSync()) {
      failures.add('Missing release file: $path.');
    }
  }
}

void _checkPubspec(List<String> failures) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    failures.add('Missing pubspec.yaml.');
    return;
  }

  final content = pubspec.readAsStringSync();
  for (final expected in <String>[
    'name: ascp_sdk_dart',
    'version: 0.1.0',
    'documentation:',
    'agent-session-control-protocol',
  ]) {
    if (!content.contains(expected)) {
      failures.add('pubspec.yaml does not contain "$expected".');
    }
  }

  String? descriptionLine;
  for (final line in content.split('\n')) {
    if (line.startsWith('description:')) {
      descriptionLine = line;
      break;
    }
  }
  if (descriptionLine == null) {
    failures.add('pubspec.yaml is missing a description.');
  } else if (descriptionLine.toLowerCase().contains('foundation')) {
    failures.add(
      'pubspec.yaml description still describes foundation-only scope.',
    );
  }
}

void _checkPublicLibraries(List<String> failures) {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    failures.add('Missing lib/ directory.');
    return;
  }

  final publicLibraries =
      libDir
          .listSync(followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .map((file) => file.uri.pathSegments.last)
          .toList()
        ..sort();

  final expected = [..._expectedPublicLibraries]..sort();
  if (!_sameStrings(publicLibraries, expected)) {
    failures.add(
      'Unexpected public libraries. Expected $expected but found $publicLibraries.',
    );
  }

  final rootExports = _exportsFrom(File('lib/ascp_sdk_dart.dart'));
  if (!_sameStrings(rootExports, _expectedRootExports)) {
    failures.add(
      'Root library exports changed. Expected $_expectedRootExports but found $rootExports.',
    );
  }

  for (final library in _expectedPublicLibraries) {
    final file = File('lib/$library');
    if (!file.existsSync()) {
      continue;
    }

    final content = file.readAsStringSync();
    if (content.contains('.g.dart') || content.contains('.freezed.dart')) {
      failures.add('$library exports generated implementation files.');
    }

    if (library == 'ascp_sdk_dart.dart' && content.contains("export 'src/")) {
      failures.add('Root library exports private src paths directly.');
    }
  }
}

void _checkExamplesUsePublicImports(List<String> failures) {
  final exampleDir = Directory('example');
  if (!exampleDir.existsSync()) {
    return;
  }

  for (final file
      in exampleDir
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final content = file.readAsStringSync();
    if (content.contains('package:ascp_sdk_dart/src/')) {
      failures.add('${file.path} imports a private src package path.');
    }
  }
}

List<String> _exportsFrom(File file) {
  if (!file.existsSync()) {
    return const <String>[];
  }

  final exportPattern = RegExp(r"export '([^']+)';");
  return exportPattern
      .allMatches(file.readAsStringSync())
      .map((match) => match.group(1)!)
      .toList();
}

bool _sameStrings(List<String> actual, List<String> expected) {
  if (actual.length != expected.length) {
    return false;
  }

  for (var index = 0; index < actual.length; index += 1) {
    if (actual[index] != expected[index]) {
      return false;
    }
  }

  return true;
}
