import Foundation
import OSLog

extension AppError {
    /// Returns `nil` for cancellation — there is nothing to show the user.
    init?(_ error: any Error) {
        switch error {
        case let appError as AppError:
            self = appError
        case let apiError as APIError:
            self.init(api: apiError)
        case let urlError as URLError:
            self.init(api: APIError(urlError))
        case is CancellationError:
            return nil
        default:
            Logger.app.error("Unmapped error: \(String(describing: error), privacy: .public)")
            self = .unknown
        }
    }

    private init?(api error: APIError) {
        switch error {
        case .cancelled: return nil
        case .transport(let code): self.init(transport: code)
        case .status(let status): self.init(status: status)
        case .decoding: self = .decoding
        case .invalidResponse: self = .unknown
        }
    }

    private init(transport code: URLError.Code) {
        switch code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .internationalRoamingOff: self = .offline
        case .timedOut: self = .timeout
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed: self = .server
        default: self = .unknown
        }
    }

    private init(status: Int) {
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
