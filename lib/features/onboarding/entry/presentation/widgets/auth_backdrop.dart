import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Full-bleed couple photo + dark scrim shared by [WelcomeScreen] and
/// [LoginScreen] — both sit on the same hero image, just with different
/// foreground content over it. The photo is a [Hero] so navigating between
/// those two screens doesn't cross-fade/flash it — it just stays put while
/// the foreground content changes.
class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'auth-background-photo',
          child: Image.asset(Assets.images.authBackground, fit: BoxFit.fill),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black38, Colors.black45, Colors.black87],
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

/// "Find A Nikah" wordmark lockup used on the welcome + login screens.
/// Also a [Hero] for the same reason as the background photo above.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.width});

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
