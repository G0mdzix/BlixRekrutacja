@testable import BlixRekrtuacja
import SwiftUI

extension BlixAdaptiveRowSnapshotTests {
    struct Scenario {
        let name: String
        let spreadsApart: Bool
        let leading: BlixLabelConfigurator
        let trailing: BlixLabelConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "spread",
            spreadsApart: true,
            leading: .init(text: .localized(.ratesInverseRate), style: .secondary),
            trailing: .init(text: .number(4.459811, fractionLength: 6), monospacedDigits: true)
        ),
        Scenario(
            name: "packed",
            spreadsApart: false,
            leading: .init(text: .localized(.ratesQuotaTitle), weight: .semibold),
            trailing: .init(text: .localized(.ratesQuotaMessage), style: .secondary)
        )
    ]
}
