# BlixRekrtuacja
iOS 17+ SwiftUI app, iPhone only, portrait only. MVVM + Coordinator, Clean Architecture, constructor DI.
Follow the `ios-project-conventions` skill; on conflict this file and the project plan win.

## Commands — after every change
- Test: `set -o pipefail && xcodebuild -scheme BlixRekrtuacja -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' test | xcbeautify`
- Lint: `swiftlint lint --strict`. Mechanical rules live in `.swiftlint.yml` — never restate them in CLAUDE.md files.
  Fix violations; never disable or relax a rule to pass.
- Schemes: `BlixRekrtuacja` (all tests) · `BlixRekrtuacja-UnitTests` (skips `.snapshot`) · `BlixRekrtuacja-SnapshotTests` (only `.snapshot`).
- Record snapshots (only for intended UI changes): prefix the test command with `TEST_RUNNER_SNAPSHOT_TESTING_RECORD=all`.

## Layers (all inside BlixRekrtuacja/)
- App: composition root only — the only place that creates concrete types. No logic.
- Core: generic, feature-agnostic (DesignSystem, Errors, Extensions, Navigation, Networking). May know Domain's AppError, never a feature.
- Domain: Foundation only. Entities, enums, repository protocols.
- Features/<Name>: View + ViewModel (+ Coordinator, Route). ViewModels: `@MainActor @Observable final class`,
  `private(set)` state, dependencies via init as protocols.
- Extensions of Apple types → `Core/Extensions/<Type>+Extension.swift`, one file per type, append if it exists,
  `// MARK: - <Purpose>` sections. Extensions of our own types stay next to the type. Never return user-facing text from them.
- Default actor isolation is `nonisolated`: mark ViewModels and other UI-bound types `@MainActor` explicitly.

## Errors & networking
- ViewModels catch with `self.error = AppError(error)` (nil for cancellation) and views show it with `.errorAlert($viewModel.error)`.
- Requests only through the `HTTPClient` protocol and `Endpoint<Response>` — never `URLSession` in features.
- Log with `Logger` once, where the error originates.

## Text
Every user-facing string comes from Resources/Localizable.xcstrings via generated symbols: `Text(.settingsTitle)`.
Add keys manually (camelCase, feature prefix: settings…, about…, common…, error…) with PL + EN and a comment.
Values in sentences = key with arguments, plurals = Vary by Plural, numbers/dates = FormatStyle. Never literals or concatenation.
Not user-facing (plain String): Logger messages, fatalError, storage keys, SF Symbol names.

## UI
Feature views only compose Design System components (View + ViewModel pairs); tokens only (Spacing, Radius, Size, AppColor, Typography).
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
