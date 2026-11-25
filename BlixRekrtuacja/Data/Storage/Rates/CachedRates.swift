import Foundation

struct CachedRates: Equatable, Sendable {
    let rates: DailyRates
    /// `true` for the closing rates of a day; `false` for intraday rates.
    let isFinal: Bool
    /// When Fixer's `latest` last returned this day; `nil` for days fetched only by date.
    let latestFetchedAt: Date?
}
