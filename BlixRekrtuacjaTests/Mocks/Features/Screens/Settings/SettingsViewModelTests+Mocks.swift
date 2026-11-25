@testable import BlixRekrtuacja

extension SettingsViewModelTests {
    struct AppearanceTapScenario {
        let saved: Appearance
        let tapped: Appearance
    }

    struct LanguageTapScenario {
        let saved: Language
        let tapped: Language
    }

    nonisolated static let appearanceTaps: [AppearanceTapScenario] = [
        AppearanceTapScenario(saved: .dark, tapped: .system),
        AppearanceTapScenario(saved: .system, tapped: .light),
        AppearanceTapScenario(saved: .light, tapped: .dark),
        AppearanceTapScenario(saved: .dark, tapped: .dark)
    ]

    nonisolated static let languageTaps: [LanguageTapScenario] = [
        LanguageTapScenario(saved: .english, tapped: .system),
        LanguageTapScenario(saved: .system, tapped: .polish),
        LanguageTapScenario(saved: .polish, tapped: .english),
        LanguageTapScenario(saved: .english, tapped: .english)
    ]
}
