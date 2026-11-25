@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .designSystem))
struct BlixLineChartSnapshotTests {
    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let sut = BlixLineChart(configurator: scenario.configurator)
            .environment(\.locale, Language.polish.locale)

        assertSnapshots(of: sut, named: scenario.name, configurator: .component)
    }
}
