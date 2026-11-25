# Features

One folder per screen or flow. Reference: `Settings/`.
Files: `<Name>View.swift`, `<Name>ViewModel.swift`, plus `<Name>Coordinator` and `<Name>Route` once it navigates.
Features use Domain, Core and DesignSystem. They never use each other or Data types directly.

## ViewModel
- `@MainActor @Observable final class`. State is `private(set)`.
- Dependencies come through `init`: repository protocols from Domain, or the shared `UserPreferences`. A ViewModel never creates them.
- Public methods are user intents (`select(_:)`, `dismissError()`). There is no SwiftUI state and no `Binding`.
- Errors:
  - Keep `private(set) var error: AppError?`.
  - Set it in `catch` with `AppError(error)`; this gives `nil` on cancellation.
  - Clear it with `dismissError()`.
- `// MARK: - UI configurators` extension:
  - It builds every component configurator: `<element>Configurator`, or `<element>Configurator(_:)` for rows.
  - Selection state and actions are decided here.
  - Actions call ViewModel methods.

## View
- `let viewModel: <Name>ViewModel`. `body` only composes Design System components from configurators. No logic.
- Screen chrome: `.navigationTitle(.<feature>Title)` and `.errorAlert(viewModel.error) { viewModel.dismissError() }`.
- Repeated sections share one `private` helper. If sections differ only by data, the helper is generic and takes the options plus a configurator method:
  `selectionCard(Appearance.allCases, row: viewModel.appearanceRowConfigurator)`.
- `#Preview` uses real types on isolated storage (`UserDefaultsStore.isolated()`).

## Wiring
App builds dependencies once. Root ViewModels live in App `@State`; pushed screens get theirs from their Coordinator through factories injected by App. Never inside `body`.

## Tests
`Unit/<Name>/<Name>ViewModelTests.swift`, tags `.unit, .feature`. Rules: `BlixRekrtuacjaTests/Unit/CLAUDE.md`.
Failure paths use stubs (`FailingKeyValueStoreStub`). State the view reads from `UserPreferences` is tested there, not here.
