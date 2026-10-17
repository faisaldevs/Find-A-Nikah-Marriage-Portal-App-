import 'dart:math' as math;

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/discovery_filters_bloc.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/user_location_bloc.dart';
import 'package:find_a_nikah/features/discovery/presentation/widgets/ring_slider_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:latlong2/latlong.dart';

const _metersPerMile = 1609.344;

/// "Distance" tab of the Location screen: full-bleed OpenStreetMap with a
/// radius circle around the user, and a floating card holding the distance
/// slider, the "Limit to only `<country>`" toggle and Confirm.
class DistanceTab extends StatefulWidget {
  const DistanceTab({required this.onConfirmed, super.key});

  final VoidCallback onConfirmed;

  @override
  State<DistanceTab> createState() => _DistanceTabState();
}

class _DistanceTabState extends State<DistanceTab> {
  final _mapController = MapController();
  late double _miles;
  late bool _limitToHomeCountry;
  bool _mapReady = false;

  /// Floating card state — collapsed shows just the summary row + Confirm
  /// so more of the map is visible.
  bool _cardExpanded = true;

  @override
  void initState() {
    super.initState();
    final saved = context.read<DiscoveryFiltersBloc>().state.filters;
    _miles = saved.distanceMiles;
    _limitToHomeCountry = saved.limitToHomeCountry;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  bool get _isEverywhere => _miles >= kMaxDistanceMiles;

  String get _distanceLabel =>
      _isEverywhere ? 'Everywhere' : 'Upto ${_miles.round()} miles away';

  // Before: always the fixed launch country (kHomeCountryCode).
  // String get _homeCountryName => allCountries
  //     .firstWhere(
  //       (c) => c.code == kHomeCountryCode,
  //       orElse: () => suggestedCountries.first,
  //     )
  //     .name;

  /// The country the member is in (reverse geocoded), as spelled in the
  /// app's country list; null when unknown — the toggle is then hidden.
  String? _countryName(String? code) {
    if (code == null) return null;
    for (final c in [...suggestedCountries, ...allCountries]) {
      if (c.code == code) return c.name;
    }
    return null;
  }

  /// Re-frames the map so the radius circle fills the viewport (or zooms
  /// out to a country-scale view when "Everywhere").
  void _fitToRadius(LatLng center) {
    if (!_mapReady) return;
    if (_isEverywhere) {
      // _mapController.move(center, 5);
      // Zoom 5 never painted tiles on device (blank grey, audit #41);
      // 6 is still a country-scale view and loads.
      _mapController.move(center, 6);
      return;
    }
    final meters = _miles * _metersPerMile;
    final latDelta = meters / 111_320;
    final lngDelta =
        meters / (111_320 * math.cos(center.latitude * math.pi / 180));
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(center.latitude - latDelta, center.longitude - lngDelta),
          LatLng(center.latitude + latDelta, center.longitude + lngDelta),
        ),
        // Bottom inset keeps the circle clear of the floating card.
        padding: EdgeInsets.fromLTRB(
          24.w,
          24.h,
          24.w,
          _cardExpanded ? 260.h : 150.h,
        ),
        // padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 260.h),
      ),
    );
  }

  void _confirm() {
    context.read<DiscoveryFiltersBloc>().add(
      DistanceFilterConfirmed(
        miles: _miles,
        limitToHomeCountry: _limitToHomeCountry,
        center: context.read<UserLocationBloc>().state.position,
        countryName: _countryName(
          context.read<UserLocationBloc>().state.countryCode,
        ),
      ),
    );
    // The page moves on once the backend save succeeds (its listener).
    // widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final position = context.select<UserLocationBloc, GeoPoint>(
      (b) => b.state.position,
    );
    final center = LatLng(position.latitude, position.longitude);

    // Re-frame once the real position arrives (initial build uses fallback).
    return BlocListener<UserLocationBloc, UserLocationState>(
      listenWhen: (prev, next) => !prev.hasFix && next.hasFix,
      listener: (_, state) => _fitToRadius(
        LatLng(state.position.latitude, state.position.longitude),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 6,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                // onMapReady: () {
                //   _mapReady = true;
                //   _fitToRadius(center);
                // },
                // Frame on the *current* position: `center` is from the
                // build that created the map — often the fallback before
                // the GPS fix, and the fix listener skips while the map
                // isn't ready, so "Everywhere" stayed on an empty sea
                // (audit #41).
                onMapReady: () {
                  _mapReady = true;
                  final p = context.read<UserLocationBloc>().state.position;
                  _fitToRadius(LatLng(p.latitude, p.longitude));
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.findanikah.app',
                ),
                if (!_isEverywhere)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: center,
                        radius: _miles * _metersPerMile,
                        useRadiusInMeter: true,
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                        borderColor: AppColors.primaryColor,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 20.r,
                      height: 20.r,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
                // OSM tile usage policy requires visible attribution.
                // const SimpleAttributionWidget(
                //   source: Text('OpenStreetMap contributors'),
                //   alignment: Alignment.topRight,
                // ),
                // Collapsible (i) button instead of a box over the map was
                // tried (audit #41), but it only docks at the bottom where
                // the distance card hides it — keep the visible box (OSM
                // policy).
                // const RichAttributionWidget(
                //   alignment: AttributionAlignment.bottomLeft,
                //   showFlutterMapAttribution: false,
                //   attributions: [
                //     TextSourceAttribution('OpenStreetMap contributors'),
                //   ],
                // ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                  alignment: Alignment.topRight,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
            child: _DistanceCard(
              expanded: _cardExpanded,
              onExpandedChanged: (v) {
                setState(() => _cardExpanded = v);
                _fitToRadius(center);
              },
              distanceLabel: _distanceLabel,
              miles: _miles,
              onMilesChanged: (v) => setState(() => _miles = v),
              onMilesChangeEnd: (_) => _fitToRadius(center),
              homeCountryName: _countryName(
                context.select<UserLocationBloc, String?>(
                  (b) => b.state.countryCode,
                ),
              ),
              limitToHomeCountry: _limitToHomeCountry,
              onLimitChanged: (v) => setState(() => _limitToHomeCountry = v),
              // Disabled while the step-11 save is in flight.
              onConfirm:
                  context.select<DiscoveryFiltersBloc, bool>(
                    (b) =>
                        b.state.status == DiscoveryFiltersStatus.savingLocation,
                  )
                  ? null
                  : _confirm,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistanceCard extends StatelessWidget {
  const _DistanceCard({
    required this.expanded,
    required this.onExpandedChanged,
    required this.distanceLabel,
    required this.miles,
    required this.onMilesChanged,
    required this.onMilesChangeEnd,
    required this.homeCountryName,
    required this.limitToHomeCountry,
    required this.onLimitChanged,
    required this.onConfirm,
  });

  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;
  final String distanceLabel;
  final double miles;
  final ValueChanged<double> onMilesChanged;
  final ValueChanged<double> onMilesChangeEnd;

  /// Null hides the "Limit to only …" toggle (country unknown).
  final String? homeCountryName;
  final bool limitToHomeCountry;
  final ValueChanged<bool> onLimitChanged;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextFontStyle.headline16w600textDarkStyleSatoshi;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: tap to toggle, swipe down/up to collapse/expand.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onExpandedChanged(!expanded),
            onVerticalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v > 150 && expanded) onExpandedChanged(false);
              if (v < -150 && !expanded) onExpandedChanged(true);
            },
            child: Column(
              children: [
                Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text('Distance', style: labelStyle),
                    const Spacer(),
                    Text(
                      distanceLabel,
                      style: TextFontStyle.headline14w400textMutedStyleSatoshi,
                    ),
                    SizedBox(width: 4.w),
                    AnimatedRotation(
                      turns: expanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 20.r,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(
                    children: [
                      SizedBox(height: 8.h),
                      RingSliderTheme(
                        child: Slider(
                          value: miles,
                          min: kMinDistanceMiles,
                          max: kMaxDistanceMiles,
                          divisions:
                              ((kMaxDistanceMiles - kMinDistanceMiles) / 5)
                                  .round(),
                          onChanged: onMilesChanged,
                          onChangeEnd: onMilesChangeEnd,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      if (homeCountryName != null) ...[
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Limit to only $homeCountryName',
                                style: labelStyle,
                              ),
                            ),
                            Switch.adaptive(
                              value: limitToHomeCountry,
                              onChanged: onLimitChanged,
                              activeTrackColor: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
          SizedBox(height: 16.h),
          AppPrimaryButton(label: 'Confirm', onPressed: onConfirm),
        ],
      ),
    );
  }
}
