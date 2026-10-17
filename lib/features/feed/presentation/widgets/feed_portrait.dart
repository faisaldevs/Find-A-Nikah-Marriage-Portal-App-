import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Round photo with the author's flag in a white tab on its bottom-right
/// corner (Figma, 40pt photo: 14×10 flag, 2pt padding, hanging 1pt past the
/// photo and clipped by it). The tab scales with [size].
class FeedPortrait extends StatelessWidget {
  const FeedPortrait({
    required this.url,
    required this.size,
    this.countryCode,
    super.key,
  });

  final String url;
  final double size;
  final String? countryCode;

  static String? flagFor(String? code) => switch (code) {
    'bd' => Assets.icons.flagBd,
    'tr' => Assets.icons.flagTr,
    'my' => Assets.icons.flagMy,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final flag = flagFor(countryCode);
    final s = size.w;
    final k = size / 40;
    final placeholder = ColoredBox(
      color: kFeedGrey200,
      child: SizedBox.square(dimension: s),
    );
    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        children: [
          ClipOval(
            child: url.isEmpty
                ? placeholder
                : url.startsWith('assets/')
                ? Image.asset(url, width: s, height: s, fit: BoxFit.cover)
                : Image.network(
                    url,
                    width: s,
                    height: s,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => placeholder,
                  ),
          ),
          if (flag != null)
            Positioned(
              right: (-1 * k).w,
              bottom: (-1 * k).w,
              child: Container(
                padding: EdgeInsets.all((2 * k).w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular((2 * k).w),
                ),
                child: SvgPicture.asset(
                  flag,
                  width: (14 * k).w,
                  height: (10 * k).w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A country's flag on its own (profile header: 18pt wide, 4:3).
class FeedPortraitFlag extends StatelessWidget {
  const FeedPortraitFlag({required this.countryCode, super.key});

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final flag = FeedPortrait.flagFor(countryCode);
    if (flag == null) return const SizedBox.shrink();
    return SvgPicture.asset(flag, width: 18.w, height: 13.5.w);
  }
}
