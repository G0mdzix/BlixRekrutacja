/// Only cases the user can act on differently; every other failure maps to one of them.
enum AppError: Error, Equatable, Sendable {
    case offline
    case timeout
    case tooManyRequests
    case missingAPIKey
    case invalidAPIKey
    case quotaExceeded
    case server
    case storage
    case unknown
}
