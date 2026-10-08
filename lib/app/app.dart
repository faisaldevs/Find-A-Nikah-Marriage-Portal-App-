import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart';
import 'package:find_a_nikah/features/remote_config/presentation/presentation.dart';
import 'package:find_a_nikah/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

/// Design canvas every mockup in `resources/images/` was exported at
/// (iPhone 13/14 logical points) — `.w`/`.h`/`.sp`/`.r` scale from this.
const designSize = Size(390, 844);
// const designSize = Size(392.7, 802.9); // TEMP-VERIFY (Pixel 5) — pixel-match pass

/// Root widget. Owns the app-scoped blocs, which sit above the router:
/// [AuthBloc] (the redirect guards on it) and [RemoteConfigBloc] (kill
/// switches, force update).
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _auth;
  late final RemoteConfigBloc _remoteConfig;
  late final GoRouter _router;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _auth = getIt<AuthBloc>()..add(const AuthStatusSubscriptionRequested());
    _remoteConfig = getIt<RemoteConfigBloc>()
      ..add(const RemoteConfigRefreshRequested());
    _router = createAppRouter(
      currentAuth: () => _auth.state,
      authStatus: _auth.stream,
      updateRequired: () => _remoteConfig.state.updateRequired,
      isEnabled: (flag) => _remoteConfig.state.isEnabled(flag),
      remoteConfig: _remoteConfig.stream,
    );
    // Kill switches and the version floor are re-read on every return to
    // the foreground.
    _lifecycle = AppLifecycleListener(
      onResume: () => _remoteConfig.add(const RemoteConfigRefreshRequested()),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _router.dispose();
    _auth.close().ignore();
    _remoteConfig.close().ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _auth),
        BlocProvider.value(value: _remoteConfig),
      ],
      child: ScreenUtilPlusInit(
        designSize: designSize,
        minTextAdapt: true,
        builder: (context, _) => ToastificationWrapper(
          child: MaterialApp.router(
            title: 'Find A Nikah',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
