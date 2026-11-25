@testable import BlixRekrtuacja
import Foundation

extension BlixButtonSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixButtonConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "primary-icon", configurator: .init(title: .localized(.ratesCopyRate), icon: .copy) {}),
        Scenario(name: "secondary", configurator: .init(title: .localized(.ratesLoadOlder), style: .secondary) {}),
        Scenario(name: "primary-loading", configurator: .init(title: .localized(.commonRetry), isLoading: true) {})
    ]
}
