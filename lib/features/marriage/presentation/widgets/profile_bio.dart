import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Bio text: blank lines become a full empty line, "• " lines become a
/// bulleted list with a hanging indent.
class ProfileBio extends StatelessWidget {
  const ProfileBio(this.bio, {super.key});

  final String bio;

  @override
  Widget build(BuildContext context) {
    final style = TextFontStyle.headline16w400textDarkStyleSatoshi
        .copyWith(color: kProfileInk)
        .lh(22, tracking: 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in bio.split('\n'))
          if (line.trim().isEmpty)
            SizedBox(height: 22.h)
          else if (line.startsWith('• '))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24.w,
                  child: Padding(
                    padding: EdgeInsets.only(left: 9.8.w, top: 10.75.h),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 4.5.r,
                        height: 4.5.r,
                        decoration: const BoxDecoration(
                          color: kProfileInk,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Text(line.substring(2), style: style)),
              ],
            )
          else
            Text(line, style: style),
      ],
    );
  }
}
