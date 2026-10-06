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

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).educationLevel;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Education',  // now from OnboardingRoutes.wizardSections
      // step: 8,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(educationLevel: _value));
              ref.read(appNavigatorProvider).toProfession();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: "What's your education level?"),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: educationOptions,
                value: _value,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
