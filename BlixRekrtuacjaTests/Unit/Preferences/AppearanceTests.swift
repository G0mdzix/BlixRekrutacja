@testable import BlixRekrtuacja
import Testing

@Suite(.tags(.unit, .preferences))
struct AppearanceTests {
    @Test(arguments: Self.colorSchemes)
    func mapsToColorScheme(_ scenario: Scenario) {
        let sut = scenario.appearance

        #expect(sut.colorScheme == scenario.expectedColorScheme)
    }
}
