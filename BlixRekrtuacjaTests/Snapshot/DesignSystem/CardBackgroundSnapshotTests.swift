@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .designSystem))
struct CardBackgroundSnapshotTests {
    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let sut = BlixLabel(configurator: .init(text: .localized(.errorOfflineMessage)))
            .padding(Spacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardBackground(scenario.background)
            .padding(Spacing.large)

        assertSnapshots(of: sut, named: scenario.name, configurator: .component)
    }
}
