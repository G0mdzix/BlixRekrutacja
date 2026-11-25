@testable import BlixRekrtuacja
import Foundation
import Testing

@MainActor
@Suite(.tags(.unit, .rates))
struct RemoteRatesRepositoryTests {
    let client: HTTPClientSpy
    let sut: RemoteRatesRepository

    init() throws {
        let response = try RatesSamples.fixerResponse()
        client = HTTPClientSpy { _ in response }
        sut = RemoteRatesRepository(client: client, apiKey: Self.apiKey)
    }

    @Test(arguments: Self.requests)
    func requestsTheDayWithTheKey(_ scenario: RequestScenario) async throws {
        _ = try await scenario.request.perform(on: sut)

        let query = [URLQueryItem(name: "access_key", value: Self.apiKey)]
        #expect(client.requests == [HTTPClientSpy.Request(path: scenario.expectedPath, query: query)])
    }

    @Test(arguments: Self.requests)
    func failsWithoutAKeyBeforeTheNetwork(_ scenario: RequestScenario) async {
        let keyless = RemoteRatesRepository(client: client, apiKey: "")

        await #expect(throws: AppError.missingAPIKey) { try await scenario.request.perform(on: keyless) }
        #expect(client.requests.isEmpty)
    }

    @Test func returnsTheMappedResponse() async throws {
        let rates = try await sut.latest()

        #expect(rates == RatesSamples.fixerSaturday)
    }

    @Test(arguments: Self.rateLimits)
    func triesOnceMoreWhenRateLimited(_ scenario: RateLimitScenario) async throws {
        let response = try RatesSamples.fixerResponse()
        var outcomes = scenario.outcomes[...]
        client.respond = { _ throws(APIError) in
            guard outcomes.popFirst() == .rateLimited else { return response }
            throw .status(HTTPStatus.tooManyRequests)
        }
        let sut = RemoteRatesRepository(client: client, apiKey: Self.apiKey, retryDelay: .zero)

        let rates = try? await sut.latest()

        #expect((rates != nil) == scenario.expectsRates)
        #expect(client.requests.count == scenario.outcomes.count)
    }

    @Test func passesClientErrorsOn() async {
        client.respond = { _ throws(APIError) in throw .transport(.notConnectedToInternet) }

        await #expect(throws: APIError.transport(.notConnectedToInternet)) { try await sut.latest() }
    }
}
