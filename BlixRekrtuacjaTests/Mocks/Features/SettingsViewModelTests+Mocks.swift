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

    enum Row {
        case appearance(Appearance)
        case language(Language)
    }

    struct FailingTapScenario {
        let row: Row
        let expectedError: AppError?
    }

    enum ObservedChange {
        case shown
        case dismissed
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

    nonisolated static let failingTaps: [FailingTapScenario] = [
        FailingTapScenario(row: .appearance(.dark), expectedError: .storage),
        FailingTapScenario(row: .appearance(.system), expectedError: nil),
        FailingTapScenario(row: .language(.english), expectedError: .storage),
        FailingTapScenario(row: .language(.system), expectedError: nil)
    ]

    nonisolated static let observedChanges: [ObservedChange] = [.shown, .dismissed]
}
