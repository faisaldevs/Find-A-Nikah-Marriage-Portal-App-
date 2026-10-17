import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_widgets.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Figma "menu_help": pink header with a question search, then support
/// tickets and "Need more help?" links. Inside the Menu tab (bottom nav
/// stays). Search and every destination are "Coming soon" until the
/// support backend exists.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status-bar icons over the pink header.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.only(bottom: 24.w),
          children: [
            const _Header(),
            SizedBox(height: 30.w),
            _Section(
              title: 'My support tickets',
              cards: [
                _HelpCard(
                  icon: Assets.icons.menuFileText,
                  text:
                      'You can see your ongoing reports and\n'
                      'request from here.',
                  lineHeight: 1.6,
                  onTap: () => showComingSoon(context, 'Support tickets'),
                ),
              ],
            ),
            SizedBox(height: 50.w),
            _Section(
              title: 'Need more help?',
              cards: [
                _HelpCard(
                  icon: Assets.icons.menuFlag,
                  text: 'Report someone',
                  onTap: () => showComingSoon(context, 'Reporting'),
                ),
                _HelpCard(
                  icon: Assets.icons.menuHeadphones,
                  text: 'Contact support',
                  onTap: () => showComingSoon(context, 'Contact support'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      // Figma: 270 tall from the top of the screen (status bar included).
      constraints: BoxConstraints(minHeight: 270.w),
      padding: EdgeInsets.fromLTRB(20.w, top + 40.w - 24.w, 20.w, 20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: MenuCircleButton(
              icon: Assets.icons.menuBackWhite,
              iconSize: 18,
              borderColor: Colors.white,
              semanticLabel: 'Back',
              onTap: () => context.pop(),
            ),
          ),
          SizedBox(height: 30.w),
          Text(
            'What would you like help\nwith today?',
            textAlign: TextAlign.center,
            style: menuText(
              24,
              28,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40.w),
          const _SearchField(),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kMenuGrey200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => showComingSoon(context, 'Help search'),
              style: menuText(
                14,
                17,
                weight: FontWeight.w500,
                color: kMenuGrey800,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Search for a question',
                hintStyle: menuText(
                  14,
                  17,
                  weight: FontWeight.w500,
                  color: kMenuGrey800,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          AssetIcon(Assets.icons.menuSearch, size: 20),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.cards});

  final String title;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: menuText(18, 25.2, weight: FontWeight.w700)),
          for (final card in cards) ...[SizedBox(height: 14.w), card],
        ],
      ),
    );
  }
}

/// Outlined card: pink icon tile · text · chevron.
class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.icon,
    required this.text,
    required this.onTap,
    this.lineHeight = 1.7,
  });

  final String icon;
  final String text;
  final double lineHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kMenuBorderLine),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: kMenuPrimary50,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: AssetIcon(icon, size: 16),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  text,
                  style: menuText(
                    12,
                    12 * lineHeight,
                    weight: FontWeight.w500,
                    color: kMenuTextBase,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              AssetIcon(Assets.icons.menuHelpChevron, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
