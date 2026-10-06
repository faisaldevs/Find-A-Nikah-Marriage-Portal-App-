import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/ui/icons/ring_icon.dart';
import 'profile_style.dart';

const _lineColor = Color(0xFF292533);
const _stopLabelColor = Color(0xFF534F5D);
const _matchColor = Color(0xFFFC4E4D);

/// "X's marriage intentions": a timeline from Match! (heart) through when
/// they'd involve family, how long they'd chat, and when they'd marry.
class MarriageIntentionsCard extends StatelessWidget {
  const MarriageIntentionsCard({
    super.key,
    required this.name,
    required this.involveFamily,
    required this.chatFor,
    required this.marryWithin,
    this.onInfo,
  });

  final String name;
  final String involveFamily;
  final String chatFor;
  final String marryWithin;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      title: '$name’s marriage intentions',
      onInfo: onInfo,
      // Mockup: pills start 70 below the card's top edge; labels end 22
      // above its bottom edge.
      child: Padding(
        padding: EdgeInsets.only(top: 26.h, bottom: 3.h),
        child: _Timeline(
          involveFamily: involveFamily,
          chatFor: chatFor,
          marryWithin: marryWithin,
        ),
      ),
    );
  }
}

/// White rounded card with a regular-18 title and a grey (i) on the right.
/// Shared by the intentions and "Verified profile" cards.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.title,
    required this.child,
    this.onInfo,
  });

  final String title;
  final Widget child;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kProfileGutter),
      // + the 1 border = the mockup's 21 / 18.7 / 19 insets.
      padding: EdgeInsets.fromLTRB(20.w, 17.7.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: kProfileBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  // Mockup: medium 18.
                  style: TextFontStyle.headline18w500textWhiteStyleSatoshi
                      .copyWith(color: kProfileInk)
                      .lh(24),
                  // style: TextFontStyle.headline18w400textDarkStyleSatoshi
                  //     .copyWith(color: kProfileInk)
                  //     .lh(24),
                ),
              ),
              Padding(
                // Circle sits a little below the title's centre line.
                padding: EdgeInsets.only(top: 4.3.h),
                child: GestureDetector(
                  onTap: onInfo,
                  child: Icon(
                    Icons.info_outline,
                    size: 21.r,
                    color: kProfileLabelGrey,
                  ),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.involveFamily,
    required this.chatFor,
    required this.marryWithin,
  });

  final String involveFamily;
  final String chatFor;
  final String marryWithin;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextFontStyle.headline12w400textMutedStyleSatoshi
        .copyWith(color: _stopLabelColor)
        .lh(16, tracking: 0);
    // Geometry from the mockup's 310-wide card interior, scaled to the
    // actual width. Stops: Family / Chatting / Marriage.
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = constraints.maxWidth / 310;
        double x(double designX) => designX * s;

        // Pill / label centred on [centre] (design x).
        Widget centred(double centre, double top, Widget child) => Positioned(
          left: x(centre) - 70.w,
          width: 140.w,
          top: top.h,
          child: Center(child: child),
        );

        Widget tick(double centre) => Positioned(
          left: x(centre) - 1.w,
          top: 39.h,
          child: Container(
            width: 2.w,
            height: 9.h,
            decoration: BoxDecoration(
              color: _lineColor,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        );

        return SizedBox(
          height: 72.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: x(15),
                right: x(0.5),
                top: 35.h,
                height: 4.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _lineColor,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
              tick(88.5),
              tick(176.5),
              tick(275.5),
              // Icons.favorite's heart fills 20/24 of its box, offset 2
              // from the left and 3 from the top.
              Positioned(
                left: x(1.2),
                top: 23.8.h,
                child: Icon(
                  Icons.favorite,
                  size: 27.3.r,
                  color: const Color(0xFFFD4F50),
                ),
              ),
              centred(
                88.5,
                0,
                _StopPill(
                  icon: Icon(
                    Icons.people_outline,
                    size: 12.r,
                    color: Colors.white,
                  ),
                  label: 'Family',
                ),
              ),
              centred(
                177,
                0,
                _StopPill(
                  icon: Icon(
                    Icons.forum_outlined,
                    size: 12.r,
                    color: Colors.white,
                  ),
                  label: 'Chatting',
                ),
              ),
              Positioned(
                right: x(0.5),
                top: 0,
                child: _StopPill(
                  icon: RingIcon(width: 9.5.r, color: Colors.white),
                  label: 'Marriage',
                ),
              ),
              Positioned(
                left: 0,
                top: 56.h,
                child: Text(
                  'Match!',
                  style: labelStyle.copyWith(color: _matchColor),
                ),
              ),
              centred(88.85, 56, Text(involveFamily, style: labelStyle)),
              centred(177, 56, Text(chatFor, style: labelStyle)),
              centred(271, 56, Text(marryWithin, style: labelStyle)),
            ],
          ),
        );
      },
    );
  }
}

class _StopPill extends StatelessWidget {
  const _StopPill({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.only(left: 11.w, right: 11.w),
      decoration: const ShapeDecoration(
        color: kProfileNavy,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 5.5.w),
          Text(
            label,
            // Mockup: medium 10 (cap height 7.25).
            style: TextFontStyle.headline12w500textWhiteStyleSatoshi
                .copyWith(fontSize: 10.sp)
                .lh(14, tracking: 0),
            // style: TextFontStyle.headline12w500textWhiteStyleSatoshi.lh(16),
          ),
        ],
      ),
    );
  }
}
