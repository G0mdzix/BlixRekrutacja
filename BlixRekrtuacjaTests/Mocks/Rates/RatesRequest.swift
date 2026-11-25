@testable import BlixRekrtuacja
import Foundation

enum RatesRequest: Equatable, Sendable {
    case latest
    case day(Date)

    var day: Date? {
        guard case .day(let day) = self else { return nil }
        return day
    }

    func perform(on repository: some RatesRepository) async throws -> DailyRates {
        switch self {
        case .latest: try await repository.latest()
        case .day(let day): try await repository.rates(on: day)
        }
    }

    func read(from cache: some RatesCache) async -> CachedRates? {
        switch self {
        case .latest: await cache.latest()
        case .day(let day): await cache.rates(on: day)
        }
    }
}
