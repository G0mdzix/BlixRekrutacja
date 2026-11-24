enum AppError: Error, Equatable, Sendable {
    case offline
    case timeout
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case tooManyRequests
    case server
    case decoding
    case unknown
}
