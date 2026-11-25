import Foundation

extension AppError {
    var message: LocalizedStringResource {
        switch self {
        case .offline: .errorOfflineMessage
        case .timeout: .errorTimeoutMessage
        case .tooManyRequests: .errorTooManyRequestsMessage
        case .missingAPIKey: .errorMissingAPIKeyMessage
        case .invalidAPIKey: .errorInvalidAPIKeyMessage
        case .quotaExceeded: .errorQuotaExceededMessage
        case .server: .errorServerMessage
        case .storage: .errorStorageMessage
        case .unknown: .errorGenericMessage
        }
    }
}
