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

  /// Set by "Open settings": on return, re-check *with* a prompt. Android's
  /// "Ask every time" leaves no lasting grant, so a plain check stayed
  /// denied and the dialog never closed (audit #41). Not set for ordinary
  /// resumes — the system prompt itself pauses/resumes the app.
  bool _awaitingSettings = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserLocationBloc>();
    // _lifecycle = AppLifecycleListener(
    //   onResume: () =>
    //       bloc.add(const LocationAccessCheckRequested(request: false)),
    // );
    _lifecycle = AppLifecycleListener(
      onResume: () {
        bloc.add(LocationAccessCheckRequested(request: _awaitingSettings));
        _awaitingSettings = false;
      },
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
        // onOpenSettings: () => bloc.add(const LocationSettingsRequested()),
        onOpenSettings: () {
          _awaitingSettings = true;
          bloc.add(const LocationSettingsRequested());
        },
        onTryAgain: () =>
            bloc.add(const LocationAccessCheckRequested(request: true)),
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
    required this.onTryAgain,
  });

  final bool servicesOff;
  final VoidCallback onOpenSettings;

  /// Re-asks (shows the system prompt again while Android still allows it).
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    // return PopScope(
    // canPop: false,
    // child: AlertDialog(
    // backgroundColor: Colors.white,
    // shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.circular(20.r),
    // ),
    // title: Text(
    // 'Location is required',
    // style: TextFontStyle.headline18w700StyleSatoshi,
    // ),
    // content: Text(
    // servicesOff
    // ? 'Location services are turned off. Turn them on in Settings '
    // 'so we can show matches near you.'
    // : 'Find A Nikah needs your location to show matches near you. '
    // 'Please allow location access in Settings to continue.',
    // style: TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
    // height: 1.4,
    // ),
    // ),
    // actions: [
    // TextButton(
    // onPressed: () => Navigator.of(context).pop(true),
    // child: Text(
    // 'Go back',
    // style: TextFontStyle.headline15w600textDarkStyleSatoshi,
    // ),
    // ),
    // TextButton(
    // onPressed: onTryAgain,
    // child: Text(
    // 'Try again',
    // style: TextFontStyle.headline15w600textDarkStyleSatoshi.copyWith(
    // color: AppColors.primaryColor,
    // ),
    // ),
    // ),
    // FilledButton(
    // style: FilledButton.styleFrom(
    // backgroundColor: AppColors.primaryColor,
    // ),
    // onPressed: onOpenSettings,
    // child: Text(
    // 'Open settings',
    // style: TextFontStyle.headline15w600StyleSatoshi,
    // ),
    // ),
    // ],
    // ),
    // );
    // Title row with a close (✕ = go back) at the far end; two equal
    // buttons below: Open settings · Refresh (re-asks for permission).
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Location is required',
                      style: TextFontStyle.headline18w700StyleSatoshi,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(true),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close,
                        size: 22.r,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                servicesOff
                    ? 'Location services are turned off. Turn them on in '
                          'Settings so we can show matches near you.'
                    : 'Find A Nikah needs your location to show matches near '
                          'you. Please allow location access to continue.',
                style: TextFontStyle.headline14w400textMutedStyleSatoshi
                    .copyWith(height: 1.4),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(44.h),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        side: const BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: onOpenSettings,
                      child: Text(
                        'Open settings',
                        maxLines: 1,
                        softWrap: false,
                        style: TextFontStyle.headline15w600textDarkStyleSatoshi
                            .copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size.fromHeight(44.h),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: onTryAgain,
                      child: Text(
                        'Refresh',
                        style: TextFontStyle.headline15w600StyleSatoshi,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
