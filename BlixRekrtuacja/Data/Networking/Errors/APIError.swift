import Foundation

enum APIError: Error, Equatable, Sendable {
    case cancelled
    case transport(URLError.Code)
    case invalidResponse
    case status(Int)
    case decoding
}

extension APIError {
    init(_ error: URLError) {
        self = error.code == .cancelled ? .cancelled : .transport(error.code)
    }
}
