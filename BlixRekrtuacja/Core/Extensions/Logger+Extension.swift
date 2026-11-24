import OSLog

// MARK: - Categories
extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "BlixRekrtuacja"
    static let app = Logger(subsystem: subsystem, category: "app")
    static let network = Logger(subsystem: subsystem, category: "network")
}
