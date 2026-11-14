# Feed — profile design (one member, two sides)

## Idea (from the product owner)

Feed members are the same users as Marriage. A member's profile opened from
Feed shows their **Feed activity** (posts, comments, likes) and has a way to
open their **Marriage profile**. Both share the same base data (photo, name,
country, verified); Feed adds activity data.

## Proposed layout (dummy version is on the device now)

One page, header shared, a two-option switch under the header buttons:

```
[ back ]                     [ search ][ share ][ ⋮ ]
(photo)  Name
         @handle
N Followers   N Following
🇧🇩 Country   📅 Joined Oct 2026
[ Message ] [ Follow ]
( Feed activity | Marriage profile )      ← switch
─────────────────────────────────────────
Feed activity:  stats card, tabs Posts · Comments · Likes
Marriage profile: the full Muzz-style card (same as Menu → Edit profile → Preview)
```

- **Default side** depends on where you came from (proposed, not yet confirmed — O7):
  from Feed → Feed activity; from the Marriage deck / Explore / Chat → Marriage profile.
- Groups tab removed (groups not in v1).
- Follow toggles Follow ↔ Following (optimistic when real).

## Marriage side = shared `profile_view`

The Marriage side must not be a third copy of the profile card. It becomes the
shared `profile_view` feature already designed in `../PENDING.md`
("profile_view — shared member profile"): one `ProfileView` widget and a
`/profile/:id` page, used by Marriage, Explore, Chat, Feed and Menu → Preview.
Until then `feed_marriage_preview.dart` is a copy of Menu's Preview for visual
review only.

## Locked-profile rule (decision 16)

- The Marriage side is **always shown**. The server returns, per viewer, an
  `access` object: `level` (`full | partial | locked`), `reason`
  (`BLOCKED | NOT_IN_FILTERS | NOT_ELIGIBLE | PREMIUM_REQUIRED`),
  `unlockable`, `lockedSections`.
- Visible sections render normally. Locked sections render **blurred** with a
  message like "This profile isn't available to you".
- **Security rule:** locked data is **withheld by the server** (null/omitted;
  photos replaced by a pre-blurred low-res image or no URL). The app must never
  receive real data and blur it itself — that can be bypassed.
- Later, `unlockable: true` + `PREMIUM_REQUIRED` lets the blur carry an
  "Unlock" call-to-action (paid). No UI for payment is planned now.
- Open questions O3, O4 (likes privacy, counting a view) are in `02_DECISIONS.md`.

## Backend asks for this design

`NEED_FROM_BACKEND_FEED.md` §13 (access contract), §14 (Feed profile + tabs),
§15 (follow).

## Review notes on the dummy layout (to decide, O8)

- The switch is visually strong; a quieter text toggle may suit if the Marriage
  side is often locked.
- Stats card + 4 tabs is a lot; drop the card or move the counts into the tabs.
- The Marriage side has no photo carousel in the dummy; the real one has photos
  between sections.
- Dummy photos are random avatars (not the same person) — dummy only.
