import Foundation

struct CachedRatesRepository: RatesRepository {
    private let remote: any RatesRepository
    private let cache: any RatesCache
    private let now: @Sendable () -> Date

    init(remote: any RatesRepository, cache: any RatesCache, now: @escaping @Sendable () -> Date = { Date() }) {
        self.remote = remote
        self.cache = cache
        self.now = now
    }

    /// Fixer's `latest` is the last published day, not today on weekends, so the cache keeps what it last returned.
    func latest() async throws -> DailyRates {
        let now = now()
        if let cached = await cache.latest(), let fetchedAt = cached.latestFetchedAt,
           now.timeIntervalSince(fetchedAt) < Lifetime.latest {
            return cached.rates
        }
        let rates = try await remote.latest()
        await store(rates, at: now, fromLatest: true)
        return rates
    }

    func rates(on day: Date) async throws -> DailyRates {
        if let cached = await cache.rates(on: BusinessDays.day(containing: day)), cached.isFinal {
            return cached.rates
        }
        let rates = try await remote.rates(on: day)
        await store(rates, at: now(), fromLatest: false)
        return rates
    }

    /// A day before today (UTC) is closed.
    private func store(_ rates: DailyRates, at now: Date, fromLatest: Bool) async {
        let isFinal = rates.day < BusinessDays.day(containing: now)
        await cache.save(CachedRates(rates: rates, isFinal: isFinal, latestFetchedAt: fromLatest ? now : nil))
    }
}

// MARK: - Constants

private extension CachedRatesRepository {
    enum Lifetime {
        static let secondsPerHour: TimeInterval = 3_600
        /// Fixer refreshes `latest` hourly on the free plan.
        static let latest = secondsPerHour
    }
}
