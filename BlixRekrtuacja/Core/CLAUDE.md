# Core

Feature-agnostic infrastructure. Core knows only Domain, never Data, DesignSystem or a feature.

| Folder | Contents |
|---|---|
| Errors | `AppError(error)` mapping, `AppErrorConvertible` for layers that depend on Core, user-facing `message` |
| Extensions | Extensions of Apple types: `<Type>+Extension.swift`, one file per type per layer, `// MARK: - <Purpose>` sections |
| Navigation | `Coordinator` (`push`, `pop`, `popToRoot`) and `CoordinatedStack` |
| Preferences | App-wide settings: `UserPreferences` and its values (`Appearance`, `Language`) |
| Services | Side effects and environment the app injects: `Clipboard` (protocol; `SystemClipboard` in App), `DateProvider` (value; `.system`) |
| UserDefaults | `KeyValueStore`, `UserDefaultsStore`, `StorageKey`; every key goes in `StorageKeys.swift` |

## Rules
- Extensions of Apple types (`Extensions/`) never return user-facing text. Extensions of our own types stay next to the type. `AppError` (Domain) gets its `message` in `Errors/`;
  how a screen shows it lives in `Features/Shared/Presentation/`.
- Logging: `Logger.app`, `.network` or `.storage`, once, where the error originates. Add new categories in `Logger+Extension.swift`.
- Errors:
  - A new user-visible error is an `AppError` case plus a message key, only when the user can act on it differently
    from the existing cases; otherwise map to an existing case.
  - Layers that depend on Core (Data) map their errors with `AppErrorConvertible`. Core never imports their types.
- Storage:
  - Reads fall back to the key's `defaultValue` and log corrupt data.
  - Writes never throw: settings are `Codable` values that always encode; a failure only logs.
- New app-wide setting:
  1. A value type in `Preferences/` with `title` and its system mapping.
  2. A key in `StorageKeys.swift`.
  3. A property and `set(_:)` in `UserPreferences`. The setter skips unchanged values.

  The App root reads the setting. ViewModels change it.
