@testable import BlixRekrtuacja
import SwiftUI

extension BlixLabelSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixLabelConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "primary-body",
            configurator: .init(text: .localized(.appearanceSystem))
        ),
        Scenario(
            name: "primary-largeTitle",
            configurator: .init(text: .localized(.settingsTitle), typography: .largeTitle)
        ),
        Scenario(
            name: "primary-semibold-icon",
            configurator: .init(text: .localized(.appearanceDark), weight: .semibold, icon: .moon)
        ),
        Scenario(
            name: "secondary-verbatim",
            configurator: .init(text: .verbatim("Gorzów Wielkopolski"), style: .secondary, typography: .subheadline)
        ),
        Scenario(
            name: "multiline-centered",
            configurator: .init(text: .localized(.errorOfflineMessage), icon: .wifiSlash, alignment: .center)
        )
    ]
}
