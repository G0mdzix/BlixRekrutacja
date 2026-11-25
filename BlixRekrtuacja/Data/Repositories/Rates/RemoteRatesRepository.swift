import Foundation

struct RemoteRatesRepository: RatesRepository {
    private let client: any HTTPClient
    private let apiKey: String

    init(client: any HTTPClient, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func latest() async throws -> DailyRates {
        try await send(.fixerLatest(apiKey: validKey()))
    }

    func rates(on day: Date) async throws -> DailyRates {
        try await send(.fixerRates(on: day, apiKey: validKey()))
    }

    /// An empty key would cost a request and come back as 101, so it fails before the network.
    private func validKey() throws -> String {
        guard !apiKey.isEmpty else { throw AppError.missingAPIKey }
        return apiKey
    }

    private func send(_ endpoint: Endpoint<FixerRatesResponse>) async throws -> DailyRates {
        try await client.send(endpoint).dailyRates()
    }
}
