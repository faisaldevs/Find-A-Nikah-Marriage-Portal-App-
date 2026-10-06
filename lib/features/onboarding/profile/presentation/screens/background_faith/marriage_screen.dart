import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../data/wizard_options.dart';
import '../../../../state/onboarding_controller.dart';
import '../../widgets/wizard_chip_group.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class MarriageScreen extends ConsumerStatefulWidget {
  const MarriageScreen({super.key});

  @override
  ConsumerState<MarriageScreen> createState() => _MarriageScreenState();
}

class _MarriageScreenState extends ConsumerState<MarriageScreen> {
  String? _knowSomeone;
  String? _marriedWithin;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingControllerProvider);
    _knowSomeone = data.knowSomeoneDuration;
    _marriedWithin = data.marriedWithinDuration;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _knowSomeone != null && _marriedWithin != null;
    return WizardScaffold(
      // title: 'Marital Status',  // now from OnboardingRoutes.wizardSections
      // step: 11,
      // totalSteps: _totalSteps,
      onContinue: !canContinue
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch(
                    (d) => d.copyWith(
                      knowSomeoneDuration: _knowSomeone,
                      marriedWithinDuration: _marriedWithin,
                    ),
                  );
              ref.read(appNavigatorProvider).toFaith();
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
