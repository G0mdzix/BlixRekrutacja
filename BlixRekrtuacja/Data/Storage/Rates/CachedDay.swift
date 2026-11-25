import Foundation
import OSLog
import SwiftData

@Model
final class CachedDay {
    @Attribute(.unique) var day: Date
    var base: String
    var updatedAt: Date
    var isFinal: Bool
    var latestFetchedAt: Date?
    /// `code → value` as decimal strings: text keeps every digit of a rate, whatever the store does with numbers.
    var rates: [String: String]

    init(_ cached: CachedRates) {
        day = cached.rates.day
        base = cached.rates.base
        updatedAt = cached.rates.updatedAt
        isFinal = cached.isFinal
        latestFetchedAt = cached.latestFetchedAt
        rates = Self.strings(from: cached.rates.rates)
    }

    /// `nil` when a stored value no longer parses: a partial day would show wrong data.
    var cachedRates: CachedRates? {
        let values = rates.compactMap { code, value in
            Decimal(string: value, locale: Self.decimalLocale).map { CurrencyRate(code: code, value: $0) }
        }
        guard values.count == rates.count else {
            Logger.storage.error("Cached rates of \(self.day, privacy: .public) are corrupt")
            return nil
        }
        let daily = DailyRates(day: day, base: base, updatedAt: updatedAt, rates: values.sorted())
        return CachedRates(rates: daily, isFinal: isFinal, latestFetchedAt: latestFetchedAt)
    }

    func update(with cached: CachedRates) {
        latestFetchedAt = cached.latestFetchedAt ?? latestFetchedAt
        if isFinal && !cached.isFinal { return }
        base = cached.rates.base
        updatedAt = cached.rates.updatedAt
        isFinal = cached.isFinal
        rates = Self.strings(from: cached.rates.rates)
    }

    private static let decimalLocale = Locale(identifier: "en_US_POSIX")

    private static func strings(from rates: [CurrencyRate]) -> [String: String] {
        Dictionary(uniqueKeysWithValues: rates.map { ($0.code, $0.value.description) })
    }
}
