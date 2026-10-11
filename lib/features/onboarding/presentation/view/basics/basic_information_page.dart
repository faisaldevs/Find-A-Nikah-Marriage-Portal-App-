import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_chip_group.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Subject/partner pronouns for the family-flow copy, keyed by
/// `RelationshipPage`'s relationship value. Individual flow (no
/// relationship set) uses its own copy entirely, not this map.
const _pronouns = {
  'son': ('him', 'her'),
  'brother': ('him', 'her'),
  'daughter': ('her', 'him'),
  'sister': ('her', 'him'),
  'other_family_member': ('them', 'them'),
};

/// Both flows: "Tell us about yourself" (individual) or "Tell us about
/// him/her/them" (family, copy driven by the relationship chosen on
/// `RelationshipPage`). Fills the gaps the step-4 API needs that had no
/// screen before: full name, date of birth, gender, religion (plus
/// language, captured locally only for now).
class BasicInformationPage extends StatefulWidget {
  const BasicInformationPage({super.key});

  @override
  State<BasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage> {
  late final TextEditingController _nameController;
  int? _day;
  int? _month;
  int? _year;
  String? _gender;
  String? _religion;
  late Set<String> _languages;

  @override
  void initState() {
    super.initState();
    final draft = context.read<OnboardingBloc>().state.draft;
    _nameController = TextEditingController(text: draft.fullName ?? '');
    final dob = draft.dateOfBirth;
    _day = dob?.day;
    _month = dob?.month;
    _year = dob?.year;
    _gender = draft.gender;
    _religion = draft.religion;
    _languages = draft.languages.toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  DateTime? get _dateOfBirth {
    final day = _day;
    final month = _month;
    final year = _year;
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  int? get _age {
    final dob = _dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

  bool get _canContinue =>
      _nameController.text.trim().isNotEmpty &&
      _dateOfBirth != null &&
      (_age ?? 0) >= OnboardingData.minAge &&
      _gender != null &&
      _religion != null;

  @override
  Widget build(BuildContext context) {
    final relationship = context
        .read<OnboardingBloc>()
        .state
        .draft
        .relationship;
    final pronouns = _pronouns[relationship];

    return WizardScaffold(
      onContinue: _canContinue
          ? () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(
                    fullName: _nameController.text.trim(),
                    dateOfBirth: _dateOfBirth,
                    gender: _gender,
                    religion: _religion,
                    languages: _languages.toList(),
                  ),
                ),
              );
              context.push<void>(RoutePaths.intentions).ignore();
            }
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WizardHeadline(
              text: pronouns == null
                  ? 'Tell us about yourself'
                  : 'Tell us about ${pronouns.$1}',
              subtitle: pronouns == null
                  ? 'Tell us about yourself so we can help you find '
                        'meaningful, compatible matches nearby.'
                  : 'Tell us about ${pronouns.$1} so we can connect '
                        '${pronouns.$2} with compatible, verified matches.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 24.h),
            const _FieldLabel('Name'),
            SizedBox(height: 8.h),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              style: TextFontStyle.headline15w400textDarkStyleSatoshi,
              decoration: _fieldDecoration(hint: 'Full name'),
            ),
            SizedBox(height: 20.h),
            const _FieldLabel('Birth Date'),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _NumberDropdown(
                    hint: 'Date',
                    value: _day,
                    items: [for (var d = 1; d <= 31; d++) d],
                    onChanged: (v) => setState(() => _day = v),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _NumberDropdown(
                    hint: 'Month',
                    value: _month,
                    items: [for (var m = 1; m <= 12; m++) m],
                    labelBuilder: _monthName,
                    onChanged: (v) => setState(() => _month = v),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _NumberDropdown(
                    hint: 'Year',
                    value: _year,
                    items: [
                      for (
                        var y = DateTime.now().year - OnboardingData.minAge;
                        y >= DateTime.now().year - 100;
                        y--
                      )
                        y,
                    ],
                    onChanged: (v) => setState(() => _year = v),
                  ),
                ),
              ],
            ),
            if (_dateOfBirth != null) ...[
              SizedBox(height: 8.h),
              Text(
                (_age ?? 0) >= OnboardingData.minAge
                    ? 'You are $_age years old and eligible to begin '
                          'your journey'
                    : 'You must be at least ${OnboardingData.minAge} to '
                          'continue',
                style: (_age ?? 0) >= OnboardingData.minAge
                    ? TextFontStyle.headline13w400textMutedStyleSatoshi
                    : TextFontStyle.headline13w400errorColorStyleSatoshi,
              ),
            ],
            SizedBox(height: 20.h),
            const _FieldLabel('Gender'),
            SizedBox(height: 12.h),
            _GenderToggle(
              value: _gender,
              onChanged: (v) => setState(() => _gender = v),
            ),
            SizedBox(height: 20.h),
            const _FieldLabel('Religion'),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              initialValue: _religion,
              items: [
                for (final o in religionOptions)
                  DropdownMenuItem(value: o.value, child: Text(o.title)),
              ],
              onChanged: (v) => setState(() => _religion = v),
              style: TextFontStyle.headline15w400textDarkStyleSatoshi,
              decoration: _fieldDecoration(hint: 'Select religion'),
            ),
            SizedBox(height: 20.h),
            const _FieldLabel('Language'),
            SizedBox(height: 12.h),
            WizardChipGroup(
              options: languageOptions,
              selected: _languages,
              onTap: (v) => setState(() {
                if (!_languages.remove(v)) _languages.add(v);
              }),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  static String _monthName(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}

InputDecoration _fieldDecoration({required String hint}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: TextFontStyle.headline15w400textMutedStyleSatoshi,
    filled: true,
    fillColor: const Color(0xFFF7F7F8),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextFontStyle.headline15w600textDarkStyleSatoshi);
  }
}

class _NumberDropdown extends StatelessWidget {
  const _NumberDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelBuilder,
  });

  final String hint;
  final int? value;
  final List<int> items;
  final String Function(int)? labelBuilder;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      isExpanded: true,
      items: [
        for (final i in items)
          DropdownMenuItem(
            value: i,
            child: Text(labelBuilder?.call(i) ?? '$i'),
          ),
      ],
      onChanged: onChanged,
      style: TextFontStyle.headline15w400textDarkStyleSatoshi,
      decoration: _fieldDecoration(hint: hint),
    );
  }
}

/// Male/female toggle — the mockup's illustrated avatars are replaced with
/// plain icon circles (no new asset files); visual reference only, per the
/// "mockup is UI guideline, can change" instruction.
class _GenderToggle extends StatelessWidget {
  const _GenderToggle({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GenderOption(
          icon: Icons.male,
          label: 'Male',
          selected: value == 'male',
          onTap: () => onChanged('male'),
        ),
        SizedBox(width: 24.w),
        _GenderOption(
          icon: Icons.female,
          label: 'Female',
          selected: value == 'female',
          onTap: () => onChanged('female'),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              border: Border.all(
                color: selected ? AppColors.primaryColor : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
            ),
            child: Icon(
              icon,
              size: 28.r,
              color: selected ? AppColors.primaryColor : AppColors.textMuted,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: selected
                ? TextFontStyle.headline13w600primaryColorStyleSatoshi
                : TextFontStyle.headline13w400textMutedStyleSatoshi,
          ),
        ],
      ),
    );
  }
}
