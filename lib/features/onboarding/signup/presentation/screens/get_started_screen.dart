import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/router/app_navigator.dart';
// import '../widgets/app_primary_button.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/app_primary_button.dart';

/// Static fan of three photo cards: a portrait card in the centre with two
/// smaller cards tucked behind it, tilted outward and dropped lower, peeking
/// in from the screen edges — spokes of a wheel whose hub sits below.
const _cardWidth = 220.0;
const _cardHeight = 338.0;
const _cardRadius = 12.0;
const _sideScale = 0.85;

/// Horizontal distance of a side card's centre from the screen centre, as a
/// fraction of screen width — ~0.57 leaves ~60pt of it visible at the edge.
const _sideOffsetFraction = 0.57;
const _sideDrop = 90.0;
const _sideTilt = 0.15;

/// Room for the fan: the dropped side cards reach lower than the centre card.
const _fanHeight = 410.0;

/// Shown once right after signup — the "you're new here, let's get your
/// profile going" beat. "Get Started" leads into the profile-info wizard,
/// starting with account type.
///
/// Each image is either a bundled asset path or an `http(s)` URL (see
/// [_FanImage]), so the cards can later come from the backend without
/// touching the layout. Null falls back to the bundled photos.
class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({
    super.key,
    this.centerImage,
    this.leftImage,
    this.rightImage,
  });

  final String? centerImage;
  final String? leftImage;
  final String? rightImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // Fan sits outside the horizontal padding so side cards can
            // run off the screen edges.
            _CardFan(
              center: centerImage ?? Assets.images.getStartedPhoto,
              left: leftImage ?? Assets.images.onboardingPhoto1,
              right: rightImage ?? Assets.images.onboardingPhoto3,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              // padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: 'Welcome to\n',
                        // Design title is regular weight, not bold.
                        style: TextFontStyle.headline28w500textDarkStyleSatoshi
                            .copyWith(height: 1.25),
                        // style: TextFontStyle.headline28w700textDarkStyleSatoshi
                        //     .copyWith(height: 1.25),
                        children: [
                          TextSpan(
                            text: 'Find A Nikah',
                            style: TextFontStyle
                                .headline28w500primaryColorStyleSatoshi
                                .copyWith(height: 1.25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tell us about yourself so we can help you find '
                      'meaningful, compatible matches nearby.',
                      // Design body copy is near-black, not muted grey.
                      style: TextFontStyle.headline15w400textDarkStyleSatoshi
                          .copyWith(height: 1.4),
                      // style: TextFontStyle.headline15w400textMutedStyleSatoshi
                      //     .copyWith(height: 1.4),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  AppPrimaryButton(
                    label: 'Get Started',
                    onPressed: () =>
                        ref.read(appNavigatorProvider).toAccountType(),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // Previously a single rounded photo (no side cards, no shadow) inside
    // the padded column — didn't match the three-card fan in the design.
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 24.w),
    //       child: Column(
    //         children: [
    //           const Spacer(flex: 2),
    //           ClipRRect(
    //             borderRadius: BorderRadius.circular(20.r),
    //             child: Image.asset(
    //               Assets.images.getStartedPhoto,
    //               height: 260.h,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           const Spacer(flex: 3),
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text.rich(
    //               TextSpan(
    //                 text: 'Welcome to\n',
    //                 style: TextStyle(
    //                   fontSize: 28.sp,
    //                   height: 1.25,
    //                   fontWeight: FontWeight.w700,
    //                   color: AppColors.textDark,
    //                 ),
    //                 children: const [
    //                   TextSpan(
    //                     text: 'Find A Nikah',
    //                     style: TextStyle(color: AppColors.primaryColor),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           SizedBox(height: 16.h),
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               'Tell us about yourself so we can help you find '
    //               'meaningful, compatible matches nearby.',
    //               style: TextStyle(
    //                 fontSize: 15.sp,
    //                 height: 1.4,
    //                 color: AppColors.textMuted,
    //               ),
    //             ),
    //           ),
    //           const Spacer(flex: 4),
    //           AppPrimaryButton(
    //             label: 'Get Started',
    //             onPressed: () => ref.read(appNavigatorProvider).toAccountType(),
    //           ),
    //           SizedBox(height: 24.h),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class _CardFan extends StatelessWidget {
  const _CardFan({
    required this.center,
    required this.left,
    required this.right,
  });

  final String center;
  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    final sideDx = MediaQuery.sizeOf(context).width * _sideOffsetFraction;
    // Side cards are laid out top-centred like the centre card, then shifted
    // so their *top* lands [_sideDrop] lower; shrinking about the centre
    // would otherwise raise it by half the height difference.
    final sideDy = _sideDrop.h - _cardHeight.h * (1 - _sideScale) / 2;

    Widget side(String src, double dir) => Transform.translate(
      offset: Offset(dir * sideDx, sideDy),
      child: Transform.rotate(
        angle: dir * _sideTilt,
        child: Transform.scale(
          scale: _sideScale,
          child: _FanCard(src: src),
        ),
      ),
    );

    return SizedBox(
      height: _fanHeight.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Painted first so the centre card overlaps them.
          side(left, -1),
          side(right, 1),
          _FanCard(src: center),
        ],
      ),
    );
  }
}

class _FanCard extends StatelessWidget {
  const _FanCard({required this.src});

  final String src;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _cardWidth.w,
      height: _cardHeight.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_cardRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius.r),
        child: _FanImage(src: src),
      ),
    );
  }
}

/// Renders [src] as a network image when it's an `http(s)` URL, otherwise
/// as a bundled asset. Network loads show a tinted placeholder while loading
/// and on failure, so a bad URL never leaves a hole in the fan.
class _FanImage extends StatelessWidget {
  const _FanImage({required this.src});

  final String src;

  bool get _isNetwork =>
      src.startsWith('http://') || src.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (!_isNetwork) {
      return Image.asset(src, fit: BoxFit.cover);
    }
    return Image.network(
      src,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _FanPlaceholder(),
      errorBuilder: (context, error, stackTrace) => const _FanPlaceholder(),
    );
  }
}

class _FanPlaceholder extends StatelessWidget {
  const _FanPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryColor.withValues(alpha: 0.08),
      child: const SizedBox.expand(),
    );
  }
}
