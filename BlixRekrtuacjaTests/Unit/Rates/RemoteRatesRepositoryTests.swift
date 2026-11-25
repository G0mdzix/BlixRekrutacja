@testable import BlixRekrtuacja
import Foundation
import os
import Testing

@Suite(.tags(.unit, .rates))
struct RemoteRatesRepositoryTests {
    @Test(arguments: Self.requests)
    func requestsTheDayWithTheKey(_ scenario: RequestScenario) async throws {
        let response = try RatesSamples.fixerResponse()
        let sent = OSAllocatedUnfairLock<(path: String, query: [URLQueryItem])?>(initialState: nil)
        let sut = Self.makeSUT { path, query in
            sent.withLock { $0 = (path, query) }
            return response
        }

        _ = try await scenario.request.perform(on: sut)

        let request = try #require(sent.withLock { $0 })
        #expect(request.path == scenario.expectedPath)
        #expect(request.query == [URLQueryItem(name: "access_key", value: Self.apiKey)])
    }

    @Test(arguments: Self.requests)
    func failsWithoutAKeyBeforeTheNetwork(_ scenario: RequestScenario) async throws {
        let response = try RatesSamples.fixerResponse()
        let sent = OSAllocatedUnfairLock(initialState: false)
        let client = HTTPClientStub { _, _ in
            sent.withLock { $0 = true }
            return response
        }
        let sut = RemoteRatesRepository(client: client, apiKey: "")

        await #expect(throws: AppError.missingAPIKey) { try await scenario.request.perform(on: sut) }
        #expect(!sent.withLock { $0 })
    }

    @Test func returnsTheMappedResponse() async throws {
        let response = try RatesSamples.fixerResponse()
        let sut = Self.makeSUT { _, _ in response }

        let rates = try await sut.latest()

        #expect(rates == RatesSamples.fixerSaturday)
    }

    @Test func passesClientErrorsOn() async {
        let sut = Self.makeSUT { _, _ throws(APIError) in throw .transport(.notConnectedToInternet) }

        await #expect(throws: APIError.transport(.notConnectedToInternet)) { try await sut.latest() }
    }

    // MARK: - Helpers

    private static func makeSUT(
        respond: @escaping @Sendable (String, [URLQueryItem]) throws(APIError) -> any Sendable
    ) -> RemoteRatesRepository {
        RemoteRatesRepository(client: HTTPClientStub(respond: respond), apiKey: apiKey)
    }
}
