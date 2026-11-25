import Foundation

struct RateSelection: Hashable {
    let code: String
    let name: String?
    let value: Decimal
    let base: String
    let day: Date
    let change: Decimal?
}
