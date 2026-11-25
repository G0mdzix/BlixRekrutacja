@testable import BlixRekrtuacja
import Foundation

struct RatesCacheStub: RatesCache {
    var onRates: @Sendable (Date) -> CachedRates? = { _ in nil }
    var onLatest: @Sendable () -> CachedRates? = { nil }
    var onSave: @Sendable (CachedRates) throws -> Void = { _ in }

    func rates(on day: Date) async -> CachedRates? { onRates(day) }

    func latest() async -> CachedRates? { onLatest() }

    func save(_ cached: CachedRates) async throws { try onSave(cached) }
}
