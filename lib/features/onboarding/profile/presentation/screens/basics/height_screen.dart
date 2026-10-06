import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../data/wizard_options.dart';
import '../../../../state/onboarding_controller.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class HeightScreen extends ConsumerStatefulWidget {
  const HeightScreen({super.key});

  @override
  ConsumerState<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends ConsumerState<HeightScreen> {
  int? _cm;
  final _options = buildHeightOptions();

  @override
  void initState() {
    super.initState();
    _cm = ref.read(onboardingControllerProvider).heightCm;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Height',  // now from OnboardingRoutes.wizardSections
      // step: 7,
      // totalSteps: _totalSteps,
      onContinue: _cm == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(heightCm: _cm));
              ref.read(appNavigatorProvider).toEducation();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: 'How tall are you?'),
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: _options.length,
              itemBuilder: (context, i) {
                final option = _options[i];
                final selected = option.cm == _cm;
                return InkWell(
                  onTap: () => setState(() => _cm = option.cm),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      children: [
                        Container(
                          width: 22.r,
                          height: 22.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? AppColors.primaryColor
                                  : AppColors.textMuted,
                              width: 2,
                            ),
                          ),
                          child: selected
                              ? Center(
                                  child: Container(
                                    width: 11.r,
                                    height: 11.r,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          option.label,
                          style: selected
                              ? TextFontStyle
                                    .headline15w500primaryColorStyleSatoshi
                              : TextFontStyle
                                    .headline15w500textDarkStyleSatoshi,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
