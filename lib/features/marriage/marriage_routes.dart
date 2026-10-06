import 'package:go_router/go_router.dart';

import 'presentation/screens/marriage_screen.dart';

/// Path constants + route table for `features/marriage` — the first
/// bottom-nav tab. Merged into the app's bottom-nav shell in
/// `core/router/app_router.dart`.
class MarriageRoutes {
  MarriageRoutes._();

  static const marriage = '/marriage';

  static List<GoRoute> routes = [
    GoRoute(path: marriage, builder: (_, _) => const MarriageScreen()),
  ];
}
