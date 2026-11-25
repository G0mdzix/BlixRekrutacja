@testable import BlixRekrtuacja
import Foundation

extension RateDetailViewSnapshotTests {
    struct Scenario {
        let name: String
        let rate: RateSelection
        var isCopied = false
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "with-change", rate: Rate.pln),
        Scenario(name: "without-change", rate: Rate.plnWithoutChange),
        Scenario(name: "copied", rate: Rate.pln, isCopied: true),
        Scenario(name: "with-history", rate: Rate.plnWithHistory)
    ]
}

private enum Rate {
    static let pln = RatesSamples.selection("PLN", "złoty polski", "4.259811", change: "0.0020")
    /// The oldest loaded day has no previous day to compare with, so the change row is hidden.
    static let plnWithoutChange = RatesSamples.selection("PLN", "złoty polski", "4.251240", change: nil)
    /// Five loaded days: enough for the chart and the list of loaded days.
    static let plnWithHistory = RatesSamples.selection(
        "PLN",
        "złoty polski",
        "4.259811",
        change: "0.0020",
        history: [
            ("2026-11-25", "4.259811"), ("2026-11-24", "4.251240"), ("2026-11-23", "4.262013"),
            ("2026-11-20", "4.270554"), ("2026-11-19", "4.248930")
        ].map { RateSelection.Point(day: Date(iso: "\($0)T00:00:00Z"), value: Decimal(exact: $1)) }
    )
}
