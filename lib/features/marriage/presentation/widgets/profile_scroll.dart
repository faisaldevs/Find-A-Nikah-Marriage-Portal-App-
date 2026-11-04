import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/presentation/bloc/marriage_feed_bloc.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/compliment_sent_strip.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_details.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_hero.dart';
import 'package:flutter/material.dart';

/// The scrolling profile: hero photo, then every detail section. Shared by
/// the Marriage tab and any screen that shows a full profile (e.g. opening a
/// card from Explore) so both look the same.
class ProfileScroll extends StatefulWidget {
  const ProfileScroll({
    required this.profile,
    required this.compliment,
    required this.onCompliment,
    required this.heroHeight,
    required this.heroBottomInset,
    required this.bottomPadding,
    required this.onComingSoon,
    // required this.actions,
    super.key,
  });

  final MarriageProfile profile;

  /// What was sent to this profile, shown above its photo.
  final SentCompliment? compliment;

  /// Compliment box at the bottom of the profile.
  final ValueChanged<String> onCompliment;
  final double heroHeight;

  /// Gap between the details and the photo's bottom edge.
  final double heroBottomInset;
  final double bottomPadding;

  /// Snackbar for actions that aren't wired up yet.
  final ValueChanged<String> onComingSoon;

  // Scrolled with the hero; now pinned by the page instead.
  // /// Pass / undo / message / like row, laid over the hero's bottom edge.
  // final Widget actions;

  @override
  State<ProfileScroll> createState() => ProfileScrollState();
}

class ProfileScrollState extends State<ProfileScroll> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// The compliment box sits at the bottom; the sent message shows at the
  /// top, so bring it into view.
  void _sentFromBox(String text) {
    widget.onCompliment(text);
    if (_scroll.hasClients) {
      _scroll
          .animateTo(
            0,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
          )
          .ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final heroHeight = widget.heroHeight;
    final heroBottomInset = widget.heroBottomInset;
    final bottomPadding = widget.bottomPadding;
    final onComingSoon = widget.onComingSoon;
    final compliment = widget.compliment;
    // return SingleChildScrollView(
    // child: Column(
    // children: [
    // ProfileHero(
    // profile: profile,
    // height: heroHeight,
    // bottomInset: heroBottomInset,
    // ),
    // ProfileDetails(
    // profile: profile,
    // bottomPadding: bottomPadding,
    // onCheckFilters: () => onComingSoon('Filter match'),
    // onCompliment: (_) => CustomToast.showSuccess(
    // context,
    // 'Compliment sent',
    // description: 'Your compliment was sent to ${profile.name}.',
    // ),
    // onShare: () => onComingSoon('Share profile'),
    // onFavourite: () => onComingSoon('Favourite'),
    // onBlock: () => onComingSoon('Block'),
    // onReport: () => onComingSoon('Report'),
    // ),
    // ],
    // ),
    // );
    // // Before the full-profile design: only the extra photos, as rounded
    // // cards, under the hero.
    // // return SingleChildScrollView(
    // //   padding: EdgeInsets.only(bottom: bottomPadding),
    // //   child: Column(
    // //     children: [
    // //       ProfileHero(
    // //         profile: profile,
    // //         height: heroHeight,
    // //         bottomInset: heroBottomInset,
    // //       ),
    // //       for (final url in profile.photoUrls.skip(1))
    // //         Padding(
    // //           padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
    // //           child: ClipRRect(
    // //             borderRadius: BorderRadius.circular(16.r),
    // //             child: SizedBox(
    // //               height: heroHeight * 0.75,
    // //               child: ProfilePhoto(url: url),
    // //             ),
    // //           ),
    // //         ),
    // //     ],
    // //   ),
    // // );

    // Buttons straddling the photo's edge and scrolling away with it
    // (replaced: they're pinned by the page now):
    // final button = kProfileActionButtonSize.r;
    // final overlap = 19.h;
    // return SingleChildScrollView(
    //   child: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       Column(
    //         children: [
    //           ProfileHero(...),
    //           // Room for the part of the buttons below the photo.
    //           SizedBox(height: button - overlap + 12.h),
    //           ProfileDetails(...),
    //         ],
    //       ),
    //       Positioned(
    //         left: 0,
    //         right: 0,
    //         top: heroHeight - overlap,
    //         height: button,
    //         child: actions,
    //       ),
    //     ],
    //   ),
    // );
    return SingleChildScrollView(
      controller: _scroll,
      child: Column(
        children: [
          if (compliment != null) ComplimentSentStrip(compliment: compliment),
          ProfileHero(
            profile: profile,
            height: heroHeight,
            bottomInset: heroBottomInset,
          ),
          ProfileDetails(
            profile: profile,
            bottomPadding: bottomPadding,
            onCheckFilters: () => onComingSoon('Filter match'),
            // onCompliment: (_) => CustomToast.showSuccess(
            //   context,
            //   'Compliment sent',
            //   description: 'Your compliment was sent to ${profile.name}.',
            // ),
            onCompliment: _sentFromBox,
            onShare: () => onComingSoon('Share profile'),
            onFavourite: () => onComingSoon('Favourite'),
            onBlock: () => onComingSoon('Block'),
            onReport: () => onComingSoon('Report'),
          ),
        ],
      ),
    );
  }
}
