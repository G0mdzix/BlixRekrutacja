# Features

The app's screens, one module under one coordinator. Features use Domain, Core and DesignSystem, never Data types.
- `Screens/<Name>/`: `<Name>View.swift` + `<Name>ViewModel.swift`. Reference: `Screens/Settings/`.
  A screen never uses another screen.
- `Models/`: types several screens share (`RateSelection`, `DaySelection`, `RateDateFormat`).
- `Navigation/`: the only place that knows every screen. `MainCoordinator` creates the ViewModels, `MainRoute` carries
  them, `MainDestination` shows the screen for a route. A pushed screen's ViewModel is `nonisolated Hashable` by
  identity (`===`, `ObjectIdentifier`), as in `SettingsViewModel`.

## ViewModel
- `@MainActor @Observable final class`. State is `private(set)`.
- Dependencies come through `init`: Domain repository protocols, the shared `UserPreferences`, `Models/` values and
  side-effect closures (`copy`). A ViewModel never creates them.
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
- Screen chrome: `.navigationTitle(.<feature>Title)`, toolbar buttons and `.errorAlert(viewModel.error) { viewModel.dismissError() }`.
  A screen that keeps a failure in place (Rates: empty state, footer card) shows it inline instead and has no alert.
- A screen with several states switches over one ViewModel enum (`RatesViewModel.Content`, `.Footer`).
- Repeated sections share one `private` helper. If sections differ only by data, the helper is generic and takes the options plus a configurator method:
  `selectionCard(Appearance.allCases, row: viewModel.appearanceRowConfigurator)`.
- `#Preview` uses real types on isolated storage (`UserDefaultsStore.isolated()`).

## Wiring
App's `AppContainer` builds dependencies once, including platform side effects as closures (pasteboard), and gives
them to `MainCoordinator`, which creates every ViewModel: the root once (`root`), pushed screens when they are pushed
(`MainRoute.day`, `.rate`, `.settings`). ViewModels report intents through callbacks (`onSelectRate`, `onShowDay`,
`onOpenSettings`) wired to the coordinator. Never inside `body`.

## Tests
`Unit/Features/<Name>ViewModelTests.swift` and `MainCoordinatorTests.swift`, tags `.unit, .feature`.
Screens: `Snapshot/Features/<Name>ViewSnapshotTests.swift` in a `NavigationStack`, `configurator: .screen`, data from
repository stubs (`RatesRepositoryStub`, `RatesSamples.market`). Rules: `BlixRekrtuacjaTests/Unit/CLAUDE.md`,
`BlixRekrtuacjaTests/Snapshot/CLAUDE.md`.
Failure paths use stubs (`FailingKeyValueStoreStub`). State the view reads from `UserPreferences` is tested there, not here.
