@testable import BlixRekrtuacja
import Foundation

extension RateDetailViewModelTests {
    struct RowCountScenario {
        let change: String?
        let expectedRows: Int
    }

    struct HistoryScenario {
        let history: [RateSelection.Point]
        let expectedChartDays: [Date]?
    }

    nonisolated static let histories: [HistoryScenario] = [
        HistoryScenario(history: points([RatesSamples.wednesday, RatesSamples.tuesday]), expectedChartDays: nil),
        HistoryScenario(
            history: points([RatesSamples.wednesday, RatesSamples.tuesday, monday]),
            expectedChartDays: [monday, RatesSamples.tuesday, RatesSamples.wednesday]
        )
    ]

    nonisolated static let rowCounts: [RowCountScenario] = [
        RowCountScenario(change: "0.0028", expectedRows: 4),
        RowCountScenario(change: nil, expectedRows: 3)
    ]
}

extension RateDetailViewModel.History {
    var chart: BlixLineChartConfigurator? {
        if case let .loaded(_, chart, _) = self { chart } else { nil }
    }

    var rows: [BlixValueRowConfigurator]? {
        if case let .loaded(_, _, rows) = self { rows } else { nil }
    }
}

private let monday = Date(iso: "2026-11-23T00:00:00Z")

private func points(_ days: [Date]) -> [RateSelection.Point] {
    days.map { RateSelection.Point(day: $0, value: Decimal(exact: "4.25")) }
}
