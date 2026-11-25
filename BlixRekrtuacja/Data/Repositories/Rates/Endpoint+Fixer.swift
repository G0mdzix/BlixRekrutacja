import Foundation

extension Endpoint where Response == FixerRatesResponse {
    static func fixerLatest(apiKey: String) -> Self {
        Self(path: FixerAPI.latestPath, query: query(apiKey: apiKey))
    }

    static func fixerRates(on day: Date, apiKey: String) -> Self {
        Self(path: day.formatted(Date.ISO8601FormatStyle.fixerDay), query: query(apiKey: apiKey))
    }

    /// The key goes in the query, so URLs are never logged (the client logs the path only).
    private static func query(apiKey: String) -> [URLQueryItem] {
        [URLQueryItem(name: FixerAPI.apiKeyParameter, value: apiKey)]
    }
}

// MARK: - Constants

private enum FixerAPI {
    static let latestPath = "latest"
    static let apiKeyParameter = "access_key"
}
