import Foundation

extension ProcessInfo {
    /// The app only hosts unit tests: nothing may open stores or send requests.
    var isUnitTestHost: Bool { environment[EnvironmentKey.testConfiguration] != nil }
}

// MARK: - Constants

private enum EnvironmentKey {
    static let testConfiguration = "XCTestConfigurationFilePath"
}
