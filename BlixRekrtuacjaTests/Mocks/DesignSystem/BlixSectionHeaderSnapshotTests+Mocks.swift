@testable import BlixRekrtuacja
import Foundation

extension BlixSectionHeaderSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixSectionHeaderConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "today",
            configurator: .init(
                title: .verbatim("Środa, 25 listopada"),
                badge: .localized(.ratesToday),
                caption: .verbatim("Aktualizacja 10:00")
            )
        ),
        Scenario(
            name: "past-day",
            configurator: .init(title: .verbatim("Poniedziałek, 23 listopada"), caption: .localized(.ratesClosingRate))
        ),
        Scenario(name: "title-only", configurator: .init(title: .verbatim("Piątek, 20 listopada")))
    ]
}
