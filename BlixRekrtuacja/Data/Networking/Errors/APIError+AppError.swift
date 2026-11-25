import Foundation

extension APIError: AppErrorConvertible {
    var appError: AppError? {
        switch self {
        case .cancelled: nil
        case .transport(let code): AppError(transport: code)
        case .status(let status): AppError(status: status)
        case .decoding: .server
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
        case HTTPStatus.unauthorized, HTTPStatus.forbidden: self = .invalidAPIKey
        case HTTPStatus.requestTimeout: self = .timeout
        case HTTPStatus.tooManyRequests: self = .tooManyRequests
        case HTTPStatus.serverError: self = .server
        default: self = .unknown
        }
    }
}
