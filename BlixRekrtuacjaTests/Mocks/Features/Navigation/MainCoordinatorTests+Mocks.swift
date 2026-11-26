@testable import BlixRekrtuacja
import Foundation

extension MainCoordinatorTests {
    enum RootIntent: CaseIterable {
        case tapRate
        case showAll
        case openSettings
    }
}

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
