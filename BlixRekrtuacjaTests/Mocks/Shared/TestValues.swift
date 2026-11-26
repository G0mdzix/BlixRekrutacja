import Foundation

extension Decimal {
    /// Float literals go through `Double` (`0.0028` becomes `0.002800…0512`); expected values must be exact.
    init(exact text: String) {
        guard let value = Decimal(string: text, locale: Locale(identifier: "en_US_POSIX")) else {
            preconditionFailure("Not a decimal: \(text)")
        }
        self = value
    }
}

extension Date {
    init(iso text: String) {
        guard let date = try? Date(text, strategy: .iso8601) else {
            preconditionFailure("Not an ISO 8601 date: \(text)")
        }
        self = date
    }
}

extension TimeZone {
    init(fixed identifier: String) {
        guard let zone = TimeZone(identifier: identifier) else { preconditionFailure("Not a time zone: \(identifier)") }
        self = zone
    }
}
