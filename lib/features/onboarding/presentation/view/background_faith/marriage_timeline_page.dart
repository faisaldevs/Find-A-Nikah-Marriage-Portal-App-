import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_chip_group.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'What are your intentions for marriage?',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            Text(
              "I'd like to know someone on Find A Nikah for:",
              style: TextFontStyle.headline14w400textDarkStyleSatoshi,
            ),
            SizedBox(height: 10.h),
            WizardChipGroup(
              options: durationOptions.map((o) => o.title).toList(),
              selected: _knowSomeone == null
                  ? {}
                  : {_labelFor(durationOptions, _knowSomeone!)},
              onTap: (label) => setState(
                () => _knowSomeone = durationOptions
                    .firstWhere((o) => o.title == label)
                    .value,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "I'd like to be married within:",
              style: TextFontStyle.headline14w400textDarkStyleSatoshi,
            ),
            SizedBox(height: 10.h),
            WizardChipGroup(
              options: marriedWithinOptions.map((o) => o.title).toList(),
              selected: _marriedWithin == null
                  ? {}
                  : {_labelFor(marriedWithinOptions, _marriedWithin!)},
              onTap: (label) => setState(
                () => _marriedWithin = marriedWithinOptions
                    .firstWhere((o) => o.title == label)
                    .value,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  String _labelFor(List<WizardOption> options, String value) =>
      options.firstWhere((o) => o.value == value).title;
}
