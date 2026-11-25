@testable import BlixRekrtuacja
import Foundation

struct HTTPClientStub: HTTPClient {
    let respond: @Sendable (_ path: String, _ query: [URLQueryItem]) throws(APIError) -> any Sendable

    func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response {
        let response = try respond(endpoint.path, endpoint.query)
        guard let response = response as? Response else {
            preconditionFailure("Stub returned \(type(of: response)) for \(Response.self)")
        }
        return response
    }
}
