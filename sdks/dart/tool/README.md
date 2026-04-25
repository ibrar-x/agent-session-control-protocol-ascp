# Tooling

Use the package root for Dart code generation and verification:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test example
dart format tool
dart run tool/check_package_boundary.dart
dart analyze
dart test
dart run example/foundation_decode.dart
dart run example/mock_server_client.dart
dart pub publish --dry-run
```

`check_package_boundary.dart` is a release-facing guard. It verifies the expected public Dart libraries, keeps the root library from exporting private `src` paths directly, confirms release docs exist, and checks examples use only public package imports.
