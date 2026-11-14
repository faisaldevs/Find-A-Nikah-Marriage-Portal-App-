import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Leaves a Feed screen. A screen opened from a shared link has nothing
/// under it to pop to, so go to the Feed tab instead of doing nothing (or
/// closing the app).
void feedGoBack(BuildContext context, [Object? result]) {
  if (context.canPop()) {
    context.pop(result);
  } else {
    context.go(RoutePaths.feed);
  }
}
