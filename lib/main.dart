import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// Design canvas every mockup in `resources/images/` was exported at
/// (iPhone 13/14 logical points) — `.w`/`.h`/`.sp`/`.r` scale from this.
///
const _designSize = Size(390, 844);
const _verifySize = Size(392.7, 802.9); // TEMP-VERIFY

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return ScreenUtilPlusInit(
      designSize: _verifySize, // TEMP-VERIFY
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Find A Nikah',
          debugShowCheckedModeBanner: false,
          // Placeholder seed color — swap once core/theme/ has real brand tokens.
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFFE94057),
            useMaterial3: true,
            fontFamily: 'Satoshi',
            // Android's default M3 "Zoom" push transition fades BOTH the
            // outgoing and incoming page's non-Hero content out through a
            // transparent middle stretch before the new page pops in — that
            // dead zone is what reads as a "flicker" between screens. The
            // slide transition below has no such gap.
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}
