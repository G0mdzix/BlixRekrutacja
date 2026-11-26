@testable import BlixRekrtuacja
import Foundation

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
