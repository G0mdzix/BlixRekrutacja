@testable import BlixRekrtuacja
import Foundation

extension BlixEmptyStateSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixEmptyStateConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "default",
            configurator: .init(
                icon: .chartUptrend,
                title: .localized(.ratesSelectCurrencyTitle),
                message: .localized(.ratesSelectCurrencyMessage)
            )
        ),
        Scenario(
            name: "badge",
            configurator: .init(
                icon: .key,
                badge: .xmark,
                title: .localized(.ratesInvalidKeyTitle),
                message: .localized(.errorGenericMessage)
            )
        )
    ]
}
