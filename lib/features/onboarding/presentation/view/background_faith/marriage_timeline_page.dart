import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MarriageTimelinePage extends StatefulWidget {
  const MarriageTimelinePage({super.key});

  @override
  State<MarriageTimelinePage> createState() => _MarriageTimelinePageState();
}

class _MarriageTimelinePageState extends State<MarriageTimelinePage> {
  String? _knowSomeone;
  String? _marriedWithin;

  @override
  void initState() {
    super.initState();
    final data = context.read<OnboardingBloc>().state.draft;
    _knowSomeone = data.knowSomeoneDuration;
    _marriedWithin = data.marriedWithinDuration;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _knowSomeone != null && _marriedWithin != null;
    return WizardScaffold(
      onContinue: !canContinue
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(
                    knowSomeoneDuration: _knowSomeone,
                    marriedWithinDuration: _marriedWithin,
                  ),
                ),
              );
              context.push<void>(RoutePaths.faith).ignore();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        // The wizard body gets a loose width; without this the column
        // shrink-wraps and the whole page centres.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const WizardHeadline(
            // text: 'What are your intentions for marriage?',
            // padding: EdgeInsets.zero,
            // ),
            // SizedBox(height: 20.h),
            // Text(
            // "I'd like to know someone on Find A Nikah for:",
            // style: TextFontStyle.headline14w400textDarkStyleSatoshi,
            // ),
            // SizedBox(height: 10.h),
            // WizardChipGroup(
            // options: durationOptions.map((o) => o.title).toList(),
            // selected: _knowSomeone == null
            // ? {}
            // : {_labelFor(durationOptions, _knowSomeone!)},
            // onTap: (label) => setState(
            // () => _knowSomeone = durationOptions
            // .firstWhere((o) => o.title == label)
            // .value,
            // ),
            // ),
            // SizedBox(height: 24.h),
            // Text(
            // "I'd like to be married within:",
            // style: TextFontStyle.headline14w400textDarkStyleSatoshi,
            // ),
            // SizedBox(height: 10.h),
            // WizardChipGroup(
            // options: marriedWithinOptions.map((o) => o.title).toList(),
            // selected: _marriedWithin == null
            // ? {}
            // : {_labelFor(marriedWithinOptions, _marriedWithin!)},
            // onTap: (label) => setState(
            // () => _marriedWithin = marriedWithinOptions
            // .firstWhere((o) => o.title == label)
            // .value,
            // ),
            // ),
            // SizedBox(height: 20.h),
            // Figma 883:5245: Medium 16 prompts 20pt above two-per-row pill
            // chips (chat icon / ring icon), groups 60pt apart. A marriage
            // timeline must sit at least two steps after the get-to-know
            // period (Figma greys out the rest); "Agree together" always
            // fits.
            const WizardHeadline(
              text: 'What are your\nintentions for marriage?',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 26.h),
            Text(
              "I'd like to know someone on Find A Nikah for:",
              style: _prompt,
            ),
            SizedBox(height: 20.h),
            _ChipGrid(
              icon: Assets.icons.chipMessages,
              options: durationOptions,
              value: _knowSomeone,
              // Never blocked (Figma greys these too, but that strands the
              // user); a marriage timeline that no longer fits is cleared.
              isDisabled: (_) => false,
              onTap: (v) => setState(() {
                _knowSomeone = v;
                if (_marriedRank case final married?
                    when !_fits(_knowRank!, married)) {
                  _marriedWithin = null;
                }
              }),
            ),
            SizedBox(height: 60.h),
            Text("I'd like to be married within:", style: _prompt),
            SizedBox(height: 20.h),
            _ChipGrid(
              icon: Assets.icons.chipRing,
              iconWidth: 15.29,
              options: marriedWithinOptions,
              value: _marriedWithin,
              isDisabled: (i) => _knowRank != null && !_fits(_knowRank!, i),
              onTap: (v) => setState(() => _marriedWithin = v),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // String _labelFor(List<WizardOption> options, String value) =>
  //     options.firstWhere((o) => o.value == value).title;

  int? get _knowRank => _knowSomeone == null
      ? null
      : durationOptions.indexWhere((o) => o.value == _knowSomeone);

  int? get _marriedRank => _marriedWithin == null
      ? null
      : marriedWithinOptions.indexWhere((o) => o.value == _marriedWithin);

  /// Whether married-within option [married] works with get-to-know option
  /// [know] (indexes into [marriedWithinOptions] / [durationOptions]).
  static bool _fits(int know, int married) =>
      marriedWithinOptions[married].value == 'agree_together' ||
      married >= know + 2;

  static TextStyle get _prompt => figmaText(
    16,
    20,
    weight: FontWeight.w500,
    color: const Color(0xFF131416),
  );
}

class _ChipGrid extends StatelessWidget {
  const _ChipGrid({
    required this.icon,
    required this.options,
    required this.value,
    required this.isDisabled,
    required this.onTap,
    this.iconWidth = 20,
  });

  final String icon;
  final double iconWidth;
  final List<WizardOption> options;
  final String? value;
  final bool Function(int index) isDisabled;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 286.w,
        child: Wrap(
          spacing: 14.w,
          runSpacing: 14.h,
          children: [
            for (final (i, o) in options.indexed)
              SizedBox(
                width: 136.w,
                child: _TimelineChip(
                  icon: icon,
                  iconWidth: iconWidth,
                  label: o.title,
                  selected: o.value == value,
                  disabled: o.value != value && isDisabled(i),
                  onTap: () => onTap(o.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Figma 414:1675: 30pt-radius pill, 16×7 padding, 20pt icon + 10pt gap +
/// Medium 14. Default #D4D4D4 border; selected navy fill, white content;
/// disabled #F5F5F5 border, #A3A3A3 content.
class _TimelineChip extends StatelessWidget {
  const _TimelineChip({
    required this.icon,
    required this.iconWidth,
    required this.label,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final String icon;
  final double iconWidth;
  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = selected
        ? Colors.white
        : disabled
        ? const Color(0xFFA3A3A3)
        : const Color(0xFF0A0A0A);
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondaryColor : null,
          borderRadius: BorderRadius.circular(30.r),
          border: selected
              ? null
              : Border.all(
                  color: disabled
                      ? const Color(0xFFF5F5F5)
                      : const Color(0xFFD4D4D4),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 20.r,
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: iconWidth.r,
                  height: 20.r,
                  colorFilter: ColorFilter.mode(ink, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Figma's labels overflow their 135pt cells; scale down instead
            // of truncating.
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: figmaText(
                    14,
                    20,
                    weight: FontWeight.w500,
                    color: ink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
