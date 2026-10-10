import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_lock_overlay.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Likes in your filters" card: a tall hero photo, name/age/verified and a
/// three-part meta row (area, profession, posted-at).
class ExploreBigCard extends StatelessWidget {
  const ExploreBigCard({
    required this.profile,
    required this.locked,
    required this.onTap,
    super.key,
  });

  final ExploreProfile profile;
  final bool locked;
  final VoidCallback onTap;

  static const width = 290.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width.w,
        height: width.w * 1.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(profile.photoUrl, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.5, 1.0],
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
              if (locked) Center(child: ExploreLockOverlay(size: 52.r)),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
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
                            style: TextFontStyle
                                .headline22w700textDarkStyleSatoshi
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        if (profile.isVerified) ...[
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.verified,
                            color: kExploreVerifiedBlue,
                            size: 20.r,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          profile.countryFlag,
                          style: TextStyle(fontSize: 14.sp, height: 1),
                        ),
                        SizedBox(width: 6.w),
                        // The only one that should ever give way — the
                        // profession/posted-at labels next to it are short
                        // and fixed, so they keep their natural width
                        // instead of splitting the row's slack evenly with
                        // it (an even split truncated "Chittagong" while
                        // "Student" sat in its share with room to spare).
                        Expanded(
                          child: Text(
                            profile.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .headline13w400textWhiteStyleSatoshi,
                          ),
                        ),
                        if (profile.profession != null) ...[
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.work_outline,
                            size: 13.r,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            profile.profession!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .headline13w400textWhiteStyleSatoshi,
                          ),
                        ],
                        if (profile.postedAt != null) ...[
                          SizedBox(width: 10.w),
                          Text(
                            profile.postedAt!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .headline13w400textWhiteStyleSatoshi,
                          ),
                        ],
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
