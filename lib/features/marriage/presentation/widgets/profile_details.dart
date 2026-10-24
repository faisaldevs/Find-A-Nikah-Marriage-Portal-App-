import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/compliment_box.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/filters_teaser.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/marriage_intentions_card.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_bio.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_footer_actions.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_photo.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_sections.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/verified_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Everything below a profile's main photo, in mockup order: filters
/// teaser, similarities, then detail sections with the extra photos between
/// them, compliment box, and share / block / report.
class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    required this.profile,
    required this.onCheckFilters,
    required this.onCompliment,
    required this.onShare,
    required this.onFavourite,
    required this.onBlock,
    required this.onReport,
    required this.bottomPadding,
    super.key,
  });

  final MarriageProfile profile;
  final VoidCallback onCheckFilters;
  final ValueChanged<String> onCompliment;
  final VoidCallback onShare;
  final VoidCallback onFavourite;
  final VoidCallback onBlock;
  final VoidCallback onReport;

  /// Space after the last row, so it can scroll clear of the floating
  /// action buttons.
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    // Extra photos, in the slots after About me, My Faith, Future plans and
    // Personality. Missing ones are skipped.
    Widget photo(int i) => i < p.photoUrls.length
        ? SizedBox(
            height: 490.h,
            child: ProfilePhoto(url: p.photoUrls[i]),
          )
        : const SizedBox.shrink();
    // List<ProfileChip> chips(List<String> labels) => [
    //   for (final l in labels) ProfileChip(l),
    // ];
    // Real API: unanswered fields come through as '' — no blank chips, and
    // a section with nothing in it is left out (with its gap).
    List<ProfileChip> chips(List<String> labels) => [
      for (final l in labels)
        if (l.isNotEmpty) ProfileChip(l),
    ];
    final aboutMe = chips([
      if (p.heightCm case final cm?) _heightLabel(cm),
      p.maritalStatus,
      p.children,
    ]);
    final hasIntentions = [
      p.involveFamily,
      p.chatFor,
      p.marryWithin,
    ].any((s) => s.isNotEmpty);
    final career = chips([p.education, p.profession]);
    final languages = [
      ...chips(p.languages),
      if (p.grewUpIn.isNotEmpty)
        ProfileChip('Grew up in ${p.grewUpIn}', flag: p.grewUpFlag),
      if (p.ethnicity.isNotEmpty)
        ProfileChip(p.ethnicity, flag: p.ethnicityFlag),
    ];
    final gap40 = SizedBox(height: 40.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (p.isPremium) FiltersTeaser(name: p.name, onCheck: onCheckFilters),
        if (p.similarities.isNotEmpty) _Similarities(profile: p),
        // Each section below was unconditional before the real API (dummy
        // data always filled every field); now each is skipped when empty.
        if (aboutMe.isNotEmpty) ...[
          ProfileSection(
            title: 'About me',
            top: 30,
            child: ProfileChipList(chips: aboutMe),
          ),
          gap40,
        ],
        if (hasIntentions) ...[
          MarriageIntentionsCard(
            name: p.name,
            involveFamily: p.involveFamily,
            chatFor: p.chatFor,
            marryWithin: p.marryWithin,
          ),
          gap40,
        ],
        photo(1),
        if (p.faith.isNotEmpty) ...[
          ProfileSection(
            title: 'My Faith',
            child: ProfileChipList(chips: chips(p.faith)),
          ),
          gap40,
        ],
        photo(2),
        if (p.futurePlans.isNotEmpty) ...[
          ProfileSection(
            title: 'Future plans',
            child: ProfileChipList(chips: chips(p.futurePlans), stacked: true),
          ),
          gap40,
        ],
        photo(3),
        if (p.interests.isNotEmpty)
          ProfileSection(
            title: 'Interests',
            child: ProfileChipList(chips: chips(p.interests)),
          ),
        if (p.personality.isNotEmpty)
          ProfileSection(
            title: 'Personality',
            child: ProfileChipList(chips: chips(p.personality)),
          ),
        gap40,
        photo(4),
        if (career.isNotEmpty)
          ProfileSection(
            title: 'Education and career',
            child: ProfileChipList(chips: career),
          ),
        if (languages.isNotEmpty)
          ProfileSection(
            title: 'Languages and ethnicity',
            child: ProfileChipList(chips: languages),
          ),
        if (p.bio.isNotEmpty)
          ProfileSection(
            title: 'Bio',
            // Mockup's bio box ends ~366, short of the 371 gutter.
            child: Padding(
              padding: EdgeInsets.only(right: 4.5.w),
              child: ProfileBio(p.bio),
            ),
          ),
        if (p.isPhotoVerified || p.isAgeVerified || p.isIdVerified) ...[
          gap40,
          VerifiedProfileCard(
            name: p.name,
            photo: p.isPhotoVerified,
            age: p.isAgeVerified,
            id: p.isIdVerified,
          ),
        ],
        gap40,
        ComplimentBox(name: p.name, onSubmit: onCompliment),
        ProfileFooterActions(
          onShare: onShare,
          onFavourite: onFavourite,
          onBlock: onBlock,
          onReport: onReport,
        ),
        SizedBox(height: bottomPadding),
      ],
    );
  }

  /// "158cm (5' 2")".
  static String _heightLabel(int cm) {
    final inches = (cm / 2.54).round();
    return '${cm}cm (${inches ~/ 12}\' ${inches % 12}")';
  }
}

/// White band: "Similarities" + a short explainer + grey filled chips.
class _Similarities extends StatelessWidget {
  const _Similarities({required this.profile});

  final MarriageProfile profile;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          kProfileGutter,
          20.h,
          kProfileGutter,
          20.7.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileSectionHeading('Similarities'),
            SizedBox(height: 8.5.h),
            Text(
              'You and ${profile.name} share common background details. '
              'Explore your shared connections.',
              style: TextFontStyle.headline14w400textMutedStyleSatoshi
                  .copyWith(color: kProfileBodyGrey)
                  .lh(20, tracking: -0.005),
            ),
            SizedBox(height: 15.75.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final s in profile.similarities)
                  ProfileChip(s, filled: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
