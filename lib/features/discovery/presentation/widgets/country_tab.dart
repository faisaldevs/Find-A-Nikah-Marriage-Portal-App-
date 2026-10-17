import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/discovery_filters_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Country" tab of the Location screen: single-select country list (same
/// list + widget as onboarding's grew-up-country step) with a pinned
/// Confirm button.
class CountryTab extends StatefulWidget {
  const CountryTab({required this.onConfirmed, super.key});

  final VoidCallback onConfirmed;

  @override
  State<CountryTab> createState() => _CountryTabState();
}

class _CountryTabState extends State<CountryTab> {
  String? _code;

  @override
  void initState() {
    super.initState();
    _code = context.read<DiscoveryFiltersBloc>().state.filters.countryCode;
  }

  void _confirm() {
    final country = [
      ...suggestedCountries,
      ...allCountries,
    ].firstWhere((c) => c.code == _code);
    context.read<DiscoveryFiltersBloc>().add(
      CountryFilterConfirmed(_code!, countryName: country.name),
    );
    // The page moves on once the backend save succeeds (its listener).
    // widget.onConfirmed();
  }

  SelectListItem _item(Country c) => SelectListItem(
    value: c.code,
    label: c.name,
    leading: Text(c.flag, style: TextFontStyle.flagEmoji22),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SearchableSelectList(
              hintText: 'Search countries',
              selected: _code == null ? {} : {_code!},
              onToggle: (v) => setState(() => _code = v),
              suggested: suggestedCountries.map(_item).toList(),
              items: allCountries.map(_item).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
          child: AppPrimaryButton(
            label: 'Confirm',
            // Disabled while the step-11 save is in flight.
            onPressed:
                _code == null ||
                    context.select<DiscoveryFiltersBloc, bool>(
                      (b) =>
                          b.state.status ==
                          DiscoveryFiltersStatus.savingLocation,
                    )
                ? null
                : _confirm,
          ),
        ),
      ],
    );
  }
}
