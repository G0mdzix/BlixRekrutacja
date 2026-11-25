# BlixRekrtuacja
iOS 17+ SwiftUI app, iPhone only, portrait only. MVVM + Coordinator, Clean Architecture, constructor DI.
Follow the `ios-project-conventions` skill; on conflict the CLAUDE.md files win.

## Commands — after every change
- Test: `set -o pipefail && xcodebuild -scheme BuildApp -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.3.1' test | xcbeautify`
- Lint: `swiftlint lint --strict`. Mechanical rules live in `.swiftlint.yml`; never restate them in CLAUDE.md files.
  Fix violations. Never disable or relax a rule to pass.
- API key: `cp Config/Secrets.example.xcconfig Config/Secrets.xcconfig`, set `FIXER_API_KEY`; it reaches the app as
  Info.plist `FixerAPIKey`. Never commit `Secrets.xcconfig`.
- Schemes:
  - `BuildApp`: app + all tests.
  - `UnitTests`: skips `.snapshot`.
  - `SnapshotTests`: only `.snapshot`, verifies.
  - `SnapshotRecord`: only `.snapshot`, records.

## Layers (BlixRekrtuacja/): read the layer's CLAUDE.md before changing it
- App: composition root only. It is the only place that creates concrete types and wires them. No logic.
- Domain: Foundation only. Entities, repository protocols, pure rules (`BusinessDays`), `AppError`.
- Data (`Data/CLAUDE.md`): networking, repositories, DTOs, the SwiftData cache.
- Core (`Core/CLAUDE.md`): feature-agnostic infrastructure: errors, extensions, navigation, preferences, storage.
- DesignSystem (`DesignSystem/CLAUDE.md`): tokens, colors, components.
- Features (`Features/CLAUDE.md`): screens, each a View + ViewModel.
- Resources: String Catalog, assets, `SFSymbol`; usable by every layer except Domain.
- Dependencies point one way:
  - Features → DesignSystem, Core, Domain
  - Data → Core, Domain
  - Core → Domain

  Nothing depends on Features.

## Swift
- Default actor isolation is `nonisolated`. Mark ViewModels and other UI-bound types `@MainActor` explicitly.
- Escaping closures capture `[weak self]` and start with `guard let self else { return }`, never `self?.`.
- `ViewModel` is reserved for `@Observable` classes with logic.
- No magic numbers or strings in production code. Give every literal with a meaning (status and error codes, durations,
  API paths and parameters, Info.plist keys, identifiers) a name in an enum named after what it holds (`HTTPStatus`,
  `FixerErrorCode`, `Weekday`):
  - `private` under `// MARK: - Constants` at the end of the file; a shared enum gets its own file;
  - UI sizes, colors and opacities are DesignSystem tokens, never literals in views;
  - literals stay for 0 and ±1 meaning zero or one, enum raw values, the single value of a named constant,
    `#Preview` data, log and precondition messages, and tests.

## Text
- Every user-facing string comes from Resources/Localizable.xcstrings through generated symbols: `Text(.settingsTitle)`.
- Add keys manually (camelCase, feature prefix: settings…, about…, common…, error…) with PL + EN and a comment.
- Values in sentences use a key with arguments, plurals use Vary by Plural, numbers and dates use FormatStyle. Never use literals or concatenation.
- Not user-facing (plain String): Logger messages, fatalError, storage keys, SF Symbol names. User data is shown as-is (`.verbatim`).

## Tests
Before writing or changing any test, read and follow BlixRekrtuacjaTests/CLAUDE.md (strict rules, stubs, snapshots).

## Definition of done
- Builds without warnings.
- Tests are green.
- Zero SwiftLint violations.
- New keys have PL + EN.
- New components and screens have snapshot tests.
- Every commit builds and passes tests on its own.
- Conventional Commit `type(scope): summary` (feat, fix, refactor, test, docs, chore).

## Never
- Edit project.pbxproj by hand.
- Add dependencies.
- Hardcode URLs.
- Use APIs above iOS 17 without `if #available`.
