// Enforces the architecture guide's import rules (decisions register #2:
// pub workspace + this test for the folder-level boundaries inside the app).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _import = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''');

/// Every `import`/`export` URI in [file].
List<String> _importsOf(File file) => [
  for (final line in file.readAsLinesSync())
    if (_import.firstMatch(line) case final m?) m.group(1)!,
];

Iterable<File> _dartFiles(String dir) => Directory(dir)
    .listSync(recursive: true)
    .whereType<File>()
    .where(
      (f) =>
          f.path.endsWith('.dart') &&
          !f.path.endsWith('.g.dart') &&
          !f.path.endsWith('.freezed.dart') &&
          !f.path.endsWith('.config.dart'),
    );

/// `lib/features/<feature>/<layer>/...` → (feature, layer).
(String, String)? _locate(String path) {
  final m = RegExp(r'lib/features/(\w+)/(\w+)/').firstMatch(path);
  return m == null ? null : (m.group(1)!, m.group(2)!);
}

/// A relative `uri` in [file], as the `package:` URI it refers to.
String _resolve(File file, String uri) {
  if (uri.startsWith('package:') || uri.startsWith('dart:')) return uri;
  final dir = file.parent.path.replaceFirst(RegExp('^.*?lib/'), '');
  return 'package:find_a_nikah/$dir/$uri';
}

/// `package:find_a_nikah/features/<feature>/<layer>/...` → (feature, layer).
(String, String)? _target(String uri) {
  final m = RegExp(
    r'^package:find_a_nikah/features/(\w+)/(\w+)/',
  ).firstMatch(uri);
  return m == null ? null : (m.group(1)!, m.group(2)!);
}

void main() {
  final violations = <String>[];
  void check(bool ok, File f, String uri, String rule) {
    if (!ok) violations.add('${f.path}: $uri  ✗ $rule');
  }

  setUpAll(() {
    for (final file in _dartFiles('lib/features')) {
      final (feature, layer) = _locate(file.path)!;
      for (final raw in _importsOf(file)) {
        // `../` hides layer crossings: only same-folder barrels may be
        // relative.
        check(!raw.contains('../'), file, raw, 'use package imports');
        final uri = _resolve(file, raw);
        final target = _target(uri);

        switch (layer) {
          case 'domain':
            final pureDart =
                uri.startsWith('dart:') &&
                !uri.startsWith('dart:io') &&
                !uri.startsWith('dart:ui');
            check(
              pureDart ||
                  uri.startsWith('package:core/') ||
                  uri.startsWith('package:fpdart/') ||
                  uri.startsWith('package:freezed_annotation/') ||
                  uri.startsWith('package:meta/') ||
                  (target != null && target.$2 == 'domain'),
              file,
              uri,
              'domain is pure Dart: core, fpdart, freezed_annotation and '
              'domains only',
            );
          case 'data':
            check(
              target == null ||
                  target.$2 == 'domain' ||
                  (target.$1 == feature && target.$2 == 'data'),
              file,
              uri,
              "data imports domains and its own data, never presentation or "
              "another feature's data",
            );
            check(
              !uri.startsWith('package:flutter/material') &&
                  !uri.startsWith('package:flutter/widgets') &&
                  !uri.startsWith('package:flutter_bloc/'),
              file,
              uri,
              'data never imports widgets or blocs',
            );
          case 'presentation':
            check(
              target == null ||
                  target.$2 == 'domain' ||
                  (target.$1 == feature && target.$2 == 'presentation'),
              file,
              uri,
              "presentation never imports data, nor another feature's "
              'presentation (navigate through lib/router)',
            );
            check(
              !uri.startsWith('package:dio/') &&
                  !uri.startsWith('package:retrofit/') &&
                  !uri.startsWith('package:api_client/') &&
                  !uri.startsWith('package:realtime/'),
              file,
              uri,
              'presentation never talks to the network directly',
            );
          default:
            violations.add('${file.path}: unknown layer "$layer"');
        }

        check(
          !uri.startsWith('package:find_a_nikah/app/') ||
              uri.startsWith('package:find_a_nikah/app/config/'),
          file,
          uri,
          'features never import the app shell (config excepted)',
        );
      }
    }

    // Blocs depend on use cases / repository interfaces only.
    for (final file in _dartFiles('lib/features').where(
      (f) => f.path.contains('/presentation/bloc/'),
    )) {
      for (final uri in _importsOf(file)) {
        check(
          !uri.contains('/presentation/bloc/') ||
              uri.contains(_locate(file.path)!.$1),
          file,
          uri,
          'blocs never depend on another bloc',
        );
        check(
          !uri.startsWith('package:find_a_nikah/di/'),
          file,
          uri,
          'blocs get dependencies through their constructor, not getIt',
        );
      }
    }

    // Shared packages know no feature.
    for (final file in _dartFiles('packages')) {
      for (final uri in _importsOf(file)) {
        check(
          !uri.startsWith('package:find_a_nikah/'),
          file,
          uri,
          'packages/ never import the app',
        );
      }
    }
  });

  test('layer and feature boundaries hold', () {
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
