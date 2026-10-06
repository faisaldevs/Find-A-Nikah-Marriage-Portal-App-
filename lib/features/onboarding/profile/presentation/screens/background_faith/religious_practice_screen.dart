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

class ReligiousPracticeScreen extends ConsumerStatefulWidget {
  const ReligiousPracticeScreen({super.key});

  @override
  ConsumerState<ReligiousPracticeScreen> createState() =>
      _ReligiousPracticeScreenState();
}

class _ReligiousPracticeScreenState
    extends ConsumerState<ReligiousPracticeScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).religionPracticeLevel;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Religious practice',  // now from OnboardingRoutes.wizardSections
      // step: 13,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(religionPracticeLevel: _value));
              ref.read(appNavigatorProvider).toLifestylePreferences();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: 'How do you practise\nyour religion?'),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: religionPracticeOptions,
                value: _value,
                divider: true,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
