import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/crown_icon.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Cream band under the main photo of a premium profile: "Curious about
/// X's filters?" + gold "Check if you match their filters" button.
class FiltersTeaser extends StatelessWidget {
  const FiltersTeaser({required this.name, required this.onCheck, super.key});

  final String name;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kProfileCream,
      child: Padding(
        padding: EdgeInsets.fromLTRB(kProfileGutter, 20.h, 20.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE3D3B0)),
                  ),
                  child: CrownIcon(width: 22.r, color: kProfileGold),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Curious about $name’s filters?',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextFontStyle.headline16w500textDarkStyleSatoshi
                        .copyWith(color: kProfileGold)
                        .lh(22),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 45.h,
              child: FilledButton(
                onPressed: onCheck,
                style: FilledButton.styleFrom(
                  backgroundColor: kProfileGold,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Check if you match their filters',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextFontStyle.headline16w500textWhiteStyleSatoshi
                            .lh(22),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, size: 22.r, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
