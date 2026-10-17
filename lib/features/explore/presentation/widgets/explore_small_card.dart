import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Take a second look" / "Visited you" card: a smaller unlocked photo with
/// name/age/verified and one meta line — flag + area on the left, the
/// posted-at time right-aligned (mockup: 120×168, text inset 6pt).
class ExploreSmallCard extends StatelessWidget {
  const ExploreSmallCard({
    required this.profile,
    required this.onTap,
    super.key,
  });

  final ExploreProfile profile;
  final VoidCallback onTap;

  static const width = 120.0;
  static const double height = width * kExploreCardAspect;

  /// Gap to the next card in the row.
  static const gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final meta = TextFontStyle.headline11w400white70StyleSatoshi.copyWith(
      fontSize: 6.8.sp,
      height: kExploreTightHeight,
      color: Colors.white,
    );
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width.w,
        height: width.w * kExploreCardAspect,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(profile.photoUrl, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55, 1.0],
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 6.w,
                right: 6.75.w,
                bottom: 10.9.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${profile.name}, ${profile.age}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle.headline16w600StyleSatoshi
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 9.75.sp,
                                  fontWeight: FontWeight.w700,
                                  height: kExploreTightHeight,
                                ),
                          ),
                        ),
                        if (profile.isVerified) ...[
                          SizedBox(width: 3.25.w),
                          Icon(
                            Icons.verified,
                            color: kExploreVerifiedBlue,
                            size: 8.5.r,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 5.9.w),
                    Row(
                      children: [
                        Text(
                          profile.countryFlag,
                          style: TextStyle(fontSize: 8.2.sp, height: 1),
                        ),
                        SizedBox(width: 2.75.w),
                        Expanded(
                          child: Text(
                            profile.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: meta,
                          ),
                        ),
                        if (profile.postedAt != null)
                          Text(profile.postedAt!, maxLines: 1, style: meta),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
