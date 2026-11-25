@testable import BlixRekrtuacja
import Foundation
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct DayRatesViewModelTests {
    let navigator = MainNavigatingSpy()
    let sut: DayRatesViewModel

    init() {
        sut = DayRatesViewModel(selection: RatesSamples.threeCurrencyDay, navigator: navigator)
    }

    @Test(arguments: Self.searches)
    func searchMatchesCodesAndNames(_ scenario: SearchScenario) {
        sut.query = scenario.query

        #expect(sut.results.rows.map(\.code) == scenario.expectedCodes)
        #expect(sut.results.isNoResults == scenario.expectedCodes.isEmpty)
    }

    @Test func tappingARowOpensThatRate() throws {
        sut.query = "PLN"

        let tap = try #require(sut.results.rows.first?.action)
        tap()

        #expect(navigator.events == [.rate(RatesSamples.threeCurrencyDay.rates[1])])
    }
}
