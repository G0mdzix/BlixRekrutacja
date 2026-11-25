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
