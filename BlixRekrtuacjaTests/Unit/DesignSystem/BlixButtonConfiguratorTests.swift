@testable import BlixRekrtuacja
import SwiftUI
import Testing

@Suite(.tags(.unit, .designSystem))
struct BlixButtonConfiguratorTests {
    @Test(arguments: Self.loadingStates)
    func blocksTapsAndHidesIconWhileLoading(_ scenario: LoadingScenario) {
        let sut = BlixButtonConfigurator(title: .verbatim("Retry"), icon: .copy, isLoading: scenario.isLoading) {}

        #expect(sut.isEnabled == scenario.isEnabled)
        #expect(sut.label.icon == scenario.icon)
    }

    @Test(arguments: Self.styles)
    func mapsStyleToColours(_ scenario: StyleScenario) {
        let sut = BlixButtonConfigurator(title: .verbatim("Retry"), style: scenario.style) {}

        #expect(sut.label.style == scenario.textStyle)
        #expect(sut.style.background == scenario.background)
        #expect(sut.style.border == scenario.border)
    }
}
