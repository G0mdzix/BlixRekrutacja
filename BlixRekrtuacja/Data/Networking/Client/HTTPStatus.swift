enum HTTPStatus {
    static let success = 200..<300
    static let unauthorized = 401
    static let forbidden = 403
    static let requestTimeout = 408
    static let tooManyRequests = 429
    static let serverError = 500..<600
}
