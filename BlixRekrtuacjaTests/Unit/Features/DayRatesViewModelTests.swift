@testable import BlixRekrtuacja
import Foundation
import os
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct DayRatesViewModelTests {
    @Test(arguments: Self.searches)
    func searchMatchesCodesAndNames(_ scenario: SearchScenario) {
        let sut = DayRatesViewModel(selection: RatesSamples.threeCurrencyDay) { _ in }

        let codes = sut.rowConfigurators(matching: scenario.query).map(\.code)

        #expect(codes == scenario.expectedCodes)
    }

    @Test func tappingARowSelectsThatRate() throws {
        let selected = OSAllocatedUnfairLock<RateSelection?>(initialState: nil)
        let select: @MainActor (RateSelection) -> Void = { rate in selected.withLock { $0 = rate } }
        let sut = DayRatesViewModel(selection: RatesSamples.threeCurrencyDay, onSelectRate: select)

        let action = try #require(sut.rowConfigurators(matching: "PLN").first?.action)
        action()

        #expect(selected.withLock { $0 }?.code == "PLN")
    }
}
