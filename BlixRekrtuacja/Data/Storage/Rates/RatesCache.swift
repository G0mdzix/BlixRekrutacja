import Foundation

protocol RatesCache: Sendable {
    func rates(on day: Date) async -> CachedRates?

    func latest() async -> CachedRates?

    /// Intraday rates never replace closing ones; `latestFetchedAt` only moves forward.
    func save(_ cached: CachedRates) async
}
