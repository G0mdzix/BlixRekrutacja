@testable import BlixRekrtuacja

extension CardBackgroundSnapshotTests {
    struct Scenario {
        let name: String
        let background: CardBackground
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "primary", background: .primary),
        Scenario(name: "secondary", background: .secondary)
    ]
}
