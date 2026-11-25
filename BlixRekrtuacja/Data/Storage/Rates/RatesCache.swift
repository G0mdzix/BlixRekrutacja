import Foundation

protocol RatesCache: Sendable {
    func rates(on day: Date) async -> CachedRates?

    /// The day Fixer's `latest` returned most recently.
    func latest() async -> CachedRates?

    /// Intraday rates never replace closing ones; `latestFetchedAt` only moves forward.
    func save(_ cached: CachedRates) async
}
