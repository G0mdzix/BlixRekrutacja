@testable import BlixRekrtuacja
import Foundation

extension URLSessionHTTPClientTests {
    struct Item: Decodable, Equatable, Sendable {
        let id: Int
    }

    struct SnakeCaseItem: Decodable, Sendable {
        let userId: Int
    }

    enum Stub {
        case response(status: Int, body: String)
        case failure(URLError.Code)
    }

    struct ResponseScenario {
        let stub: Stub
        let expected: Result<Item, APIError>
    }

    struct RequestScenario {
        let baseURL: String
        let endpoint: Endpoint<EmptyResponse>
        let expectedURL: String
        let expectedContentType: String?
    }

    static let responseScenarios: [ResponseScenario] = [
        ResponseScenario(stub: .response(status: 200, body: #"{"id":1}"#), expected: .success(Item(id: 1))),
        ResponseScenario(stub: .response(status: 201, body: #"{"id":2}"#), expected: .success(Item(id: 2))),
        ResponseScenario(stub: .response(status: 200, body: ""), expected: .failure(.decoding)),
        ResponseScenario(stub: .response(status: 200, body: "<html>"), expected: .failure(.decoding)),
        ResponseScenario(stub: .response(status: 404, body: ""), expected: .failure(.status(404))),
        ResponseScenario(stub: .response(status: 500, body: ""), expected: .failure(.status(500))),
        ResponseScenario(
            stub: .failure(.notConnectedToInternet),
            expected: .failure(.transport(.notConnectedToInternet))
        ),
        ResponseScenario(stub: .failure(.cancelled), expected: .failure(.cancelled))
    ]

    static let requestScenarios: [RequestScenario] = [
        RequestScenario(
            baseURL: "https://api.example.com",
            endpoint: Endpoint(path: "items"),
            expectedURL: "https://api.example.com/items",
            expectedContentType: nil
        ),
        RequestScenario(
            baseURL: "https://api.example.com",
            endpoint: Endpoint(
                path: "items",
                method: .post,
                query: [URLQueryItem(name: "page", value: "2")],
                body: Data()
            ),
            expectedURL: "https://api.example.com/items?page=2",
            expectedContentType: "application/json"
        ),
        RequestScenario(
            baseURL: "https://api.example.com/v1",
            endpoint: Endpoint(path: "/items"),
            expectedURL: "https://api.example.com/v1/items",
            expectedContentType: nil
        )
    ]
}
