import Foundation

struct RateSelection: Hashable {
    struct Point: Hashable {
        let day: Date
        let value: Decimal
    }

    let code: String
    let name: String?
    let value: Decimal
    let base: String
    let day: Date
    let change: Decimal?
    /// The currency on every loaded day, newest first.
    let history: [Point]
}
