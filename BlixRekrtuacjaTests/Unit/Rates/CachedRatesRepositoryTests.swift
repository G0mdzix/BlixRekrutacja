@testable import BlixRekrtuacja
import Foundation
import os
import Testing

@Suite(.tags(.unit, .rates))
struct CachedRatesRepositoryTests {
    @Test(arguments: Self.scenarios)
    func asksTheSourceOnlyWhenTheCacheCannotAnswer(_ scenario: Scenario) async throws {
        let cache = try SwiftDataRatesCache(isStoredInMemoryOnly: true)
        for cached in scenario.cached { try await cache.save(cached) }
        let calls = OSAllocatedUnfairLock<[RatesRequest]>(initialState: [])
        let sut = CachedRatesRepository(remote: Self.source(latest: scenario.latest, calls: calls), cache: cache) {
            scenario.now
        }

        let rates = try await scenario.request.perform(on: sut)

        #expect(rates == scenario.expectedRates)
        #expect(calls.withLock { $0 } == scenario.expectedCalls)
        #expect(await cache.rates(on: rates.day) == scenario.expectedCached)
    }

    @Test(arguments: zip(
        [RatesRequest.latest, .day(RatesSamples.saturday)],
        [RatesSamples.rates(on: RatesSamples.wednesday), RatesSamples.rates(on: RatesSamples.saturday)]
    ))
    func returnsFreshRatesWhenTheCacheCannotSave(_ request: RatesRequest, expected: DailyRates) async throws {
        let saves = OSAllocatedUnfairLock(initialState: 0)
        var cache = RatesCacheStub()
        cache.onSave = { _ in
            saves.withLock { $0 += 1 }
            throw AppError.storage
        }
        let sut = CachedRatesRepository(remote: RatesRepositoryStub(), cache: cache) { RatesSamples.wednesdayNoon }

        let rates = try await request.perform(on: sut)

        #expect(rates == expected)
        #expect(saves.withLock { $0 } == 1)
    }

    @Test(arguments: [RatesRequest.latest, .day(RatesSamples.saturday)])
    func passesSourceErrorsOnAndCachesNothing(_ request: RatesRequest) async throws {
        let cache = try SwiftDataRatesCache(isStoredInMemoryOnly: true)
        let failing = RatesRepositoryStub { throw AppError.offline } onRates: { _ in throw AppError.offline }
        let sut = CachedRatesRepository(remote: failing, cache: cache) { RatesSamples.wednesdayNoon }

        await #expect(throws: AppError.offline) { try await request.perform(on: sut) }

        #expect(await cache.latest() == nil)
        #expect(await cache.rates(on: RatesSamples.saturday) == nil)
    }

    // MARK: - Helpers

    private static func source(
        latest: DailyRates,
        calls: OSAllocatedUnfairLock<[RatesRequest]>
    ) -> RatesRepositoryStub {
        RatesRepositoryStub {
            calls.withLock { $0.append(.latest) }
            return latest
        } onRates: { day in
            calls.withLock { $0.append(.day(day)) }
            return RatesSamples.rates(on: BusinessDays.day(containing: day), pln: Self.freshPLN)
        }
    }
}
