@testable import BlixRekrtuacja
import Foundation

extension DayRatesViewModelTests {
    struct SearchScenario {
        let query: String
        let expectedCodes: [String]
    }

    nonisolated static let searches: [SearchScenario] = [
        SearchScenario(query: "", expectedCodes: ["AUD", "PLN", "USD"]),
        SearchScenario(query: "usd", expectedCodes: ["USD"]),
        SearchScenario(query: " pln ", expectedCodes: ["PLN"]),
        SearchScenario(query: "dolar", expectedCodes: ["AUD", "USD"]),
        SearchScenario(query: "zloty", expectedCodes: ["PLN"]),
        SearchScenario(query: "Złoty", expectedCodes: ["PLN"]),
        SearchScenario(query: "   ", expectedCodes: ["AUD", "PLN", "USD"]),
        SearchScenario(query: "xyz", expectedCodes: [])
    ]
}

extension DayRatesViewModel.Results {
    var rows: [BlixRateRowConfigurator] {
        guard case .rows(let rows) = self else { return [] }
        return rows
    }

    var isNoResults: Bool {
        guard case .noResults = self else { return false }
        return true
    }
}
