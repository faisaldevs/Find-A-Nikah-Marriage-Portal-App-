import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/presentation.dart'
    show HowHeardPage;
import 'package:find_a_nikah/features/onboarding/presentation/view/basics/how_heard_page.dart'
    show HowHeardPage;
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// "What brings you to Find A Nikah?" — first of two screens sharing the
/// "About Find A Nikah" title (see [HowHeardPage] for the second).
class IntentionsPage extends StatefulWidget {
  const IntentionsPage({super.key});

  @override
  State<IntentionsPage> createState() => _IntentionsPageState();
}

class _IntentionsPageState extends State<IntentionsPage> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.lookingForIntent;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      onContinue: _value == null
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(lookingForIntent: _value),
                ),
              );
              context.push<void>(RoutePaths.howHeard).ignore();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: 'What brings you to\n',
            highlight: 'Find A Nikah?',
          ),
          // SizedBox(height: 8.h),
          SizedBox(height: 50.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: lookingForIntentOptions,
                value: _value,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            // child: Text(
            //   'This will never be shown on your profile',
            //   textAlign: TextAlign.center,
            //   style: TextFontStyle.headline12w400textMutedStyleSatoshi,
            // ),
            // Figma: centred Regular 15 Grey-500, 20pt above Continue.
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'This will never be shown on your profile',
                textAlign: TextAlign.center,
                style: figmaText(15, 21, color: const Color(0xFF737373)),
              ),
            ),
          ),
          // SizedBox(height: 12.h),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
