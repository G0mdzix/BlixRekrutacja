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
        var expectedHintKey: String?
    }

    nonisolated static let histories: [HistoryScenario] = [
        HistoryScenario(history: [], expectedChartDays: nil, expectedHintKey: hintKey),
        HistoryScenario(
            history: points([RatesSamples.wednesday, RatesSamples.tuesday]),
            expectedChartDays: nil,
            expectedHintKey: hintKey
        ),
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
    var hint: BlixLabelConfigurator? {
        if case let .hint(hint) = self { hint } else { nil }
    }

    var chart: BlixLineChartConfigurator? {
        if case let .loaded(chart, _) = self { chart } else { nil }
    }

    var rows: [BlixValueRowConfigurator]? {
        if case let .loaded(_, rows) = self { rows } else { nil }
    }
}

extension BlixLabelConfigurator.Content {
    var key: String? {
        if case let .localized(resource) = self { resource.key } else { nil }
    }
}

private let hintKey = "ratesHistoryHint"
private let monday = Date(iso: "2026-11-23T00:00:00Z")

private func points(_ days: [Date]) -> [RateSelection.Point] {
    days.map { RateSelection.Point(day: $0, value: Decimal(exact: "4.25")) }
}
