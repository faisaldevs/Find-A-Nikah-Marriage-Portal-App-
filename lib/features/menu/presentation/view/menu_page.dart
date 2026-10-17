import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_widgets.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Placeholder link until real profile / invite links exist.
const _appLink = 'https://findanikah.com';

/// Menu tab (Figma "menu" / "menu_invite"): profile header, a chip row
/// (Membership · Invite · Help · Safety & Advice) and the selected chip's
/// content. Help opens its own page; Safety has no design yet.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MenuBloc>()..add(const MenuStarted()),
      child: const _MenuView(),
    );
  }
}

class _MenuView extends StatelessWidget {
  const _MenuView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MenuBloc>().state;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: switch (state.status) {
          MenuStatus.loading when state.profile == null =>
            const AppLoadingView(),
          MenuStatus.failure when state.profile == null => AppErrorView(
            title: 'Couldn’t load your profile',
            retryLabel: 'Try again',
            onRetry: () => context.read<MenuBloc>().add(const MenuStarted()),
          ),
          _ => RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              final bloc = context.read<MenuBloc>()..add(const MenuStarted());
              await bloc.stream.firstWhere(
                (s) => s.status != MenuStatus.loading,
              );
            },
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.w),
              children: [
                const _TopActions(),
                SizedBox(height: 16.w),
                _ProfileHeader(profile: state.profile!),
                SizedBox(height: 40.w),
                _MenuChips(selected: state.tab),
                switch (state.tab) {
                  MenuTab.membership => Padding(
                    padding: EdgeInsets.only(top: 24.w),
                    child: state.membership == null
                        ? const SizedBox.shrink()
                        : _MembershipContent(membership: state.membership!),
                  ),
                  MenuTab.invite => Padding(
                    padding: EdgeInsets.only(top: 30.w),
                    child: const _InviteCard(),
                  ),
                },
              ],
            ),
          ),
        },
      ),
    );
  }
}

/// Settings + notifications, right-aligned in a 58pt bar.
class _TopActions extends StatelessWidget {
  const _TopActions();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MenuCircleButton(
              icon: Assets.icons.menuSettings,
              iconSize: 16,
              semanticLabel: 'Settings',
              onTap: () => context.push<void>(RoutePaths.settings).ignore(),
            ),
            SizedBox(width: 10.w),
            MenuCircleButton(
              icon: Assets.icons.menuBell,
              iconSize: 18,
              semanticLabel: 'Notifications',
              onTap: () => showComingSoon(context, 'Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final MyProfile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
      child: Row(
        children: [
          MenuProfileAvatar(
            photoUrl: profile.mainPhoto,
            completeness: profile.completeness,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.fullName.isEmpty ? 'You' : profile.fullName,
                        overflow: TextOverflow.ellipsis,
                        style: menuText(
                          20,
                          24,
                          weight: FontWeight.w600,
                          color: kMenuGrey800,
                        ),
                      ),
                    ),
                    if (profile.isVerified) ...[
                      SizedBox(width: 6.w),
                      AssetIcon(Assets.icons.menuVerified, size: 20),
                    ],
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  children: [
                    _HeaderChip(
                      label: 'Share',
                      icon: Assets.icons.menuShare,
                      onTap: () => shareText(
                        'Find me on Find A Nikah: $_appLink',
                        subject: 'My Find A Nikah profile',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _HeaderChip(
                      label: 'Edit',
                      icon: Assets.icons.menuEdit,
                      onTap: () =>
                          context.push<void>(RoutePaths.editProfile).ignore(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Share ⇪" / "Edit ✎" outlined mini pills.
class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.w),
        decoration: BoxDecoration(
          border: Border.all(color: kMenuGrey200),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: menuText(11, 20, weight: FontWeight.w500)),
            SizedBox(width: 4.w),
            AssetIcon(icon, size: 11),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrolling chip row; overflows the right edge like Figma.
class _MenuChips extends StatelessWidget {
  const _MenuChips({required this.selected});

  final MenuTab selected;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MenuBloc>();
    return SizedBox(
      height: 30.w,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
        children: [
          _Chip(
            label: 'Membership',
            icon: selected == MenuTab.membership
                ? Assets.icons.menuMembershipActive
                : Assets.icons.menuMembership,
            selected: selected == MenuTab.membership,
            onTap: () => bloc.add(const MenuTabSelected(MenuTab.membership)),
          ),
          SizedBox(width: 12.w),
          _Chip(
            label: 'Invite',
            icon: selected == MenuTab.invite
                ? Assets.icons.menuInviteActive
                : Assets.icons.menuInvite,
            selected: selected == MenuTab.invite,
            onTap: () => bloc.add(const MenuTabSelected(MenuTab.invite)),
          ),
          SizedBox(width: 12.w),
          _Chip(
            label: 'Help',
            icon: Assets.icons.menuHelp,
            selected: false,
            onTap: () => context.push<void>(RoutePaths.menuHelp).ignore(),
          ),
          SizedBox(width: 12.w),
          _Chip(
            label: 'Safety & Advice',
            icon: Assets.icons.menuSafety,
            selected: false,
            onTap: () => showComingSoon(context, 'Safety & Advice'),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: selected ? null : Border.all(color: kMenuGrey300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AssetIcon(icon, size: 18),
            SizedBox(width: 6.w),
            Text(
              label,
              style: menuText(
                13,
                20,
                weight: FontWeight.w500,
                color: selected ? Colors.white : kMenuGrey950,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MembershipContent extends StatelessWidget {
  const _MembershipContent({required this.membership});

  final Membership membership;

  @override
  Widget build(BuildContext context) {
    void upgrade() => showComingSoon(context, 'Upgrading');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
      child: Column(
        children: [
          _PlanCard(membership: membership, onUpgrade: upgrade),
          SizedBox(height: 14.w),
          _BalanceCard(
            background: kMenuPrimary50,
            value: '${membership.likes}',
            label: 'Likes',
            description: 'Get 3x more likes with Gold to keep swiping.',
            action: MenuPillButton(label: 'Get more', onTap: upgrade),
          ),
          SizedBox(height: 16.w),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _BenefitCard(
                    value: '${membership.compliments}',
                    title: 'Compliment',
                    description: 'Message without waiting.',
                    onGetMore: upgrade,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _BenefitCard(
                    value: '${membership.likesInFilters}',
                    title: 'Likes in your\nfilters',
                    description: 'Get more likes.',
                    onGetMore: upgrade,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _BalanceCard(
            background: kMenuGold,
            foreground: Colors.white,
            value: membership.monthlyPrice,
            label: 'Per month',
            description: 'Upgrade to find your partner\nfaster.',
            action: MenuPillButton(
              label: 'Learn more',
              style: MenuPillStyle.white,
              onTap: upgrade,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed "✓ Basic plan / Upgrade now" card.
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.membership, required this.onUpgrade});

  final Membership membership;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRRectPainter(radius: 16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: kMenuGrey50,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AssetIcon(Assets.icons.menuCheck, size: 18),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    membership.planName,
                    style: menuText(
                      16,
                      22,
                      weight: FontWeight.w700,
                      color: kMenuGrey900,
                    ),
                  ),
                ),
                MenuPillButton(label: 'Upgrade now', onTap: onUpgrade),
              ],
            ),
            SizedBox(height: 12.w),
            Text(
              membership.planDescription,
              style: menuText(14, 20, color: kMenuGrey500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.radius});

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.5),
          Radius.circular(radius),
        ),
      );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = kMenuGrey300;
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 8) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter old) => old.radius != radius;
}

/// Big number on the left (80pt column), text + action on the right.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.background,
    required this.value,
    required this.label,
    required this.description,
    required this.action,
    this.foreground,
  });

  final Color background;
  final Color? foreground;
  final String value;
  final String label;
  final String description;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Column(
              children: [
                Text(
                  value,
                  style: menuText(
                    36,
                    44,
                    weight: FontWeight.w700,
                    color: foreground ?? kMenuGrey950,
                  ),
                ),
                SizedBox(height: 5.w),
                Text(
                  label,
                  style: menuText(
                    16,
                    22,
                    weight: FontWeight.w700,
                    color: foreground ?? kMenuGrey900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: menuText(
                    14,
                    20,
                    color: foreground ?? kMenuGrey700,
                  ),
                ),
                SizedBox(height: 12.w),
                action,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey "1 Compliment" / "12 Likes in your filters" cards.
class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.value,
    required this.title,
    required this.description,
    required this.onGetMore,
  });

  final String value;
  final String title;
  final String description;
  final VoidCallback onGetMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kMenuGrey100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: menuText(28, 34, weight: FontWeight.w700)),
          SizedBox(height: 8.w),
          Text(
            title,
            style: menuText(
              16,
              22,
              weight: FontWeight.w700,
              color: kMenuGrey900,
            ),
          ),
          SizedBox(height: 8.w),
          Text(description, style: menuText(14, 20, color: kMenuGrey500)),
          SizedBox(height: 8.w),
          const Spacer(),
          MenuPillButton(
            label: 'Get more',
            style: MenuPillStyle.soft,
            onTap: onGetMore,
          ),
        ],
      ),
    );
  }
}

/// Figma "menu_invite": pink "Share the love" card.
class _InviteCard extends StatelessWidget {
  const _InviteCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: kMenuPrimary50,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share the love',
              style: menuText(
                20,
                20,
                weight: FontWeight.w700,
                color: kMenuGrey700,
              ),
            ),
            SizedBox(height: 14.w),
            Text(
              'Know someone who’s still looking?\n'
              'Invite them to join Find a Nikah',
              style: menuText(16, 24, color: kMenuGrey700),
            ),
            SizedBox(height: 18.w),
            MenuPillButton(
              label: 'Send invite',
              fontSize: 16,
              onTap: () => shareText(
                'Assalamu alaikum! I’m using Find A Nikah to find a spouse — '
                'join me: $_appLink',
                subject: 'Join me on Find A Nikah',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
