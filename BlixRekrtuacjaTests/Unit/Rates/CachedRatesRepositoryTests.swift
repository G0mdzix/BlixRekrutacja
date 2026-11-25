@testable import BlixRekrtuacja
import Foundation
import Testing

@MainActor
@Suite(.tags(.unit, .rates))
struct CachedRatesRepositoryTests {
    @Test(arguments: Self.scenarios)
    func asksTheSourceOnlyWhenTheCacheCannotAnswer(_ scenario: Scenario) async throws {
        let cache = try SwiftDataRatesCache(isStoredInMemoryOnly: true)
        for cached in scenario.cached { await cache.save(cached) }
        let remote = RatesRepositorySpy { request in
            request.day.map { RatesSamples.rates(on: BusinessDays.day(containing: $0), pln: Self.freshPLN) }
                ?? scenario.latest
        }
        let sut = CachedRatesRepository(remote: remote, cache: cache) { scenario.now }

        let rates = try await scenario.request.perform(on: sut)

        #expect(rates == scenario.expectedRates)
        #expect(remote.requests == scenario.expectedCalls)
        #expect(await cache.rates(on: rates.day) == scenario.expectedCached)
    }

    @Test(arguments: [RatesRequest.latest, .day(RatesSamples.saturday)])
    func passesSourceErrorsOnAndCachesNothing(_ request: RatesRequest) async throws {
        let cache = try SwiftDataRatesCache(isStoredInMemoryOnly: true)
        let failing = RatesRepositorySpy { _ in throw AppError.offline }
        let sut = CachedRatesRepository(remote: failing, cache: cache) { RatesSamples.wednesdayNoon }

        await #expect(throws: AppError.offline) { try await request.perform(on: sut) }

        #expect(await cache.latest() == nil)
        #expect(await cache.rates(on: RatesSamples.saturday) == nil)
    }
}
