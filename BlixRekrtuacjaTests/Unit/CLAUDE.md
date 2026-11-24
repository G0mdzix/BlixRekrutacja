# Unit tests

General rules: `../CLAUDE.md`. Reference file: `Coordinator/CoordinatorTests.swift`.

## Layout
- `Unit/<Area>/<Type>Tests.swift` containing `struct <Type>Tests`.
- File order: tests, then `// MARK: - Helpers`.
- Test data (`Scenario`, `Action`, sample models) lives in `Mocks/<Area>/<Type>Tests+Mocks.swift` as `extension <Type>Tests`.
- Argument lists live there too as `static let` named after the behaviour (`pathScenarios`, `mappings`) and are passed as `@Test(arguments: Self.pathScenarios)`.
  On a `@MainActor` suite mark them `nonisolated static let`.

## Parameterization
- One `@Test` per behaviour, every case in `arguments:`.
- A case is a `Scenario` with named fields: input and expected result.
- Input is data (`enum Action`) applied by a private helper, so the test body stays arrange, act, assert.

## Coverage per type
- Happy path, every error path, initial and empty state, boundaries, repeated operations.
- Error paths assert the exact error: `#expect(throws: APIError.status(404)) { try … }`.
- Async: `await sut.load()`, then assert state. Never start a `Task {}` inside a test.
- ViewModels: drive them through component view models (`sut.saveButtonViewModel.action()`) and assert state. No UI.
- State the UI observes: verify change notification with `withObservationTracking` and `confirmation`.
