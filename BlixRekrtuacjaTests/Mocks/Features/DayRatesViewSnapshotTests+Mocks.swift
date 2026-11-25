@testable import BlixRekrtuacja
import Foundation

extension DayRatesViewSnapshotTests {
    struct Scenario {
        let name: String
        let selection: DaySelection
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "all-currencies",
            selection: DaySelection(day: RatesSamples.wednesday, rates: RatesSamples.wednesdaySelections)
        )
    ]
}
