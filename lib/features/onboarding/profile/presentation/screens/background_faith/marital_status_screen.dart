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

class MaritalStatusScreen extends ConsumerStatefulWidget {
  const MaritalStatusScreen({super.key});

  @override
  ConsumerState<MaritalStatusScreen> createState() =>
      _MaritalStatusScreenState();
}

class _MaritalStatusScreenState extends ConsumerState<MaritalStatusScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).maritalStatus;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Marital Status',  // now from OnboardingRoutes.wizardSections
      // step: 10,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(maritalStatus: _value));
              ref.read(appNavigatorProvider).toMarriage();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: "What's your marital status?"),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: maritalStatusOptions,
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
