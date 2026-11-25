@testable import BlixRekrtuacja

extension BlixSelectionRowSnapshotTests {
    struct Scenario {
        let name: String
        let configurator: BlixSelectionRowConfigurator
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "unselected", configurator: .init(label: .init(text: .localized(.appearanceLight))) {}),
        Scenario(
            name: "selected",
            configurator: .init(label: .init(text: .localized(.appearanceSystem)), isSelected: true) {}
        ),
        Scenario(
            name: "selected-icon",
            configurator: .init(label: .init(text: .localized(.appearanceDark), icon: .moon), isSelected: true) {}
        ),
        Scenario(
            name: "selected-multiline",
            configurator: .init(label: .init(text: .localized(.errorOfflineMessage)), isSelected: true) {}
        )
    ]
}
