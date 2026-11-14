# Feed — documentation index

Everything about the Feed tab (community posts) lives in this folder.
Last updated: 2026-11-14.

**Status (2026-11-14):** the Feed runs on the **real API** (all phases built and
unit-tested; core flows verified on a phone). Round 2 to the backend is written
(`NEED_FROM_BACKEND_FEED_V2.md`) and **not yet sent**. Left: locked-profile
sample, messaging rule, deep links, shared `profile_view`.

## Read in this order

| File | What it is | Audience |
|---|---|---|
| [01_CURRENT_STATE.md](01_CURRENT_STATE.md) | What exists today: screens, code layout, dummy UI | us |
| [02_DECISIONS.md](02_DECISIONS.md) | Product decisions (final) + what is still open | us |
| [03_PHASES.md](03_PHASES.md) | The phased rollout — what ships when, how the app stays working | us |
| [04_PROFILE_DESIGN.md](04_PROFILE_DESIGN.md) | One profile, two sides (Feed activity / Marriage profile) and the locked-profile rule | us + backend |
| [05_MOBILE_GAPS.md](05_MOBILE_GAPS.md) | App-side bugs, risks and missing pieces, with status | us |
| [NEED_FROM_BACKEND_FEED.md](NEED_FROM_BACKEND_FEED.md) | **The request to the backend** — the only file to send them | backend |
| [FEED_MOBILE_IMPLEMENTATION_PLAN.md](FEED_MOBILE_IMPLEMENTATION_PLAN.md) | **The backend's answer** (verbatim): endpoints, real responses, errors, test accounts | us |
| [06_BACKEND_REPLY_REVIEW.md](06_BACKEND_REPLY_REVIEW.md) | Our review of that answer: decisions closed, concerns C1–C14 | us |
| [07_VERIFICATION_LOG.md](07_VERIFICATION_LOG.md) | What was tapped through on a phone against the live API, and what wasn't | us |
| [NEED_FROM_BACKEND_FEED_V2.md](NEED_FROM_BACKEND_FEED_V2.md) | **Round 2 to the backend** — bugs found + open questions (BE-1…BE-17) | backend |
| [PROGRESS.md](PROGRESS.md) | Tracker: per endpoint — asked / integrated / verified on device | us |

## Resuming work — checklist

1. Read `02_DECISIONS.md` (what is settled) and `PROGRESS.md` (what is done).
2. Send `NEED_FROM_BACKEND_FEED_V2.md`; record their answers there.
3. Finish the ❌ items in `07_VERIFICATION_LOG.md` once test accounts / data exist.
4. Then: shared `profile_view`, deep links, messaging rule (`05_MOBILE_GAPS.md`).

## Related files outside this folder

- `../PENDING.md` — one-line Feed entry that points here.
- `../APP_STATUS.md` §9 — the app-wide status table (Feed row).
- `lib/features/feed/` — the code. Temporary dummy UI:
  `presentation/widgets/feed_profile_extras.dart`,
  `presentation/widgets/feed_marriage_preview.dart`.
- Same pattern as Marriage: `../NEED_FROM_BACKEND_MARRIAGE*.md`.
