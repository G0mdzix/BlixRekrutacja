@testable import BlixRekrtuacja
import Foundation

/// Answers with `answer` and records every request. Main-actor isolated, so tests read it without locks.
@MainActor
final class RatesRepositorySpy: RatesRepository {
    var answer: (RatesRequest) throws -> DailyRates
    private(set) var requests: [RatesRequest] = []

    init(answer: @escaping (RatesRequest) throws -> DailyRates = RatesSamples.market(for:)) {
        self.answer = answer
    }

    nonisolated func latest() async throws -> DailyRates { try await record(.latest) }

    nonisolated func rates(on day: Date) async throws -> DailyRates { try await record(.day(day)) }

    private func record(_ request: RatesRequest) throws -> DailyRates {
        requests.append(request)
        return try answer(request)
    }
}
