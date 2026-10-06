import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../../../state/onboarding_controller.dart';
import '../../widgets/wizard_radio_tile.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class LifestylePreferencesScreen extends ConsumerStatefulWidget {
  const LifestylePreferencesScreen({super.key});

  @override
  ConsumerState<LifestylePreferencesScreen> createState() =>
      _LifestylePreferencesScreenState();
}

class _LifestylePreferencesScreenState
    extends ConsumerState<LifestylePreferencesScreen> {
  bool? _halal;
  bool? _smokes;
  bool? _drinks;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingControllerProvider);
    _halal = data.eatsHalalOnly;
    _smokes = data.smokes;
    _drinks = data.drinksAlcohol;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _halal != null && _smokes != null && _drinks != null;
    return WizardScaffold(
      // title: 'Lifestyle preferences',  // now from OnboardingRoutes.wizardSections
      // step: 14,
      // totalSteps: _totalSteps,
      onContinue: !canContinue
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch(
                    (d) => d.copyWith(
                      eatsHalalOnly: _halal,
                      smokes: _smokes,
                      drinksAlcohol: _drinks,
                    ),
                  );
              ref.read(appNavigatorProvider).toAboutYou();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'Lifestyle preferences',
              subtitle:
                  'Tell us about your daily habits to help us personalize your matches.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            YesNoQuestion(
              label: 'Do you only eat Halal food?',
              value: _halal,
              onChanged: (v) => setState(() => _halal = v),
            ),
            YesNoQuestion(
              label: 'Do you smoke?',
              value: _smokes,
              onChanged: (v) => setState(() => _smokes = v),
            ),
            YesNoQuestion(
              label: 'Do you drink alcohol?',
              value: _drinks,
              onChanged: (v) => setState(() => _drinks = v),
              trailingDivider: false,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
