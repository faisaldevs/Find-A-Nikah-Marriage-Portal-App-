import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_lock_overlay.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Likes in your filters" card: a tall hero photo, name/age/verified and a
/// three-part meta row (area, profession, posted-at). Offsets are the
/// mockup's (290×400 card, text 10pt from the left).
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

  /// Mockup: 290×400 — not the 1.4 aspect the smaller cards share.
  static const height = 400.0;

  /// Gap to the next card in the row.
  static const gap = 20.0;

  @override
  Widget build(BuildContext context) {
    final meta = TextFontStyle.headline13w400textWhiteStyleSatoshi.copyWith(
      fontSize: 12.sp,
      height: kExploreTightHeight,
    );
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width.w,
        height: height.w,
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
                    stops: [0.0, 0.5, 1.0],
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
              if (locked)
                Center(
                  // The glyph's visible centre sits ~4pt above its box's.
                  child: Transform.translate(
                    offset: Offset(0, 4.w),
                    child: ExploreLockOverlay(size: 77.r),
                  ),
                ),
              Positioned(
                left: 10.w,
                right: 10.w,
                bottom: 27.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24.r,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${profile.name}, ${profile.age}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextFontStyle
                                  .headline22w700textDarkStyleSatoshi
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 19.5.sp,
                                    height: kExploreTightHeight,
                                  ),
                            ),
                          ),
                          if (profile.isVerified) ...[
                            SizedBox(width: 9.w),
                            Transform.translate(
                              offset: Offset(0, -1.5.w),
                              child: Icon(
                                Icons.verified,
                                color: kExploreVerifiedBlue,
                                size: 24.r,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 13.2.w),
                    Row(
                      children: [
                        Text(
                          profile.countryFlag,
                          style: TextStyle(fontSize: 12.sp, height: 1),
                        ),
                        SizedBox(width: 5.5.w),
                        Flexible(
                          child: Text(
                            profile.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: meta,
                          ),
                        ),
                        if (profile.profession != null) ...[
                          SizedBox(width: 21.w),
                          Icon(
                            Icons.work_outline,
                            size: 16.r,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            profile.profession!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: meta,
                          ),
                        ],
                        if (profile.postedAt != null) ...[
                          SizedBox(width: 20.5.w),
                          Text(
                            profile.postedAt!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: meta,
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
