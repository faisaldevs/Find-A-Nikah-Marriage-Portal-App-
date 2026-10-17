import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "My history" tab grid cell: a photo over a white footer with name/age/
/// verified, then a 2-row fact grid (area + profession, active-today +
/// interacted-at) split by dividers — unlike `ExploreBigCard`/
/// `ExploreSmallCard`/`ExploreGridCard`, which overlay everything on the
/// photo itself.
class ExploreHistoryCard extends StatelessWidget {
  const ExploreHistoryCard({
    required this.profile,
    required this.onTap,
    super.key,
  });

  final ExploreProfile profile;
  final VoidCallback onTap;

  static const footerHeight = 96.0;

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    // onTap: onTap,
    // child: Container(
    // decoration: BoxDecoration(
    // color: Colors.white,
    // borderRadius: BorderRadius.circular(12.r),
    // border: Border.all(color: kExploreCircleBorder),
    // ),
    // clipBehavior: Clip.antiAlias,
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.stretch,
    // children: [
    // AspectRatio(
    // aspectRatio: 1 / kExploreCardAspect,
    // child: Image.network(profile.photoUrl, fit: BoxFit.cover),
    // ),
    // Padding(
    // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Row(
    // children: [
    // Flexible(
    // child: Text(
    // '${profile.name}, ${profile.age}',
    // maxLines: 1,
    // overflow: TextOverflow.ellipsis,
    // style: TextFontStyle.headline14w600StyleSatoshi
    // .copyWith(fontSize: 13.sp),
    // ),
    // ),
    // if (profile.isVerified) ...[
    // SizedBox(width: 4.w),
    // Icon(
    // Icons.verified,
    // color: kExploreVerifiedBlue,
    // size: 13.r,
    // ),
    // ],
    // ],
    // ),
    // SizedBox(height: 6.h),
    // const Divider(height: 1, color: kExploreCircleBorder),
    // SizedBox(height: 6.h),
    // _FactRow(
    // left: Row(
    // mainAxisSize: MainAxisSize.min,
    // children: [
    // Text(
    // profile.countryFlag,
    // style: TextStyle(fontSize: 9.sp, height: 1),
    // ),
    // SizedBox(width: 3.w),
    // Flexible(child: _FactText(profile.area)),
    // ],
    // ),
    // right: _FactText(profile.profession ?? ''),
    // ),
    // SizedBox(height: 6.h),
    // const Divider(height: 1, color: kExploreCircleBorder),
    // SizedBox(height: 6.h),
    // _FactRow(
    // left: profile.isActiveToday
    // ? Row(
    // mainAxisSize: MainAxisSize.min,
    // children: [
    // Container(
    // width: 4.r,
    // height: 4.r,
    // decoration: const BoxDecoration(
    // color: kExploreActiveGreen,
    // shape: BoxShape.circle,
    // ),
    // ),
    // SizedBox(width: 3.w),
    // const _FactText('Active today'),
    // ],
    // )
    // : const SizedBox.shrink(),
    // right: _FactText(profile.interactedAt ?? ''),
    // ),
    // ],
    // ),
    // ),
    // ],
    // ),
    // ),
    // );
    // Figma 1157:6871: the photo fills the 6pt-radius card; a transparent →
    // 60% black gradient carries the name (Bold 14 + verified) and two
    // 7pt detail rows split by faint white rules.
    final detail = figmaText(
      7,
      8.05,
      weight: FontWeight.w500,
      color: Colors.white,
    );
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(profile.photoUrl, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0x99000000)],
                  stops: [0, 0.733],
                ),
              ),
            ),
            Positioned(
              left: 8.w,
              right: 8.w,
              bottom: 12.h,
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
                          style: figmaText(
                            14,
                            14,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (profile.isVerified) ...[
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.verified,
                          color: kExploreVerifiedBlue,
                          size: 10.r,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _OverlayRow(
                    left: Row(
                      children: [
                        Text(
                          profile.countryFlag,
                          style: TextStyle(fontSize: 6.sp, height: 1),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            profile.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: detail,
                          ),
                        ),
                      ],
                    ),
                    right: Text(
                      profile.profession ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: detail,
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _OverlayRow(
                    left: Text(
                      profile.isActiveToday ? 'Active today' : '',
                      maxLines: 1,
                      style: detail,
                    ),
                    right: Text(
                      profile.interactedAt ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: detail,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Replaced by _OverlayRow (Figma overlay card).
// class _FactRow extends StatelessWidget {
//   const _FactRow({required this.left, required this.right});
//
//   final Widget left;
//   final Widget right;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(child: left),
//         SizedBox(
//           height: 10.h,
//           child:
//               const VerticalDivider(width: 1, color: kExploreCircleBorder),
//         ),
//         SizedBox(width: 6.w),
//         Expanded(child: right),
//       ],
//     );
//   }
// }

// Replaced by _OverlayRow (Figma overlay card).
// class _FactText extends StatelessWidget {
//   const _FactText(this.text);
//
//   final String text;
//
//   @override
//   Widget build(BuildContext context) => Text(
//     text,
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//     style: TextFontStyle.headline11w400white70StyleSatoshi.copyWith(
//       color: AppColors.textMuted,
//       fontSize: 10.sp,
//     ),
//   );
// }

/// One 18pt detail row: two halves split by a faint white rule.
class _OverlayRow extends StatelessWidget {
  const _OverlayRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18.h,
      child: Row(
        children: [
          Expanded(child: left),
          Container(width: 0.5, color: Colors.white.withValues(alpha: 0.2)),
          SizedBox(width: 4.w),
          Expanded(child: right),
        ],
      ),
    );
  }
}
