@testable import BlixRekrtuacja
import Foundation

struct RatesRepositoryStub: RatesRepository {
    var onLatest: @Sendable () throws -> DailyRates = { RatesSamples.rates(on: RatesSamples.wednesday) }
    var onRates: @Sendable (Date) throws -> DailyRates = { RatesSamples.rates(on: $0) }

    func latest() async throws -> DailyRates { try onLatest() }

    func rates(on day: Date) async throws -> DailyRates { try onRates(day) }
}
