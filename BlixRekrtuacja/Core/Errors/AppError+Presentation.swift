import Foundation

extension AppError {
    var message: LocalizedStringResource {
        switch self {
        case .offline: .errorOfflineMessage
        case .timeout: .errorTimeoutMessage
        case .badRequest: .errorBadRequestMessage
        case .unauthorized: .errorUnauthorizedMessage
        case .forbidden: .errorForbiddenMessage
        case .notFound: .errorNotFoundMessage
        case .tooManyRequests: .errorTooManyRequestsMessage
        case .server: .errorServerMessage
        case .decoding: .errorDecodingMessage
        case .unknown: .errorGenericMessage
        }
    }
}
