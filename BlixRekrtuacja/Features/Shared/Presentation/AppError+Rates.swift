import Foundation

extension AppError {
    var ratesEmptyState: BlixEmptyStateConfigurator {
        let title: LocalizedStringResource = switch self {
        case .missingAPIKey: .ratesMissingKeyTitle
        case .invalidAPIKey: .ratesInvalidKeyTitle
        default: .ratesFirstLoadFailedTitle
        }
        return BlixEmptyStateConfigurator(
            icon: self == .missingAPIKey || self == .invalidAPIKey ? .key : .wifiSlash,
            badge: self == .invalidAPIKey ? .xmark : nil,
            title: .localized(title),
            message: .localized(message)
        )
    }

    func ratesMessageCard(retry: BlixButtonConfigurator?) -> BlixMessageCardConfigurator {
        guard self != .quotaExceeded else {
            return BlixMessageCardConfigurator(
                icon: .hourglass,
                tone: .neutral,
                title: .localized(.ratesQuotaTitle),
                message: .localized(.ratesQuotaMessage)
            )
        }
        return BlixMessageCardConfigurator(
            icon: .wifiSlash,
            title: .localized(.ratesLoadFailedTitle),
            message: .localized(message),
            button: retry
        )
    }
}
