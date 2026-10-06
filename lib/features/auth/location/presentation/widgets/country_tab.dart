import 'package:flutter/material.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/constants/countries.dart';
import '../../../../../core/ui/components/app_primary_button.dart';
import '../../../../../core/ui/components/searchable_select_list.dart';
import '../../../../../core/filters/discovery_filters_controller.dart';

/// "Country" tab of the Location screen: single-select country list (same
/// list + widget as onboarding's grew-up-country step) with a pinned
/// Confirm button.
class CountryTab extends ConsumerStatefulWidget {
  const CountryTab({super.key, required this.onConfirmed});

  final VoidCallback onConfirmed;

  @override
  ConsumerState<CountryTab> createState() => _CountryTabState();
}

class _CountryTabState extends ConsumerState<CountryTab> {
  String? _code;

  @override
  void initState() {
    super.initState();
    _code = ref.read(discoveryFiltersControllerProvider).countryCode;
  }

  void _confirm() {
    ref
        .read(discoveryFiltersControllerProvider.notifier)
        .setCountryFilter(_code!);
    widget.onConfirmed();
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
            onPressed: _code == null ? null : _confirm,
          ),
        ),
      ],
    );
  }
}
