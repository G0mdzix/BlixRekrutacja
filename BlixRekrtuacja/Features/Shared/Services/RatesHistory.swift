import Foundation
import Observation

@MainActor @Observable
final class RatesHistory {
    private(set) var days: [DailyRates] = []
    private(set) var nextDay: Date?

    private let repository: any RatesRepository

    init(repository: any RatesRepository) {
        self.repository = repository
    }

    func loadNext() async throws {
        let requested = nextDay
        let rates = if let requested {
            try await repository.rates(on: requested)
        } else {
            try await repository.latest()
        }
        // A holiday answers with an earlier, maybe already loaded day; paging still moves past the requested one.
        nextDay = BusinessDays.previous(before: min(rates.day, requested ?? rates.day))
        if !days.contains(where: { $0.day == rates.day }) { days.append(rates) }
    }

    func day(before rates: DailyRates) -> DailyRates? {
        days.drop { $0.day != rates.day }.dropFirst().first
    }
}
