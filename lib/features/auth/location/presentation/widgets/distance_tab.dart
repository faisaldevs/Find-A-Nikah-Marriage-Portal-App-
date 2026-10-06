import 'dart:math' as math;
import 'package:find_a_nikah/core/constants/text_font_style.dart';

import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants/countries.dart';
import '../../../../../core/ui/components/app_primary_button.dart';
import '../../../../../core/filters/discovery_filters.dart';
import '../../../../../core/filters/discovery_filters_controller.dart';
import '../state/user_location_provider.dart';
import 'ring_slider_theme.dart';

const _metersPerMile = 1609.344;

/// "Distance" tab of the Location screen: full-bleed OpenStreetMap with a
/// radius circle around the user, and a floating card holding the distance
/// slider, the "Limit to only `<country>`" toggle and Confirm.
class DistanceTab extends ConsumerStatefulWidget {
  const DistanceTab({super.key, required this.onConfirmed});

  final VoidCallback onConfirmed;

  @override
  ConsumerState<DistanceTab> createState() => _DistanceTabState();
}

class _DistanceTabState extends ConsumerState<DistanceTab> {
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
    final saved = ref.read(discoveryFiltersControllerProvider);
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

  String get _homeCountryName => allCountries
      .firstWhere(
        (c) => c.code == kHomeCountryCode,
        orElse: () => suggestedCountries.first,
      )
      .name;

  /// Re-frames the map so the radius circle fills the viewport (or zooms
  /// out to a country-scale view when "Everywhere").
  void _fitToRadius(LatLng center) {
    if (!_mapReady) return;
    if (_isEverywhere) {
      _mapController.move(center, 5);
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
    ref
        .read(discoveryFiltersControllerProvider.notifier)
        .setDistanceFilter(
          miles: _miles,
          limitToHomeCountry: _limitToHomeCountry,
        );
    widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final center = ref.watch(userLocationProvider).value ?? kFallbackCenter;

    // Re-frame once the real position arrives (initial build uses fallback).
    ref.listen<AsyncValue<LatLng>>(userLocationProvider, (_, next) {
      final resolved = next.value;
      if (resolved != null) _fitToRadius(resolved);
    });

    return Stack(
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
              onMapReady: () {
                _mapReady = true;
                _fitToRadius(center);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.findanikah.app',
                maxNativeZoom: 19,
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
            homeCountryName: _homeCountryName,
            limitToHomeCountry: _limitToHomeCountry,
            onLimitChanged: (v) => setState(() => _limitToHomeCountry = v),
            onConfirm: _confirm,
          ),
        ),
      ],
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
  final String homeCountryName;
  final bool limitToHomeCountry;
  final ValueChanged<bool> onLimitChanged;
  final VoidCallback onConfirm;

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
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Limit to only $homeCountryName',
                            style: labelStyle,
                          ),
                          Switch.adaptive(
                            value: limitToHomeCountry,
                            onChanged: onLimitChanged,
                            activeTrackColor: AppColors.primaryColor,
                          ),
                        ],
                      ),
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

  // Previous always-expanded card body (before the collapsible header):
  // return Container(
  //   padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(24.r),
  //     boxShadow: [
  //       BoxShadow(
  //         color: Colors.black.withValues(alpha: 0.12),
  //         blurRadius: 24,
  //         offset: const Offset(0, 6),
  //       ),
  //     ],
  //   ),
  //   child: Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('Distance', style: labelStyle),
  //           Text(
  //             distanceLabel,
  //             style: TextFontStyle.headline14w400textMutedStyleSatoshi,
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 8.h),
  //       RingSliderTheme(
  //         child: Slider(
  //           value: miles,
  //           min: kMinDistanceMiles,
  //           max: kMaxDistanceMiles,
  //           divisions: ((kMaxDistanceMiles - kMinDistanceMiles) / 5).round(),
  //           onChanged: onMilesChanged,
  //           onChangeEnd: onMilesChangeEnd,
  //           padding: EdgeInsets.zero,
  //         ),
  //       ),
  //       SizedBox(height: 16.h),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('Limit to only $homeCountryName', style: labelStyle),
  //           Switch.adaptive(
  //             value: limitToHomeCountry,
  //             onChanged: onLimitChanged,
  //             activeTrackColor: AppColors.primaryColor,
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 16.h),
}
