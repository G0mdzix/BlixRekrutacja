@testable import BlixRekrtuacja
import Foundation

extension MainCoordinatorTests {
    enum RootIntent {
        case tapRate
        case showAll
        case openSettings
    }

    struct RootIntentScenario {
        let intent: RootIntent
    }

    nonisolated static let rootIntents: [RootIntentScenario] = [
        RootIntentScenario(intent: .tapRate),
        RootIntentScenario(intent: .showAll),
        RootIntentScenario(intent: .openSettings)
    ]
}

/// The ViewModel a route carries, or `nil` for another route.
extension MainRoute {
    var rateDetail: RateDetailViewModel? {
        guard case .rate(let viewModel) = self else { return nil }
        return viewModel
    }

    var dayRates: DayRatesViewModel? {
        guard case .day(let viewModel) = self else { return nil }
        return viewModel
    }

    var settings: SettingsViewModel? {
        guard case .settings(let viewModel) = self else { return nil }
        return viewModel
    }
}
