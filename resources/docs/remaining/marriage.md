# Marriage (swipe deck)

Code: `lib/features/marriage/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| MAR-01 | 🔴 | App or Backend | After one **like** (and one **pass**) the Menu still showed **20 Likes** and Explore → My history → **Liked / Passed** were empty. `GET /likes/like-list` returns `tag: "Who Liked You"` and no items; `/profiles/feed/passed` is empty | **Verify first:** are swipes saved? Check the request/response in logs. If saved, History is reading the wrong list; if not, the swipe call is failing silently |
| MAR-02 | 🟠 | App | **Sort** icon and the **notification bell** in the Marriage header do nothing (no sheet, no toast) | Hide until built, or build |
| MAR-03 | 🟠 | App | In the card's action row, **Favourite** uses the *share* icon and gives no feedback; **Share profile** showed no share sheet when tapped | Verify both; fix the icon |
| MAR-04 | 🟡 | App | The four round action buttons sit on top of the content below the hero (they cover the "Curious about …'s filters?" banner and the "About me" heading) | Add bottom padding / reposition |
| MAR-05 | ⚪ | Product | Marriage shows **full names** ("Amina Al-Mansoor"); Feed shows first name + initial | Decision recorded in `../feed/02_DECISIONS.md`; confirm it is intended |
| MAR-06 | ✅ | — | Profile detail sections scroll; Pass moves to the next profile; Previous (undo) brings the last passed profile back | verified |

Not tested: compliment from the deck (see Feed Message for the same API), block/report from the deck, match dialog, running out of profiles, daily like limit reached, filters applied, the swipe gesture itself.
