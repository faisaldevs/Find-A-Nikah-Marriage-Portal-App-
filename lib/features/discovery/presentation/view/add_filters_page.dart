import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/discovery_filters_bloc.dart';
import 'package:find_a_nikah/features/discovery/presentation/widgets/ring_slider_theme.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Final pre-app step: partner-preference filters. Age is edited inline;
/// location and ethnicity open their own pickers. "Discover profiles" ends
/// sign-up (first time) and drops the user into the app shell.
class AddFiltersPage extends StatelessWidget {
  const AddFiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DiscoveryFiltersBloc>()
            ..add(const DiscoveryFiltersSubscribed()),
      child: BlocListener<DiscoveryFiltersBloc, DiscoveryFiltersState>(
        listenWhen: (prev, next) => prev.status != next.status,
        listener: (context, state) => switch (state.status) {
          // `go`: clears the sign-up / filters stack so back doesn't return
          // into onboarding. The Marriage feed restarts with the filters.
          DiscoveryFiltersStatus.readyToDiscover => _onDiscoverProfiles(
            context,
          ),
          DiscoveryFiltersStatus.failure => showFailureToast(
            context,
            state.failure!,
          ),
          _ => null,
        },
        child: const _AddFiltersView(),
      ),
    );
  }

  void _onDiscoverProfiles(BuildContext context) {
    CustomToast.showSuccess(
      context,
      'You’re all set',
      description: 'Your profile preferences are ready.',
    );
    context.go(RoutePaths.marriage);
  }
}

class _AddFiltersView extends StatelessWidget {
  const _AddFiltersView();

  String _locationSummary(DiscoveryFilters f) {
    switch (f.locationMode) {
      case null:
        return 'Anywhere';
      case LocationFilterMode.distance:
        final base = f.isEverywhere
            ? 'Everywhere'
            : 'Within ${f.distanceMiles.round()} miles';
        return f.limitToHomeCountry
            ? '$base · ${_countryName(kHomeCountryCode)} only'
            : base;
      case LocationFilterMode.country:
        return _countryName(f.countryCode!);
    }
  }

  String _countryName(String code) => allCountries
      .firstWhere((c) => c.code == code, orElse: () => Country(code, code, ''))
      .name;

  String _ethnicitySummary(DiscoveryFilters f) {
    if (f.ethnicities.isEmpty) return 'No preference';
    final names = f.ethnicities.map(_countryName).toList();
    return names.length <= 2
        ? names.join(', ')
        : '${names.take(2).join(', ')} +${names.length - 2}';
  }

  Future<void> _pickEthnicity(BuildContext context) async {
    final bloc = context.read<DiscoveryFiltersBloc>();
    final current = bloc.state.filters.ethnicities;
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _EthnicitySheet(initial: current),
    );
    if (result != null) bloc.add(EthnicitiesChanged(result));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DiscoveryFiltersBloc>().state;
    final filters = state.filters;
    final bloc = context.read<DiscoveryFiltersBloc>();

    return WizardScaffold(
      title: 'Add filters',
      // Standalone page after verification — header only, no progress bar.
      // Figma does show the segmented bar; last onboarding step → all four.
      step: 1,
      totalSteps: 1,
      activeSegment: 3,
      // continueLabel: 'Discover profiles',
      continueLabel: state.status == DiscoveryFiltersStatus.submitting
          ? 'Setting up...'
          : 'Discover profiles',
      onContinue: state.status == DiscoveryFiltersStatus.submitting
          ? null
          : () => bloc.add(const DiscoverProfilesRequested()),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 16.h),
            const WizardHeadline(
              text: 'Add filters to tell us about your ideal partner',
              subtitle:
                  "We'll use this to show you the most compatible profiles. "
                  'You can always change this later.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 48.h),
            _AgeRange(
              min: filters.minAge,
              max: filters.maxAge,
              isAnyAge: filters.isAnyAge,
              onChanged: (min, max) => bloc.add(AgeRangeChanged(min, max)),
            ),
            SizedBox(height: 32.h),
            _FilterRow(
              title: 'Limit location by',
              value: _locationSummary(filters),
              onTap: () => context.push<void>(RoutePaths.locationFilter),
            ),
            const _DashedDivider(),
            _FilterRow(
              title: 'Ethnicity',
              value: _ethnicitySummary(filters),
              onTap: () => _pickEthnicity(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgeRange extends StatelessWidget {
  const _AgeRange({
    required this.min,
    required this.max,
    required this.isAnyAge,
    required this.onChanged,
  });

  final int min;
  final int max;
  final bool isAnyAge;
  final void Function(int min, int max) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Age',
              style: TextFontStyle.headline17w600textDarkStyleSatoshi,
            ),
            Text(
              isAnyAge ? 'Any age' : '$min – $max',
              style: TextFontStyle.headline15w400textMutedStyleSatoshi,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        RingSliderTheme(
          child: RangeSlider(
            values: RangeValues(min.toDouble(), max.toDouble()),
            min: kMinAge.toDouble(),
            max: kMaxAge.toDouble(),
            divisions: kMaxAge - kMinAge,
            onChanged: (v) => onChanged(v.start.round(), v.end.round()),
            padding: EdgeInsets.zero,
            // Screen readers announced "0%"/"100%" (audit #44).
            semanticFormatterCallback: (v) => 'Age ${v.round()}',
          ),
        ),
      ],
    );
  }
}

/// Title + current value on the left, chevron on the right. Whole row taps.
class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextFontStyle.headline17w600textDarkStyleSatoshi,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextFontStyle.headline15w400textMutedStyleSatoshi,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.r,
              color: AppColors.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 4.0;
        const gap = 4.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dash,
              height: 1,
              margin: const EdgeInsets.only(right: gap),
              color: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}

/// Multi-select ethnicity picker. Reuses the country list as the ethnicity
/// options, exactly like onboarding's EthnicityPage does.
class _EthnicitySheet extends StatefulWidget {
  const _EthnicitySheet({required this.initial});

  final List<String> initial;

  @override
  State<_EthnicitySheet> createState() => _EthnicitySheetState();
}

class _EthnicitySheetState extends State<_EthnicitySheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial.toSet();
  }

  void _toggle(String code) {
    setState(() {
      if (!_selected.remove(code)) _selected.add(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.85.sh,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ethnicity',
              style: TextFontStyle.headline20w700textDarkStyleSatoshi,
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: SearchableSelectList(
                hintText: 'Search ethnicities',
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
            SafeArea(
              top: false,
              child: AppPrimaryButton(
                label: _selected.isEmpty
                    ? 'No preference'
                    : 'Confirm (${_selected.length})',
                onPressed: () => Navigator.of(context).pop(_selected.toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
