# Backend requirement — Explore › "Currently available"

**From:** mobile app · **Date:** 2026-11-17 · **Priority:** P1 (the section is on the Explore "For you" tab and is currently fake)

## What the app needs

One new endpoint that returns the members who **have at least one free chat
slot**, shown on Explore → For you as the "Currently available" section
("Members who have at least one slot available to chat").

Today the app shows hard-coded fake profiles for this section because no
endpoint exists. Every other Explore section already uses a real
`/v1/profiles/feed/*` endpoint; this one should look the same so the app
reuses the same card, paging and cache code.

## Endpoint

```
GET /v1/profiles/feed/currently-available?page=1&limit=12
Authorization: Bearer <token>
```

- Same router, auth and response wrapper as `/v1/profiles/feed/near-you`
  (`discovery.routes.js`, `getNearYou`).
- `page` starts at 1. `limit` defaults to 12 (the app asks for 12), max 20.

## Who is "currently available"

A member qualifies when **all** of these are true:

1. They have a **free chat slot**: their active conversation count is below
   their limit. Use the same rule as `chat.controllers.js`:
   active = conversations where `participants` contains them and `archivedBy`
   does not contain them; limit = `10` if subscribed (Gold) else `5`.
   (`CHAT_LIMIT` 409 is already thrown from the same check when a chat starts,
   so the two must agree.)
2. They are visible to the viewer the way the other feeds already do it:
   opposite gender, same religion by default, `isDiscoverable: true`, published
   profile, not the viewer, and **not blocked in either direction**, not
   already passed / hidden by the viewer (reuse the `hidden` list from
   `getNearYou`).
3. Optional but recommended: recently active (suggest last 7 days, the same
   window the other feeds use), so the section does not list dormant accounts.

Order: most recently active first, then `completeness` descending.

## Response

Same shape as the other feeds, so no new app parsing:

```json
{
  "statusCode": 200,
  "success": true,
  "message": "Currently available",
  "data": {
    "profiles": [
      {
        "userId": "…",
        "profileId": "…",
        "fullName": "…",
        "isVerified": true,
        "lastActiveAt": "2026-11-17T04:58:54.368Z",
        "gender": "female",
        "photoUrl": "/public/upload/x.jpg",
        "images": ["/public/upload/x.jpg"],
        "age": 26,
        "dateOfBirth": "2000-01-01T00:00:00.000Z",
        "maritalStatus": "never_married",
        "professionTitle": "…",
        "educationLevel": "…",
        "religion": "islam",
        "faith": ["…"],
        "city": "Dhaka",
        "country": "Bangladesh",
        "distanceKm": 12.5,
        "completeness": 90,
        "publishedAt": "…"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "limit": 12,
      "totalPages": 3,
      "totalCount": 30,
      "hasNext": true,
      "hasPrev": false
    },
    "tag": "Currently Available"
  }
}
```

Field names and types match what the other feeds already return (the app
reads `userId`, `fullName`, `isVerified`, `lastActiveAt`, `photoUrl`, `age`,
`city`, `country`, `distanceKm`). Nothing new is required on the card.

Empty result: `200` with `profiles: []` and a normal `pagination`
(`totalCount: 0`), not `404`.

## Questions for backend

1. Is the "free slot" rule above right (5 free / 10 Gold, archived chats do not
   count)? If there is another notion of "available" (an availability toggle
   the member sets), say so and we will follow it.
2. Should a member with **no** free slots be hidden, or shown greyed? We assume
   hidden.
3. Should it exclude members the viewer already has a conversation with? We
   suggest yes.
4. Should this honour the viewer's discovery filters (age, country, ethnicity,
   faith, city) the way `/profiles/cards` does? We suggest yes, same query
   params, but it can be a later step.
5. Premium: is any part of this gated (like "visited you")? If so, use the same
   `locked` / `totalCount` shape those feeds use.

## Why it matters / app side

- The app currently renders fake names and online avatar images in this
  section. Until the endpoint exists the app will hide the section, so
  members do not mistake it for real data.
- Once the endpoint exists the app change is small: add `currently-available`
  to the feed path list in `explore_repository_impl.dart` (`feedPath`), move
  the section from the dummy source to the live sections, and reuse the
  existing cache-then-network paging.

## Acceptance

- `GET /v1/profiles/feed/currently-available?page=1&limit=12` returns only
  members with a free slot, opposite gender, same religion, not blocked, not
  the viewer.
- A member who fills their last slot disappears from the list; one who archives
  a chat appears.
- Paging works (`hasNext`, `totalCount`), and the response shape matches
  `near-you`.
