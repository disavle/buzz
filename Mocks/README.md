# Mocks

Fake data for previews, tests and for running the app without the backend.

| What | Where | Used by |
|---|---|---|
| Starting drink catalog (8 drinks, fixed ids) | [`catalog.json`](catalog.json) | Same data as `SeedCatalog` in iOS and `SeedDrinks` in the backend |
| Example API requests and responses | [`api/`](api/) | Documentation for `docs/backend/API.md`, handy for Postman / curl |
| In-memory repositories and preview data | `iOS/Modules/Domain/Sources/Fakes/` | SwiftUI `#Preview` and unit tests |
| Fake server in Swift | `iOS/Modules/Networking/Sources/MockAPIClient.swift` | Tests, and the app with `BUZZ_MOCK_API=1` |

## Run the app with the fake server

In Xcode: **Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables**, add `BUZZ_MOCK_API = 1`.
Any email and an 8+ character password will log you in. Add `BUZZ_IN_MEMORY = 1` to start with an empty database every launch.

## Rules for these files

- Dates are ISO 8601 in UTC (`2026-10-15T21:00:00Z`), like the real API (`Shared/Sources/Shared/Coding.swift`).
- The seed drink ids are `00000000-0000-0000-0000-00000000000N`. They must stay the same in all three places, otherwise an entry created offline points to a drink the server does not know.
- Error bodies only have a code (`"error": "limit_invalid"`). The app translates the code; `reason` is for developers.
- Values are approximate. They are for development, not for nutrition advice.
