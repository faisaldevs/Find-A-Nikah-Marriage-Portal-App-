import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Remove location filter?" bottom sheet shown when the user switches
/// Distance ⇄ Country while the other filter is active. Resolves `true` on
/// Discard, `false`/null on Cancel or dismiss.
Future<bool> showRemoveFilterSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.white,
    barrierColor: Colors.black54,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (_) => const _RemoveFilterSheet(),
  );
  return result ?? false;
}

class _RemoveFilterSheet extends StatelessWidget {
  const _RemoveFilterSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.infoColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Remove location filter?',
              style: TextFontStyle.headline22w700textDarkStyleSatoshi,
            ),
            SizedBox(height: 16.h),
            Text(
              'Members can only apply one location filter at a time.\n\n'
              'If you switch to a different location filter now, your '
              'current one will be removed.',
              textAlign: TextAlign.center,
              style: TextFontStyle.headline15w400textDarkStyleSatoshi.copyWith(
                height: 1.45,
              ),
            ),
            SizedBox(height: 28.h),
            AppPrimaryButton(
              label: 'Discard',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            SizedBox(height: 4.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextFontStyle.headline16w500textDarkStyleSatoshi,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
