@testable import BlixRekrtuacja
import Foundation

extension RemoteRatesRepositoryTests {
    struct RequestScenario {
        let request: RatesRequest
        let expectedPath: String
    }

    enum Outcome {
        case httpRateLimited
        /// Fixer's own limit: HTTP 200 with error 106 in the body.
        case fixerRateLimited
        case answers
    }

    struct RateLimitScenario {
        let outcomes: [Outcome]
        let expectsRates: Bool
    }

    nonisolated static let apiKey = "test-key"

    nonisolated static let rateLimits: [RateLimitScenario] = [
        RateLimitScenario(outcomes: [.httpRateLimited, .answers], expectsRates: true),
        RateLimitScenario(outcomes: [.fixerRateLimited, .answers], expectsRates: true),
        RateLimitScenario(outcomes: [.httpRateLimited, .fixerRateLimited], expectsRates: false)
    ]

    nonisolated static let fixerRateLimitBody =
        #"{"success":false,"error":{"code":106,"type":"rate_limit_reached","info":"Info"}}"#

    nonisolated static let requests: [RequestScenario] = [
        RequestScenario(request: .latest, expectedPath: "latest"),
        RequestScenario(request: .day(Date(iso: "2026-11-21T23:30:00Z")), expectedPath: "2026-11-21"),
        RequestScenario(request: .day(Date(iso: "2026-11-21T00:30:00+01:00")), expectedPath: "2026-11-20")
    ]
}
