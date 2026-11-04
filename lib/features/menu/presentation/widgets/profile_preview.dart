import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/editing/profile_options.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_format.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/profile_photo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// The Marriage tab's full-profile look, redrawn for the member's own
// profile. Colours are the same mockup samples Marriage uses; features
// can't import each other, so they are repeated here.
const _ink = Color(0xFF0A0A0A);
const _bodyGrey = Color(0xFF515151);
const _labelGrey = Color(0xFFA2A2A2);
const _border = Color(0xFFE6E7EB);
const _chipBorder = Color(0xFFD4D4D4);
const _pageBackground = Color(0xFFF9FAFC);
const _gold = Color(0xFF9C752A);
const _navy = Color(0xFF012D5C);
const _verifiedGreen = Color(0xFF17A34A);
const _verifiedBlue = Color(0xFF2563EB);
const _lineColor = Color(0xFF292533);
const _stopLabel = Color(0xFF534F5D);
const _matchColor = Color(0xFFFC4E4D);

/// Testing aid: anything the profile API leaves empty is drawn in red
/// ("`field` missing") so gaps are easy to spot. Debug builds only — a
/// release build hides empty fields and sections, like the Marriage card.
const _red = Color(0xFFE5231B);
const bool _showMissing = kDebugMode;

extension on TextStyle {
  /// Fixed line height in design pixels (same helper as Marriage's).
  TextStyle lh(double designLineHeight, {double tracking = -0.0075}) =>
      copyWith(
        height: designLineHeight.sp / fontSize!,
        leadingDistribution: TextLeadingDistribution.even,
        letterSpacing: tracking * fontSize!,
      );
}

double get _gutter => 19.w;

/// Edit → Preview tab: how other members see the signed-in member's own
/// profile. Read-only; fed from the same state as the Edit tab.
class MyProfilePreview extends StatelessWidget {
  const MyProfilePreview({
    required this.profile,
    required this.showGoldBadge,
    super.key,
  });

  final MyProfile profile;

  /// The Edit tab's "Gold member badge" toggle: crown on the main photo.
  final bool showGoldBadge;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final screenHeight = MediaQuery.sizeOf(context).height;

    /// Extra photos sit between the sections: slots 1-4.
    Widget photo(int i) {
      if (i < p.photos.length) {
        return Padding(
          padding: EdgeInsets.only(bottom: 40.h),
          // child: SizedBox(height: 490.h, child: AppPhoto(p.photos[i])),
          child: SizedBox(height: 490.h, child: ProfilePhoto(p.photos[i])),
        );
      }
      // if (!_showMissing) return const SizedBox.shrink();
      // Only slots below the 3-photo minimum count as missing.
      if (!_showMissing || i >= minPhotos) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.fromLTRB(_gutter, 0, _gutter, 40.h),
        child: _MissingBox('Photo ${i + 1} missing', height: 90.h),
      );
    }

    final aboutMe = _chips([
      _Entry('Height', MenuFormat.height(p.heightCm)),
      _Entry('Marital status', MenuFormat.token(p.maritalStatus)),
      _Entry('Children', MenuFormat.children(p.hasChildren)),
    ]);
    // Muzz's Faith section: practice and lifestyle first, then the tags.
    final faith = _chips([
      _Entry('Practice', MenuFormat.token(p.religiousPractice)),
      _Entry('Diet', MenuFormat.diet(p.halalFood)),
      _Entry('Smoking', MenuFormat.smoking(p.smoking)),
      _Entry('Alcohol', MenuFormat.alcohol(p.alcohol)),
      for (final f in p.faith) _Entry('Faith', MenuFormat.token(f)),
      if (p.faith.isEmpty) const _Entry('Faith', null),
    ]);
    final plans = _chips([
      _Entry('Relocation plans', MenuFormat.relocation(p.relocateAbroad)),
    ]);
    final interests = _chips([
      for (final i in p.interests) _Entry('Interests', MenuFormat.token(i)),
      if (p.interests.isEmpty) const _Entry('Interests', null),
    ]);
    final personality = _chips([
      for (final i in p.personality) _Entry('Personality', MenuFormat.token(i)),
      if (p.personality.isEmpty) const _Entry('Personality', null),
    ]);
    final career = _chips([
      _Entry('Education', MenuFormat.token(p.education)),
      _Entry('Profession', MenuFormat.text(p.profession)),
    ]);
    final grewUp = MenuFormat.text(p.grewUpIn);
    final ethnicity = p.ethnicity.isEmpty ? null : p.ethnicity.first;
    final languages = _chips(
      [
        for (final l in p.languages) _Entry('Languages', MenuFormat.token(l)),
        if (p.languages.isEmpty) const _Entry('Languages', null),
        _Entry(
          'Grew up in',
          grewUp == null ? null : 'Grew up in $grewUp',
          flag: grewUp == null ? null : flagForCountryName(grewUp),
        ),
        _Entry(
          'Ethnicity',
          ethnicity,
          flag: ethnicity == null ? null : flagForCountryName(ethnicity),
        ),
        for (final n in p.nationality)
          _Entry('Nationality', MenuFormat.token(n)),
        if (p.nationality.isEmpty) const _Entry('Nationality', null),
      ],
    );
    final gap40 = SizedBox(height: 40.h);

    return ColoredBox(
      color: _pageBackground,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Hero(
              profile: p,
              height: screenHeight * 0.78,
              showCrown: showGoldBadge,
            ),
            if (aboutMe.isNotEmpty) ...[
              _Section(title: 'About me', top: 30, chips: aboutMe),
              gap40,
            ],
            _IntentionsCard(profile: p),
            gap40,
            photo(1),
            if (faith.isNotEmpty) _Section(title: 'My Faith', chips: faith),
            if (faith.isNotEmpty) gap40,
            photo(2),
            if (plans.isNotEmpty) ...[
              _Section(title: 'Future plans', chips: plans, stacked: true),
              gap40,
            ],
            photo(3),
            if (interests.isNotEmpty)
              _Section(title: 'Interests', chips: interests),
            if (personality.isNotEmpty)
              _Section(title: 'Personality', chips: personality),
            gap40,
            photo(4),
            if (career.isNotEmpty)
              _Section(title: 'Education and career', chips: career),
            if (languages.isNotEmpty)
              _Section(title: 'Languages and ethnicity', chips: languages),
            _BioSection(bio: MenuFormat.text(p.bio)),
            gap40,
            _VerifiedCard(profile: p),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}

/// One profile value and the name to flag it by when it's empty.
class _Entry {
  const _Entry(this.field, this.value, {this.flag});

  final String field;
  final String? value;
  final String? flag;
}

/// Filled entries become normal chips; empty ones a red "missing" chip in
/// debug builds and nothing otherwise.
List<_Chip> _chips(List<_Entry> entries) => [
  for (final e in entries)
    if (e.value != null)
      _Chip(e.value!, flag: (e.flag?.isEmpty ?? true) ? null : e.flag)
    else if (_showMissing)
      _Chip('${e.field} missing', missing: true),
];

class _Hero extends StatelessWidget {
  const _Hero({
    required this.profile,
    required this.height,
    required this.showCrown,
  });

  final MyProfile profile;
  final double height;
  final bool showCrown;

  @override
  Widget build(BuildContext context) {
    final main = profile.mainPhoto;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (main != null)
            // AppPhoto(main)
            ProfilePhoto(main)
          else
            ColoredBox(
              color: Colors.grey.shade300,
              child: const Center(
                child: Text(
                  'Main photo missing',
                  style: TextStyle(color: _red, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.18, 0.45, 1.0],
                colors: [
                  Color(0x55000000),
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0xE6000000),
                ],
              ),
            ),
          ),
          if (showCrown)
            Positioned(
              top: 20.h,
              right: 20.w,
              child: Container(
                width: 30.r,
                height: 30.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _gold,
                  shape: BoxShape.circle,
                ),
                child: CrownIcon(width: 14.r, color: Colors.white),
              ),
            ),
          Positioned(
            left: 19.w,
            right: 19.w,
            bottom: 24.h,
            child: _Summary(profile: profile),
          ),
        ],
      ),
    );
  }
}

int? _age(DateTime? dob, DateTime now) {
  if (dob == null) return null;
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

class _Summary extends StatelessWidget {
  const _Summary({required this.profile});

  final MyProfile profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final age = _age(p.dateOfBirth, DateTime.now());
    final name = p.fullName.trim();
    final country = MenuFormat.text(p.currentLocation) ?? '';
    final flag = flagForCountryName(country);
    final ethnicity = p.ethnicity.isEmpty ? '' : p.ethnicity.first;
    final title = [
      if (name.isNotEmpty) name,
      if (age != null) '$age',
    ].join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: title.isEmpty
                  ? const _MissingText('Name / age missing')
                  : Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headline28w700textWhiteStyleSatoshi
                          .lh(35, tracking: -0.015),
                    ),
            ),
            if (p.isVerified) ...[
              SizedBox(width: 8.w),
              Icon(Icons.verified, color: const Color(0xFF3B82F6), size: 24.r),
            ],
          ],
        ),
        if (_showMissing && (name.isEmpty || age == null)) ...[
          SizedBox(height: 4.h),
          _MissingText(
            '${[
              if (name.isEmpty) 'name',
              if (age == null) 'date of birth',
            ].join(' + ')} missing',
          ),
        ],
        SizedBox(height: 9.h),
        Row(
          children: [
            if (flag.isNotEmpty) ...[
              Text(flag, style: TextStyle(fontSize: 17.sp, height: 1)),
              SizedBox(width: 7.w),
            ],
            Expanded(
              child: country.isEmpty
                  ? const _MissingText('Location missing')
                  : Text(
                      country,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headline14w400textWhiteStyleSatoshi
                          .lh(17.5, tracking: -0.015),
                    ),
            ),
          ],
        ),
        SizedBox(height: 31.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _DetailColumn(
                  top: _Detail('Country', country, flag: flag),
                  bottom: _Detail(
                    'Practice',
                    MenuFormat.token(p.religiousPractice) ?? '',
                  ),
                  padding: EdgeInsets.only(right: 12.w),
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Colors.white24,
              ),
              Expanded(
                child: _DetailColumn(
                  top: _Detail(
                    'Profession',
                    MenuFormat.text(p.profession) ?? '',
                  ),
                  bottom: _Detail(
                    'Ethnicity',
                    ethnicity,
                    flag: flagForCountryName(ethnicity),
                  ),
                  padding: EdgeInsets.only(left: 12.w),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailColumn extends StatelessWidget {
  const _DetailColumn({
    required this.top,
    required this.bottom,
    required this.padding,
  });

  final _Detail top;
  final _Detail bottom;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: padding.copyWith(bottom: 10.h),
          child: top,
        ),
        const Divider(height: 1, thickness: 1, color: Colors.white24),
        Padding(
          padding: padding.copyWith(top: 8.h),
          child: bottom,
        ),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail(this.label, this.value, {this.flag});

  final String label;
  final String value;
  final String? flag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextFontStyle.headline11w400white70StyleSatoshi
              .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500)
              .lh(12.5),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (flag?.isNotEmpty ?? false) ...[
              Text(flag!, style: TextStyle(fontSize: 11.5.sp, height: 1)),
              SizedBox(width: 7.w),
            ],
            Expanded(
              child: value.isEmpty
                  ? (_showMissing
                        ? const _MissingText('missing')
                        : Text(
                            '—',
                            style: TextFontStyle
                                .headline14w400textWhiteStyleSatoshi
                                .lh(17.5),
                          ))
                  : Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headline14w400textWhiteStyleSatoshi
                          .lh(17.5),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Red bold text, for the debug "missing" markers.
class _MissingText extends StatelessWidget {
  const _MissingText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    if (!_showMissing) return const SizedBox.shrink();
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _red,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _MissingBox extends StatelessWidget {
  const _MissingBox(this.text, {required this.height});

  final String text;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: _red),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: const TextStyle(color: _red, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.chips,
    this.top = 40,
    this.stacked = false,
  });

  final String title;
  final List<_Chip> chips;
  final double top;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_gutter, top.h, _gutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Heading(title),
          SizedBox(height: 17.h),
          if (stacked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < chips.length; i++) ...[
                  if (i > 0) SizedBox(height: 10.h),
                  chips[i],
                ],
              ],
            )
          else
            Wrap(spacing: 10.w, runSpacing: 10.h, children: chips),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextFontStyle.headline18w700StyleSatoshi
          .copyWith(color: _ink)
          .lh(24, tracking: -0.003),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, {this.flag, this.missing = false});

  final String label;
  final String? flag;
  final bool missing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(color: missing ? _red : _chipBorder),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (flag != null) ...[
            Text(flag!, style: TextStyle(fontSize: 13.sp, height: 1)),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextFontStyle.headline14w400textDarkStyleSatoshi
                  .copyWith(color: missing ? _red : _ink)
                  .lh(20, tracking: -0.003),
            ),
          ),
        ],
      ),
    );
  }
}

class _BioSection extends StatelessWidget {
  const _BioSection({required this.bio});

  final String? bio;

  @override
  Widget build(BuildContext context) {
    if (bio == null && !_showMissing) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(_gutter, 40.h, _gutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Heading('Bio'),
          SizedBox(height: 17.h),
          if (bio == null)
            const _MissingText('Bio missing')
          else
            Padding(
              padding: EdgeInsets.only(right: 4.5.w),
              child: Text(
                bio!,
                style: TextFontStyle.headline16w400textDarkStyleSatoshi
                    .copyWith(color: _ink)
                    .lh(22, tracking: 0),
              ),
            ),
        ],
      ),
    );
  }
}

/// White rounded card with a medium-18 title.
class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _gutter),
      padding: EdgeInsets.fromLTRB(20.w, 17.7.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextFontStyle.headline18w500textWhiteStyleSatoshi
                      .copyWith(color: _ink)
                      .lh(24),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.3.h),
                child: Icon(
                  Icons.info_outline,
                  size: 21.r,
                  color: _labelGrey,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

/// "`name`'s marriage intentions": Match! → Family → Chatting → Marriage.
/// The API has no "involve family" answer yet, so that stop is always the
/// red marker in debug builds.
class _IntentionsCard extends StatelessWidget {
  const _IntentionsCard({required this.profile});

  final MyProfile profile;

  @override
  Widget build(BuildContext context) {
    final chat = MenuFormat.token(profile.gettingToKnow);
    final marry = MenuFormat.token(profile.marriageTimeline);
    final first = profile.firstName;
    final name = first.isEmpty ? 'My' : '$first’s';
    if (chat == null && marry == null && !_showMissing) {
      return const SizedBox.shrink();
    }

    final label = TextFontStyle.headline12w400textMutedStyleSatoshi
        .copyWith(color: _stopLabel)
        .lh(16, tracking: 0);

    Widget stop(Widget icon, String title, String? value) => Expanded(
      child: Column(
        children: [
          Container(
            height: 24.h,
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            decoration: const ShapeDecoration(
              color: _navy,
              shape: StadiumBorder(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                SizedBox(width: 5.5.w),
                Text(
                  title,
                  style: TextFontStyle.headline12w500textWhiteStyleSatoshi
                      .copyWith(fontSize: 10.sp)
                      .lh(14, tracking: 0),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(width: 2.w, height: 9.h, color: _lineColor),
          SizedBox(height: 10.h),
          if (value != null)
            Text(value, textAlign: TextAlign.center, style: label)
          else if (_showMissing)
            Text(
              'missing',
              style: label.copyWith(
                color: _red,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );

    return _Card(
      title: '$name marriage intentions',
      child: Padding(
        padding: EdgeInsets.only(top: 22.h),
        child: Stack(
          children: [
            // The timeline bar the stops hang from (pill 24 + gap 10 + 9
            // tick = bar sits at the tick's top).
            Positioned(
              left: 0,
              right: 0,
              top: 24.h + 10.h,
              height: 4.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _lineColor,
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
            ),
            // Left gap keeps "Match!" clear of the Family label.
            Padding(
              padding: EdgeInsets.only(left: 56.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // No API field for family involvement: the stop was always
                  // empty. Muzz shows only the stops that have a value.
                  // stop(
                  //   Icon(
                  //     Icons.people_outline,
                  //     size: 12.r,
                  //     color: Colors.white,
                  //   ),
                  //   'Family',
                  //   null,
                  // ),
                  stop(
                    Icon(Icons.forum_outlined, size: 12.r, color: Colors.white),
                    'Chatting',
                    chat,
                  ),
                  stop(
                    RingIcon(width: 9.5.r, color: Colors.white),
                    'Marriage',
                    marry,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                'Match!',
                style: label.copyWith(color: _matchColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Verified profile": photo row when face-verified. The API has no age /
/// ID check flags, so those two rows are red markers in debug builds.
class _VerifiedCard extends StatelessWidget {
  const _VerifiedCard({required this.profile});

  final MyProfile profile;

  @override
  Widget build(BuildContext context) {
    final first = profile.firstName;
    final name = first.isEmpty ? 'My' : '$first’s';
    final rows = [
      if (profile.isVerified)
        _VerifiedRow(_verifiedGreen, '$name main photo has been verified.')
      else if (_showMissing)
        const _VerifiedRow(_red, 'Photo verification missing'),
      if (_showMissing) ...const [
        _VerifiedRow(_red, 'Age verification missing (not in API)'),
        _VerifiedRow(_red, 'ID verification missing (not in API)'),
      ],
    ];
    if (rows.isEmpty) return const SizedBox.shrink();
    return _Card(
      title: 'Verified profile',
      child: Padding(
        padding: EdgeInsets.only(top: 14.2.h),
        child: Column(children: rows),
      ),
    );
  }
}

class _VerifiedRow extends StatelessWidget {
  const _VerifiedRow(this.color, this.text);

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 7.6.h),
          child: Icon(
            color == _red ? Icons.error_outline : Icons.verified,
            size: 17.5.r,
            color: color == _verifiedGreen || color == _red
                ? color
                : _verifiedBlue,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextFontStyle.headline14w400textMutedStyleSatoshi
                .copyWith(color: color == _red ? _red : _bodyGrey)
                .lh(27),
          ),
        ),
      ],
    );
  }
}
