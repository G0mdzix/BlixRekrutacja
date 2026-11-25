@testable import BlixRekrtuacja
import Testing

@Suite(.tags(.unit, .designSystem))
struct BlixSectionHeaderConfiguratorTests {
    @Test(arguments: Self.headers)
    func showsStyledDetailsOnlyWhenPresent(_ scenario: Scenario) {
        let sut = BlixSectionHeaderConfigurator(
            title: .verbatim("Day"),
            badge: scenario.badge,
            caption: scenario.caption
        )

        #expect(sut.hasDetails == scenario.hasDetails)
        #expect(sut.badgeLabel?.style == scenario.badgeStyle)
        #expect(sut.captionLabel?.style == scenario.captionStyle)
    }
}
