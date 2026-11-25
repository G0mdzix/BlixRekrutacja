import Foundation
import OSLog

/// Fixer answers errors with HTTP 200 as well: `success` tells which of the optional groups is present.
struct FixerRatesResponse: Decodable, Sendable {
    struct ErrorBody: Decodable, Sendable {
        let code: Int
    }

    let success: Bool
    let timestamp: Int?
    let base: String?
    let date: String?
    let rates: [String: Decimal]?
    let error: ErrorBody?

    func dailyRates() throws -> DailyRates {
        guard success else { throw reportedError() }
        guard let base, let timestamp, let rates, let day else {
            Logger.network.error("Fixer response misses fields or has a bad date: \(date ?? "nil", privacy: .public)")
            throw AppError.server
        }
        return DailyRates(
            day: day,
            base: base,
            updatedAt: Date(timeIntervalSince1970: TimeInterval(timestamp)),
            rates: rates.map { CurrencyRate(code: $0.key, value: $0.value) }.sorted()
        )
    }

    private var day: Date? {
        date.flatMap { try? Date($0, strategy: Date.ISO8601FormatStyle.fixerDay) }
    }

    private func reportedError() -> AppError {
        let code = error?.code ?? .zero
        Logger.network.error("Fixer reported error \(code, privacy: .public)")
        return AppError(fixerCode: code)
    }
}

private extension AppError {
    init(fixerCode: Int) {
        switch fixerCode {
        case FixerErrorCode.invalidAPIKey, FixerErrorCode.inactiveAccount: self = .invalidAPIKey
        case FixerErrorCode.monthlyLimitReached: self = .quotaExceeded
        case FixerErrorCode.rateLimitReached: self = .tooManyRequests
        default: self = .server
        }
    }
}

// MARK: - Constants

private enum FixerErrorCode {
    static let invalidAPIKey = 101
    static let inactiveAccount = 102
    static let monthlyLimitReached = 104
    static let rateLimitReached = 106
}
