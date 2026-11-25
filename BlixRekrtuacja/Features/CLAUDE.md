# Features

The app's screens: one module, one coordinator. Features use Domain, Core and DesignSystem, never Data.
Goal: the fewest lines that read top to bottom. Match the existing files before inventing a pattern.
Reference files: simple screen `Screens/Settings/`, several states `Screens/Rates/`, text input `Screens/DayRates/`.

## Folders
- `Screens/<Name>/`: `<Name>View.swift` + `<Name>ViewModel.swift`. A screen never uses another screen.
- `Shared/` holds only what several screens use or a ViewModel delegates; single-screen helpers stay in the screen's folder.
  - `Models/`: plain values passed between screens (`RateSelection`, `DaySelection`). No UI, no navigation.
  - `Services/`: state and rules a ViewModel delegates (`RatesHistory`, `AppError.stopsLoading`).
  - `Presentation/`: Domain → screen values and configurators (`DailyRates+Selection`, `RateSelection+Row`,
    `AppError+Rates`, `RateDateFormat`).
- `Navigation/`: the only place that knows every screen: `MainCoordinator` (creates ViewModels, implements
  `MainNavigating`), `MainRoute` (carries them, compared by identity), `MainDestination` (route → screen).

## Adding a screen
1. ViewModel and View in `Screens/<Name>/`; strings in the catalog (PL + EN).
2. A `MainRoute` case, a `show…` in `MainNavigating` and `MainCoordinator`, a case in `MainDestination`.
3. Anything a second screen needs moves to `Shared/`. A ViewModel past ~150 lines delegates to `Shared/Services`.
4. Unit tests for every intent and state; light + dark screen snapshots for every settled state.

## ViewModel
- `@MainActor @Observable final class`. State `private(set)`; only intents and configurators are public besides it.
- `init` takes protocols or values only: Domain repositories, `UserPreferences`, Core services (`Clipboard`,
  `DateProvider`), `Shared/Models` values, `navigator: any MainNavigating`. No defaults, no closure per intent.
  `navigator` is `@ObservationIgnored private weak var`; `let` dependencies need nothing.
- Services the ViewModel owns (`RatesHistory`) are built in its `init` from injected dependencies.
- Public methods are user intents (`start()`, `loadNextDay()`, `select(_:)`, `openSettings()`). The only settable
  property is a text input the view binds with `@Bindable` (`DayRatesViewModel.query`).
- A screen with several states exposes one enum whose cases carry their configurators (`RatesViewModel.Content`,
  `DayRatesViewModel.Results`), computed as an `if`/`switch` expression. The view never unwraps optionals for state.
- Errors: `private(set) var error: AppError?`, set in `catch` as `AppError(error)` (`nil` on cancellation), shown inline
  where the data would be (empty state, footer card). No alerts.
- File order: nested enums → state → private dependencies → `init` → state enums → intents → private helpers →
  `// MARK: - UI configurators` extension → `// MARK: - Constants` (`private extension` unless tests need it).
- UI configurators: `<element>Configurator`, or `<element>Configurator(_:)` for rows. Actions capture `[weak self]` +
  `guard let self` and call an intent; async intents run in `Task { await self.intent() }`. Repeated buttons share one
  private builder (`loadButton(title:style:isLoading:)`). Rows that open a screen use `RateSelection+Row`.

## View
- `let viewModel` (`@Bindable var` only for a text input). `body` is a short outline: a container, named sections,
  then chrome (`.navigationTitle`, `.toolbar`, `.task`, `.blixSearchable`).
- Every section is a `private var … : some View` (`ratesCard`, `results`), or a `private func` when it needs data from
  an enum case (`list(baseInfo:)`). Toolbar items are `private var … : some ToolbarContent`.
- Sections differing only by data share one generic helper:
  `selectionCard(Appearance.allCases, row: viewModel.appearanceRowConfigurator)`.
- Only Design System components fed by configurators, plus layout (`VStack`, `ForEach`, `.cardBackground`, `Spacing`).
  No formatting, filtering or business `if`s in the view.
- Lists go through `BlixList`. Paging triggers are `.task(id:)` on the footer, keyed on a value that changes per load.
- `#Preview` uses real types on isolated storage (`UserDefaultsStore.isolated()`).

## Style
- Swift 6.2: `if`/`switch` expressions, `if let x`, implicit returns; `guard` only for early exits.
- Prefer deleting code: no "just in case" states, alerts, animations or parameters; drop what nothing shows.
- Comments only for a non-obvious why (`RatesHistory` paging, raw copy in `RateDetailViewModel`). Names over comments.
- Mapping, formatting and rules used by two screens go to `Shared/`, never copied.

## Wiring
`AppContainer` builds dependencies once and passes them to `MainCoordinator`, which creates the root once (`root`) and
every pushed ViewModel when it is pushed. Never inside `body`.

## Tests
Folders mirror this one: `Unit/Features/{Navigation,Screens/<Name>}`, `Snapshot/Features/Screens/<Name>`,
`Mocks/Features/…`; tags `.unit|.snapshot, .feature`.
- Dependencies are `@MainActor` spies (`RatesRepositorySpy`, `MainNavigatingSpy`, `ClipboardSpy`); assert on what they
  recorded (`repository.requests`, `navigator.events`). No locks.
- Spies and `sut` are stored properties; `sut` is built in `init()` with `.isolated(language:)` preferences and
  `RatesSamples.dates`. A test changes only what it needs (`repository.answer = …`).
- Drive ViewModels through their configurators and intents; enum accessors for tests live in the Mocks file.
- Screens: `NavigationStack`, `configurator: .screen`, settled states only (paging finished, no spinners).
- State the view reads from `UserPreferences` is tested there, not here.

Rules: `BlixRekrtuacjaTests/Unit/CLAUDE.md`, `BlixRekrtuacjaTests/Snapshot/CLAUDE.md`.
