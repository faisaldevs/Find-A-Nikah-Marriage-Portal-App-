import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../data/wizard_options.dart';
import '../../../../state/onboarding_controller.dart';
// import '../widgets/searchable_select_list.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/searchable_select_list.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class ProfessionScreen extends ConsumerStatefulWidget {
  const ProfessionScreen({super.key});

  @override
  ConsumerState<ProfessionScreen> createState() => _ProfessionScreenState();
}

class _ProfessionScreenState extends ConsumerState<ProfessionScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).profession;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Profession',  // now from OnboardingRoutes.wizardSections
      // step: 9,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(profession: _value));
              ref.read(appNavigatorProvider).toMaritalStatus();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: "What's your profession?"),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchableSelectList(
                hintText: 'Search jobs',
                selected: _value == null ? {} : {_value!},
                onToggle: (v) => setState(() => _value = v),
                items: professionOptions
                    .map((p) => SelectListItem(value: p, label: p))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
