@testable import BlixRekrtuacja

extension UserPreferences {
    /// Preferences on isolated storage. Pass a language to fix currency names and dates against the simulator's.
    static func isolated(language: Language = .system) -> UserPreferences {
        let preferences = UserPreferences(store: UserDefaultsStore.isolated())
        preferences.set(language)
        return preferences
    }
}
