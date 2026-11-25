@testable import BlixRekrtuacja
import SwiftUI
import Testing

@Suite(.tags(.unit, .designSystem))
struct BlixMessageCardConfiguratorTests {
    @Test(arguments: Self.tones)
    func mapsToneToIconColours(_ scenario: Scenario) {
        let sut = BlixMessageCardConfigurator(
            icon: .wifiSlash,
            tone: scenario.tone,
            title: .verbatim("Title"),
            message: .verbatim("Message")
        )

        #expect(sut.tone.iconColor == scenario.iconColor)
        #expect(sut.tone.iconBackground == scenario.iconBackground)
    }
}
