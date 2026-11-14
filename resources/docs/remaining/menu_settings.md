# Menu, edit profile, settings, membership

Code: `lib/features/menu/`, `lib/features/edit_profile/` (check path), `lib/features/settings/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| SET-01 | 🔴 | App + Backend | Settings → Manage account → **"Delete marriage profile"** closes the sheet and **nothing happens** (no confirmation, no request). There is no way to delete the account | Apple and Google both require in-app account deletion. Needs a confirmation, a backend endpoint, and sign-out + data removal |
| SET-02 | 🔴 | App + Product | Membership: **"Upgrade now"** and every **"Get more"** button do nothing | Payments (App Store / Play Billing), plans, restore purchases are not built |
| SET-03 | 🟠 | App | "Start again" and "Take a break" in Manage account — not exercised | Test and confirm copy |
| SET-04 | 🟠 | App | "Safety & Advice" chip: coming soon | Content needed |
| SET-05 | 🟡 | App | Menu header bell and the notification toggle in Settings: no notification feature behind them | See `cross_cutting.md` XC-03 |
| SET-06 | 🟡 | Product | "Block social chat requests from women" is **ON by default** for a male account, and the text is gendered | Check the default and the wording for female accounts |
| SET-07 | 🟡 | App | Settings shows **First name "QA"** (locked "every 6 months") but the profile name is "QA Tester" | Clarify what the field edits |
| SET-08 | 🟡 | App | "Safety & Advice" chip is cut off at the right edge (horizontal chip row) — expected scroll, but nothing hints it scrolls | Polish |
| SET-09 | ✅ | — | Edit profile: Preview / Edit tabs, user info, Languages saved ("English, Bengali"), photos and location sections; Settings: personal info with locked fields; **Sign out** returns to login | verified |
| SET-10 | ⚪ | App | Not tested: Preview tab fully, every edit field, photo add/replace/reorder, email and phone change, "Who can see my marriage profile", sharing-link toggle, "Profiles I've blocked", "Block my phone contacts" (needs contacts permission), Invite sharing, Help tickets, "Report someone" | |
