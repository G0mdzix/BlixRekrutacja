# Data

Data talks to the outside world: networking now, repositories and DTOs once the first API exists.
It knows Domain and Core.

## Networking (`Networking/`)
- Every request goes through the `HTTPClient` protocol and `Endpoint<Response>` (path, method, query, body).
  Only `URLSessionHTTPClient` touches `URLSession`.
- The client throws typed `APIError` and logs once with `Logger.network`.
- Use `EmptyResponse` for requests without a body in the reply.
- Map errors to `AppError` only in `APIError+AppError.swift`, through `AppErrorConvertible`. Never map them in ViewModels.

## Repositories (first API)
- The protocol `<Name>Repository` and its entities live in `Domain/`.
  The implementation is `Data/Repositories/<Name>/Remote<Name>Repository.swift` and takes an `HTTPClient`.
- DTOs (`<Name>Request`, `<Name>Response`) sit next to the repository. They are `Codable` and `Sendable`.
  The repository maps them to Domain entities, so DTOs never leave Data.
- The base URL and other config are injected in App, never hardcoded in a repository.

## Tests
- Client: `Unit/Networking` with `URLProtocolStub`.
- Repositories: a stubbed `HTTPClient` that returns fixed DTOs or `APIError`s.
