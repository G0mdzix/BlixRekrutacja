@testable import BlixRekrtuacja
import Foundation

/// Answers with `respond` and records every endpoint's path and query.
@MainActor
final class HTTPClientSpy: HTTPClient {
    struct Request: Equatable {
        let path: String
        let query: [URLQueryItem]
    }

    var respond: (Request) throws(APIError) -> any Sendable
    private(set) var requests: [Request] = []

    init(respond: @escaping (Request) throws(APIError) -> any Sendable) {
        self.respond = respond
    }

    nonisolated func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response {
        let response = try await record(Request(path: endpoint.path, query: endpoint.query))
        guard let response = response as? Response else {
            preconditionFailure("Spy returned \(type(of: response)) for \(Response.self)")
        }
        return response
    }

    private func record(_ request: Request) throws(APIError) -> any Sendable {
        requests.append(request)
        return try respond(request)
    }
}
