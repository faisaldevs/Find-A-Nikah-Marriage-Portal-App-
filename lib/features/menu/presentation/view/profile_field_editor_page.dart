// Yes/No editors take a `bool` answer callback, like MenuFormat's
// single-value formatters.
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:math' as math;

// import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/bloc/field_editor_bloc.dart';
import 'package:find_a_nikah/features/menu/presentation/editing/profile_options.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/editor_widgets.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_format.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Every Edit profile row that opens a field page.
enum ProfileField {
  name('Name'),
  birthDate('Birth date'),
  gender('Gender'),
  religion('Religion'),
  languages('Languages'),
  grewUpIn('Grew up in'),
  height('Height'),
  maritalStatus('Marital status'),
  children('Children'),
  bio('Bio'),
  marriageIntentions('Marriage intentions'),
  relocation('Relocation plans'),
  bornMuslim('Born Muslim'),
  religiousPractice('Religious practice'),
  faith('Faith'),
  diet('Diet'),
  alcohol('Alcohol'),
  smoking('Smoking'),
  interests('Interests'),
  personality('Personality'),
  education('Education'),
  profession('Profession'),
  ethnicity('Ethnicity'),
  nationality('Nationality');

  const ProfileField(this.title);

  /// Page title.
  final String title;
}

/// What the field page route needs (passed as go_router `extra`).
class ProfileFieldEditorArgs {
  const ProfileFieldEditorArgs({required this.field, required this.profile});

  final ProfileField field;

  /// The profile as Edit profile shows it: the editor's starting value, and
  /// the rest of a group that has to be sent whole.
  final MyProfile profile;
}

/// One field of the member's profile on its own page (Muzz-style): the
/// current value pre-selected, "Update" enabled once it changes. Pops at
/// once with the [ProfilePatch]; Edit profile shows and saves it.
class ProfileFieldEditorPage extends StatelessWidget {
  const ProfileFieldEditorPage({required this.args, super.key});

  final ProfileFieldEditorArgs args;

  @override
  Widget build(BuildContext context) {
    final p = args.profile;
    final title = args.field.title;
    return switch (args.field) {
      ProfileField.name => _FieldEditor<String>(
        title: title,
        initial: p.fullName,
        isValid: (v) => v.trim().isNotEmpty && v.trim() != p.fullName.trim(),
        toPatch: (v) => ProfilePatch(fullName: v.trim()),
        builder: (_, v, onChanged) => _TextEditor(
          initial: v,
          onChanged: onChanged,
          hint: 'Your full name',
          maxLength: 50,
        ),
      ),
      ProfileField.birthDate => _FieldEditor<DateTime?>(
        title: title,
        helper: 'You need to be at least $minAge.',
        initial: _dateOnly(p.dateOfBirth),
        isValid: (v) => v != null && _age(v) >= minAge,
        toPatch: (v) => ProfilePatch(dateOfBirth: v),
        builder: (_, v, onChanged) =>
            _DateEditor(initial: v, onChanged: onChanged),
      ),
      ProfileField.gender => _single(
        title,
        initial: p.gender,
        options: genderOptions,
        toPatch: (v) => ProfilePatch(gender: v),
      ),
      ProfileField.religion => _single(
        title,
        initial: p.religion,
        options: religionOptions,
        toPatch: (v) => ProfilePatch(religion: v),
      ),
      ProfileField.languages => _chips(
        title,
        helper: 'Which languages do you speak?',
        initial: p.languages.toSet(),
        options: _labels(languageOptions, p.languages),
        allowEmpty: true,
        toPatch: (v) => ProfilePatch(languages: v.toList()),
      ),
      ProfileField.grewUpIn => _FieldEditor<String?>(
        title: title,
        initial: p.grewUpIn,
        isValid: (v) => v != null,
        toPatch: (v) => ProfilePatch(grewUpIn: [v!]),
        builder: (_, v, onChanged) => _CountryEditor(
          selected: {?v},
          current: [?p.grewUpIn],
          withSuggested: true,
          onToggle: onChanged,
        ),
      ),
      ProfileField.height => _height(title, p),
      ProfileField.maritalStatus => _single(
        title,
        initial: p.maritalStatus,
        options: maritalStatusOptions,
        toPatch: (v) => ProfilePatch(maritalStatus: v),
      ),
      ProfileField.children => _yesNo(
        title,
        initial: p.hasChildren,
        yes: 'Has children',
        no: 'Doesn’t have children',
        toPatch: (v) => ProfilePatch(
          aboutYou: AboutYouAnswers.of(p).copyWith(haveChildren: v),
        ),
      ),
      ProfileField.bio => _FieldEditor<String>(
        title: title,
        initial: p.bio ?? '',
        isValid: (v) => v.trim().isNotEmpty && v.trim() != (p.bio ?? '').trim(),
        toPatch: (v) => ProfilePatch(bio: v.trim()),
        builder: (_, v, onChanged) => _TextEditor(
          initial: v,
          onChanged: onChanged,
          hint: 'Tell others a little about yourself',
          multiline: true,
        ),
      ),
      ProfileField.marriageIntentions =>
        _FieldEditor<({String? know, String? marry})>(
          title: title,
          helper:
              'Let others know how you’d like to approach the journey '
              'towards marriage.',
          initial: (know: p.gettingToKnow, marry: p.marriageTimeline),
          isValid: (v) =>
              v.know != null &&
              v.marry != null &&
              timelineFits(v.know!, v.marry!),
          toPatch: (v) => ProfilePatch(
            marriageIntentions: MarriageIntentionAnswers(
              getToKnow: v.know!,
              marriageTimeline: v.marry!,
            ),
          ),
          builder: (_, v, onChanged) =>
              _IntentionsEditor(value: v, onChanged: onChanged),
        ),
      ProfileField.relocation => _yesNo(
        title,
        initial: p.relocateAbroad,
        yes: 'Will move abroad',
        no: 'Won’t move abroad',
        toPatch: (v) => ProfilePatch(
          aboutYou: AboutYouAnswers.of(p).copyWith(relocateAbroad: v),
        ),
      ),
      ProfileField.bornMuslim => _yesNo(
        title,
        helper: 'Were you born a Muslim?',
        initial: p.bornMuslim,
        yes: 'Yes',
        no: 'No',
        toPatch: (v) => ProfilePatch(
          aboutYou: AboutYouAnswers.of(p).copyWith(bornMuslim: v),
        ),
      ),
      ProfileField.religiousPractice => _single(
        title,
        initial: p.religiousPractice,
        options: religiousPracticeOptions,
        toPatch: (v) => ProfilePatch(religiousPractices: [v]),
      ),
      ProfileField.faith => _chips(
        title,
        helper:
            'Choose up to $maxFaithTags to describe what matters most in '
            'your Islamic practice.',
        initial: p.faith.toSet(),
        options: _withCurrent(faithOptions, p.faith),
        max: maxFaithTags,
        toPatch: (v) => ProfilePatch(faith: v.toList()),
      ),
      ProfileField.diet => _yesNo(
        title,
        initial: p.halalFood,
        yes: 'Only eats Halal food',
        no: 'Doesn’t only eat Halal food',
        toPatch: (v) => ProfilePatch(
          lifestyle: LifestyleAnswers.of(p).copyWith(halalFood: v),
        ),
      ),
      ProfileField.alcohol => _yesNo(
        title,
        initial: p.alcohol,
        yes: 'Drinks',
        no: 'Doesn’t drink',
        noFirst: true,
        toPatch: (v) => ProfilePatch(
          lifestyle: LifestyleAnswers.of(p).copyWith(alcohol: v),
        ),
      ),
      ProfileField.smoking => _yesNo(
        title,
        initial: p.smoking,
        yes: 'Smoker',
        no: 'Non-smoker',
        noFirst: true,
        toPatch: (v) => ProfilePatch(
          lifestyle: LifestyleAnswers.of(p).copyWith(smoking: v),
        ),
      ),
      ProfileField.interests => _interests(title, p),
      ProfileField.personality => _chips(
        title,
        helper: 'Choose up to $maxPersonalityTraits traits.',
        initial: p.personality.toSet(),
        options: _labels(personalityOptions, p.personality),
        max: maxPersonalityTraits,
        toPatch: (v) => ProfilePatch(personalityTraits: v.toList()),
      ),
      ProfileField.education => _single(
        title,
        initial: p.education,
        options: educationOptions,
        toPatch: (v) => ProfilePatch(educationLevel: v),
      ),
      ProfileField.profession => _FieldEditor<String?>(
        title: title,
        initial: p.profession,
        isValid: (v) => v != null,
        toPatch: (v) => ProfilePatch(profession: v),
        builder: (_, v, onChanged) => Padding(
          padding: EdgeInsets.fromLTRB(kMenuGutter, 16.w, kMenuGutter, 0),
          child: SearchableSelectList(
            hintText: 'Search jobs',
            radioFirst: true,
            selected: {?v},
            onToggle: onChanged,
            items: [
              for (final job in {...professionOptions, ?p.profession})
                SelectListItem(value: job, label: job),
            ],
          ),
        ),
      ),
      ProfileField.ethnicity => _FieldEditor<Set<String>>(
        title: title,
        initial: p.ethnicity.toSet(),
        isValid: (v) => v.isNotEmpty,
        toPatch: (v) => ProfilePatch(ethnicity: v.toList()),
        builder: (_, v, onChanged) => _CountryEditor(
          selected: v,
          current: p.ethnicity,
          multiSelect: true,
          onToggle: (name) => onChanged(_toggle(v, name)),
        ),
      ),
      ProfileField.nationality => _FieldEditor<Set<String>>(
        title: title,
        helper: 'Which countries are you a citizen of? Up to two.',
        initial: p.nationality.toSet(),
        isValid: (v) => v.isNotEmpty && v.length <= maxNationalities,
        toPatch: (v) => ProfilePatch(nationality: v.toList()),
        builder: (_, v, onChanged) => _CountryEditor(
          selected: v,
          current: p.nationality,
          multiSelect: true,
          withSuggested: true,
          max: maxNationalities,
          onToggle: (name) =>
              onChanged(_toggle(v, name, max: maxNationalities)),
        ),
      ),
    };
  }
}

// ── Editor kinds ──────────────────────────────────────────────────────────

/// Single choice from [options], pre-selecting [initial].
Widget _single(
  String title, {
  required String? initial,
  required List<EditOption> options,
  required ProfilePatch Function(String value) toPatch,
  String? helper,
}) => _FieldEditor<String?>(
  title: title,
  helper: helper,
  initial: initial,
  isValid: (v) => v != null,
  toPatch: (v) => toPatch(v!),
  builder: (_, v, onChanged) => EditorRadioList(
    options: _withCurrent(options, [?initial]),
    value: v,
    onChanged: onChanged,
  ),
);

/// Yes / No question shown as two descriptive choices (Muzz: "Only eats
/// Halal food" / "Doesn't only eat Halal food").
Widget _yesNo(
  String title, {
  required bool? initial,
  required String yes,
  required String no,
  required ProfilePatch Function(bool value) toPatch,
  String? helper,
  bool noFirst = false,
}) {
  final options = [EditOption('yes', yes), EditOption('no', no)];
  return _FieldEditor<bool?>(
    title: title,
    helper: helper,
    initial: initial,
    isValid: (v) => v != null,
    toPatch: (v) => toPatch(v!),
    builder: (_, v, onChanged) => EditorRadioList(
      options: noFirst ? options.reversed.toList() : options,
      value: v == null ? null : (v ? 'yes' : 'no'),
      onChanged: (o) => onChanged(o == 'yes'),
    ),
  );
}

/// Multi-select chips, at most [max] (when given).
Widget _chips(
  String title, {
  required Set<String> initial,
  required List<EditOption> options,
  required ProfilePatch Function(Set<String> value) toPatch,
  String? helper,
  int? max,
  bool allowEmpty = false,
}) => _FieldEditor<Set<String>>(
  title: title,
  helper: helper,
  initial: initial,
  isValid: (v) =>
      (allowEmpty || v.isNotEmpty) && (max == null || v.length <= max),
  toPatch: toPatch,
  builder: (_, v, onChanged) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(kMenuGutter, 20.w, kMenuGutter, 20.w),
    child: EditorChips(
      options: options,
      selected: v,
      disabled: max != null && v.length >= max
          ? {for (final o in options) o.value}
          : const {},
      onTap: (value) => onChanged(_toggle(v, value, max: max)),
    ),
  ),
);

Widget _height(String title, MyProfile p) {
  final options = buildHeightOptions();
  // Snap an odd stored value to the nearest row, like onboarding does.
  final saved = p.heightCm;
  final initial = saved == null
      ? null
      : options
            .reduce(
              (a, b) => (a.cm - saved).abs() <= (b.cm - saved).abs() ? a : b,
            )
            .cm;
  return _FieldEditor<int?>(
    title: title,
    initial: initial,
    isValid: (v) => v != null,
    toPatch: (v) => ProfilePatch(heightCm: v),
    builder: (_, v, onChanged) => _HeightEditor(
      options: options,
      value: v,
      onChanged: onChanged,
    ),
  );
}

Widget _interests(String title, MyProfile p) {
  final initial = {
    for (final c in InterestCategory.values) c: {...?p.interestGroups[c]},
  };
  int count(Map<InterestCategory, Set<String>> v) =>
      {for (final s in v.values) ...s}.length;
  return _FieldEditor<Map<InterestCategory, Set<String>>>(
    title: title,
    helper: 'Choose up to $maxInterests interests.',
    initial: initial,
    isValid: (v) => count(v) > 0 && count(v) <= maxInterests,
    // Every category goes back, including ones with no chips here
    // (fashion, activities), so nothing is wiped (ISS-010).
    toPatch: (v) => ProfilePatch(
      interests: {for (final e in v.entries) e.key: e.value.toList()},
    ),
    builder: (_, v, onChanged) {
      final atMax = count(v) >= maxInterests;
      return ListView(
        padding: EdgeInsets.fromLTRB(kMenuGutter, 20.w, kMenuGutter, 20.w),
        children: [
          for (final c in InterestCategory.values)
            if (_labels(interestOptions[c]!.$2, [...?v[c]]) case final opts
                when opts.isNotEmpty) ...[
              EditorGroupLabel(interestOptions[c]!.$1),
              EditorChips(
                options: opts,
                selected: v[c] ?? const {},
                disabled: atMax ? {for (final o in opts) o.value} : const {},
                onTap: (label) => onChanged({
                  ...v,
                  c: _toggle(v[c] ?? const {}, label),
                }),
              ),
              SizedBox(height: 24.w),
            ],
        ],
      );
    },
  );
}

// ── Host ──────────────────────────────────────────────────────────────────

/// Wires one editor to a [FieldEditorBloc] and the page chrome. On save it
/// pops with the updated profile; on failure it shows the error and stays.
class _FieldEditor<T> extends StatelessWidget {
  const _FieldEditor({
    required this.title,
    required this.initial,
    required this.toPatch,
    required this.builder,
    this.isValid,
    this.helper,
  });

  final String title;
  final String? helper;
  final T initial;
  final ProfilePatch Function(T value) toPatch;
  final bool Function(T value)? isValid;
  final Widget Function(BuildContext context, T value, ValueChanged<T> change)
  builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FieldEditorBloc<T>(
        // getIt<MenuRepository>(),
        initial: initial,
        toPatch: toPatch,
        isValid: isValid,
      ),
      child: BlocConsumer<FieldEditorBloc<T>, FieldEditorState<T>>(
        listenWhen: (a, b) => a.status != b.status,
        // Was: pop after the server answered, toast on failure.
        // listener: (context, state) {
        //   if (state.status == FieldEditorStatus.saved) {
        //     context.pop(state.saved);
        //   } else if (state.status == FieldEditorStatus.failure &&
        //       state.failure != null) {
        //     showFailureToast(context, state.failure!);
        //   }
        // },
        // Hands the edit back at once; Edit profile shows it and saves it
        // in the background.
        listener: (context, state) {
          if (state.status == FieldEditorStatus.submitted) {
            context.pop(state.patch);
          }
        },
        builder: (context, state) {
          final bloc = context.read<FieldEditorBloc<T>>();
          return EditorScaffold(
            title: title,
            helper: helper,
            saving: state.status == FieldEditorStatus.saving,
            onUpdate: state.canSave
                ? () => bloc.add(FieldEditorSubmitted<T>())
                : null,
            body: builder(
              context,
              state.value,
              (v) => bloc.add(FieldEditorChanged<T>(v)),
            ),
          );
        },
      ),
    );
  }
}

// ── Editor bodies ─────────────────────────────────────────────────────────

class _TextEditor extends StatefulWidget {
  const _TextEditor({
    required this.initial,
    required this.onChanged,
    required this.hint,
    this.multiline = false,
    this.maxLength,
  });

  final String initial;
  final ValueChanged<String> onChanged;
  final String hint;
  final bool multiline;
  final int? maxLength;

  @override
  State<_TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<_TextEditor> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(kMenuGutter, 16.w, kMenuGutter, 16.w),
      child: TextField(
        controller: _controller,
        autofocus: true,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        minLines: widget.multiline ? 5 : 1,
        maxLines: widget.multiline ? null : 1,
        keyboardType: widget.multiline
            ? TextInputType.multiline
            : TextInputType.name,
        textCapitalization: widget.multiline
            ? TextCapitalization.sentences
            : TextCapitalization.words,
        style: menuText(16, 24),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: menuText(16, 24, color: kMenuGrey400),
          filled: true,
          fillColor: kMenuGrey50,
          contentPadding: EdgeInsets.all(16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: kMenuGrey200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: kMenuGrey200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}

/// Month / day / year wheels (Muzz uses the same).
class _DateEditor extends StatelessWidget {
  const _DateEditor({required this.initial, required this.onChanged});

  final DateTime? initial;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final latest = DateTime(now.year - minAge, now.month, now.day);
    final start = initial == null || initial!.isAfter(latest)
        ? latest
        : initial!;
    return Column(
      children: [
        SizedBox(height: 24.w),
        SizedBox(
          height: 220.h,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            initialDateTime: start,
            minimumDate: DateTime(1940),
            maximumDate: latest,
            onDateTimeChanged: (d) => onChanged(_dateOnly(d)),
          ),
        ),
        SizedBox(height: 16.w),
        if (initial case final d?)
          Text(
            'You are ${_age(d)} years old',
            style: menuText(14, 20, color: kMenuGrey500),
          ),
      ],
    );
  }
}

class _HeightEditor extends StatefulWidget {
  const _HeightEditor({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<({int cm, String label})> options;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  State<_HeightEditor> createState() => _HeightEditorState();
}

class _HeightEditorState extends State<_HeightEditor> {
  // Opens scrolled near the current height (rows are ~50pt with gaps).
  late final _controller = ScrollController(
    initialScrollOffset: math.max(
      0,
      (widget.options.indexWhere((o) => o.cm == widget.value) - 3) * 50.h,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditorRadioList(
      controller: _controller,
      options: [
        for (final o in widget.options) EditOption('${o.cm}', o.label),
      ],
      value: widget.value?.toString(),
      onChanged: (v) => widget.onChanged(int.tryParse(v)),
    );
  }
}

/// Searchable country list. Values are country names (what the API stores);
/// a stored name that isn't in the list is added so it can be unticked.
class _CountryEditor extends StatelessWidget {
  const _CountryEditor({
    required this.selected,
    required this.current,
    required this.onToggle,
    this.multiSelect = false,
    this.withSuggested = false,
    this.max,
  });

  final Set<String> selected;
  final bool multiSelect;

  /// What the profile has now.
  final List<String> current;
  final ValueChanged<String> onToggle;
  final bool withSuggested;
  final int? max;

  @override
  Widget build(BuildContext context) {
    SelectListItem item(Country c) => SelectListItem(
      value: c.name,
      label: c.name,
      leading: Text(c.flag, style: TextFontStyle.flagEmoji22),
    );
    final known = {for (final c in allCountries) c.name};
    final sorted = [...allCountries]..sort((a, b) => a.name.compareTo(b.name));
    return Padding(
      padding: EdgeInsets.fromLTRB(kMenuGutter, 16.w, kMenuGutter, 0),
      child: SearchableSelectList(
        hintText: 'Search countries',
        multiSelect: multiSelect,
        maxSelections: max,
        selected: selected,
        onToggle: onToggle,
        suggested: withSuggested
            ? suggestedCountries.map(item).toList()
            : const [],
        items: [
          for (final name in current)
            if (!known.contains(name)) SelectListItem(value: name, label: name),
          ...sorted.map(item),
        ],
      ),
    );
  }
}

/// "Marriage intentions": know-someone-for and married-within on one page,
/// saved together. Choices that break onboarding's rule are faded.
class _IntentionsEditor extends StatelessWidget {
  const _IntentionsEditor({required this.value, required this.onChanged});

  final ({String? know, String? marry}) value;
  final ValueChanged<({String? know, String? marry})> onChanged;

  @override
  Widget build(BuildContext context) {
    final know = value.know;
    final marry = value.marry;
    return ListView(
      padding: EdgeInsets.fromLTRB(kMenuGutter, 24.w, kMenuGutter, 20.w),
      children: [
        const EditorGroupLabel('I’d like to know someone for'),
        EditorChips(
          options: _withCurrent(getToKnowOptions, [?know]),
          selected: {?know},
          disabled: {
            for (final o in getToKnowOptions)
              if (marry != null && !timelineFits(o.value, marry)) o.value,
          },
          onTap: (v) => onChanged((know: v, marry: marry)),
        ),
        SizedBox(height: 32.w),
        const EditorGroupLabel('I’d like to be married within'),
        EditorChips(
          options: _withCurrent(marriageTimelineOptions, [?marry]),
          selected: {?marry},
          disabled: {
            for (final o in marriageTimelineOptions)
              if (know != null && !timelineFits(know, o.value)) o.value,
          },
          onTap: (v) => onChanged((know: know, marry: v)),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────

/// [options] plus any stored value missing from them (labelled from its
/// token), so an unexpected server value still shows as selected.
List<EditOption> _withCurrent(List<EditOption> options, List<String> current) {
  final known = {for (final o in options) o.value};
  return [
    ...options,
    for (final v in current)
      if (!known.contains(v)) EditOption(v, MenuFormat.token(v) ?? v),
  ];
}

/// Label-only options (value = label), plus stored values not in the list.
List<EditOption> _labels(List<String> labels, List<String> current) => [
  for (final l in {...labels, ...current}) EditOption(l, l),
];

/// [set] with [value] toggled; adding stops at [max].
Set<String> _toggle(Set<String> set, String value, {int? max}) {
  if (set.contains(value)) return {...set}..remove(value);
  if (max != null && set.length >= max) return set;
  return {...set, value};
}

DateTime? _dateOnly(DateTime? d) =>
    d == null ? null : DateTime(d.year, d.month, d.day);

int _age(DateTime dob) {
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}
