import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Pink 48pt "Compose post" button floating over the feed.
class FeedComposeButton extends StatelessWidget {
  const FeedComposeButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'New post',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48.w,
          height: 48.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 18,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SvgPicture.asset(
            Assets.icons.feedPlus,
            width: 24.w,
            height: 24.w,
          ),
        ),
      ),
    );
  }
}
