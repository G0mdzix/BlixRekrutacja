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
        .environment(\.verticalSizeClass, scenario.verticalSizeClass)

        assertSnapshots(of: sut, named: scenario.name, configurator: scenario.snapshot)
    }
}
