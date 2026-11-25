@testable import BlixRekrtuacja
import Foundation
import Observation
import os
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct RateDetailViewModelTests {
    @Test func copiesTheExactRate() {
        let copied = OSAllocatedUnfairLock<String?>(initialState: nil)
        let sut = RateDetailViewModel(rate: Self.rate(change: nil)) { text in copied.withLock { $0 = text } }

        sut.copyButtonConfigurator.action()

        #expect(copied.withLock { $0 } == "4.459811")
        #expect(sut.isCopied)
        #expect(sut.copyButtonConfigurator.icon == .checkmark)
    }

    @Test func copyingNotifiesTheView() async {
        let sut = RateDetailViewModel(rate: Self.rate(change: nil)) { _ in }

        await confirmation(expectedCount: 1) { changed in
            withObservationTracking { _ = sut.isCopied } onChange: { changed() }
            sut.copyRate()
        }
    }

    @Test(arguments: Self.rowCounts)
    func showsTheChangeOnlyWhenThePreviousDayIsLoaded(_ scenario: RowCountScenario) {
        let sut = RateDetailViewModel(rate: Self.rate(change: scenario.change)) { _ in }

        #expect(sut.valueRowConfigurators.count == scenario.expectedRows)
    }

    @Test func showsTheInverseRateWithSixDecimals() throws {
        let sut = RateDetailViewModel(rate: Self.rate(change: nil)) { _ in }

        let inverse = try #require(sut.valueRowConfigurators.last)

        guard case let .number(value, fractionLength) = inverse.value else {
            Issue.record("Expected a number, got \(inverse.value)")
            return
        }
        #expect(value == 1 / Decimal(exact: "4.459811"))
        #expect(fractionLength == 6)
    }

    // MARK: - Helpers

    private static func rate(change: Decimal?) -> RateSelection {
        RateSelection(
            code: "PLN",
            name: "Polish Zloty",
            value: Decimal(exact: "4.459811"),
            base: "EUR",
            day: RatesSamples.wednesday,
            change: change
        )
    }
}
