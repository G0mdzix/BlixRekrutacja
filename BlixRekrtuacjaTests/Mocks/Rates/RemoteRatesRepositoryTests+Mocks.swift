@testable import BlixRekrtuacja
import Foundation

extension RemoteRatesRepositoryTests {
    struct RequestScenario {
        let request: RatesRequest
        let expectedPath: String
    }

    static let apiKey = "test-key"

    static let requests: [RequestScenario] = [
        RequestScenario(request: .latest, expectedPath: "latest"),
        RequestScenario(request: .day(Date(iso: "2026-11-21T23:30:00Z")), expectedPath: "2026-11-21"),
        RequestScenario(request: .day(Date(iso: "2026-11-21T00:30:00+01:00")), expectedPath: "2026-11-20")
    ]
}
