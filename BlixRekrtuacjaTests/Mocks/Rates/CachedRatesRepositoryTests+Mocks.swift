@testable import BlixRekrtuacja
import Foundation

extension CachedRatesRepositoryTests {
    struct Scenario {
        let now: Date
        let cached: [CachedRates]
        let latest: DailyRates
        let request: RatesRequest
        let expectedRates: DailyRates
        let expectedCalls: [RatesRequest]
        let expectedCached: CachedRates?
    }

    nonisolated static let freshPLN = "4.470000"

    nonisolated static let scenarios: [Scenario] = closedDays + latestDays

    nonisolated private static let closedDays: [Scenario] = [
        Scenario(
            now: RatesSamples.wednesdayNoon,
            cached: [stored(RatesSamples.saturday, isFinal: true)],
            latest: fresh(RatesSamples.wednesday),
            request: .day(Date(iso: "2026-11-21T18:00:00Z")),
            expectedRates: RatesSamples.rates(on: RatesSamples.saturday),
            expectedCalls: [],
            expectedCached: stored(RatesSamples.saturday, isFinal: true)
        ),
        Scenario(
            now: RatesSamples.wednesdayNoon,
            cached: [stored(RatesSamples.friday, isFinal: false, latestAt: RatesSamples.fridayNoon)],
            latest: fresh(RatesSamples.wednesday),
            request: .day(RatesSamples.friday),
            expectedRates: fresh(RatesSamples.friday),
            expectedCalls: [.day(RatesSamples.friday)],
            expectedCached: stored(fresh(RatesSamples.friday), isFinal: true, latestAt: RatesSamples.fridayNoon)
        ),
        Scenario(
            now: RatesSamples.wednesdayNoon,
            cached: [],
            latest: fresh(RatesSamples.wednesday),
            request: .day(RatesSamples.wednesdayNoon),
            expectedRates: fresh(RatesSamples.wednesday),
            expectedCalls: [.day(RatesSamples.wednesdayNoon)],
            expectedCached: stored(fresh(RatesSamples.wednesday), isFinal: false)
        )
    ]

    nonisolated private static let latestDays: [Scenario] = [
        Scenario(
            now: RatesSamples.wednesdayNoon,
            cached: [stored(RatesSamples.wednesday, isFinal: false, latestAt: RatesSamples.wednesdayNoon - 59 * 60)],
            latest: fresh(RatesSamples.wednesday),
            request: .latest,
            expectedRates: RatesSamples.rates(on: RatesSamples.wednesday),
            expectedCalls: [],
            expectedCached: stored(
                RatesSamples.wednesday,
                isFinal: false,
                latestAt: RatesSamples.wednesdayNoon - 59 * 60
            )
        ),
        Scenario(
            now: RatesSamples.wednesdayNoon,
            cached: [stored(RatesSamples.wednesday, isFinal: false, latestAt: RatesSamples.wednesdayNoon - 60 * 60)],
            latest: fresh(RatesSamples.wednesday),
            request: .latest,
            expectedRates: fresh(RatesSamples.wednesday),
            expectedCalls: [.latest],
            expectedCached: stored(fresh(RatesSamples.wednesday), isFinal: false, latestAt: RatesSamples.wednesdayNoon)
        ),
        Scenario(
            now: RatesSamples.wednesdayNoon,
            cached: [stored(RatesSamples.friday, isFinal: true)],
            latest: fresh(RatesSamples.wednesday),
            request: .latest,
            expectedRates: fresh(RatesSamples.wednesday),
            expectedCalls: [.latest],
            expectedCached: stored(fresh(RatesSamples.wednesday), isFinal: false, latestAt: RatesSamples.wednesdayNoon)
        ),
        Scenario(
            now: RatesSamples.saturdayNoon,
            cached: [stored(RatesSamples.friday, isFinal: true, latestAt: RatesSamples.saturdayNoon - 10 * 60)],
            latest: fresh(RatesSamples.friday),
            request: .latest,
            expectedRates: RatesSamples.rates(on: RatesSamples.friday),
            expectedCalls: [],
            expectedCached: stored(RatesSamples.friday, isFinal: true, latestAt: RatesSamples.saturdayNoon - 10 * 60)
        ),
        Scenario(
            now: RatesSamples.saturdayNoon,
            cached: [],
            latest: fresh(RatesSamples.friday),
            request: .latest,
            expectedRates: fresh(RatesSamples.friday),
            expectedCalls: [.latest],
            expectedCached: stored(fresh(RatesSamples.friday), isFinal: true, latestAt: RatesSamples.saturdayNoon)
        )
    ]

    nonisolated private static func fresh(_ day: Date) -> DailyRates {
        RatesSamples.rates(on: day, pln: freshPLN)
    }

    nonisolated private static func stored(_ day: Date, isFinal: Bool, latestAt: Date? = nil) -> CachedRates {
        stored(RatesSamples.rates(on: day), isFinal: isFinal, latestAt: latestAt)
    }

    nonisolated private static func stored(_ rates: DailyRates, isFinal: Bool, latestAt: Date? = nil) -> CachedRates {
        CachedRates(rates: rates, isFinal: isFinal, latestFetchedAt: latestAt)
    }
}
