@testable import BlixRekrtuacja
import Foundation
import os
import Testing

@Suite(.serialized, .tags(.unit, .networking))
struct URLSessionHTTPClientTests {
    @Test(arguments: Self.responseScenarios)
    func mapsResponseToResult(_ scenario: ResponseScenario) async throws {
        let sut = try Self.makeSUT()
        URLProtocolStub.handler = { request in try Self.respond(with: scenario.stub, to: request) }

        let result = await Self.send(Endpoint<Item>(path: "items/1"), with: sut)

        #expect(result == scenario.expected)
    }

    @Test(arguments: Self.requestScenarios)
    func buildsRequestFromEndpoint(_ scenario: RequestScenario) async throws {
        let sut = try Self.makeSUT(baseURL: scenario.baseURL)
        let sentRequest = OSAllocatedUnfairLock<URLRequest?>(initialState: nil)
        URLProtocolStub.handler = { request in
            sentRequest.withLock { $0 = request }
            return try Self.respond(with: .response(status: 204, body: ""), to: request)
        }

        _ = try await sut.send(scenario.endpoint)

        let request = try #require(sentRequest.withLock { $0 })
        #expect(request.httpMethod == scenario.endpoint.method.rawValue)
        #expect(request.url?.absoluteString == scenario.expectedURL)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == scenario.expectedContentType)
    }

    @Test func decodesWithInjectedDecoder() async throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let sut = try Self.makeSUT(decoder: decoder)
        URLProtocolStub.handler = { request in
            try Self.respond(with: .response(status: 200, body: #"{"user_id":7}"#), to: request)
        }

        let response = try await sut.send(Endpoint<SnakeCaseItem>(path: "items/7"))

        #expect(response.userId == 7)
    }

    // MARK: - Helpers

    private static func makeSUT(
        baseURL: String = "https://api.example.com",
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> URLSessionHTTPClient {
        let url = try #require(URL(string: baseURL))
        return URLSessionHTTPClient(baseURL: url, session: URLProtocolStub.session(), decoder: decoder)
    }

    private static func respond(with stub: Stub, to request: URLRequest) throws -> (HTTPURLResponse, Data) {
        switch stub {
        case let .response(status, body):
            let url = try #require(request.url)
            let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)
            return (try #require(response), Data(body.utf8))
        case .failure(let code):
            throw URLError(code)
        }
    }

    private static func send(
        _ endpoint: Endpoint<Item>,
        with sut: URLSessionHTTPClient
    ) async -> Result<Item, APIError> {
        do {
            return .success(try await sut.send(endpoint))
        } catch {
            return .failure(error)
        }
    }
}
