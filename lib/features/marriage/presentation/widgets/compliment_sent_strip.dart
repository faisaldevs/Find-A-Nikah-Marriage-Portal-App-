import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/presentation/bloc/marriage_feed_bloc.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// The compliment you sent, shown above the profile photo: the text on the
/// left and, on the right, a spinner while it is sending that turns into a
/// double tick once the server has it.
class ComplimentSentStrip extends StatelessWidget {
  const ComplimentSentStrip({required this.compliment, super.key});

  final SentCompliment compliment;

  @override
  Widget build(BuildContext context) {
    final sending = compliment.status == ComplimentStatus.sending;
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kProfileGutter,
          vertical: 16.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                compliment.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextFontStyle.headline14w400textDarkStyleSatoshi
                    .copyWith(color: kProfileBodyGrey, fontSize: 16.sp)
                    .lh(22),
              ),
            ),
            SizedBox(width: 12.w),
            SizedBox.square(
              dimension: 20.r,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: sending
                    ? Padding(
                        key: const ValueKey('sending'),
                        padding: EdgeInsets.all(2.r),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kProfileLabelGrey,
                        ),
                      )
                    : Icon(
                        Icons.done_all,
                        key: const ValueKey('sent'),
                        size: 20.r,
                        color: kProfileLabelGrey,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
