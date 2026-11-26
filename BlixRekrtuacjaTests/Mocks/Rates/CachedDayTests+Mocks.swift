@testable import BlixRekrtuacja
import Foundation

extension CachedDayTests {
    struct Scenario {
        /// What the store holds instead of the saved value, `nil` to keep it.
        let storedOverride: String?
        let expectedValue: Decimal?
    }

    static let tinyRate = Decimal(exact: "0.000123456789012345678901")

    static let storedValues: [Scenario] = [
        Scenario(storedOverride: nil, expectedValue: tinyRate),
        Scenario(storedOverride: "not a number", expectedValue: nil)
    ]
}
