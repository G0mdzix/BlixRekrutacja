import Foundation

/// The current time and the user's time zone, injected so tests can fix both.
struct DateProvider: Sendable {
    let now: @Sendable () -> Date
    let timeZone: TimeZone

    static let system = Self(now: { Date() }, timeZone: .autoupdatingCurrent)
}
