import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_navigator.dart';
import '../../../../../core/filters/discovery_filters.dart';
import '../../../../../core/filters/discovery_filters_controller.dart';
import '../widgets/country_tab.dart';
import '../widgets/distance_tab.dart';
import '../widgets/location_permission_gate.dart';
import '../widgets/remove_filter_sheet.dart';

/// "Location" screen. Two tabs (Distance / Country); only one filter can be
/// active, so switching tabs while the other filter is saved prompts the
/// "Remove location filter?" sheet first. "Clear" wipes the saved filter.
///
/// Used twice:
/// - [isOnboardingStep] — standalone step between Photo verification and
///   Add filters; Confirm moves on to Add filters.
/// - otherwise — opened from Add filters → "Limit location by" to edit the
///   choice; Confirm / Clear go back.
///
/// Location permission is mandatory either way ([LocationPermissionGate]).
class LocationFilterScreen extends ConsumerStatefulWidget {
  const LocationFilterScreen({super.key, this.isOnboardingStep = false});

  final bool isOnboardingStep;

  @override
  ConsumerState<LocationFilterScreen> createState() =>
      _LocationFilterScreenState();
}

class _LocationFilterScreenState extends ConsumerState<LocationFilterScreen> {
  late LocationFilterMode _tab;

  @override
  void initState() {
    super.initState();
    _tab =
        ref.read(discoveryFiltersControllerProvider).locationMode ??
        LocationFilterMode.distance;
  }

  Future<void> _selectTab(LocationFilterMode tab) async {
    if (tab == _tab) return;
    final savedMode = ref.read(discoveryFiltersControllerProvider).locationMode;
    // A filter of the *other* kind is saved → confirm before discarding it.
    if (savedMode != null && savedMode != tab) {
      final discard = await showRemoveFilterSheet(context);
      if (!discard || !mounted) return;
      ref
          .read(discoveryFiltersControllerProvider.notifier)
          .clearLocationFilter();
    }
    setState(() => _tab = tab);
  }

  void _clear() {
    ref.read(discoveryFiltersControllerProvider.notifier).clearLocationFilter();
    // As a step there's nowhere "back" to confirm into — just reset.
    if (!widget.isOnboardingStep) context.pop();
    // context.pop();
  }

  void _onConfirmed() => widget.isOnboardingStep
      ? ref.read(appNavigatorProvider).toAddFilters()
      : context.pop();
  // void _onConfirmed() => context.pop();

  @override
  Widget build(BuildContext context) {
    final hasFilter = ref.watch(
      discoveryFiltersControllerProvider.select((f) => f.hasLocationFilter),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _LocationAppBar(onClear: hasFilter ? _clear : null),
            _TabBar(active: _tab, onSelect: _selectTab),
            Expanded(
              // Tab content only builds once location access is granted.
              child: LocationPermissionGate(
                // Keyed so each tab rebuilds its draft state from the saved
                // filter when it comes on screen.
                child: switch (_tab) {
                  LocationFilterMode.distance => DistanceTab(
                    key: const ValueKey('distance'),
                    onConfirmed: _onConfirmed,
                  ),
                  LocationFilterMode.country => CountryTab(
                    key: const ValueKey('country'),
                    onConfirmed: _onConfirmed,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back arrow · centred "Location" · "Clear" (muted when nothing to clear).
class _LocationAppBar extends StatelessWidget {
  const _LocationAppBar({required this.onClear});

  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    // NavigationToolbar (what AppBar uses): full width, title centred, and
    // the title is laid out *between* back / Clear so they can't overlap.
    return SizedBox(
      height: 52.h,
      child: NavigationToolbar(
        centerMiddle: true,
        middleSpacing: 8.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back, color: AppColors.textDark, size: 22.r),
          ),
        ),
        middle: Text(
          'Location',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextFontStyle.headline17w500textDarkStyleSatoshi,
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: TextButton(
            onPressed: onClear,
            child: Text(
              'Clear',
              style: onClear == null
                  ? TextFontStyle.headline15w400textMutedStyleSatoshi.copyWith(
                      color: AppColors.textMuted.withValues(alpha: 0.6),
                    )
                  : TextFontStyle.headline15w400textDarkStyleSatoshi,
            ),
          ),
        ),
      ),
    );
    // Previous Stack layout — the SizedBox had no width, so inside the
    // Column it shrank to the title's width and both Positioned buttons
    // landed on top of "Location".
    // return SizedBox(
    //   height: 52.h,
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       Text(
    //         'Location',
    //         style: TextFontStyle.headline17w500textDarkStyleSatoshi,
    //       ),
    //       Positioned(
    //         left: 4.w,
    //         child: IconButton(
    //           onPressed: () => context.pop(),
    //           icon: Icon(
    //             Icons.arrow_back,
    //             color: AppColors.textDark,
    //             size: 22.r,
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         right: 8.w,
    //         child: TextButton(
    //           onPressed: onClear,
    //           child: Text(
    //             'Clear',
    //             style: onClear == null
    //                 ? TextFontStyle.headline15w400textMutedStyleSatoshi
    //                       .copyWith(
    //                         color: AppColors.textMuted.withValues(alpha: 0.6),
    //                       )
    //                 : TextFontStyle.headline15w400textDarkStyleSatoshi,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.active, required this.onSelect});

  final LocationFilterMode active;
  final ValueChanged<LocationFilterMode> onSelect;

  @override
  Widget build(BuildContext context) {
    Widget tab(LocationFilterMode mode, String label) {
      final selected = mode == active;
      return Expanded(
        child: InkWell(
          onTap: () => onSelect(mode),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected
                      ? AppColors.primaryColor
                      : Colors.grey.shade300,
                  width: selected ? 2 : 1,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: selected
                  ? TextFontStyle.headline16w600primaryColorStyleSatoshi
                  : TextFontStyle.headline16w600textDarkStyleSatoshi,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(LocationFilterMode.distance, 'Distance'),
        tab(LocationFilterMode.country, 'Country'),
      ],
    );
  }
}
