import OSLog

// MARK: - Categories
extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "BlixRekrtuacja"
    static let app = Logger(subsystem: subsystem, category: "app")
    static let storage = Logger(subsystem: subsystem, category: "storage")
}
