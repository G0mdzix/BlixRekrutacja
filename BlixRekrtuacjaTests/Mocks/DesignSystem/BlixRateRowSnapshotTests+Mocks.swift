@testable import BlixRekrtuacja
import Foundation

extension BlixRateRowSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixRateRowConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "with-change",
            configurator: .init(code: "PLN", name: "złoty polski", value: 4.459811, change: 0.0028) {}
        ),
        Scenario(name: "without-change", configurator: .init(code: "GBP", name: "funt szterling", value: 0.838894)),
        Scenario(name: "compact", configurator: .init(code: "JPY", value: 173.978128, change: -0.0042)),
        Scenario(
            name: "tiny-value",
            configurator: .init(code: "BTC", name: "bitcoin", value: Decimal(exact: "0.0000117"))
        ),
        Scenario(
            name: "large-value",
            configurator: .init(code: "XDR", name: "specjalne prawa ciągnienia MFW", value: 17_845.123456, change: 0)
        )
    ]
}
