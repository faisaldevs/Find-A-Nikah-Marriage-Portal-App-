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
const _maxSelections = 2;

class NationalityScreen extends ConsumerStatefulWidget {
  const NationalityScreen({super.key});

  @override
  ConsumerState<NationalityScreen> createState() => _NationalityScreenState();
}

class _NationalityScreenState extends ConsumerState<NationalityScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(onboardingControllerProvider).nationalities.toSet();
  }

  void _toggle(String code) {
    setState(() {
      if (_selected.contains(code)) {
        _selected.remove(code);
      } else if (_selected.length < _maxSelections) {
        _selected.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Nationality',  // now from OnboardingRoutes.wizardSections
      // step: 4,
      // totalSteps: _totalSteps,
      continueLabel: _selected.isEmpty
          ? 'Continue'
          : 'Confirm (${_selected.length})',
      onContinue: _selected.isEmpty
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(nationalities: _selected.toList()));
              ref.read(appNavigatorProvider).toCountry();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: "What's your nationality?",
            subtitle:
                'Which countries are you a citizen of? You can select '
                'up to two.',
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchableSelectList(
                hintText: 'Search for nationalities',
                multiSelect: true,
                maxSelections: _maxSelections,
                selected: _selected,
                onToggle: _toggle,
                suggested: suggestedCountries
                    .map(
                      (c) => SelectListItem(
                        value: c.code,
                        label: c.name,
                        leading: Text(c.flag, style: TextFontStyle.flagEmoji22),
                      ),
                    )
                    .toList(),
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
