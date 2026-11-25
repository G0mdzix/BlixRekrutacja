import Foundation

/// `day` is midnight UTC of the day the rates are for.
struct DailyRates: Equatable, Sendable {
    let day: Date
    let base: String
    let updatedAt: Date
    let rates: [CurrencyRate]
}
