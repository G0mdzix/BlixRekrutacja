import Foundation

struct CurrencyRate: Comparable, Sendable {
    let code: String
    /// Units of this currency for one unit of the base currency.
    let value: Decimal

    static func < (lhs: Self, rhs: Self) -> Bool { lhs.code < rhs.code }
}
