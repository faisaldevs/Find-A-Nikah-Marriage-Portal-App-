import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../state/marriage_profile.dart';
import 'crown_icon.dart';
import 'profile_photo.dart';
import 'profile_style.dart';

/// First screen of a profile: full-height main photo with "Active today",
/// premium crown, name/age/verified, distance line and a 2×2 details grid
/// laid over a dark gradient.
class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.profile,
    required this.height,
    required this.bottomInset,
  });

  final MarriageProfile profile;
  final double height;

  /// Space kept clear at the bottom for the floating action buttons.
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProfilePhoto(url: profile.photoUrls.first),
          // Keeps the white text readable on any photo.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.18, 0.45, 1.0],
                colors: [
                  Color(0x55000000),
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0xE6000000),
                ],
              ),
            ),
          ),
          // Full-profile mockup: badge 20 from the top/right, dot at 19.
          Positioned(
            top: 20.h,
            left: 19.w,
            right: 20.w,
            // top: 14.h,
            // left: 14.w,
            // right: 14.w,
            child: Row(
              children: [
                if (profile.isActiveToday) const _ActiveTodayPill(),
                const Spacer(),
                if (profile.isPremium) const _CrownBadge(),
              ],
            ),
          ),
          Positioned(
            left: 19.w,
            right: 19.w,
            // left: 16.w,
            // right: 16.w,
            bottom: bottomInset,
            child: _ProfileSummary(profile: profile),
          ),
        ],
      ),
    );
  }
}

class _ActiveTodayPill extends StatelessWidget {
  const _ActiveTodayPill();

  @override
  Widget build(BuildContext context) {
    // Mockup: plain dot + text on the photo (the top gradient keeps it
    // readable), no pill background.
    // Vertically centred on the crown badge by the parent Row.
    return Padding(
      padding: EdgeInsets.zero,
      // padding: EdgeInsets.symmetric(vertical: 5.h),
      // decoration: BoxDecoration(
      //   color: Colors.black.withValues(alpha: 0.35),
      //   borderRadius: BorderRadius.circular(20.r),
      // ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: const BoxDecoration(
              color: Color(0xFF28E857),
              // color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.5.w),
          Text(
            'Active today',
            style: TextFontStyle.headline12w500textWhiteStyleSatoshi
                // Mockup: medium 14 (cap height 10).
                .copyWith(fontSize: 14.sp)
                .lh(17.5, tracking: -0.015),
            // style: TextFontStyle.headline12w500textWhiteStyleSatoshi,
          ),
        ],
      ),
    );
  }
}

class _CrownBadge extends StatelessWidget {
  const _CrownBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.r,
      height: 30.r,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: kProfileGold,
        // color: Color(0xFF8B6B2E),
        shape: BoxShape.circle,
      ),
      child: CrownIcon(width: 14.r, color: Colors.white),
      // child: Icon(
      //   Icons.workspace_premium,
      //   size: 17.r,
      //   color: const Color(0xFFF5D98B),
      // ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.profile});

  final MarriageProfile profile;

  @override
  Widget build(BuildContext context) {
    final km = profile.distanceKm;
    final distance = km == km.roundToDouble()
        ? '${km.round()} km'
        : '${km.toStringAsFixed(1)} km';
    return Column(
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
                // Explicit line heights throughout: Satoshi's 0.1em line
                // gap otherwise makes each line ~10% taller on Android.
                style: TextFontStyle.headline28w700textWhiteStyleSatoshi.lh(
                  35,
                  tracking: -0.015,
                ),
                // style: TextFontStyle.headline28w700textWhiteStyleSatoshi,
              ),
            ),
            if (profile.isVerified) ...[
              SizedBox(width: 8.w),
              Icon(Icons.verified, color: const Color(0xFF3B82F6), size: 24.r),
            ],
          ],
        ),
        SizedBox(height: 9.h),
        // SizedBox(height: 6.h),
        Row(
          children: [
            // height: 1 — the emoji font's own line height made this row
            // ~6 taller than the text, pushing the name up.
            Text(
              profile.countryFlag,
              style: TextStyle(fontSize: 17.sp, height: 1),
            ),
            SizedBox(width: 7.w),
            // Text(profile.countryFlag, style: TextStyle(fontSize: 13.sp)),
            // SizedBox(width: 6.w),
            Expanded(
              child: Text(
                '$distance away, ${profile.area}, ${profile.country}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // Full-profile mockup: 14 (was 13).
                style: TextFontStyle.headline14w400textWhiteStyleSatoshi.lh(
                  17.5,
                  tracking: -0.015,
                ),
                // style: TextFontStyle.headline13w400textWhiteStyleSatoshi,
              ),
            ),
          ],
        ),
        SizedBox(height: 31.h),
        // SizedBox(height: 16.h),
        // Mockup: one vertical divider between the columns and one line
        // under the first row (not a separate underline per cell).
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _DetailColumn(
                  top: _Detail(
                    label: 'Country',
                    value: profile.country,
                    flag: profile.countryFlag,
                  ),
                  bottom: _Detail(label: 'Practice', value: profile.practice),
                  padding: EdgeInsets.only(right: 12.w),
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Colors.white24,
              ),
              Expanded(
                child: _DetailColumn(
                  top: _Detail(label: 'Profession', value: profile.profession),
                  bottom: _Detail(
                    label: 'Ethnicity',
                    value: profile.ethnicity,
                    flag: profile.ethnicityFlag,
                  ),
                  padding: EdgeInsets.only(left: 12.w),
                ),
              ),
            ],
          ),
        ),
        // Previous grid (per-cell underlines, no vertical divider):
        // SizedBox(height: 16.h),
        // _DetailRow(
        //   left: _Detail(
        //     label: 'Country',
        //     value: profile.country,
        //     flag: profile.countryFlag,
        //   ),
        //   right: _Detail(label: 'Profession', value: profile.profession),
        // ),
        // SizedBox(height: 12.h),
        // _DetailRow(
        //   left: _Detail(label: 'Practice', value: profile.practice),
        //   right: _Detail(
        //     label: 'Ethnicity',
        //     value: profile.ethnicity,
        //     flag: profile.ethnicityFlag,
        //   ),
        // ),
      ],
    );
  }
}

/// One column of the details grid: top cell, a line, bottom cell.
class _DetailColumn extends StatelessWidget {
  const _DetailColumn({
    required this.top,
    required this.bottom,
    required this.padding,
  });

  final _Detail top;
  final _Detail bottom;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: padding.copyWith(bottom: 10.h),
          child: top,
        ),
        // Runs the full column width so it meets the vertical divider.
        const Divider(height: 1, thickness: 1, color: Colors.white24),
        Padding(
          padding: padding.copyWith(top: 8.h),
          // padding: padding.copyWith(top: 10.h),
          child: bottom,
        ),
      ],
    );
  }
}

// class _DetailRow extends StatelessWidget {
//   const _DetailRow({required this.left, required this.right});
//
//   final _Detail left;
//   final _Detail right;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(child: left),
//         SizedBox(width: 16.w),
//         Expanded(child: right),
//       ],
//     );
//   }
// }

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value, this.flag});

  final String label;
  final String value;
  final String? flag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-profile mockup: medium 10.
        Text(
          label,
          style: TextFontStyle.headline11w400white70StyleSatoshi
              .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500)
              .lh(12.5),
        ),
        // Text(label, style: TextFontStyle.headline11w400white70StyleSatoshi),
        // Text(label, style: TextFontStyle.headline12w400white70StyleSatoshi),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (flag != null) ...[
              Text(flag!, style: TextStyle(fontSize: 11.5.sp, height: 1)),
              // Text(flag!, style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 7.w),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextFontStyle.headline14w400textWhiteStyleSatoshi.lh(
                  17.5,
                ),
                // style: TextFontStyle.headline14w500textWhiteStyleSatoshi,
                // style: TextFontStyle.headline15w500textWhiteStyleSatoshi,
              ),
            ),
          ],
        ),
      ],
    );
    // Previously wrapped in a Container with a per-cell bottom border:
    // return Container(
    //   padding: EdgeInsets.only(bottom: 8.h),
    //   decoration: const BoxDecoration(
    //     border: Border(bottom: BorderSide(color: Colors.white24)),
    //   ),
    //   child: Column(...),
    // );
  }
}
