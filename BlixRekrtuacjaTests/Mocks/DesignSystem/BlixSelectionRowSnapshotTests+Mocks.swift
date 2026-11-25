@testable import BlixRekrtuacja

extension BlixSelectionRowSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixSelectionRowConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "unselected", configurator: .init(title: .localized(.appearanceLight)) {}),
        Scenario(
            name: "selected",
            configurator: .init(title: .localized(.appearanceSystem), isSelected: true) {}
        ),
        Scenario(
            name: "selected-icon",
            configurator: .init(title: .localized(.appearanceDark), icon: .moon, isSelected: true) {}
        ),
        Scenario(
            name: "selected-multiline",
            configurator: .init(title: .localized(.errorOfflineMessage), isSelected: true) {}
        )
    ]
}
