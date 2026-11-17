# Menu, edit profile, settings, membership

Code: `lib/features/menu/`, `lib/features/edit_profile/` (check path), `lib/features/settings/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| SET-02 | 🔴 | App + Product | Membership counters work. **Missing:** plan list/prices (`GET /subscriptions/plans`), paywall, buying (`verify-purchase`), restore. "Upgrade now" / "Get more" say coming soon | Needs `in_app_purchase`, store product IDs, paywall design |
| SET-03 | 🟠 | App + Product | "Take a break" still says coming soon — needs durations and a resume rule | Decision needed |
| SET-04 | 🟠 | App | "Safety & Advice" chip: coming soon | Content needed |
| SET-06 | 🟡 | Product | "Block social chat requests from women" is ON by default for **both** male and female accounts (seen on a new female account), wording gendered | Fix default and wording per gender |
| SET-07 | 🟡 | App | Settings shows **First name "QA"** (locked "every 6 months") but the profile name is "QA Tester" | Clarify what the field edits |
| SET-08 | 🟡 | App | "Safety & Advice" chip is cut off at the right edge (horizontal chip row) — expected scroll, but nothing hints it scrolls | Polish |
| SET-10 | ⚪ | App | Not tested: Preview tab fully, every edit field, photo add/replace/reorder, email and phone change, "Who can see my marriage profile", sharing-link toggle, "Profiles I've blocked", "Block my phone contacts" (needs contacts permission), Invite sharing, Help tickets, "Report someone" | |
| SET-12 | ⚪ | App | Settings also has **Restore purchases**, **Passcode** ("require a passcode every time you open the app") and **Chaperone** rows, plus a **Language** row. Not exercised; most likely not built | Test each; build or hide (Passcode and Chaperone need product definitions; restore needs B-05) |
