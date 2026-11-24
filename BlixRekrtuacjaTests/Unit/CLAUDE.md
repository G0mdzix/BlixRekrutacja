# Unit tests

General rules: `../CLAUDE.md`. Reference file: `Coordinator/CoordinatorTests.swift`.

## Layout
- `Unit/<Area>/<Type>Tests.swift` containing `struct <Type>Tests`.
- File order: tests, `// MARK: - Helpers`, `// MARK: - Test data` (extension with `Action` and `Scenario`).

## Parameterization
- One `@Test` per behaviour, every case in `arguments:`.
- A case is a `Scenario` with named fields: input and expected result.
- Input is data (`enum Action`) applied by a private helper, so the test body stays arrange, act, assert.

## Coverage per type
- Happy path, every error path, initial and empty state, boundaries, repeated operations.
- Error paths assert the exact error: `#expect(throws: AppError.storage) { try … }`.
- Async: `await sut.load()`, then assert state. Never start a `Task {}` inside a test.
- ViewModels: drive them through component view models (`sut.saveButtonViewModel.action()`) and assert state. No UI.
- State the UI observes: verify change notification with `withObservationTracking` and `confirmation`.
