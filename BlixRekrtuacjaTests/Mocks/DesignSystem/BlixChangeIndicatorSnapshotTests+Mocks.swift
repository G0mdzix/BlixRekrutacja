@testable import BlixRekrtuacja
import Foundation

extension BlixChangeIndicatorSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixChangeIndicatorConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "rise", configurator: .init(change: 0.0028)),
        Scenario(name: "fall", configurator: .init(change: -0.0115)),
        Scenario(name: "flat", configurator: .init(change: 0))
    ]
}
