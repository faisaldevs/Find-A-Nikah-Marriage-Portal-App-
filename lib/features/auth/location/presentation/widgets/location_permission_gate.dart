import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../state/user_location_provider.dart';

enum _Access { checking, granted, denied, serviceOff }

/// Location is mandatory on the Location screen: asks for permission on
/// arrival and only builds [child] once it's granted.
///
/// Denied → non-dismissible "Location is required" popup with
/// "Open settings" / "Go back". Android only lets the app show the system
/// prompt once or twice before it stops appearing, so the popup sends the
/// user to Settings instead of re-asking. Coming back to the app re-checks
/// and closes the popup if access was granted.
class LocationPermissionGate extends ConsumerStatefulWidget {
  const LocationPermissionGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LocationPermissionGate> createState() =>
      _LocationPermissionGateState();
}

class _LocationPermissionGateState
    extends ConsumerState<LocationPermissionGate> {
  _Access _access = _Access.checking;
  late final AppLifecycleListener _lifecycle;

  /// True while a check (incl. the system prompt) is in flight. The system
  /// prompt itself pauses/resumes the app on Android, which would otherwise
  /// trigger a premature re-check.
  bool _busy = false;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () => _check(request: false));
    WidgetsBinding.instance.addPostFrameCallback((_) => _check(request: true));
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  static Future<_Access> _resolve({required bool request}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _Access.serviceOff;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && request) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always
          ? _Access.granted
          : _Access.denied;
    } catch (_) {
      // Plugin unavailable (e.g. tests) — treat as not granted.
      return _Access.denied;
    }
  }

  Future<void> _check({required bool request}) async {
    if (_busy) return;
    _busy = true;
    final access = await _resolve(request: request);
    _busy = false;
    if (!mounted) return;

    if (access == _Access.granted) {
      if (_access != _Access.granted) {
        // Re-resolve the real position — an earlier read may have cached the
        // fallback centre while permission was missing.
        ref.invalidate(userLocationProvider);
      }
      setState(() => _access = access);
      if (_dialogOpen) Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    setState(() => _access = access);
    _showRequiredDialog();
  }

  Future<void> _showRequiredDialog() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final goBack = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) =>
          _LocationRequiredDialog(servicesOff: _access == _Access.serviceOff),
    );
    _dialogOpen = false;
    if (goBack == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_access == _Access.granted) return widget.child;
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: _access == _Access.checking
            ? const CircularProgressIndicator(color: AppColors.primaryColor)
            : Icon(
                Icons.location_off_outlined,
                size: 48.r,
                color: AppColors.textMuted,
              ),
      ),
    );
  }
}

/// Pops `true` for "Go back". "Open settings" leaves it open — the gate
/// closes it on resume once access is granted.
class _LocationRequiredDialog extends StatelessWidget {
  const _LocationRequiredDialog({required this.servicesOff});

  final bool servicesOff;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Location is required',
          style: TextFontStyle.headline18w700StyleSatoshi,
        ),
        content: Text(
          servicesOff
              ? 'Location services are turned off. Turn them on in Settings '
                    'so we can show matches near you.'
              : 'Find A Nikah needs your location to show matches near you. '
                    'Please allow location access in Settings to continue.',
          style: TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Go back',
              style: TextFontStyle.headline15w600textDarkStyleSatoshi,
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: servicesOff
                ? Geolocator.openLocationSettings
                : Geolocator.openAppSettings,
            child: Text(
              'Open settings',
              style: TextFontStyle.headline15w600StyleSatoshi,
            ),
          ),
        ],
      ),
    );
  }
}
