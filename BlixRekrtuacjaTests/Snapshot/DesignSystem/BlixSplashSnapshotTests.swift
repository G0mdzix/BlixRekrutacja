@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .designSystem))
struct BlixSplashSnapshotTests {
    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let sut = BlixSplash(configurator: Self.configurator, isShown: scenario.isShown)
            .transaction { $0.disablesAnimations = true }
            .environment(\.locale, Language.polish.locale)

        assertSnapshots(of: sut, named: scenario.name, configurator: .component.layout(.screen))
    }
}
