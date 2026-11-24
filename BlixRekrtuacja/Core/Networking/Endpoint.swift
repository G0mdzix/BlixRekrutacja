import Foundation

struct Endpoint<Response: Decodable & Sendable>: Sendable {
    let path: String
    let method: HTTPMethod
    let query: [URLQueryItem]
    let body: Data?

    init(path: String, method: HTTPMethod = .get, query: [URLQueryItem] = [], body: Data? = nil) {
        self.path = path
        self.method = method
        self.query = query
        self.body = body
    }
}
