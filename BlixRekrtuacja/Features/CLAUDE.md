# Features

The app's screens, one module under one coordinator. Features use Domain, Core and DesignSystem, never Data types.
- `Screens/<Name>/`: `<Name>View.swift` + `<Name>ViewModel.swift`. Reference: `Screens/Settings/`.
  A screen never uses another screen.
- `Shared/`: values passed between screens, logic a ViewModel delegates, and Domain → configurator mapping.
  Other single-screen helpers stay in the screen's folder.
  - `Models/`: values passed between screens (`RateSelection`, `DaySelection`).
  - `Services/`: state and logic a ViewModel delegates (`RatesHistory`, `AppError.stopsLoading`). A ViewModel creates the
    services it owns from its injected dependencies.
  - `Presentation/`: Domain data turned into screen values and configurators (`DailyRates+Selection`,
    `RateSelection+Row`, `AppError+Rates`, `RateDateFormat`).
- `Navigation/`: the only place that knows every screen. `MainCoordinator` creates the ViewModels and implements
  `MainNavigating`, `MainRoute` carries them (compared by identity), `MainDestination` shows the screen for a route.

## ViewModel
- `@MainActor @Observable final class`. State is `private(set)`.
- Dependencies come through `init`, as protocols or values: Domain repositories, `UserPreferences`, Core services
  (`Clipboard`, `DateProvider`), `Shared/Models` values and `navigator: any MainNavigating`, held `@ObservationIgnored weak`.
  Never closures per intent.
- Public methods are user intents (`select(_:)`, `loadNextDay()`). No SwiftUI types; the one exception is a text input
  the view binds with `@Bindable` (`DayRatesViewModel.query`).
- Mapping and rules shared by screens live in `Shared/`, not in a ViewModel.
- Errors: keep `private(set) var error: AppError?`, set it in `catch` with `AppError(error)` (`nil` on cancellation)
  and show it inline where the data would appear (empty state, footer card). There are no alerts.
- `// MARK: - UI configurators` extension:
  - It builds every component configurator: `<element>Configurator`, or `<element>Configurator(_:)` for rows.
  - Selection state and actions are decided here.
  - Actions call ViewModel methods.

## View
- `let viewModel: <Name>ViewModel`. `body` only composes Design System components from configurators. No logic.
- Screen chrome: `.navigationTitle(.<feature>Title)` and toolbar buttons.
- A screen with several states switches over one ViewModel enum whose cases carry their configurators
  (`RatesViewModel.Content`); `body` never unwraps optional configurators for state.
- Toolbar items are a `private var … : some ToolbarContent`.
- Repeated sections share one `private` helper. If sections differ only by data, the helper is generic and takes the options plus a configurator method:
  `selectionCard(Appearance.allCases, row: viewModel.appearanceRowConfigurator)`.
- `#Preview` uses real types on isolated storage (`UserDefaultsStore.isolated()`).

## Wiring
App's `AppContainer` builds dependencies once (`SystemClipboard` among them) and gives them to `MainCoordinator`,
which creates every ViewModel: the root once (`root`), pushed screens when they are pushed (`MainRoute.day`, `.rate`,
`.settings`). ViewModels ask for navigation through `MainNavigating` (`showRate`, `showDay`, `showSettings`).
Never inside `body`.

## Tests
Tests mirror this folder: `Unit/Features/Navigation/`, `Unit/Features/Screens/<Name>/`, `Snapshot/Features/Screens/<Name>/`,
`Mocks/Features/…`; tags `.unit|.snapshot, .feature`. Dependencies are spies (`RatesRepositorySpy`, `MainNavigatingSpy`,
`ClipboardSpy`); screens in a `NavigationStack`, `configurator: .screen`. Rules: `BlixRekrtuacjaTests/Unit/CLAUDE.md`,
`BlixRekrtuacjaTests/Snapshot/CLAUDE.md`.
State the view reads from `UserPreferences` is tested there, not here.
