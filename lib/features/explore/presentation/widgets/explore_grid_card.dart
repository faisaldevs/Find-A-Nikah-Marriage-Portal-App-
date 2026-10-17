import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_lock_overlay.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Currently available" / "Just joined" / "Active near you" card (mockup:
/// 90×126, in a 2-row strip that scrolls sideways): name/age/verified and
/// one meta line — flag + area (or a distance) on the left, the green
/// active-today dot + label right-aligned.
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

  static const width = 90.0;

  /// Gap between cards, both across and down.
  static const gap = 7.0;

  @override
  Widget build(BuildContext context) {
    final meta = TextFontStyle.headline11w400white70StyleSatoshi.copyWith(
      fontSize: 5.85.sp,
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
              if (locked)
                Center(
                  child: Transform.translate(
                    offset: Offset(0, 1.5.w),
                    child: ExploreLockOverlay(size: 27.r),
                  ),
                ),
              Positioned(
                left: 6.w,
                right: 6.5.w,
                bottom: 10.6.w,
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
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 9.6.sp,
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
                            size: 8.4.r,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.2.w),
                    Row(
                      children: [
                        if (profile.distanceKm != null)
                          Expanded(
                            child: Text(
                              '${profile.distanceKm!.round()} km away',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: meta,
                            ),
                          )
                        else ...[
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
                        ],
                        if (profile.isActiveToday) ...[
                          Container(
                            width: 3.r,
                            height: 3.r,
                            decoration: const BoxDecoration(
                              color: kExploreActiveGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text('Active today', maxLines: 1, style: meta),
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
