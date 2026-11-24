# Tests

Swift Testing suite. Area rules: `Unit/CLAUDE.md`, `Snapshot/CLAUDE.md`.

## Before adding a test
- Test behaviour that can break: decisions, state changes, error paths, edge cases (empty, duplicate, boundary, repeated call).
- Each case reflects a real situation. No variations for their own sake.
- Skip what the compiler, Apple frameworks or an existing test already guarantee.
- Prefer a new argument in an existing test over a new test.
- Remove tests that no longer protect any behaviour.

## Failing tests
- Fix the code, or prove the test is wrong and fix the test.
- Never weaken an assertion, drop a case or add `.disabled` to get green.

## Determinism
- Same result on every run, in any order, in parallel.
- Forbidden: timeouts, `Date()`, randomness, network, file system, `UserDefaults.standard`, shared mutable state.
- Inject time, IDs and side effects; fix their values in tests.
- Events: `confirmation` (exact count). Async results: `await` directly, never poll.
- Unavoidable static state: `@Suite(.serialized)`.

## Conventions
- Tools: `@Test`, `#expect`, `#require`, `confirmation`.
- `#require` for preconditions (unwrapping, initial state) — it stops the test. `#expect` for the actual checks.
- Tested object is `sut`. Arrange, act, assert separated by one blank line.
- Suite is `@MainActor` when the tested type is.
- Every suite has one kind and one area tag from `Tags.swift`: `@Suite(.tags(.unit, .networking))`. New area → add a tag there.
- Names describe behaviour: `notifiesObserversWhenPathChanges`.
- Tests ship in the same commit as the code they cover.
- While working run one suite (`-only-testing:BlixRekrtuacjaTests/<Suite>`); run everything before a commit.

## Mocks and stubs
- `Mocks/<Area>/<Type>Tests+Mocks.swift`: test data for one suite (`Scenario`, `Action`, sample models) as an extension of the suite.
- `Stubs/<Area>/<Type>Stub.swift`: one per file, `internal`, shared by all tests.
- Fixed data or closures set by the test. No logic, randomness or assertions inside.
- To verify a call, record it through a closure passed by the test and assert in the test.
- Closures that run on other threads (e.g. `URLProtocol` handlers) only record; assert after `await`.
- If the app provides a lightweight isolated implementation, use it instead of a stub.
