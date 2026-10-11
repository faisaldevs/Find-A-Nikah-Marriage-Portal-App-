import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.accountType;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      onContinue: _value == null
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved((d) => d.copyWith(accountType: _value)),
              );
              context
                  .push<void>(
                    _value == 'family'
                        ? RoutePaths.relationship
                        : RoutePaths.basicInformation,
                  )
                  .ignore();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: 'How would you like to use ',
            highlight: 'Find A Nikah?',
            subtitle:
                'Tell us about yourself so we can help you find '
                'meaningful, compatible matches nearby.',
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: accountTypeOptions,
                value: _value,
                divider: true,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
