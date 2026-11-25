@testable import BlixRekrtuacja
import Foundation

extension BlixMessageCardSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixMessageCardConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "error-retry",
            configurator: .init(
                icon: .wifiSlash,
                title: .localized(.ratesLoadFailedTitle),
                message: .localized(.errorOfflineMessage),
                button: .init(title: .localized(.commonRetry), style: .secondary) {}
            )
        ),
        Scenario(
            name: "neutral",
            configurator: .init(
                icon: .hourglass,
                tone: .neutral,
                title: .localized(.ratesQuotaTitle),
                message: .localized(.ratesQuotaMessage)
            )
        )
    ]
}
