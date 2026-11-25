@testable import BlixRekrtuacja
import Foundation

extension RateDetailViewModelTests {
    struct RowCountScenario {
        let change: Decimal?
        let expectedRows: Int
    }

    nonisolated static let rowCounts: [RowCountScenario] = [
        RowCountScenario(change: Decimal(exact: "0.0028"), expectedRows: 4),
        RowCountScenario(change: nil, expectedRows: 3)
    ]
}
