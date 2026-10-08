// import '../data/countries.dart'; // moved to core/constants (shared with features/auth)
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class EthnicityPage extends StatefulWidget {
  const EthnicityPage({super.key});

  @override
  State<EthnicityPage> createState() => _EthnicityPageState();
}

class _EthnicityPageState extends State<EthnicityPage> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<OnboardingBloc>().state.draft.ethnicities.toSet();
  }

  void _toggle(String code) {
    setState(() {
      if (!_selected.remove(code)) _selected.add(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      continueLabel: _selected.isEmpty
          ? 'Continue'
          : 'Confirm (${_selected.length})',
      onContinue: _selected.isEmpty
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(ethnicities: _selected.toList()),
                ),
              );
              context.push<void>(RoutePaths.height).ignore();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: "What's your ethnicity?",
            subtitle:
                'Tell us about your ethnic and cultural background to '
                'continue.',
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
