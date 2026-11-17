# Resolved (removed from the feature files)

Date = day it was verified on a real device. Kept as a short history so a row never just vanishes.

| Date | ID | What | How |
|---|---|---|---|
| 2026-11-15 | AUTH-01 | Login prefilled with dev credentials in every build | Prefilled only in the dev flavor (`login_page.dart`); dev flavor checked on the phone, staging/prod not buildable here |
| 2026-11-15 | AUTH-04 | Welcome: dead language, help, Terms, Privacy | Language and help hidden; Terms/Privacy open `findanikah.com/terms` and `/privacy-policy` (`LegalFooterText`, `url_launcher`) |
| 2026-11-15 | SUP-01 | Email field capital letters | No capitalization, autocorrect or suggestions on email fields; typed text stays lower-case |
| 2026-11-15 | SUP-03 | Code screen: Continue hidden behind keyboard | Keyboard closes after the 6th digit (email and phone code) |
| 2026-11-15 | SUP-04 | Digits dropped when typing the code | **Not a bug** — my test tapped the second box; typing from the first box works |
| 2026-11-15 | SUP-05 | "number (1-9)" rule text | Now "At least 1 number" |
| 2026-11-15 | SUP-06 | No message for mismatched passwords | New "Both passwords match" rule row |
| 2026-11-15 | MAR-01 / EXP-01 | Likes/passes "not saved", History empty | Swipes were saved all along; History → Liked read the wrong endpoint, now `/likes/sent` (shows the liked member) |
| 2026-11-15 | MAR-02 | Dead Sort and bell in Marriage header | Hidden (owner's decision); build later — see `../PENDING.md` |
| 2026-11-15 | SET-11 | Settings lost on restart | Notifications and Message preview save to `PATCH /me/settings`; checked after a force-stop |
| 2026-11-15 | XC-09 | Analyzer warning in `chat_room_page.dart` | Silenced; `dart analyze lib` shows no errors or warnings |
| 2026-11-15 | FEED A7, A10 | "1 Likes"; top comment shown twice on the post page | Singular labels; preview off on the post page |
| 2026-11-15 | AUTH-02 | Forgot password | Email → code + new password → login with new password; old rejected (device + API) |
| 2026-11-15 | SET-01 | Delete account, Start again | Start again toast "Your deck was refreshed"; Delete → signed out, token returns 401 |
| 2026-11-15 | SET-02 (part) | Membership counters | Menu card shows plan, 10 likes, 1 compliment, 0 likes in filters from `/subscriptions/me` |
| 2026-11-15 | EXP-05 (part) | Liked / Complimented tabs | Both list the member; Favourited shows its empty state (Favourite button itself not reachable, see FA-MAR-01) |
| 2026-11-15 | MAR-03 / EXP-05 | Favourite button + Favourited tab | Toast "Added to your favourites", server list has the member, tab lists them |
| 2026-11-15 | SET-05 / P2-FEED-01 | Dead bells (Menu, Feed) | Hidden (commented, see PENDING) |
| 2026-11-15 | XC-07 / AUTH-07 | Back at root left the app | Back → first tab; on first tab "Press back again to exit" (2 s) |
| 2026-11-15 | FA-AUTH-01 | Reset password field taller | Suffix constraints; (visual check pending) |

