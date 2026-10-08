import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Segmented progress indicator shared by every wizard screen. Each segment
/// is one section of the flow; segments before [activeSegment] are full and
/// the active one fills gradually across [step]/[totalSteps].
class WizardProgressBar extends StatelessWidget {
  const WizardProgressBar({
    required this.step,
    required this.totalSteps,
    super.key,
    this.activeSegment = 0,
    this.segmentCount = 4,
  });

  /// 1-based index of the current screen within its section.
  final int step;
  final int totalSteps;
  final int activeSegment;

  /// Number of sections in the flow (Profile and Verification use 3).
  final int segmentCount;

  @override
  Widget build(BuildContext context) {
    final fraction = (step / totalSteps).clamp(0.0, 1.0);
    // Overall position across all segments (e.g. 1.5 = segment 1 full,
    // segment 2 half). Animating this one number lets the fill grow
    // smoothly even when it crosses into the next segment. `Tween(end:)`
    // with no `begin` means no animation on first build — only on change,
    // which is what the persistent WizardShell header relies on.
    final target = activeSegment + fraction;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: target),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Row(
        children: List.generate(segmentCount, (i) {
          final fill = (value - i).clamp(0.0, 1.0);
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == segmentCount - 1 ? 0 : 8.w),
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: fill == 0
                  ? null
                  : FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: fill,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  // Previous static build — no animation, so the bar jumped between steps.
  // Widget _staticBuild(BuildContext context) {
  //   final fraction = (step / totalSteps).clamp(0.0, 1.0);
  //   return Row(
  //     children: List.generate(4, (i) {
  //       return Expanded(
  //         child: Container(
  //           margin: EdgeInsets.only(right: i == 3 ? 0 : 8.w),
  //           height: 8.h,
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade300,
  //             borderRadius: BorderRadius.circular(8.r),
  //           ),
  //           child: i == activeSegment
  //               ? FractionallySizedBox(
  //                   alignment: Alignment.centerLeft,
  //                   widthFactor: fraction,
  //                   child: DecoratedBox(
  //                     decoration: BoxDecoration(
  //                       color: AppColors.primaryColor,
  //                       borderRadius: BorderRadius.circular(8.r),
  //                     ),
  //                   ),
  //                 )
  //               : (i < activeSegment
  //                     ? DecoratedBox(
  //                         decoration: BoxDecoration(
  //                           color: AppColors.primaryColor,
  //                           borderRadius: BorderRadius.circular(8.r),
  //                         ),
  //                       )
  //                     : null),
  //         ),
  //       );
  //     }),
  //   );
  // }
}
