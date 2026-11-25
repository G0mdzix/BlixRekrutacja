@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .designSystem))
struct BlixListSnapshotTests {
    @Test(arguments: Self.contents)
    func recordSnapshot(_ scenario: Scenario) {
        let sut = BlixList {
            ForEach(scenario.items, id: \.self) { Text($0) }
        }

        assertSnapshots(of: sut, named: scenario.name, configurator: scenario.snapshot)
    }
}
