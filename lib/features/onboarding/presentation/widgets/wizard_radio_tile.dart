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
    // return ListView(
    // children: options
    // .map(
    // (o) => WizardRadioTile(
    // title: o.title,
    // subtitle: o.subtitle,
    // selected: value == o.value,
    // onTap: () => onChanged(o.value),
    // divider: divider,
    // ),
    // )
    // .toList(),
    // );
    // Figma: rows 14pt apart, or a dashed rule with 20pt either side when
    // [divider] — none after the last option.
    return ListView(
      children: [
        for (final (i, o) in options.indexed) ...[
          if (i > 0)
            divider
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const WizardDashedDivider(),
                  )
                : SizedBox(height: 14.h),
          WizardRadioTile(
            title: o.title,
            subtitle: o.subtitle,
            selected: value == o.value,
            onTap: () => onChanged(o.value),
          ),
        ],
      ],
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
    // return InkWell(
    // onTap: onTap,
    // child: Padding(
    // padding: EdgeInsets.symmetric(vertical: dense ? 6.h : 14.h),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Row(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // _RadioCircle(selected: selected),
    // SizedBox(width: 12.w),
    // Expanded(
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Text(
    // title,
    // // Figma: Satoshi 16 / Bold 700 / line height 20px.
    // // Titles without a description stay Medium 500.
    // style: (selected ? _titleSelected : _title).copyWith(
    // fontWeight: subtitle != null
    // ? FontWeight.w700
    // : FontWeight.w500,
    // height: 20 / 16,
    // ),
    // ),
    // if (subtitle != null) ...[
    // SizedBox(height: 4.h),
    // Text(
    // subtitle!,
    // // Figma: Satoshi 14 / Regular 400 / line height 16px.
    // // Design color is Neutral 20 #383C42 — kept on
    // // textMuted until tokens are updated.
    // style: TextFontStyle
    // .headline14w400textMutedStyleSatoshi
    // .copyWith(height: 16 / 14),
    // // style: TextFontStyle
    // //     .headline13w400textMutedStyleSatoshi
    // //     .copyWith(height: 1.35),
    // ),
    // ],
    // ],
    // ),
    // ),
    // ],
    // ),
    // if (divider) ...[
    // SizedBox(height: 14.h),
    // Container(height: 1, color: Colors.grey.shade200),
    // ],
    // ],
    // ),
    // ),
    // );
    // Figma (883:3972): 8pt vertical padding, 24pt radio, 16pt gap, Bold 16
    // title (#131416, pink when selected), Regular 14 #383C42 description.
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dense ? 6.h : 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: subtitle != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                _RadioCircle(selected: selected),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        // Dense (Yes/No) rows: Medium 15; others Bold 16.
                        style: figmaText(
                          dense ? 15 : 16,
                          20,
                          weight: dense ? FontWeight.w500 : FontWeight.w700,
                          color: selected
                              ? AppColors.primaryColor
                              : const Color(0xFF131416),
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          style: figmaText(
                            14,
                            16,
                            color: const Color(0xFF383C42),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (divider) ...[
              SizedBox(height: 20.h),
              const WizardDashedDivider(),
              SizedBox(height: 12.h),
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
    // return Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Text(label, style: TextFontStyle.headline15w600textDarkStyleSatoshi),
    // SizedBox(height: 4.h),
    // WizardRadioTile(
    // title: 'Yes',
    // selected: value == true,
    // onTap: () => onChanged(true),
    // dense: true,
    // ),
    // WizardRadioTile(
    // title: 'No',
    // selected: value == false,
    // onTap: () => onChanged(false),
    // dense: true,
    // ),
    // if (trailingDivider) ...[
    // SizedBox(height: 10.h),
    // Container(height: 1, color: Colors.grey.shade200),
    // SizedBox(height: 14.h),
    // ],
    // ],
    // );
    // Figma 883:4596: Bold 16 question, 16pt to Medium 15 Yes/No rows (6pt
    // padding, 4pt apart); groups split by 24pt + an edge-to-edge dashed
    // rule + 24pt.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: figmaText(
            16,
            20,
            weight: FontWeight.w700,
            color: const Color(0xFF131416),
          ),
        ),
        SizedBox(height: 16.h),
        WizardRadioTile(
          title: 'Yes',
          selected: value == true,
          onTap: () => onChanged(true),
          dense: true,
        ),
        SizedBox(height: 4.h),
        WizardRadioTile(
          title: 'No',
          selected: value == false,
          onTap: () => onChanged(false),
          dense: true,
        ),
        if (trailingDivider) ...[
          SizedBox(height: 24.h),
          // Bleeds past the page's 20pt side padding like Figma's rule.
          SizedBox(
            height: 1,
            child: OverflowBox(
              maxWidth: 1.sw,
              child: const WizardDashedDivider(),
            ),
          ),
          SizedBox(height: 24.h),
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
    // return Container(
    // width: 22.r,
    // height: 22.r,
    // margin: EdgeInsets.only(top: 2.h),
    // decoration: BoxDecoration(
    // shape: BoxShape.circle,
    // border: Border.all(
    // color: selected ? AppColors.primaryColor : AppColors.textMuted,
    // width: 2,
    // ),
    // ),
    // child: selected
    // ? Center(
    // child: Container(
    // width: 11.r,
    // height: 11.r,
    // decoration: const BoxDecoration(
    // shape: BoxShape.circle,
    // color: AppColors.primaryColor,
    // ),
    // ),
    // )
    // : null,
    // );
    // Figma radio: 24pt, 1.5pt ring (#131416 off, pink on) + 12pt dot.
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryColor : const Color(0xFF131416),
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 12.r,
                height: 12.r,
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

// TextStyle get _title => TextFontStyle.headline16w700textDarkStyleSatoshi;
//
// TextStyle get _titleSelected =>
//     TextFontStyle.headline16w700primaryColorStyleSatoshi;

/// Figma's dashed #D4D4D4 rule between wizard options.
class WizardDashedDivider extends StatelessWidget {
  const WizardDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _DashPainter()),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4D4D4)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 4) {
      canvas.drawLine(Offset(x, 0.5), Offset(x + 2, 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => false;
}
