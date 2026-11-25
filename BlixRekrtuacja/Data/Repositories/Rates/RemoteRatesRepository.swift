import Foundation

struct RemoteRatesRepository: RatesRepository {
    private let client: any HTTPClient
    private let apiKey: String

    init(client: any HTTPClient, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func latest() async throws -> DailyRates {
        try await client.send(.fixerLatest(apiKey: apiKey)).dailyRates()
    }

    func rates(on day: Date) async throws -> DailyRates {
        try await client.send(.fixerRates(on: day, apiKey: apiKey)).dailyRates()
    }
}
