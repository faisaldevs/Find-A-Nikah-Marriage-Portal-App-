import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class MaritalStatusPage extends StatefulWidget {
  const MaritalStatusPage({super.key});

  @override
  State<MaritalStatusPage> createState() => _MaritalStatusPageState();
}

class _MaritalStatusPageState extends State<MaritalStatusPage> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.maritalStatus;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      onContinue: _value == null
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved((d) => d.copyWith(maritalStatus: _value)),
              );
              context.push<void>(RoutePaths.marriageTimeline).ignore();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: "What's your marital status?"),
          // SizedBox(height: 8.h),
          SizedBox(height: 50.h),
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
