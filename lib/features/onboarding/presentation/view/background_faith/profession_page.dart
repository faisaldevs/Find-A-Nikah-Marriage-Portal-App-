import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class ProfessionPage extends StatefulWidget {
  const ProfessionPage({super.key});

  @override
  State<ProfessionPage> createState() => _ProfessionPageState();
}

class _ProfessionPageState extends State<ProfessionPage> {
  String? _value;
  final _other = TextEditingController();
  var _otherSelected = false;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.profession;
    // A saved profession that isn't in the list was typed under "Other".
    if (_value != null && !professionOptions.contains(_value)) {
      _otherSelected = true;
      _other.text = _value!;
    }
    _other.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  /// What gets saved: the typed text under "Other", else the picked item.
  String? get _answer {
    if (!_otherSelected) return _value;
    final t = _other.text.trim();
    return t.isEmpty ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      onContinue: _answer == null
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved((d) => d.copyWith(profession: _answer)),
              );
              context.push<void>(RoutePaths.maritalStatus).ignore();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(text: "What's your profession?"),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchableSelectList(
                hintText: 'Search jobs',
                radioFirst: true,
                selected: _otherSelected || _value == null ? {} : {_value!},
                onToggle: (v) => setState(() {
                  _value = v;
                  _otherSelected = false;
                }),
                otherController: _other,
                otherSelected: _otherSelected,
                onOtherTap: () => setState(() => _otherSelected = true),
                items: professionOptions
                    .map((p) => SelectListItem(value: p, label: p))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
