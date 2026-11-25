@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .designSystem))
struct BlixAdaptiveRowSnapshotTests {
    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let sut = BlixAdaptiveRow(spreadsApart: scenario.spreadsApart) {
            BlixLabel(configurator: scenario.leading)
        } trailing: {
            BlixLabel(configurator: scenario.trailing)
        }

        assertSnapshots(of: sut, named: scenario.name, configurator: .component)
    }
}
