import 'package:find_a_nikah/features/auth/presentation/presentation.dart'
    show LoginPage, WelcomePage;
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Full-bleed couple photo (scrim baked into the asset) shared by
/// [WelcomePage] and [LoginPage] — both sit on the same hero image, just
/// with different foreground content over it. The photo is a [Hero] so
/// navigating between those two screens doesn't cross-fade/flash it — it
/// just stays put while the foreground content changes.
class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'auth-background-photo',
          // child: Image.asset(Assets.images.authBackground, fit: BoxFit.fill),
          // Dark fallback = the photo's average tone, so a late decode never
          // flashes white behind the white text. Precached in SplashPage.
          child: ColoredBox(
            color: const Color(0xFF414042),
            child: Image.asset(
              Assets.images.authBackground,
              fit: BoxFit.fill,
              gaplessPlayback: true,
            ),
          ),
        ),
        // The Figma export already has the grey scrim baked into
        // auth_background.jpg — an extra gradient on top darkened it far past
        // the design (audit #5/#6).
        // const DecoratedBox(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [Colors.black38, Colors.black45, Colors.black87],
        //     ),
        //   ),
        // ),
        SafeArea(child: child),
      ],
    );
  }
}

/// "Find A Nikah" wordmark lockup used on the welcome + login screens.
/// Also a [Hero] for the same reason as the background photo above.
class BrandLogo extends StatelessWidget {
  const BrandLogo({required this.width, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'auth-brand-logo',
      child: Image.asset(
        Assets.images.findANikahFullLogoImage4xColored,
        width: width,
      ),
    );
  }
}
