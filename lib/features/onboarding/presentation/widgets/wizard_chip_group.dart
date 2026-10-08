import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Wrap of pill chips — unselected: white with a grey border; selected:
/// solid navy with white text. Used for faith tags, personality traits,
/// interests, and the two duration pickers on the marriage screen.
/// Selection semantics (toggle vs. replace) are the caller's decision via
/// [onTap] — this widget only renders.
class WizardChipGroup extends StatelessWidget {
  const WizardChipGroup({
    required this.options,
    required this.selected,
    required this.onTap,
    super.key,
    this.disabled = const {},
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;

  /// Options that can't be selected right now (e.g. a max-count reached) —
  /// rendered faded, still tappable-looking is avoided via reduced opacity.
  final Set<String> disabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        final isDisabled = !isSelected && disabled.contains(option);
        return Opacity(
          opacity: isDisabled ? 0.4 : 1,
          child: GestureDetector(
            onTap: isDisabled ? null : () => onTap(option),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryColor : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                option,
                style: isSelected
                    ? TextFontStyle.headline14w500textWhiteStyleSatoshi
                    : TextFontStyle.headline14w500textDarkStyleSatoshi,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
