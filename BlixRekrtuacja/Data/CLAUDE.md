# Data

Data talks to the outside world: networking, repositories, DTOs and the on-device cache.
It knows Domain and Core.

## Networking (`Networking/Client/`, `Networking/Errors/`)
- Every request goes through the `HTTPClient` protocol and `Endpoint<Response>` (path, method, query, body).
  Only `URLSessionHTTPClient` touches `URLSession`.
- The client throws typed `APIError` and logs once with `Logger.network`.
- Use `EmptyResponse` for requests without a body in the reply.
- Errors reach Features as `AppError`: `APIError` through `AppErrorConvertible` (`APIError+AppError.swift`); Fixer error
  codes, incomplete Fixer bodies and storage failures throw `AppError` directly. Never map them in ViewModels.
- Extensions of Apple types used only by Data live in `Extensions/<Type>+Extension.swift`.

## Repositories (`Repositories/<Name>/`)
- The protocol `<Name>Repository` and its entities live in `Domain/`. `Remote<Name>Repository` takes an `HTTPClient`.
- DTOs (`<Source><Name>Response`, e.g. `FixerRatesResponse`) sit next to the repository, are `Decodable` and `Sendable`,
  map themselves to Domain (`dailyRates()`) and never leave Data.
- The base URL and the API key are injected in App, never hardcoded. The key travels in the query, so URLs are never logged.

## Rates (`Repositories/Rates/`)
- Fixer reports errors in HTTP 200 bodies: `success == false` maps its code to `AppError` in the DTO.
- `CachedRatesRepository` reads through `RatesCache`:
  - a closed day (before today, UTC) is fetched once and kept;
  - `latest` answers from the day it last returned for an hour (`latestFetchedAt`; not today on weekends);
  - intraday rates never replace closing ones: the rule lives in the cache's `save`.

## Storage (`Storage/<Name>/`)
- On-device caches, separate from networking. A repository reads them through a protocol (`RatesCache`).
- `SwiftDataRatesCache` (`@ModelActor`) stores rates as decimal strings, so no digit is lost. `@Model` types never leave Data.

## Tests
- Client: `Unit/Networking` with `URLProtocolStub`.
- Repositories: a stubbed `HTTPClient` that returns fixed DTOs or `APIError`s.
- Cache: `SwiftDataRatesCache(isStoredInMemoryOnly: true)`; cache failures use `RatesCacheStub`.
