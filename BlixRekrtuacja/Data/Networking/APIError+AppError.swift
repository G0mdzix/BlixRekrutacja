import Foundation

extension APIError: AppErrorConvertible {
    var appError: AppError? {
        switch self {
        case .cancelled: nil
        case .transport(let code): AppError(transport: code)
        case .status(let status): AppError(status: status)
        case .decoding: .decoding
        case .invalidResponse: .unknown
        }
    }
}

private extension AppError {
    init(transport code: URLError.Code) {
        switch code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .internationalRoamingOff: self = .offline
        case .timedOut: self = .timeout
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed: self = .server
        default: self = .unknown
        }
    }

    init(status: Int) {
        switch status {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 408: self = .timeout
        case 429: self = .tooManyRequests
        case 500..<600: self = .server
        default: self = .unknown
        }
    }
}
