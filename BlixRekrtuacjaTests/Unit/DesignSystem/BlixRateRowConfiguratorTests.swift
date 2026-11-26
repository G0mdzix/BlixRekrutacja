@testable import BlixRekrtuacja
import SwiftUI
import Testing

@Suite(.tags(.unit, .designSystem))
struct BlixRateRowConfiguratorTests {
    @Test(arguments: Self.optionalData)
    func showsNameAndChangeOnlyWhenPresent(_ scenario: DataScenario) {
        let sut = BlixRateRowConfigurator(code: "PLN", name: scenario.name, value: 4.459811, change: scenario.change)

        #expect(sut.nameLabel?.style == scenario.nameStyle)
        #expect(sut.changeIndicator?.change == scenario.change)
    }
}
