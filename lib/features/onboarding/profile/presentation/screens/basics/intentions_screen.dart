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

/// "What brings you to Find A Nikah?" — first of two screens sharing the
/// "About Find A Nikah" title (see [HowHeardScreen] for the second).
class IntentionsScreen extends ConsumerStatefulWidget {
  const IntentionsScreen({super.key});

  @override
  ConsumerState<IntentionsScreen> createState() => _IntentionsScreenState();
}

class _IntentionsScreenState extends ConsumerState<IntentionsScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).lookingForIntent;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'About Find A Nikah',  // now from OnboardingRoutes.wizardSections
      // step: 2,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(lookingForIntent: _value));
              ref.read(appNavigatorProvider).toHowHeard();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: 'What brings you to\n',
            highlight: 'Find A Nikah?',
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: lookingForIntentOptions,
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
