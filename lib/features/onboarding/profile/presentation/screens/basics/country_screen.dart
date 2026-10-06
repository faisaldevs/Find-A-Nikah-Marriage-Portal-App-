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

/// "Where did you grow up?" — single-country pick, unlike [NationalityScreen]
/// which allows up to two.
class CountryScreen extends ConsumerStatefulWidget {
  const CountryScreen({super.key});

  @override
  ConsumerState<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends ConsumerState<CountryScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).grewUpCountry;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Country',  // now from OnboardingRoutes.wizardSections
      // step: 5,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(grewUpCountry: _value));
              ref.read(appNavigatorProvider).toEthnicity();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: 'Where did you grow up?'),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchableSelectList(
                hintText: 'Search countries',
                selected: _value == null ? {} : {_value!},
                onToggle: (v) => setState(() => _value = v),
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
