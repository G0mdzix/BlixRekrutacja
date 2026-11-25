@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .designSystem))
struct BlixProgressRowSnapshotTests {
    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let sut = BlixProgressRow(configurator: scenario.configurator)

        assertSnapshots(of: sut, named: scenario.name, configurator: .component)
    }
}
