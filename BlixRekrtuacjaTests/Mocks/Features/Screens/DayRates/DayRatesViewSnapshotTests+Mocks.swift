@testable import BlixRekrtuacja
import Foundation

extension DayRatesViewSnapshotTests {
    struct Scenario {
        let name: String
        var query = ""
    }

    nonisolated static let selection = DaySelection(
        day: RatesSamples.wednesday,
        rates: RatesSamples.wednesdaySelections
    )

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "all-currencies"),
        Scenario(name: "no-results", query: "xyz")
    ]
}
