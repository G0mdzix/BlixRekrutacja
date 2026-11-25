@testable import BlixRekrtuacja

extension UserDefaultsStoreTests {
    enum Action {
        case save(String)
        case corruptStoredData
    }

    struct Scenario {
        let actions: [Action]
        let expectedValue: String
    }

    static let valueScenarios: [Scenario] = [
        Scenario(actions: [], expectedValue: "default"),
        Scenario(actions: [.save("dark")], expectedValue: "dark"),
        Scenario(actions: [.save("light"), .save("dark")], expectedValue: "dark"),
        Scenario(actions: [.save("dark"), .corruptStoredData], expectedValue: "default")
    ]
}

extension StorageKey where Value == String {
    static var sample: Self { Self(name: "sample", defaultValue: "default") }
}

extension StorageKey where Value == Double {
    static var unencodable: Self { Self(name: "unencodable", defaultValue: 0) }
}
