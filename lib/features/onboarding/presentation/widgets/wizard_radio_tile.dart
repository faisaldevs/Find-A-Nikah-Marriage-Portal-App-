import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Scrollable list of [WizardRadioTile]s built from [WizardOption]s — the
/// body of every plain single-choice wizard screen (marital status,
/// education, religious practice, ...).
class WizardRadioGroup extends StatelessWidget {
  const WizardRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.divider = false,
  });

  final List<WizardOption> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: options
          .map(
            (o) => WizardRadioTile(
              title: o.title,
              subtitle: o.subtitle,
              selected: value == o.value,
              onTap: () => onChanged(o.value),
              divider: divider,
            ),
          )
          .toList(),
    );
  }
}

/// Single-select radio row: title (+ optional description), a trailing/
/// leading circle indicator. Used for every plain single-choice question
/// in the wizard (marital status, education, religious practice, ...).
class WizardRadioTile extends StatelessWidget {
  const WizardRadioTile({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.divider = false,
    this.dense = false,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool divider;

  /// Tighter vertical padding — used for the Yes/No question pairs on the
  /// lifestyle-preferences and about-you screens.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dense ? 6.h : 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadioCircle(selected: selected),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        // Figma: Satoshi 16 / Bold 700 / line height 20px.
                        // Titles without a description stay Medium 500.
                        style: (selected ? _titleSelected : _title).copyWith(
                          fontWeight: subtitle != null
                              ? FontWeight.w700
                              : FontWeight.w500,
                          height: 20 / 16,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          // Figma: Satoshi 14 / Regular 400 / line height 16px.
                          // Design color is Neutral 20 #383C42 — kept on
                          // textMuted until tokens are updated.
                          style: TextFontStyle
                              .headline14w400textMutedStyleSatoshi
                              .copyWith(height: 16 / 14),
                          // style: TextFontStyle
                          //     .headline13w400textMutedStyleSatoshi
                          //     .copyWith(height: 1.35),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (divider) ...[
              SizedBox(height: 14.h),
              Container(height: 1, color: Colors.grey.shade200),
            ],
          ],
        ),
      ),
    );
  }
}

/// One "question label + Yes/No radio pair" block — the repeating unit on
/// the lifestyle-preferences and about-you screens.
class YesNoQuestion extends StatelessWidget {
  const YesNoQuestion({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.trailingDivider = true,
  });

  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final bool trailingDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextFontStyle.headline15w600textDarkStyleSatoshi),
        SizedBox(height: 4.h),
        WizardRadioTile(
          title: 'Yes',
          selected: value == true,
          onTap: () => onChanged(true),
          dense: true,
        ),
        WizardRadioTile(
          title: 'No',
          selected: value == false,
          onTap: () => onChanged(false),
          dense: true,
        ),
        if (trailingDivider) ...[
          SizedBox(height: 10.h),
          Container(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryColor : AppColors.textMuted,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 11.r,
                height: 11.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : null,
    );
  }
}

TextStyle get _title => TextFontStyle.headline16w700textDarkStyleSatoshi;

TextStyle get _titleSelected =>
    TextFontStyle.headline16w700primaryColorStyleSatoshi;
