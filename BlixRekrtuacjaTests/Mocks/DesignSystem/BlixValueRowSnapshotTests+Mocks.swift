@testable import BlixRekrtuacja
import Foundation

extension BlixValueRowSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixValueRowConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "localized-title",
            configurator: .init(title: .localized(.ratesInverseRate), value: .verbatim("1 PLN = 0,224225 EUR"))
        ),
        Scenario(
            name: "long-texts",
            configurator: .init(
                title: .verbatim("Poprzedni dzień roboczy (poniedziałek, 23 listopada)"),
                value: .number(17_845.123456, fractionLength: 6)
            )
        )
    ]
}
