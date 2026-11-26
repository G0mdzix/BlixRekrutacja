import Foundation

extension ProcessInfo {
    var isUnitTestHost: Bool { environment[EnvironmentKey.testConfiguration] != nil }
}

// MARK: - Constants

private enum EnvironmentKey {
    static let testConfiguration = "XCTestConfigurationFilePath"
}
