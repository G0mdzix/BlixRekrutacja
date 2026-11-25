@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .rates))
struct BusinessDaysTests {
    @Test(arguments: Self.previousDays)
    func skipsWeekendsWhenGoingBack(_ scenario: Scenario) {
        let previous = BusinessDays.previous(before: scenario.date)

        #expect(previous == scenario.expected)
    }

    @Test(arguments: Self.dayStarts)
    func startsTheDayAtMidnightUTC(_ scenario: Scenario) {
        let day = BusinessDays.day(containing: scenario.date)

        #expect(day == scenario.expected)
    }
}
