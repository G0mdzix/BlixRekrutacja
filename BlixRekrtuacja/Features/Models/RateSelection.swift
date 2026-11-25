import Foundation

struct RateSelection: Hashable {
    let code: String
    let name: String?
    let value: Decimal
    let base: String
    let day: Date
    let change: Decimal?
}

extension RateSelection {
    func rowConfigurator(action: @escaping @MainActor () -> Void) -> BlixRateRowConfigurator {
        BlixRateRowConfigurator(code: code, name: name, value: value, change: change, action: action)
    }
}
