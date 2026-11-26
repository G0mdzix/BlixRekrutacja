import Foundation

struct CachedRates: Equatable, Sendable {
    let rates: DailyRates
    /// `true` for the closing rates of a day; `false` for intraday rates.
    let isFinal: Bool
    let latestFetchedAt: Date?
}
