import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/presentation.dart'
    show IntentionsPage;
import 'package:find_a_nikah/features/onboarding/presentation/view/basics/intentions_page.dart'
    show IntentionsPage;
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// "How did you hear about Find A Nikah?" — second of two screens sharing
/// the "About Find A Nikah" title (see [IntentionsPage] for the first).
class HowHeardPage extends StatefulWidget {
  const HowHeardPage({super.key});

  @override
  State<HowHeardPage> createState() => _HowHeardPageState();
}

class _HowHeardPageState extends State<HowHeardPage> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.howHeard;
  }

  void _next() => context.push<void>(RoutePaths.nationality).ignore();

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      showSkip: true,
      onSkip: _next,
      onContinue: _value == null
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved((d) => d.copyWith(howHeard: _value)),
              );
              _next();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: 'How did you hear about\n',
            highlight: 'Find A Nikah?',
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: howHeardOptions,
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
