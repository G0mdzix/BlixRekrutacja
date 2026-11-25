# BlixRekrtuacja
iOS 17+ SwiftUI app, iPhone only, portrait only. MVVM + Coordinator, Clean Architecture, constructor DI.
Follow the `ios-project-conventions` skill; on conflict this file and the project plan win.

## Commands — after every change
- Test: `set -o pipefail && xcodebuild -scheme BuildApp -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.3.1' test | xcbeautify`
- Lint: `swiftlint lint --strict`. Mechanical rules live in `.swiftlint.yml` — never restate them in CLAUDE.md files.
  Fix violations; never disable or relax a rule to pass.
- Schemes: `BuildApp` (app + all tests) · `UnitTests` (skips `.snapshot`) · `SnapshotTests` (only `.snapshot`, verifies) · `SnapshotRecord` (only `.snapshot`, records).

## Layers (all inside BlixRekrtuacja/)
- App: composition root only — the only place that creates concrete types. No logic.
- Core: generic, feature-agnostic (DesignSystem, Errors, Extensions, Navigation, Networking, UserDefaults). May know Domain's AppError, never a feature.
- Domain: Foundation only. Entities, enums, repository protocols.
- Features/<Name>: View + ViewModel (+ Coordinator, Route). ViewModels: `@MainActor @Observable final class`,
  `private(set)` state, dependencies via init as protocols.
- ViewModels build component configurators in `// MARK: - UI configurators`: `<element>Configurator` property,
  or `<element>Configurator(_:)` for rows; configurator actions call ViewModel methods.
- Extensions of Apple types → `Core/Extensions/<Type>+Extension.swift`, one file per type, append if it exists,
  `// MARK: - <Purpose>` sections. Extensions of our own types stay next to the type. Never return user-facing text from them.
- Default actor isolation is `nonisolated`: mark ViewModels and other UI-bound types `@MainActor` explicitly.
- Escaping closures capture `[weak self]` and start with `guard let self else { return }` — never `self?.`.

## Errors & networking
- ViewModels: `private(set) var error: AppError?`, set in `catch` with `AppError(error)` (nil for cancellation), cleared by `dismissError()`.
- Views: `.errorAlert(viewModel.error) { viewModel.dismissError() }` — no `Binding` in ViewModels.
- Requests only through the `HTTPClient` protocol and `Endpoint<Response>` — never `URLSession` in features.
- Log with `Logger` once, where the error originates.

## Text
Every user-facing string comes from Resources/Localizable.xcstrings via generated symbols: `Text(.settingsTitle)`.
Add keys manually (camelCase, feature prefix: settings…, about…, common…, error…) with PL + EN and a comment.
Values in sentences = key with arguments, plurals = Vary by Plural, numbers/dates = FormatStyle. Never literals or concatenation.
Not user-facing (plain String): Logger messages, fatalError, storage keys, SF Symbol names. User data is shown as-is (`.verbatim`).

## UI
Feature views only compose Design System components: View + `<Name>Configurator` struct; containers take `@ViewBuilder`.
`ViewModel` is reserved for `@Observable` classes with logic.
Dynamic Type from xSmall to accessibility5: no truncation, no fixed text heights.

## Tests
Before writing or changing any test, read and follow BlixRekrtuacjaTests/CLAUDE.md (strict rules, stubs, snapshots).

## Definition of done
Builds without warnings · tests green · zero SwiftLint violations · new keys have PL + EN ·
new component/screen has snapshot tests · every commit builds and passes tests on its own ·
Conventional Commit `type(scope): summary` (feat, fix, refactor, test, docs, chore).

## Never
Edit project.pbxproj by hand · add dependencies · hardcode user-facing text or URLs · logic in component views ·
APIs above iOS 17 without `if #available`.
