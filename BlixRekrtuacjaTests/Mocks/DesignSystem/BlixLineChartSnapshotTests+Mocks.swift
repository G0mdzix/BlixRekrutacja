@testable import BlixRekrtuacja
import Foundation

extension BlixLineChartSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixLineChartConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "five-days", configurator: chart(["4.248930", "4.270554", "4.262013", "4.251240", "4.259811"])),
        Scenario(name: "flat", configurator: chart(["0.922196", "0.922196", "0.922196"]))
    ]
}

private let days = ["19", "20", "23", "24", "25"].map { Date(iso: "2026-11-\($0)T00:00:00Z") }

private func chart(_ values: [String]) -> BlixLineChartConfigurator {
    BlixLineChartConfigurator(
        points: zip(days, values).map { BlixLineChartConfigurator.Point(date: $0, value: Decimal(exact: $1)) },
        dateFormat: Date.FormatStyle(timeZone: .gmt).day().month(.abbreviated)
    )
}
