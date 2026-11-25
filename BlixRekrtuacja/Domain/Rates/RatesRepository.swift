import Foundation

protocol RatesRepository: Sendable {
    func latest() async throws -> DailyRates

    /// `day` is any moment of that day in UTC.
    func rates(on day: Date) async throws -> DailyRates
}
