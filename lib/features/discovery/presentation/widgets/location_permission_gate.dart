import 'dart:async';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/user_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Location is mandatory on the Location page: asks for permission on
/// arrival and only builds [child] once it's granted.
///
/// Denied → non-dismissible "Location is required" popup with
/// "Open settings" / "Go back". Android only lets the app show the system
/// prompt once or twice before it stops appearing, so the popup sends the
/// user to Settings instead of re-asking. Coming back to the app re-checks
/// and closes the popup if access was granted.
class LocationPermissionGate extends StatefulWidget {
  const LocationPermissionGate({required this.child, super.key});

  final Widget child;

  @override
  State<LocationPermissionGate> createState() => _LocationPermissionGateState();
}

class _LocationPermissionGateState extends State<LocationPermissionGate> {
  late final AppLifecycleListener _lifecycle;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserLocationBloc>();
    _lifecycle = AppLifecycleListener(
      onResume: () =>
          bloc.add(const LocationAccessCheckRequested(request: false)),
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => bloc.add(const LocationAccessCheckRequested(request: true)),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _onAccess(BuildContext context, LocationAccess access) {
    if (access == LocationAccess.granted) {
      if (_dialogOpen) Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    if (access != LocationAccess.checking) {
      unawaited(_showRequiredDialog(access));
    }
  }

  Future<void> _showRequiredDialog(LocationAccess access) async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final bloc = context.read<UserLocationBloc>();
    final goBack = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LocationRequiredDialog(
        servicesOff: access == LocationAccess.serviceOff,
        onOpenSettings: () => bloc.add(const LocationSettingsRequested()),
      ),
    );
    _dialogOpen = false;
    if ((goBack ?? false) && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserLocationBloc, UserLocationState>(
      listenWhen: (prev, next) => prev.access != next.access,
      listener: (context, state) => _onAccess(context, state.access),
      buildWhen: (prev, next) => prev.access != next.access,
      builder: (context, state) {
        if (state.access == LocationAccess.granted) return widget.child;
        return ColoredBox(
          color: Colors.white,
          child: Center(
            child: state.access == LocationAccess.checking
                ? const CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  )
                : Icon(
                    Icons.location_off_outlined,
                    size: 48.r,
                    color: AppColors.textMuted,
                  ),
          ),
        );
      },
    );
  }
}

/// Pops `true` for "Go back". "Open settings" leaves it open — the gate
/// closes it on resume once access is granted.
class _LocationRequiredDialog extends StatelessWidget {
  const _LocationRequiredDialog({
    required this.servicesOff,
    required this.onOpenSettings,
  });

  final bool servicesOff;
  final VoidCallback onOpenSettings;

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
            onPressed: onOpenSettings,
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
