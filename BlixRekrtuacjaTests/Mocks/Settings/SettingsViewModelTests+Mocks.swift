@testable import BlixRekrtuacja

extension SettingsViewModelTests {
    struct LoadScenario {
        let saved: Appearance?
        let expected: Appearance
    }

    struct TapScenario {
        let saved: Appearance
        let tapped: Appearance
    }

    struct FailingTapScenario {
        let tapped: Appearance
        let expectedError: AppError?
    }

    enum ObservedChange {
        case appearance
        case errorShown
        case errorDismissed
    }

    nonisolated static let savedAppearances: [LoadScenario] = [
        LoadScenario(saved: nil, expected: .system),
        LoadScenario(saved: .light, expected: .light),
        LoadScenario(saved: .dark, expected: .dark)
    ]

    nonisolated static let taps: [TapScenario] = [
        TapScenario(saved: .dark, tapped: .system),
        TapScenario(saved: .system, tapped: .light),
        TapScenario(saved: .light, tapped: .dark),
        TapScenario(saved: .dark, tapped: .dark)
    ]

    nonisolated static let failingTaps: [FailingTapScenario] = [
        FailingTapScenario(tapped: .dark, expectedError: .storage),
        FailingTapScenario(tapped: .system, expectedError: nil)
    ]

    nonisolated static let observedChanges: [ObservedChange] = [.appearance, .errorShown, .errorDismissed]
}
