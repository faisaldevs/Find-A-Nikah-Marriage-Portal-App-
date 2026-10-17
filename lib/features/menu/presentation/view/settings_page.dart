import 'dart:async';

import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/bloc/settings_bloc.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_format.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_widgets.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Figma "settings": personal info, notifications, app settings, privacy
/// and account. Toggles are live (saved via [SettingsBloc]); rows whose
/// screens aren't designed yet show "Coming soon".
class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.onSignOut, super.key});

  /// Wired by the router — features don't import the auth feature.
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..add(const SettingsStarted()),
      child: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (prev, next) =>
            next.failure != null && prev.failure != next.failure,
        listener: (context, state) => showFailureToast(context, state.failure!),
        child: _SettingsView(onSignOut: onSignOut),
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsBloc>().state;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TitleBar(title: 'Settings'),
            Expanded(
              child: switch (state.status) {
                SettingsStatus.loading => const AppLoadingView(),
                SettingsStatus.failure => AppErrorView(
                  title: 'Couldn’t load your settings',
                  retryLabel: 'Try again',
                  onRetry: () => context.read<SettingsBloc>().add(
                    const SettingsStarted(),
                  ),
                ),
                SettingsStatus.ready => ListView(
                  padding: EdgeInsets.only(top: 24.w, bottom: 40.w),
                  children: [
                    _PersonalInfo(profile: state.profile!),
                    SizedBox(height: 60.w),
                    _Notifications(settings: state.settings),
                    SizedBox(height: 60.w),
                    _AppSettings(settings: state.settings),
                    SizedBox(height: 60.w),
                    _Privacy(settings: state.settings),
                    SizedBox(height: 60.w),
                    _Account(onSignOut: onSignOut),
                  ],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 62pt bar: round back button left, centred title (Satoshi Bold 20/28).
class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Full width, or the Stack shrinks to the title and the button
      // lands on top of it.
      width: double.infinity,
      height: 62.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: kMenuGutter,
            child: MenuCircleButton(
              icon: Assets.icons.menuBack,
              iconSize: 18,
              semanticLabel: 'Back',
              onTap: () => context.pop(),
            ),
          ),
          Text(title, style: menuText(20, 28, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}

Widget _icon(String asset) => AssetIcon(asset, size: 20);

void _toggle(
  BuildContext context,
  AppSettings Function(AppSettings s) update,
) => context.read<SettingsBloc>().add(SettingsChanged(update));

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<MenuInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuSectionTitle(title),
        SizedBox(height: 16.w),
        MenuRowGroup(rows: rows),
      ],
    );
  }
}

class _PersonalInfo extends StatelessWidget {
  const _PersonalInfo({required this.profile});

  final MyProfile profile;

  @override
  Widget build(BuildContext context) {
    void soon(String what) => showComingSoon(context, what);
    void locked(String why) => CustomToast.showInfo(context, why);
    return _Section(
      title: 'Personal Information',
      rows: [
        MenuInfoRow(
          title: 'First name',
          value: MenuFormat.text(profile.firstName) ?? '—',
          hint: 'Can only be edited every 6 months',
          trailing: _icon(Assets.icons.menuLock),
          onTap: () => locked('Your name can only be edited every 6 months'),
        ),
        MenuInfoRow(
          title: 'Date of birth',
          value: MenuFormat.date(profile.dateOfBirth) ?? '—',
          hint: 'Can only be updated once',
          trailing: _icon(Assets.icons.menuLock),
          onTap: () => locked('Your date of birth can only be updated once'),
        ),
        MenuInfoRow(
          title: 'Gender',
          value: MenuFormat.token(profile.gender) ?? '—',
          trailing: _icon(Assets.icons.menuChevronRight),
          onTap: () => soon('Changing gender'),
        ),
        MenuInfoRow(
          title: 'Email address',
          value: MenuFormat.text(profile.email) ?? '—',
          trailing: _icon(Assets.icons.menuChevronRight),
          onTap: () => soon('Changing email'),
        ),
        MenuInfoRow(
          title: 'Phone number',
          value: MenuFormat.text(profile.phone) ?? '—',
          trailing: _icon(Assets.icons.menuChevronRight),
          onTap: () => soon('Changing phone number'),
        ),
      ],
    );
  }
}

class _Notifications extends StatelessWidget {
  const _Notifications({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Notifications',
      rows: [
        MenuInfoRow(
          title: 'Notifications',
          value:
              'Enable notifications to stay up to date\n'
              'with new likes, matches and messages',
          trailing: MenuToggle(
            value: settings.notifications,
            semanticLabel: 'Notifications',
            onChanged: (v) =>
                _toggle(context, (s) => s.copyWith(notifications: v)),
          ),
        ),
        MenuInfoRow(
          title: 'Chat message preview',
          value:
              'Display a preview of the message when\n'
              'you receive a notification',
          trailing: MenuToggle(
            value: settings.chatMessagePreview,
            semanticLabel: 'Chat message preview',
            onChanged: (v) =>
                _toggle(context, (s) => s.copyWith(chatMessagePreview: v)),
          ),
        ),
      ],
    );
  }
}

class _AppSettings extends StatelessWidget {
  const _AppSettings({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    void soon(String what) => showComingSoon(context, what);
    return _Section(
      title: 'App Settings',
      rows: [
        MenuInfoRow(
          title: 'Language',
          value: settings.language,
          trailing: _icon(Assets.icons.menuLanguage),
          onTap: () => soon('Changing language'),
        ),
        MenuInfoRow(
          title: 'Restore purchases',
          value: 'Restore any purchases or subscriptions',
          trailing: _icon(Assets.icons.menuCreditCard),
          onTap: () => soon('Restoring purchases'),
        ),
        MenuInfoRow(
          title: 'Passcode',
          value:
              'For additional privacy, require a passcode\n'
              'every time you open to the Find a Nikah App',
          trailing: _icon(Assets.icons.menuLock),
          onTap: () => soon('Passcode'),
        ),
        MenuInfoRow(
          title: 'Chaperone',
          value:
              'For your peace of mind you can add a\n'
              'chaperone or wali to automatically receive\n'
              'copies of your chats',
          trailing: _icon(Assets.icons.menuUsers),
          onTap: () => soon('Chaperone'),
        ),
      ],
    );
  }
}

class _Privacy extends StatelessWidget {
  const _Privacy({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    void soon(String what) => showComingSoon(context, what);
    return _Section(
      title: 'Privacy',
      rows: [
        MenuInfoRow(
          title: 'Who can see my marriage profile',
          value:
              'Select if your marriage profile is invisible\n'
              'to people you haven’t liked or hidden to\n'
              'everyone',
          trailing: _icon(Assets.icons.menuEyeSlash),
          onTap: () => soon('Profile visibility'),
        ),
        MenuInfoRow(
          title: 'My marriage profile sharing link',
          value:
              'Allow your marriage profile to be shared\n'
              'via a link. Hidden photos stay hidden.',
          trailing: MenuToggle(
            value: settings.profileSharingLink,
            semanticLabel: 'Marriage profile sharing link',
            onChanged: (v) =>
                _toggle(context, (s) => s.copyWith(profileSharingLink: v)),
          ),
        ),
        MenuInfoRow(
          title: 'Block social chat requests from women',
          value:
              'Prevent women from sending a chat\n'
              'request to your social profile',
          trailing: MenuToggle(
            value: settings.blockSocialRequestsFromWomen,
            semanticLabel: 'Block social chat requests from women',
            onChanged: (v) => _toggle(
              context,
              (s) => s.copyWith(blockSocialRequestsFromWomen: v),
            ),
          ),
        ),
        MenuInfoRow(
          title: 'Profiles I’ve blocked',
          value: 'View and manage everyone you have blocked',
          trailing: _icon(Assets.icons.menuUserSquare),
          onTap: () => soon('Blocked profiles'),
        ),
        MenuInfoRow(
          title: 'Block my phone contacts',
          value:
              'Block people from your contact list on your\n'
              'phone, so they can’t see you on Find A Nikah',
          trailing: _icon(Assets.icons.menuBook),
          onTap: () => soon('Blocking phone contacts'),
        ),
      ],
    );
  }
}

class _Account extends StatelessWidget {
  const _Account({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Account',
      rows: [
        MenuInfoRow(
          title: 'Manage account',
          value:
              'Start again with your marriage search, take a\n'
              'break or delete your marriage profile',
          trailing: _icon(Assets.icons.menuUserSimple),
          onTap: () => unawaited(_showManageAccount(context)),
        ),
      ],
    );
  }

  /// Not in Figma: the actions "Manage account" describes, plus Sign out
  /// (the design has no other place for it).
  Future<void> _showManageAccount(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        Widget action(
          String label, {
          required VoidCallback onTap,
          Color color = kMenuGrey950,
          IconData? icon,
        }) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: kMenuGutter),
          leading: icon == null ? null : Icon(icon, color: color),
          title: Text(
            label,
            style: menuText(16, 22, weight: FontWeight.w700, color: color),
          ),
          onTap: onTap,
        );
        void soon(String what) {
          Navigator.of(sheetContext).pop();
          showComingSoon(context, what);
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                action(
                  'Start again',
                  icon: Icons.refresh_rounded,
                  onTap: () => soon('Starting again'),
                ),
                action(
                  'Take a break',
                  icon: Icons.pause_circle_outline_rounded,
                  onTap: () => soon('Taking a break'),
                ),
                action(
                  'Delete marriage profile',
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.errorColor,
                  onTap: () => soon('Deleting your profile'),
                ),
                const Divider(height: 1),
                action(
                  'Sign out',
                  icon: Icons.logout_rounded,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSignOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
