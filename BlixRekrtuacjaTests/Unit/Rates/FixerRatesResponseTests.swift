@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .rates))
struct FixerRatesResponseTests {
    @Test func mapsARealResponseKeepingEveryDigit() throws {
        let sut = try RatesSamples.fixerResponse()

        let rates = try sut.dailyRates()

        #expect(rates == RatesSamples.fixerSaturday)
    }

    @Test(arguments: Self.errorCodes)
    func mapsFixerErrorCodes(_ scenario: ErrorScenario) throws {
        let sut = try RatesSamples.fixerResponse(scenario.body)

        #expect(throws: scenario.expectedError) { try sut.dailyRates() }
    }

    @Test(arguments: Self.incompleteBodies)
    func rejectsIncompleteResponses(_ body: String) throws {
        let sut = try RatesSamples.fixerResponse(body)

        #expect(throws: AppError.server) { try sut.dailyRates() }
    }
}
