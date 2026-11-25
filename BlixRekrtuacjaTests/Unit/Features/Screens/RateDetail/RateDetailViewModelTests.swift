@testable import BlixRekrtuacja
import Foundation
import Observation
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct RateDetailViewModelTests {
    let clipboard = ClipboardSpy()
    let sut: RateDetailViewModel

    init() {
        sut = RateDetailViewModel(rate: Self.rate(change: nil), clipboard: clipboard)
    }

    @Test func copiesTheExactRate() {
        sut.copyButtonConfigurator.action()

        #expect(clipboard.copied == ["4.459811"])
        #expect(sut.isCopied)
        #expect(sut.copyButtonConfigurator.icon == .checkmark)
    }

    @Test func copyingNotifiesTheView() async {
        await confirmation(expectedCount: 1) { changed in
            withObservationTracking { _ = sut.isCopied } onChange: { changed() }
            sut.copyRate()
        }
    }

    @Test(arguments: Self.rowCounts)
    func showsTheChangeOnlyWhenThePreviousDayIsLoaded(_ scenario: RowCountScenario) {
        let sut = RateDetailViewModel(rate: Self.rate(change: scenario.change), clipboard: clipboard)

        #expect(sut.valueRowConfigurators.count == scenario.expectedRows)
    }

    @Test func showsTheInverseRateWithSixDecimals() throws {
        let inverse = try #require(sut.valueRowConfigurators.last)

        guard case let .number(value, fractionLength) = inverse.value else {
            Issue.record("Expected a number, got \(inverse.value)")
            return
        }
        #expect(value == 1 / Decimal(exact: "4.459811"))
        #expect(fractionLength == 6)
    }

    // MARK: - Helpers

    private static func rate(change: String?) -> RateSelection {
        RatesSamples.selection("PLN", "Polish Zloty", "4.459811", change: change)
    }
}
