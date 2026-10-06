# Marriage screen — full-profile build: progress log

**Started:** 2026-10-03 · **Status:** layout built, pixel-match pass ~90% done.
**Design:** full-length mockup, 1560×24700 px (4x of a 390-wide frame).
The user pasted it into the chat; it is **not saved in the repo**. Save it
as `resources/Find A Nikah.360 images/marriage_full_profile.jpg` before
resuming. (`marriage.jpg` in that folder is mislabeled: it's the onboarding
"intentions for marriage" screen.)

---

## ⚠️ Temporary change to revert

`lib/main.dart`: `designSize: _verifySize, // TEMP-VERIFY` with
`_verifySize = Size(392.7, 802.9)` (the Pixel 5's logical size). This makes
every ScreenUtil scale = 1 on that phone so device screenshots can be
measured 1:1 against the mockup. **Switch back to `designSize: _designSize`
and delete `_verifySize` when verification is finished.** (Until then the
analyzer reports `_designSize` as unused.)

Why it was needed: on the Pixel 5, ScreenUtil gives w = 1.007, h = r = 0.951,
sp = 1.007. Text ends up ~6% larger relative to vertical spacing, so a 1:1
comparison with the 390×844 mockup is impossible without this.

---

## What's built

### Model / data
- `MarriageProfile` (Freezed) gained: `similarities`, `heightCm`,
  `maritalStatus`, `children`, `involveFamily`, `chatFor`, `marryWithin`,
  `faith`, `futurePlans`, `interests`, `personality`, `education`,
  `languages`, `grewUpIn`, `grewUpFlag`, `bio`, `isPhotoVerified`,
  `isAgeVerified`, `isIdVerified`. `build_runner` has been re-run.
- `dummy_profiles.dart`: a `_profile()` helper fills the detail fields
  (copied from the mockup). Each profile now has 5 photos.
- The height chip is computed (158 cm → `158cm (5' 2")`). The mockup says
  5' 6", which is wrong for 158 cm.

### New widgets (`features/marriage/presentation/widgets/`)
| File | What |
|---|---|
| `profile_style.dart` | Colours sampled from the mockup, the `kProfileGutter` (19) margin, and the `TextStyle.lh(lineHeight, {tracking})` extension (fixed line height with even leading, like Figma, plus letter-spacing) |
| `profile_sections.dart` | `ProfileSectionHeading`, `ProfileSection` (40 top / 17 gap), `ProfileChipList` (wrap, or `stacked` for Future plans), `ProfileChip` (30 high; outlined, or filled grey for Similarities) |
| `crown_icon.dart` | Painted crown, used by the hero badge and the filters teaser |
| `filters_teaser.dart` | Cream "Curious about X's filters?" band + gold button (premium profiles only) |
| `marriage_intentions_card.dart` | `ProfileCard` (shared white card with title + (i) icon) and the intentions timeline (heart, line, ticks, Family/Chatting/Marriage pills, labels) |
| `verified_profile_card.dart` | Green/blue badge rows |
| `profile_bio.dart` | Bio text: blank line = 22 gap; lines starting with "• " become a bulleted list with a hanging indent |
| `compliment_box.dart` | Compliment text field + Submit. Faded until text is typed; on submit it shows a "Compliment sent" snackbar and clears |
| `profile_footer_actions.dart` | Share profile, divider, Favourite · Block · Report (painted tray-arrow and flag icons) |
| `profile_details.dart` | Puts everything together in mockup order, with photos 2–5 between the sections |

`core/ui/icons/ring_icon.dart`: painted ring with a diamond. Used by the
nav's Marriage tab and the intentions "Marriage" pill.

### Changes to existing files (old code left as comments)
- `marriage_screen.dart`: the whole profile now scrolls in one view.
  - Hero height = viewport − 48.
  - Buttons float fixed 65 above the hero's bottom edge.
  - Removed the shadow strip.
  - Bottom padding is set so the last row scrolls clear of the buttons.
  - Every action without a backend shows a "coming soon" snackbar.
- `profile_hero.dart`:
  - Name 28 bold, distance 14, value text 14 regular, labels medium 10.
  - Explicit line heights everywhere (Satoshi's 0.1em line gap made lines
    taller on Android).
  - Flag emoji set to `height: 1` (they had inflated row heights by ~6).
  - Badge/dot insets 20/19; painted crown in the gold badge.
  - Bottom inset 23.6, name→distance gap 9, distance→grid 31, row-2 top
    padding 8.
- `profile_action_buttons.dart`: 58 diameter, 33.5 side padding,
  spaceBetween.
- `marriage_top_bar.dart`:
  - 38 circles, padding 19.5/13/20.5/17, 10 gap on the right.
  - Wordmark centred on the screen.
  - Painted filters glyph; border colour #E6E7EB.
- `core/ui/components/main_nav_shell.dart` (shared by every tab):
  - 20 top / 19 bottom padding (no SafeArea; uses the bottom inset only
    when it's bigger than 34) and 8 side padding.
  - 24-high icon slot, 9 gap.
  - Labels bold 12; unselected colour #727272; top border #E9EAEC.
  - Ring icon for Marriage; bigger Material icons for the other tabs.
- `text_font_style.dart`: added `headline18w400textDark`,
  `headline18w500textWhite` and `headline16w500textWhite`.

---

## Verification so far (Pixel 5 over adb, in TEMP-VERIFY mode)

Each device screenshot was converted from Display-P3 to sRGB (the PNGs
embed a P3 ICC profile; without converting, #EF0160 reads as #DB2F62).
Then band positions and text rows were measured in design units.

| Area | Result |
|---|---|
| Top bar | circles ±0.3, logo position matches |
| Hero text rows / badge / dot / buttons | within ~0.5 |
| Filters teaser (139) | exact |
| Similarities (159) | within 0.7 |
| About me + intentions card (385 band) | within 0.3 (card internals not yet compared, see below) |
| Photos (490) and section rhythm (40 / heading / 17 / chips) | within 0.5 |
| My Faith, Future plans, Interests, Personality, Education, Languages | rows wrap the same as the mockup; within 0.5 |
| Verified card (158), compliment band (314), footer | within 0.5 |
| Bottom nav | icons +20, labels +57, height 88 |

Letter-spacing (`tracking`, in em) per role. Flutter lays Satoshi out 2–3%
wider than the mockup. On device, letter-spacing has ~2.5× the expected
effect (it also turns off ligatures), so these values were tuned on the
phone:
- default `lh()`: −0.0075
- chips: −0.003 (fixed My Faith wrapping onto 5 rows instead of 4)
- headings: −0.003
- Similarities body: −0.005
- bio: 0

---

## Session 2 (2026-10-06)

- Design saved: `resources/Find A Nikah.360 images/marriage_full_profile.jpg`.
- **Bio: verified on device.** Every line break and line end matches the
  mockup (±0.3). Step 1 below is done.
- Hero name/distance tracking set to −0.015, so widths match again (±1.5).
- Intentions card vertical layout verified (±0.3).
- Fixes found by measuring cap heights (glyph height is more reliable than
  width; the mockup renderer draws Satoshi narrower):
  - card titles (`ProfileCard`) → **medium** 18 (was regular)
  - verified rows → 14 (was 15)
  - intentions pill text → **medium 10**, line 14, tracking 0 (was 12);
    pill padding 11/11, icon gap 5.5
  - timeline labels → tracking 0
  - "Active today" → medium 14 (was 13)
- Removed the now-unused `headline18w400textDarkStyleSatoshi`.
- **Not yet verified on device** (the phone disconnected): the five fixes
  above.

## Resume here (next steps)

0. Reconnect the phone. Run, hot-reload, and re-measure the intentions
   card, verified card and "Active today" against the mockup.
1. ~~**Bio wrap check.**~~ Done. The last edit gave the bio tracking 0 and a 4.5 right
   inset, so the bio box ends at ~366 like the mockup. That edit was
   hot-reloaded but not measured yet. The mockup's line 1 ends at
   "…meeting new people" (x≈338), and the widest line is "…as long as they
   belong" (x≈365). Compare every bio line break with the mockup.
2. **Card internals:** crop and compare the intentions timeline (pill
   positions/widths, heart, ticks, labels) and the verified rows (badge
   x = 40.5, text x = 65.5, row pitch 27) against the mockup.
3. **Hero text widths:** these were matched with tracking −0.015. The
   default is now −0.0075, so re-check name/distance widths (mockup: name
   19.5–182.2, distance 48–251.8).
4. **Revert TEMP-VERIFY** in `main.dart`, run `flutter analyze`, and take a
   final screenshot in normal mode.
5. Things to raise with the user:
   - The buttons are **sticky**. The mockup's ~100 of bottom space isn't
     enough to clear them, so bottom padding was increased. Confirm sticky
     vs. scrolling away with the hero.
   - Icons are Material approximations or painted shapes. For a true pixel
     match, ask the designer for SVG exports (two-hearts Explore, chat,
     globe, filters, share, flag, pill icons).
   - The mockup uses the share/upload glyph for "Favourite" (a likely
     design mistake). It's matched as drawn for now.
   - The compliment placeholder says "about her". It's hard-coded; the
     model has no gender field.

### Tools used (scratchpad; recreate if gone)
- Slice the 4x mockup with PIL. `ink.py` measures ink rows and x extents
  per region; `bands.py` finds background bands and the ink rows inside
  them.
- `srgb.py` converts P3 screenshots to sRGB via ImageCms.
- Device: `flutter run -d 08201FDD4005BA --pid-file …`. Hot reload with
  `kill -USR1 <pid>`, hot restart with `kill -USR2 <pid>`.
- Screenshots: `adb exec-out screencap -p`. At TEMP-VERIFY scale,
  1 design unit = 2.75 px.
