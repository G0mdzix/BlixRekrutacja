@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .errors))
struct AppErrorTests {
    @Test(arguments: Self.mappings)
    func mapsAnyErrorToAppError(_ scenario: Scenario) {
        let sut = AppError(scenario.error)

        #expect(sut == scenario.expectedError)
    }
}
