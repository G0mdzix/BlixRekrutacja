import Foundation

struct RemoteRatesRepository: RatesRepository {
    private let client: any HTTPClient
    private let apiKey: String
    private let retryDelay: Duration

    init(client: any HTTPClient, apiKey: String, retryDelay: Duration = RateLimit.retryDelay) {
        self.client = client
        self.apiKey = apiKey
        self.retryDelay = retryDelay
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

    /// The free plan rejects a request that follows another too closely (the first launch asks for two days at once);
    /// one later try gets through.
    private func send(_ endpoint: Endpoint<FixerRatesResponse>) async throws -> DailyRates {
        do {
            return try await client.send(endpoint).dailyRates()
        } catch let error where AppError(error) == .tooManyRequests {
            try await Task.sleep(for: retryDelay)
            return try await client.send(endpoint).dailyRates()
        }
    }
}

// MARK: - Constants

extension RemoteRatesRepository {
    enum RateLimit {
        static let retryDelay = Duration.seconds(1)
    }
}
