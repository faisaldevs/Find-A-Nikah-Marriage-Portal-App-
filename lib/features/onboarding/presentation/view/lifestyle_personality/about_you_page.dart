import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class AboutYouPage extends StatefulWidget {
  const AboutYouPage({super.key});

  @override
  State<AboutYouPage> createState() => _AboutYouPageState();
}

class _AboutYouPageState extends State<AboutYouPage> {
  bool? _bornMuslim;
  bool? _hasChildren;
  bool? _wouldRelocate;

  @override
  void initState() {
    super.initState();
    final data = context.read<OnboardingBloc>().state.draft;
    _bornMuslim = data.bornMuslim;
    _hasChildren = data.hasChildren;
    _wouldRelocate = data.wouldRelocate;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue =
        _bornMuslim != null && _hasChildren != null && _wouldRelocate != null;
    return WizardScaffold(
      onContinue: !canContinue
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(
                    bornMuslim: _bornMuslim,
                    hasChildren: _hasChildren,
                    wouldRelocate: _wouldRelocate,
                  ),
                ),
              );
              context.push<void>(RoutePaths.personality).ignore();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'About you',
              subtitle:
                  'Tell us about yourself to help us personalize your matches.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            YesNoQuestion(
              label: 'Were you born a Muslim?',
              value: _bornMuslim,
              onChanged: (v) => setState(() => _bornMuslim = v),
            ),
            YesNoQuestion(
              label: 'Do you have children?',
              value: _hasChildren,
              onChanged: (v) => setState(() => _hasChildren = v),
            ),
            YesNoQuestion(
              label: 'Would you move abroad for marriage?',
              value: _wouldRelocate,
              onChanged: (v) => setState(() => _wouldRelocate = v),
              trailingDivider: false,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
