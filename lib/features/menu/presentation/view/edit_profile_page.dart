import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/bloc/edit_profile_bloc.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_format.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_widgets.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Max photo slots — mirrors onboarding's limit (features can't share it).
const _maxPhotos = 5;

/// Figma "menu_edit": Preview / Edit tabs over the member's profile in
/// sections. Rows show real values from the profile; editing them waits
/// for the profile API, so every row is "Coming soon" for now (Preview
/// has no design yet either). The gold badge toggle is live.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileBloc>()..add(const EditProfileStarted()),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listenWhen: (prev, next) =>
            next.failure != null &&
            prev.failure != next.failure &&
            next.status == EditProfileStatus.ready,
        listener: (context, state) => showFailureToast(context, state.failure!),
        child: const _EditProfileView(),
      ),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditProfileBloc>().state;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TitleBar(profile: state.profile),
            _Tabs(selected: state.tab),
            Expanded(
              child: switch (state.status) {
                EditProfileStatus.loading => const AppLoadingView(),
                EditProfileStatus.failure => AppErrorView(
                  title: 'Couldn’t load your profile',
                  retryLabel: 'Try again',
                  onRetry: () => context.read<EditProfileBloc>().add(
                    const EditProfileStarted(),
                  ),
                ),
                EditProfileStatus.ready => switch (state.tab) {
                  EditProfileTab.edit => _EditTab(
                    profile: state.profile!,
                    settings: state.settings,
                  ),
                  EditProfileTab.preview => const AppEmptyView(
                    title: 'Profile preview',
                    message: 'See how others see your profile — coming soon.',
                  ),
                },
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 62pt bar: round close button left, name + verified tick centred.
class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.profile});

  final MyProfile? profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
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
            child: Semantics(
              button: true,
              label: 'Close',
              child: InkWell(
                onTap: () => context.pop(),
                customBorder: const CircleBorder(),
                child: AssetIcon(Assets.icons.menuClose, size: 38),
              ),
            ),
          ),
          if (p != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      p.fullName,
                      overflow: TextOverflow.ellipsis,
                      style: menuText(20, 28, weight: FontWeight.w700),
                    ),
                  ),
                  if (p.isVerified) ...[
                    SizedBox(width: 6.w),
                    AssetIcon(Assets.icons.menuVerifiedSmall, size: 18),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 54pt Preview / Edit tabs; active = brand text + 2pt brand underline.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected});

  final EditProfileTab selected;

  @override
  Widget build(BuildContext context) {
    Widget tab(EditProfileTab t, String label) {
      final active = t == selected;
      return Expanded(
        child: InkWell(
          onTap: () =>
              context.read<EditProfileBloc>().add(EditProfileTabSelected(t)),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: active
                  ? const Border(
                      bottom: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    )
                  : null,
            ),
            child: Text(
              label,
              style: menuText(
                18,
                25.2,
                weight: FontWeight.w700,
                color: active ? AppColors.primaryColor : kMenuGrey500,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 54.w,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kMenuGrey200)),
      ),
      child: Row(
        children: [
          tab(EditProfileTab.preview, 'Preview'),
          tab(EditProfileTab.edit, 'Edit'),
        ],
      ),
    );
  }
}

/// Pink prompt shown in place of a missing value.
const _completePrompt = 'Complete your profile';

class _EditTab extends StatelessWidget {
  const _EditTab({required this.profile, required this.settings});

  final MyProfile profile;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final value = menuText(14, 20, color: kMenuGrey400);
    final prompt = menuText(14, 20, color: AppColors.primaryColor);

    /// A row showing [text], or the pink [placeholder] when it's missing.
    MenuInfoRow row(
      String title,
      String? text, {
      String placeholder = _completePrompt,
      Widget? titleBadge,
    }) => MenuInfoRow(
      title: title,
      titleBadge: titleBadge,
      value: text ?? placeholder,
      valueStyle: text == null ? prompt : value,
      trailing: AssetIcon(Assets.icons.menuChevronRight, size: 20),
      onTap: () => showComingSoon(context, 'Editing ${title.toLowerCase()}'),
    );

    Widget section(String title, List<MenuInfoRow> rows, {Widget? tag}) =>
        Column(
          children: [
            MenuSectionTitle(title, fontSize: 22, tag: tag),
            SizedBox(height: 24.w),
            MenuRowGroup(rows: rows, gap: 24),
          ],
        );

    const newTag = MenuTag('New');

    return ListView(
      padding: EdgeInsets.only(top: 24.w, bottom: 40.w),
      children: [
        section(
          'Complete profile',
          tag: MenuTag('${p.completeness}%'),
          [
            row(
              'Family involvement',
              null,
              placeholder: 'When do you want to involve family?',
            ),
            row(
              'Living arrangements',
              null,
              placeholder: 'Who do you want to live with?',
            ),
            MenuInfoRow(
              title: 'ID Verified badge',
              titleBadge: AssetIcon(Assets.icons.menuIdBadge, size: 16),
              value:
                  'Verify your age and identity to receive more\n'
                  'likes and matches',
              hint: p.isVerified ? null : _completePrompt,
              hintStyle: prompt,
              trailing: AssetIcon(Assets.icons.menuChevronRight, size: 20),
              onTap: () => showComingSoon(context, 'ID verification'),
            ),
            row('Tagline', null, placeholder: 'Add a fun introduction'),
            row(
              'Job title',
              MenuFormat.text(p.profession),
              placeholder: 'What do you do for work?',
            ),
            row('Employer', null, placeholder: 'What do you do for work?'),
          ],
        ),
        SizedBox(height: 60.w),
        _PhotosSection(photos: p.photos),
        SizedBox(height: 60.w),
        section('Profile features', [
          MenuInfoRow(
            title: 'Gold member badge',
            value: 'Show Gold member badge on profile',
            trailing: MenuToggle(
              value: settings.showGoldBadge,
              semanticLabel: 'Show Gold member badge',
              onChanged: (v) => context.read<EditProfileBloc>().add(
                GoldBadgeToggled(visible: v),
              ),
            ),
          ),
        ]),
        SizedBox(height: 60.w),
        section('Location', tag: newTag, [
          row('Current location', MenuFormat.text(p.currentLocation)),
          row('Grew up in', MenuFormat.text(p.grewUpIn)),
        ]),
        SizedBox(height: 60.w),
        section('About me', [
          row('Height', MenuFormat.height(p.heightCm)),
          row('Marital status', MenuFormat.token(p.maritalStatus)),
          row('Children', MenuFormat.children(p.hasChildren)),
          row('Bio', MenuFormat.text(p.bio)),
        ]),
        SizedBox(height: 60.w),
        section('Marriage intentions', tag: newTag, [
          row('Chatting', MenuFormat.token(p.gettingToKnow)),
          row('Marriage', MenuFormat.token(p.marriageTimeline)),
        ]),
        SizedBox(height: 60.w),
        section('Future plans', [
          row('Relocation plans', MenuFormat.relocation(p.relocateAbroad)),
          row('Family plans', null),
          row('Polygamy plan', null),
        ]),
        SizedBox(height: 60.w),
        section('Religiosity', [
          row('Sect', null),
          row('Born Muslim', MenuFormat.yesNo(p.bornMuslim)),
          row('Religious practice', MenuFormat.token(p.religiousPractice)),
          row(
            'Faith',
            MenuFormat.list(p.faith),
            titleBadge: const MenuTag('New', fontSize: 11),
          ),
          row('Diet', MenuFormat.diet(p.halalFood)),
          row('Alcohol', MenuFormat.alcohol(p.alcohol)),
          row('Smoking', MenuFormat.smoking(p.smoking)),
        ]),
        SizedBox(height: 60.w),
        section('Interests and Personality', [
          row('Interests', MenuFormat.list(p.interests)),
          row('Personality', MenuFormat.list(p.personality)),
        ]),
        SizedBox(height: 60.w),
        section('Education and career', [
          row('Education', MenuFormat.token(p.education)),
          row('Profession', MenuFormat.text(p.profession)),
        ]),
        SizedBox(height: 60.w),
        section('Languages and ethnicity', [
          row('Ethnicity', MenuFormat.list(p.ethnicity)),
          row('Nationality', MenuFormat.list(p.nationality)),
          row('Languages', MenuFormat.list(p.languages)),
        ]),
      ],
    );
  }
}

/// 3-column grid (14pt gaps, 140pt tall): photos, dashed "+" slots, and the
/// "Photo guidelines" tile last.
class _PhotosSection extends StatelessWidget {
  const _PhotosSection({required this.photos});

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    final slots = [
      for (var i = 0; i < _maxPhotos; i++) i < photos.length ? photos[i] : null,
    ];
    final cells = <Widget>[
      for (final photo in slots)
        photo == null
            ? _AddSlot(onTap: () => showComingSoon(context, 'Editing photos'))
            : ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: AppPhoto(photo),
              ),
      _GuidelinesSlot(
        onTap: () => showComingSoon(context, 'Photo guidelines'),
      ),
    ];
    return Column(
      children: [
        const MenuSectionTitle('Photos', fontSize: 22),
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              for (var r = 0; r < 2; r++) ...[
                if (r > 0) SizedBox(height: 14.w),
                SizedBox(
                  height: 140.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var c = 0; c < 3; c++) ...[
                        if (c > 0) SizedBox(width: 14.w),
                        Expanded(child: cells[r * 3 + c]),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AddSlot extends StatelessWidget {
  const _AddSlot({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: CustomPaint(
        painter: _DashedBorderPainter(radius: 8.r),
        child: Center(child: AssetIcon(Assets.icons.menuPlus, size: 18)),
      ),
    );
  }
}

class _GuidelinesSlot extends StatelessWidget {
  const _GuidelinesSlot({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AssetIcon(Assets.icons.menuInfoCircle, size: 18),
          SizedBox(height: 12.w),
          Text(
            'Photo\nguidelines',
            textAlign: TextAlign.center,
            style: menuText(12, 15.6, weight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.radius});

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
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.radius != radius;
}
