@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .rates))
struct SwiftDataRatesCacheTests {
    @Test(arguments: Self.scenarios)
    func keepsOneVersionOfEachDayAndNeverDowngradesClosingRates(_ scenario: Scenario) async throws {
        let sut = try SwiftDataRatesCache(isStoredInMemoryOnly: true)
        for cached in scenario.saved { await sut.save(cached) }

        let loaded = await scenario.read.read(from: sut)

        #expect(loaded == scenario.expected)
    }
}
