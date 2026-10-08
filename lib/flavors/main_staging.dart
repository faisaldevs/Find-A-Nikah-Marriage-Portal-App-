import 'package:find_a_nikah/bootstrap.dart';
import 'package:find_a_nikah/flavors/app_config.dart';

/// `flutter run -t lib/flavors/main_staging.dart --dart-define-from-file=lib/flavors/env/staging.json`
Future<void> main() => bootstrap(Flavors.uat);
