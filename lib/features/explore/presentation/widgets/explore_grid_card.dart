import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_lock_overlay.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Currently available" / "Just joined" / "Active near you" grid card: a
/// 4-up photo with name/age/verified and either an area or a distance,
/// next to an active-today dot. Sized by its parent's `GridView` cell.
class ExploreGridCard extends StatelessWidget {
  const ExploreGridCard({
    required this.profile,
    required this.locked,
    required this.onTap,
    super.key,
  });

  final ExploreProfile profile;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
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
            if (locked) Center(child: ExploreLockOverlay(size: 32.r)),
            Positioned(
              left: 6.w,
              right: 6.w,
              bottom: 8.h,
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
                          style: TextFontStyle.headline14w600StyleSatoshi
                              .copyWith(color: Colors.white, fontSize: 10.sp),
                        ),
                      ),
                      if (profile.isVerified) ...[
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.verified,
                          color: kExploreVerifiedBlue,
                          size: 9.r,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Its own line: on a 4-up column, "flag + area + dot +
                  // Active today" all on one row (as the mockup has it)
                  // doesn't fit — "Active today" alone is close to the
                  // whole column's width.
                  Row(
                    children: [
                      if (profile.distanceKm != null)
                        Flexible(
                          child: Text(
                            '${profile.distanceKm!.round()} km away',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .headline11w400white70StyleSatoshi
                                .copyWith(fontSize: 10.sp),
                          ),
                        )
                      else ...[
                        Text(
                          profile.countryFlag,
                          style: TextStyle(fontSize: 9.sp, height: 1),
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            profile.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .headline11w400white70StyleSatoshi
                                .copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (profile.isActiveToday) ...[
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4.r,
                          height: 4.r,
                          decoration: const BoxDecoration(
                            color: kExploreActiveGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            'Active today',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .headline11w400white70StyleSatoshi
                                .copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
