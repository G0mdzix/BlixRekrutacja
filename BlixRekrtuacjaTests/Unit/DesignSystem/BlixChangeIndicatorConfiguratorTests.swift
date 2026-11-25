@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .designSystem))
struct BlixChangeIndicatorConfiguratorTests {
    @Test(arguments: Self.changes)
    func directionFollowsTheShownChange(_ scenario: ChangeScenario) {
        let sut = BlixChangeIndicatorConfigurator(change: scenario.change)

        #expect(sut.direction == scenario.direction)
        #expect(sut.magnitude == scenario.magnitude)
    }

    @Test(arguments: Self.directions)
    func pairsArrowAndColourWithTheDirection(_ scenario: DirectionScenario) {
        let sut = BlixChangeIndicatorConfigurator(change: scenario.change)

        #expect(sut.label.icon == scenario.symbol)
        #expect(sut.label.style == scenario.style)
    }
}
