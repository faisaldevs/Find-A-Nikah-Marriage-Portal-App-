import 'package:flutter/material.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
// import '../data/countries.dart'; // moved to core/constants (shared with features/auth)
import '../../../../../../core/constants/countries.dart';
import '../../../../state/onboarding_controller.dart';
// import '../widgets/searchable_select_list.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/searchable_select_list.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class EthnicityScreen extends ConsumerStatefulWidget {
  const EthnicityScreen({super.key});

  @override
  ConsumerState<EthnicityScreen> createState() => _EthnicityScreenState();
}

class _EthnicityScreenState extends ConsumerState<EthnicityScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(onboardingControllerProvider).ethnicities.toSet();
  }

  void _toggle(String code) {
    setState(() {
      if (!_selected.remove(code)) _selected.add(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Ethnicity',  // now from OnboardingRoutes.wizardSections
      // step: 6,
      // totalSteps: _totalSteps,
      continueLabel: _selected.isEmpty
          ? 'Continue'
          : 'Confirm (${_selected.length})',
      onContinue: _selected.isEmpty
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(ethnicities: _selected.toList()));
              ref.read(appNavigatorProvider).toHeight();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: "What's your ethnicity?",
            subtitle:
                'Tell us about your ethnic and cultural background to continue.',
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchableSelectList(
                hintText: 'Search for ethnicities',
                multiSelect: true,
                selected: _selected,
                onToggle: _toggle,
                items: allCountries
                    .map(
                      (c) => SelectListItem(
                        value: c.code,
                        label: c.name,
                        leading: Text(c.flag, style: TextFontStyle.flagEmoji22),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
