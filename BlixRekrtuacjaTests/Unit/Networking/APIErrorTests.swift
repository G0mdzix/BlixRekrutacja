@testable import BlixRekrtuacja
import Testing

@Suite(.tags(.unit, .networking))
struct APIErrorTests {
    @Test(arguments: Self.mappings)
    func mapsToAppError(_ scenario: Scenario) {
        let sut = scenario.error

        #expect(sut.appError == scenario.expectedError)
    }
}
