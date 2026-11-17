# Marriage (swipe deck)

Code: `lib/features/marriage/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| MAR-04 | ⚪ | Product | The round action buttons float over the scrolling profile (by design: content scrolls under them) | Confirm it matches Figma |
| MAR-05 | ⚪ | Product | Marriage shows **full names** ("Amina Al-Mansoor"); Feed shows first name + initial | Decision recorded in `../feed/02_DECISIONS.md`; confirm it is intended |

Not tested: compliment from the deck (see Feed Message for the same API), block/report from the deck, match dialog, running out of profiles, daily like limit reached, filters applied, the swipe gesture itself.

| MAR-03 | 🟡 | Product | Favourite works (toast, server list, Explore → Favourited). Still open: no "already favourited" state or remove (`DELETE /favorites/:id`), and Share profile says coming soon | Needs a design |
