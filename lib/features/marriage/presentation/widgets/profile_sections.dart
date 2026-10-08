import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Bold 18 section title ("About me", "My Faith", ...).
class ProfileSectionHeading extends StatelessWidget {
  const ProfileSectionHeading(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextFontStyle.headline18w700StyleSatoshi
          .copyWith(color: kProfileInk)
          .lh(24, tracking: -0.003),
    );
  }
}

/// Heading + content, 40 below whatever precedes it (mockup rhythm: every
/// block — photo, chips, card — is followed by 40 before the next heading).
class ProfileSection extends StatelessWidget {
  const ProfileSection({
    required this.title,
    required this.child,
    super.key,
    this.top = 40,
  });

  final String title;
  final Widget child;

  /// Gap above the heading, in design pixels.
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(kProfileGutter, top.h, kProfileGutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeading(title),
          SizedBox(height: 17.h),
          child,
        ],
      ),
    );
  }
}

/// Chips flowing left to right, or one per row when [stacked].
class ProfileChipList extends StatelessWidget {
  const ProfileChipList({required this.chips, super.key, this.stacked = false});

  final List<ProfileChip> chips;

  /// Mockup's "Future plans": one chip per row even when two would fit.
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) SizedBox(height: 10.h),
            chips[i],
          ],
        ],
      );
    }
    return Wrap(spacing: 10.w, runSpacing: 10.h, children: chips);
  }
}

/// 30-high pill: outlined on the page background, or [filled] grey with no
/// border (the "Similarities" chip).
class ProfileChip extends StatelessWidget {
  const ProfileChip(this.label, {super.key, this.flag, this.filled = false});

  final String label;

  /// Emoji flag shown before the label.
  final String? flag;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      // Border (1) + 15 = the mockup's 16 from edge to text.
      padding: EdgeInsets.symmetric(horizontal: filled ? 16.w : 15.w),
      decoration: ShapeDecoration(
        color: filled ? kProfileChipFill : null,
        shape: StadiumBorder(
          side: filled
              ? BorderSide.none
              : const BorderSide(color: kProfileChipBorder),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (flag != null) ...[
            Text(flag!, style: TextStyle(fontSize: 13.sp, height: 1)),
            SizedBox(width: 8.w),
          ],
          // Flexible + ellipsis: a long label (or a large text scale) must
          // shrink inside the chip, not overflow it.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextFontStyle.headline14w400textDarkStyleSatoshi
                  .copyWith(color: kProfileInk)
                  .lh(20, tracking: -0.003),
            ),
          ),
        ],
      ),
    );
  }
}
