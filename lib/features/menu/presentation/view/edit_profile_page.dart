import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/bloc/edit_profile_bloc.dart';
import 'package:find_a_nikah/features/menu/presentation/editing/profile_options.dart';
import 'package:find_a_nikah/features/menu/presentation/view/profile_field_editor_page.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_format.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_widgets.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/profile_photo.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/profile_preview.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Max photo slots — mirrors onboarding's limit (features can't share it).
const _maxPhotos = 5;

/// Figma "menu_edit": Preview / Edit tabs over the member's profile in
/// sections. Each row opens its own field page (Muzz-style) that saves
/// through `PATCH /v1/profiles/me`; tapping a photo offers "Use as main
/// photo" / "Delete". Preview shows the profile as other members see it.
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
                    photoBusy: state.photoBusy,
                  ),
                  EditProfileTab.preview => MyProfilePreview(
                    profile: state.profile!,
                    showGoldBadge: state.settings.showGoldBadge,
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

// Before: the field page saved, then handed back the server's profile.
// Future<void> _openField(
//   BuildContext context,
//   ProfileField field,
//   MyProfile profile,
// ) async {
//   final bloc = context.read<EditProfileBloc>();
//   final updated = await context.push<MyProfile>(
//     RoutePaths.editProfileField,
//     extra: ProfileFieldEditorArgs(field: field, profile: profile),
//   );
//   if (updated == null) return;
//   bloc.add(EditProfileUpdated(updated));
//   if (context.mounted) {
//     CustomToast.showSuccess(context, '${field.title} updated');
//   }
// }

/// Opens [field]'s page. Its edit shows here at once and saves in the
/// background; a failed save is rolled back with an error toast.
Future<void> _openField(
  BuildContext context,
  ProfileField field,
  MyProfile profile,
) async {
  final bloc = context.read<EditProfileBloc>();
  final patch = await context.push<ProfilePatch>(
    RoutePaths.editProfileField,
    extra: ProfileFieldEditorArgs(field: field, profile: profile),
  );
  if (patch != null) bloc.add(EditProfileSaveRequested(patch));
}

class _EditTab extends StatelessWidget {
  const _EditTab({
    required this.profile,
    required this.settings,
    this.photoBusy = false,
  });

  final MyProfile profile;
  final AppSettings settings;

  /// A photo change is saving: the grid shows a spinner.
  final bool photoBusy;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final value = menuText(14, 20, color: kMenuGrey400);
    final prompt = menuText(14, 20, color: AppColors.primaryColor);

    /// A row showing [text], or the pink [placeholder] when it's missing.
    /// Opens [field]'s page; rows without one (no API yet) say "Coming
    /// soon".
    MenuInfoRow row(
      String title,
      String? text, {
      ProfileField? field,
      String placeholder = _completePrompt,
      Widget? titleBadge,
    }) => MenuInfoRow(
      title: title,
      titleBadge: titleBadge,
      value: text ?? placeholder,
      valueStyle: text == null ? prompt : value,
      trailing: AssetIcon(Assets.icons.menuChevronRight, size: 20),
      // onTap: () => showComingSoon(context, 'Editing ${title.toLowerCase()}'),
      onTap: field == null
          ? () => showComingSoon(context, 'Editing ${title.toLowerCase()}')
          : () => _openField(context, field, p),
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
        // The page holds profile data only. Same fields as onboarding's
        // Basic information page.
        section('User info', [
          row('Name', MenuFormat.text(p.fullName), field: ProfileField.name),
          row(
            'Birth date',
            MenuFormat.date(p.dateOfBirth),
            field: ProfileField.birthDate,
          ),
          row(
            'Gender',
            MenuFormat.token(p.gender),
            field: ProfileField.gender,
          ),
          row(
            'Religion',
            MenuFormat.token(p.religion),
            field: ProfileField.religion,
          ),
          row(
            'Languages',
            MenuFormat.list(p.languages),
            field: ProfileField.languages,
          ),
        ]),
        SizedBox(height: 60.w),
        // Removed: the page is profile data only. The ID badge is account
        // verification, and Profession already sits in "Education and
        // career", so nothing was left in this section.
        // section(
        //   'Complete profile',
        //   tag: MenuTag('${p.completeness}%'),
        //   [
        //     // No onboarding step / API field yet — re-enable when added.
        //     // row(
        //     //   'Family involvement',
        //     //   null,
        //     //   placeholder: 'When do you want to involve family?',
        //     // ),
        //     // row(
        //     //   'Living arrangements',
        //     //   null,
        //     //   placeholder: 'Who do you want to live with?',
        //     // ),
        //     MenuInfoRow(
        //       title: 'ID Verified badge',
        //       titleBadge: AssetIcon(Assets.icons.menuIdBadge, size: 16),
        //       value:
        //           'Verify your age and identity to receive more\n'
        //           'likes and matches',
        //       hint: p.isVerified ? null : _completePrompt,
        //       hintStyle: prompt,
        //       trailing: AssetIcon(Assets.icons.menuChevronRight, size: 20),
        //       onTap: () => showComingSoon(context, 'ID verification'),
        //     ),
        //     // row('Tagline', null, placeholder: 'Add a fun introduction'),
        //     // Was 'Job title' + 'Employer'; onboarding only collects
        //     // profession, so a single row now matches it.
        //     // row(
        //     //   'Job title',
        //     //   MenuFormat.text(p.profession),
        //     //   placeholder: 'What do you do for work?',
        //     // ),
        //     // row('Employer', null, placeholder: 'What do you do for work?'),
        //     row(
        //       'Profession',
        //       MenuFormat.text(p.profession),
        //       placeholder: 'What do you do for work?',
        //     ),
        //   ],
        // ),
        // SizedBox(height: 60.w),
        // _PhotosSection(photos: p.photos),
        _PhotosSection(photos: p.photos, busy: photoBusy),
        SizedBox(height: 60.w),
        // Removed: Gold badge is a membership setting, not profile data.
        // Preview still draws the crown from `settings.showGoldBadge`.
        // section('Profile features', [
        //   MenuInfoRow(
        //     title: 'Gold member badge',
        //     value: 'Show Gold member badge on profile',
        //     trailing: MenuToggle(
        //       value: settings.showGoldBadge,
        //       semanticLabel: 'Show Gold member badge',
        //       onChanged: (v) => context.read<EditProfileBloc>().add(
        //         GoldBadgeToggled(visible: v),
        //       ),
        //     ),
        //   ),
        // ]),
        // SizedBox(height: 60.w),
        section('Location', tag: newTag, [
          // Stays "Coming soon": how to set it after onboarding (country +
          // coordinates) isn't confirmed by the backend yet.
          row('Current location', MenuFormat.text(p.currentLocation)),
          row(
            'Grew up in',
            MenuFormat.text(p.grewUpIn),
            field: ProfileField.grewUpIn,
          ),
        ]),
        SizedBox(height: 60.w),
        section('About me', [
          row(
            'Height',
            MenuFormat.height(p.heightCm),
            field: ProfileField.height,
          ),
          row(
            'Marital status',
            MenuFormat.token(p.maritalStatus),
            field: ProfileField.maritalStatus,
          ),
          row(
            'Children',
            MenuFormat.children(p.hasChildren),
            field: ProfileField.children,
          ),
          row('Bio', MenuFormat.text(p.bio), field: ProfileField.bio),
        ]),
        SizedBox(height: 60.w),
        section('Marriage intentions', tag: newTag, [
          // Both open the one "Marriage intentions" page (saved together).
          row(
            'Chatting',
            MenuFormat.token(p.gettingToKnow),
            field: ProfileField.marriageIntentions,
          ),
          row(
            'Marriage',
            MenuFormat.token(p.marriageTimeline),
            field: ProfileField.marriageIntentions,
          ),
        ]),
        SizedBox(height: 60.w),
        section('Future plans', [
          row(
            'Relocation plans',
            MenuFormat.relocation(p.relocateAbroad),
            field: ProfileField.relocation,
          ),
          // row('Family plans', null), // no onboarding step / API field yet
          // row('Polygamy plan', null), // no onboarding step / API field yet
        ]),
        SizedBox(height: 60.w),
        section('Religiosity', [
          // row('Sect', null), // no onboarding step / API field yet
          row(
            'Born Muslim',
            MenuFormat.yesNo(p.bornMuslim),
            field: ProfileField.bornMuslim,
          ),
          row(
            'Religious practice',
            MenuFormat.token(p.religiousPractice),
            field: ProfileField.religiousPractice,
          ),
          row(
            'Faith',
            MenuFormat.list(p.faith),
            field: ProfileField.faith,
            titleBadge: const MenuTag('New', fontSize: 11),
          ),
          row(
            'Diet',
            MenuFormat.diet(p.halalFood),
            field: ProfileField.diet,
          ),
          row(
            'Alcohol',
            MenuFormat.alcohol(p.alcohol),
            field: ProfileField.alcohol,
          ),
          row(
            'Smoking',
            MenuFormat.smoking(p.smoking),
            field: ProfileField.smoking,
          ),
        ]),
        SizedBox(height: 60.w),
        section('Interests and Personality', [
          row(
            'Interests',
            MenuFormat.list(p.interests),
            field: ProfileField.interests,
          ),
          row(
            'Personality',
            MenuFormat.list(p.personality),
            field: ProfileField.personality,
          ),
        ]),
        SizedBox(height: 60.w),
        section('Education and career', [
          row(
            'Education',
            MenuFormat.token(p.education),
            field: ProfileField.education,
          ),
          row(
            'Profession',
            MenuFormat.text(p.profession),
            field: ProfileField.profession,
          ),
        ]),
        SizedBox(height: 60.w),
        // Languages moved to "User info" (it's on Basic information).
        // section('Languages and ethnicity', [
        section('Ethnicity and nationality', [
          row(
            'Ethnicity',
            MenuFormat.list(p.ethnicity),
            field: ProfileField.ethnicity,
          ),
          row(
            'Nationality',
            MenuFormat.list(p.nationality),
            field: ProfileField.nationality,
          ),
          // row('Languages', MenuFormat.list(p.languages)),
        ]),
      ],
    );
  }
}

/// 3-column grid (14pt gaps, 140pt tall): photos, dashed "+" slots, and the
/// "Photo guidelines" tile last.
class _PhotosSection extends StatelessWidget {
  const _PhotosSection({required this.photos, this.busy = false});

  final List<String> photos;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final slots = [
      for (var i = 0; i < _maxPhotos; i++) i < photos.length ? photos[i] : null,
    ];
    final cells = <Widget>[
      for (final (i, photo) in slots.indexed)
        photo == null
            // Uploading after onboarding isn't confirmed by the backend yet.
            ? _AddSlot(onTap: () => showComingSoon(context, 'Adding photos'))
            // : ClipRRect(
            //     borderRadius: BorderRadius.circular(8.r),
            //     child: AppPhoto(photo),
            //   ),
            : _PhotoTile(
                url: photo,
                isMain: i == 0,
                onTap: busy
                    ? null
                    : () => _showPhotoActions(context, photo, isMain: i == 0),
              ),
      _GuidelinesSlot(
        onTap: () => showComingSoon(context, 'Photo guidelines'),
      ),
    ];
    return Column(
      children: [
        const MenuSectionTitle('Photos', fontSize: 22),
        // No progress bar: photo changes show at once now.
        // if (busy)
        //   Padding(
        //     padding: EdgeInsets.only(top: 12.w),
        //     child: const LinearProgressIndicator(
        //       color: AppColors.primaryColor,
        //       minHeight: 2,
        //     ),
        //   ),
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

/// Muzz's photo sheet: Use as main photo / Replace photo / Delete.
Future<void> _showPhotoActions(
  BuildContext context,
  String url, {
  required bool isMain,
}) async {
  final bloc = context.read<EditProfileBloc>();
  final count = bloc.state.profile?.photos.length ?? 0;
  final action = await showModalBottomSheet<_PhotoAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheet) => _PhotoActionSheet(isMain: isMain),
  );
  if (action == null || !context.mounted) return;
  switch (action) {
    case _PhotoAction.makeMain:
      bloc.add(EditProfilePhotoMadeMain(url));
    case _PhotoAction.replace:
      showComingSoon(context, 'Replacing photos');
    case _PhotoAction.delete:
      if (count <= minPhotos) {
        CustomToast.showInfo(
          context,
          'Keep at least $minPhotos photos on your profile',
        );
      } else {
        bloc.add(EditProfilePhotoDeleted(url));
      }
  }
}

enum _PhotoAction { makeMain, replace, delete }

class _PhotoActionSheet extends StatelessWidget {
  const _PhotoActionSheet({required this.isMain});

  final bool isMain;

  @override
  Widget build(BuildContext context) {
    Widget item(_PhotoAction action, IconData icon, String label) => ListTile(
      leading: Icon(icon, color: kMenuGrey950),
      title: Text(label, style: menuText(16, 24, weight: FontWeight.w600)),
      onTap: () => Navigator.of(context).pop(action),
    );
    final card = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
    );
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: card,
              child: Column(
                children: [
                  if (!isMain)
                    item(
                      _PhotoAction.makeMain,
                      Icons.account_box_outlined,
                      'Use as main photo',
                    ),
                  item(
                    _PhotoAction.replace,
                    Icons.upload_outlined,
                    'Replace photo',
                  ),
                  item(_PhotoAction.delete, Icons.delete_outline, 'Delete'),
                ],
              ),
            ),
            SizedBox(height: 12.w),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: card,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: menuText(16, 24, weight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An uploaded photo; the first one carries a "Main" label (Muzz).
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.url, required this.isMain, this.onTap});

  final String url;
  final bool isMain;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isMain ? 'Main photo' : 'Photo',
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // AppPhoto(url),
              ProfilePhoto(url),
              if (isMain)
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.w,
                    ),
                    decoration: BoxDecoration(
                      color: kMenuGrey950,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Main',
                      style: menuText(
                        12,
                        16,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
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
