@testable import BlixRekrtuacja
import Foundation

extension RatesViewSnapshotTests {
    struct Scenario {
        let name: String
        let repository: any RatesRepository
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(
            name: "loaded",
            repository: RatesRepositoryStub { RatesSamples.market(on: RatesSamples.wednesday) } onRates: {
                RatesSamples.market(on: $0)
            }
        ),
        Scenario(name: "older-day-failed", repository: Repository.shortMarket { _ in throw AppError.offline }),
        Scenario(name: "quota-reached", repository: Repository.shortMarket { _ in throw AppError.quotaExceeded }),
        Scenario(name: "first-load-failed", repository: Repository.failing(.offline)),
        Scenario(name: "invalid-key", repository: Repository.failing(.invalidAPIKey)),
        Scenario(name: "missing-key", repository: Repository.failing(.missingAPIKey))
    ]
}

/// Today loads with two currencies, so the footer of the older day is on screen.
private enum Repository {
    static func shortMarket(olderDay: @escaping @Sendable (Date) throws -> DailyRates) -> RatesRepositoryStub {
        RatesRepositoryStub(onLatest: { RatesSamples.shortMarket(on: RatesSamples.wednesday) }, onRates: olderDay)
    }

    static func failing(_ error: AppError) -> RatesRepositoryStub {
        RatesRepositoryStub(onLatest: { throw error }, onRates: { _ in throw error })
    }
}
