@testable import BlixRekrtuacja

extension UserPreferencesTests {
    struct LoadScenario {
        let savedAppearance: Appearance?
        let savedLanguage: Language?
        let expectedAppearance: Appearance
        let expectedLanguage: Language
    }

    struct AppearanceSaveScenario {
        let saved: Appearance
        let selected: Appearance
    }

    struct LanguageSaveScenario {
        let saved: Language
        let selected: Language
    }

    enum Preference {
        case appearance
        case language
    }

    nonisolated static let savedPreferences: [LoadScenario] = [
        LoadScenario(savedAppearance: nil, savedLanguage: nil, expectedAppearance: .system, expectedLanguage: .system),
        LoadScenario(savedAppearance: .dark, savedLanguage: nil, expectedAppearance: .dark, expectedLanguage: .system),
        LoadScenario(
            savedAppearance: nil,
            savedLanguage: .english,
            expectedAppearance: .system,
            expectedLanguage: .english
        ),
        LoadScenario(
            savedAppearance: .dark,
            savedLanguage: .english,
            expectedAppearance: .dark,
            expectedLanguage: .english
        ),
        LoadScenario(
            savedAppearance: .light,
            savedLanguage: .polish,
            expectedAppearance: .light,
            expectedLanguage: .polish
        )
    ]

    nonisolated static let appearanceSaves: [AppearanceSaveScenario] = [
        AppearanceSaveScenario(saved: .dark, selected: .system),
        AppearanceSaveScenario(saved: .system, selected: .light),
        AppearanceSaveScenario(saved: .light, selected: .dark)
    ]

    nonisolated static let languageSaves: [LanguageSaveScenario] = [
        LanguageSaveScenario(saved: .english, selected: .system),
        LanguageSaveScenario(saved: .system, selected: .polish),
        LanguageSaveScenario(saved: .polish, selected: .english)
    ]

    nonisolated static let preferences: [Preference] = [.appearance, .language]
}
