import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../data/wizard_options.dart';
import '../../../../state/onboarding_controller.dart';
import '../../widgets/wizard_radio_tile.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

/// "How did you hear about Find A Nikah?" — second of two screens sharing
/// the "About Find A Nikah" title (see [IntentionsScreen] for the first).
class HowHeardScreen extends ConsumerStatefulWidget {
  const HowHeardScreen({super.key});

  @override
  ConsumerState<HowHeardScreen> createState() => _HowHeardScreenState();
}

class _HowHeardScreenState extends ConsumerState<HowHeardScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).howHeard;
  }

  void _next() => ref.read(appNavigatorProvider).toNationality();

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'About Find A Nikah',  // now from OnboardingRoutes.wizardSections
      // step: 3,
      // totalSteps: _totalSteps,
      showSkip: true,
      onSkip: _next,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(howHeard: _value));
              _next();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: 'How did you hear about\n',
            highlight: 'Find A Nikah?',
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: howHeardOptions,
                value: _value,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'This will never be shown on your profile',
              textAlign: TextAlign.center,
              style: TextFontStyle.headline12w400textMutedStyleSatoshi,
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
