import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/flavors/app_config.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class _IntroSlide {
  const _IntroSlide({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

const _slides = [
  _IntroSlide(
    title: 'Where your story begins',
    subtitle:
        'Tell us about your values and preferences to create a profile '
        'that reflects your personality.',
  ),
  _IntroSlide(
    title: 'Meaningful connections,\nbuilt on trust',
    subtitle:
        'Meet genuine people, explore shared values, and build '
        'connections with confidence.',
  ),
  _IntroSlide(
    title: 'Find a partner with\nconfidence',
    subtitle:
        'Step forward with confidence toward a partner who truly '
        'complements your journey.',
  ),
];

/// Cards sit on a wheel rather than a flat strip: each one off-centre is
/// tilted by [_arcTilt] and pushed down the circle's curve, so scrolling
/// reads as rotation. Drop is quadratic in the page offset — the small-angle
/// form of `R(1 - cos θ)`.
///
/// Tilt must stay small relative to card height: rotating about the card's
/// centre swings its bottom corner inward by ~`(height / 2) · tilt`, which
/// has to be less than [_cardGap] or neighbouring cards overlap. At 0.04
/// the gap reads ~24 at the top and ~10 at the visible bottom, as in design.
const _viewportFraction = 0.8; // was 0.72 — design card spans ~78% of width
const _arcTilt = 0.04; // was 0.12 — swung side cards ~24pt into the centre card
const _arcDrop = 14.0; // was 22.0 — design drops side cards ~13pt
const _cardHeight =
    400.0; // was 340 — bottom [_domeOverlap] now sits under the dome
const _cardGap = 16.0; // was 12 (6.w padding each side)
const _cardRadius = 14.0; // was 28 — design corners are much tighter

/// White dome that covers the bottom of every card (centre and side peeks)
/// so the carousel ends in one continuous curve above the captions.
/// [_domeOverlap] is how much of the centre card it hides; [_domeRise] is how
/// much lower the dome's edge sits at the screen sides than at its centre.
const _domeOverlap = 40.0;
const _domeRise = 16.0;

/// PageView has no infinite mode, so the slides repeat across a long page
/// range and the user starts in the middle — that's what puts a peek of the
/// *previous* slide on the left edge of slide 1.
const _loopCount = 999;
final int _initialPage = (_loopCount ~/ 2) - (_loopCount ~/ 2) % _slides.length;

/// Three-slide pitch carousel shown right after splash, before the user
/// hits the welcome/auth screen. Purely a marketing beat — no data is
/// collected here (that's the profile wizard, later).
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) => const _IntroView();
}

class _IntroView extends StatefulWidget {
  const _IntroView();

  @override
  State<_IntroView> createState() => _IntroPageState();
}

class _IntroPageState extends State<_IntroView> {
  final _controller = PageController(
    viewportFraction: _viewportFraction,
    initialPage: _initialPage,
  );
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Fractional page the carousel is at right now (mid-swipe included).
  double get _page =>
      _controller.hasClients && _controller.position.haveDimensions
      ? _controller.page ?? _initialPage.toDouble()
      : _initialPage.toDouble();

  /// Page offset of the card relative to the one centred right now.
  double _deltaFor(int i) => (_page - i).clamp(-2.0, 2.0);
  // double _deltaFor(int i) {
  //   final page = _controller.hasClients && _controller.position
  //       .haveDimensions
  //       ? _controller.page ?? _initialPage.toDouble()
  //       : _initialPage.toDouble();
  //   return (page - i).clamp(-2.0, 2.0);
  // }

  /// Captions of the two slides straddling the current scroll position,
  /// each shifted by exactly as far as its card is — so title/subtitle move
  /// as one unit with their image — and faded out as they leave centre, so
  /// neighbouring captions never show at the screen edges.
  Widget _buildCaptions(double width) {
    final page = _page;
    final base = page.floor();
    final pageWidth = width * _viewportFraction;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        for (final i in [base, base + 1])
          Opacity(
            opacity: (1 - (i - page).abs()).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset((i - page) * pageWidth, 0),
              child: _Caption(slide: _slides[i % _slides.length]),
            ),
          ),
      ],
    );
  }

  String _imageFor(int i) => switch (i) {
    0 => Assets.images.onboardingPhoto1,
    1 => Assets.images.onboardingPhoto2,
    _ => Assets.images.onboardingPhoto3,
  };

  void _onContinue() {
    context.push<void>(RoutePaths.welcome).ignore();
    // Previously Continue advanced the carousel and only left on the last
    // slide — slides are swipe-only now.
    // if (_index == _slides.length - 1) {
    //   context.push<void>(RoutePaths.welcome);
    // } else {
    //   _controller.nextPage(
    //     duration: const Duration(milliseconds: 320),
    //     curve: Curves.easeOut,
    //   );
    // }
  }

  /// The development skip bypasses the intro carousel, not authentication.
  void _skip() => context.push<void>(RoutePaths.welcome).ignore();

  /// "Skip" exists only in dev builds; staging/prod users always sign in.
  static final _showSkip = getIt<AppConfig>().flavors == Flavors.dev;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: List.generate(_slides.length, (i) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: i == _slides.length - 1 ? 0 : 8.w,
                      ),
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: i <= _index
                            ? AppColors.primaryColor
                            : AppColors.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 28.h),
            // Cards, dome and captions share one Stack so each caption can
            // travel with its card. The PageView fills the whole area (dome +
            // captions included) and both overlays ignore pointers, so a
            // swipe anywhere — image or text — drives the carousel.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final domeTop = (_cardHeight - _domeOverlap).h;
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: _loopCount,
                          clipBehavior: Clip.none,
                          onPageChanged: (i) =>
                              setState(() => _index = i % _slides.length),
                          itemBuilder: (context, i) {
                            return Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  final delta = _deltaFor(i);
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      _arcDrop.h * delta * delta,
                                    ),
                                    child: Transform.rotate(
                                      angle: -delta * _arcTilt,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (_cardGap / 2).w,
                                    // horizontal: 6.w,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      _cardRadius.r,
                                    ),
                                    // borderRadius: BorderRadius.circular(28
                                    //     .r),
                                    child: Image.asset(
                                      _imageFor(i % _slides.length),
                                      height: _cardHeight.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: domeTop,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _DomePainter(
                              rise: _domeRise.h,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: domeTop + 28.h,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) =>
                                _buildCaptions(constraints.maxWidth),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Previously a fixed-height carousel with a static title/subtitle
            // below it, swapped on onPageChanged — text didn't travel with
            // its card, so mid-swipe the caption didn't match the image.
            // SizedBox(
            //   height: _cardHeight.h + _arcDrop.h,
            //   child: PageView.builder(
            //     controller: _controller,
            //     itemCount: _loopCount,
            //     clipBehavior: Clip.none,
            //     onPageChanged: (i) =>
            //         setState(() => _index = i % _slides.length),
            //     itemBuilder: (context, i) {
            //       return AnimatedBuilder(
            //         animation: _controller,
            //         builder: (context, child) {
            //           final delta = _deltaFor(i);
            //           return Transform.translate(
            //             offset: Offset(0, _arcDrop.h * delta * delta),
            //             child: Transform.rotate(
            //               angle: -delta * _arcTilt,
            //               child: child,
            //             ),
            //           );
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 6.w),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(28.r),
            //             child: Image.asset(
            //               _imageFor(i % _slides.length),
            //               height: _cardHeight.h,
            //               width: double.infinity,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(height: 32.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 28.w),
            //   child: Text(
            //     _slides[_index].title,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 30.sp,
            //       height: 1.15,
            //       fontWeight: FontWeight.w700,
            //       color: AppColors.textDark,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 14.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 32.w),
            //   child: Text(
            //     _slides[_index].subtitle,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 15.sp,
            //       height: 1.4,
            //       color: AppColors.textMuted,
            //     ),
            //   ),
            // ),
            // const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
              child: AppPrimaryButton(
                label: 'Continue',
                onPressed: _onContinue,
              ),
            ),
            if (_showSkip)
              TextButton(
                onPressed: _skip,
                child: Text(
                  'Skip',
                  style: TextFontStyle.headline14w500textDarkStyleSatoshi,
                ),
              )
            else
              SizedBox(height: 48.h),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

/// Title + subtitle for one slide — the text half of a card/caption unit.
class _Caption extends StatelessWidget {
  const _Caption({required this.slide});

  final _IntroSlide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Text(
            slide.title,
            textAlign: TextAlign.center,
            style: TextFontStyle.headline30w700textDarkStyleSatoshi.copyWith(
              height: 1.15,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: TextFontStyle.headline15w400textMutedStyleSatoshi.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Fills its box with [color] below a shallow arc: top edge is at y = 0 in
/// the middle and at y = [rise] on both sides (quadratic Bézier whose control
/// point sits at -rise, putting the curve's midpoint exactly on 0).
class _DomePainter extends CustomPainter {
  const _DomePainter({required this.rise, required this.color});

  final double rise;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, rise)
      ..quadraticBezierTo(size.width / 2, -rise, size.width, rise)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_DomePainter old) =>
      old.rise != rise || old.color != color;
}
