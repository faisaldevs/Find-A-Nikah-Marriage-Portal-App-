import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Grey 42pt pill with a magnifier (Figma "profile post and comment
/// search"); used by the feed's search mode and profile search.
class FeedSearchField extends StatelessWidget {
  const FeedSearchField({
    required this.controller,
    required this.hint,
    this.autofocus = false,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final style = feedText(15, 20);
    return Container(
      height: 42.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: kFeedGrey100,
        borderRadius: BorderRadius.circular(21.w),
      ),
      child: Row(
        children: [
          FeedIcon(Assets.icons.feedSearch, size: 18, color: kFeedGrey500),
          SizedBox(width: 11.w),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              style: style,
              cursorColor: AppColors.primaryColor,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: style.copyWith(color: kFeedGrey500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
