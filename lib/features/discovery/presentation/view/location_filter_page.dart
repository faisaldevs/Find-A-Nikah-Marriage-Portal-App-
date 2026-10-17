import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/discovery_filters_bloc.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/user_location_bloc.dart';
import 'package:find_a_nikah/features/discovery/presentation/widgets/country_tab.dart';
import 'package:find_a_nikah/features/discovery/presentation/widgets/distance_tab.dart';
import 'package:find_a_nikah/features/discovery/presentation/widgets/location_permission_gate.dart';
import 'package:find_a_nikah/features/discovery/presentation/widgets/remove_filter_sheet.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

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
class LocationFilterPage extends StatelessWidget {
  const LocationFilterPage({super.key, this.isOnboardingStep = false});

  final bool isOnboardingStep;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<DiscoveryFiltersBloc>()
                ..add(const DiscoveryFiltersSubscribed()),
        ),
        BlocProvider(create: (_) => getIt<UserLocationBloc>()),
      ],
      child: _LocationFilterView(isOnboardingStep: isOnboardingStep),
    );
  }
}

class _LocationFilterView extends StatefulWidget {
  const _LocationFilterView({required this.isOnboardingStep});

  final bool isOnboardingStep;

  @override
  State<_LocationFilterView> createState() => _LocationFilterPageState();
}

class _LocationFilterPageState extends State<_LocationFilterView> {
  late LocationFilterMode _tab;

  @override
  void initState() {
    super.initState();
    _tab =
        context.read<DiscoveryFiltersBloc>().state.filters.locationMode ??
        LocationFilterMode.distance;
  }

  Future<void> _selectTab(LocationFilterMode tab) async {
    if (tab == _tab) return;
    final bloc = context.read<DiscoveryFiltersBloc>();
    final savedMode = bloc.state.filters.locationMode;
    // A filter of the *other* kind is saved → confirm before discarding it.
    if (savedMode != null && savedMode != tab) {
      final discard = await showRemoveFilterSheet(context);
      if (!discard || !mounted) return;
      bloc.add(const LocationFilterCleared());
    }
    setState(() => _tab = tab);
  }

  void _clear() {
    context.read<DiscoveryFiltersBloc>().add(const LocationFilterCleared());
    // As a step there's nowhere "back" to confirm into — just reset.
    if (!widget.isOnboardingStep) context.pop();
  }

  void _onConfirmed() => widget.isOnboardingStep
      ? context.push<void>(RoutePaths.addFilters)
      : context.pop();

  @override
  Widget build(BuildContext context) {
    final hasFilter = context.select<DiscoveryFiltersBloc, bool>(
      (b) => b.state.filters.hasLocationFilter,
    );
    return BlocListener<DiscoveryFiltersBloc, DiscoveryFiltersState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) => switch (state.status) {
        // Step 11 saved → move on (Add filters, or back when editing).
        DiscoveryFiltersStatus.locationSaved => _onConfirmed(),
        DiscoveryFiltersStatus.failure when state.failure != null =>
          showFailureToast(context, state.failure!),
        _ => null,
      },
      child: _scaffold(hasFilter),
    );
  }

  Widget _scaffold(bool hasFilter) {
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
