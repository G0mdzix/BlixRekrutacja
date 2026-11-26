@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .rates))
struct CachedDayTests {
    @Test(arguments: Self.storedValues)
    func readsBackEveryDigitOrNothing(_ scenario: Scenario) {
        let rates = DailyRates(
            day: RatesSamples.wednesday,
            base: "EUR",
            updatedAt: RatesSamples.wednesday,
            rates: [CurrencyRate(code: "BTC", value: Self.tinyRate)]
        )
        let sut = CachedDay(CachedRates(rates: rates, isFinal: true, latestFetchedAt: nil))
        if let stored = scenario.storedOverride { sut.rates["BTC"] = stored }

        let loaded = sut.cachedRates

        #expect(loaded?.rates.rates.first?.value == scenario.expectedValue)
    }
}
