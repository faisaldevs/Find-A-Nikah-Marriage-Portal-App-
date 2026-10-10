import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Take a second look" / "Visited you" card: a smaller unlocked photo with
/// name/age/verified and a two-part meta row (area, posted-at).
class ExploreSmallCard extends StatelessWidget {
  const ExploreSmallCard({
    required this.profile,
    required this.onTap,
    super.key,
  });

  final ExploreProfile profile;
  final VoidCallback onTap;

  static const width = 120.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width.w,
        height: width.w * 1.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
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
                left: 10.w,
                right: 10.w,
                bottom: 10.h,
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
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        if (profile.isVerified) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.verified,
                            color: kExploreVerifiedBlue,
                            size: 14.r,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Area and posted-at are each on their own line — on
                    // this card's width, fitting both ("Chittagong" +
                    // "Last Month") on one row the way the mockup has it
                    // truncated the area down to a couple of letters.
                    Row(
                      children: [
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
                    ),
                    if (profile.postedAt != null)
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          profile.postedAt!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextFontStyle.headline11w400white70StyleSatoshi
                              .copyWith(fontSize: 10.sp),
                        ),
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
