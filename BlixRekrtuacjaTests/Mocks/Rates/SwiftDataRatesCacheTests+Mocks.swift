@testable import BlixRekrtuacja
import Foundation

extension SwiftDataRatesCacheTests {
    struct Scenario {
        let saved: [CachedRates]
        let read: RatesRequest
        let expected: CachedRates?
    }

    static let scenarios: [Scenario] = [
        Scenario(saved: [], read: .day(RatesSamples.friday), expected: nil),
        Scenario(saved: [], read: .latest, expected: nil),
        Scenario(saved: [intraday], read: .day(RatesSamples.friday), expected: intraday),
        Scenario(saved: [closing], read: .day(RatesSamples.wednesday), expected: nil),
        Scenario(saved: [intraday, closing], read: .day(RatesSamples.friday), expected: closingSeenByLatest),
        Scenario(saved: [closing, intraday], read: .day(RatesSamples.friday), expected: closingSeenByLatest),
        Scenario(saved: [closing], read: .latest, expected: nil),
        Scenario(saved: [intraday, newerLatest], read: .latest, expected: newerLatest)
    ]

    private static let intraday = CachedRates(
        rates: RatesSamples.rates(on: RatesSamples.friday, pln: "4.451234"),
        isFinal: false,
        latestFetchedAt: RatesSamples.fridayNoon
    )

    private static let closing = CachedRates(
        rates: RatesSamples.rates(on: RatesSamples.friday),
        isFinal: true,
        latestFetchedAt: nil
    )

    /// Closing values win; the time `latest` returned the day is kept.
    private static let closingSeenByLatest = CachedRates(
        rates: closing.rates,
        isFinal: true,
        latestFetchedAt: intraday.latestFetchedAt
    )

    private static let newerLatest = CachedRates(
        rates: RatesSamples.rates(on: RatesSamples.wednesday),
        isFinal: false,
        latestFetchedAt: RatesSamples.wednesdayNoon
    )
}
