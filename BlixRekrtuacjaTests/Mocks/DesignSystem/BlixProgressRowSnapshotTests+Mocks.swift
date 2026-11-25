@testable import BlixRekrtuacja
import Foundation

extension BlixProgressRowSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixProgressRowConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "default", configurator: .init(text: .localized(.ratesLoadingNextDay)))
    ]
}
