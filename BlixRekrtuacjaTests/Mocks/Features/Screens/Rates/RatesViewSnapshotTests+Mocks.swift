@testable import BlixRekrtuacja
import Foundation

extension RatesViewSnapshotTests {
    struct Scenario {
        let name: String
        let answer: @Sendable (RatesRequest) throws -> DailyRates
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "loaded", answer: RatesSamples.market(for:)),
        Scenario(name: "older-day-failed", answer: Answer.shortMarketThen(.offline)),
        Scenario(name: "quota-reached", answer: Answer.shortMarketThen(.quotaExceeded)),
        Scenario(name: "first-load-failed", answer: Answer.failing(.offline)),
        Scenario(name: "invalid-key", answer: Answer.failing(.invalidAPIKey)),
        Scenario(name: "missing-key", answer: Answer.failing(.missingAPIKey))
    ]
}

private enum Answer {
    /// Today loads with two currencies, so the footer of the failed older day is on screen.
    static func shortMarketThen(_ error: AppError) -> @Sendable (RatesRequest) throws -> DailyRates {
        { request in
            guard request == .latest else { throw error }
            return RatesSamples.shortMarket(on: RatesSamples.wednesday)
        }
    }

    static func failing(_ error: AppError) -> @Sendable (RatesRequest) throws -> DailyRates {
        { _ in throw error }
    }
}
