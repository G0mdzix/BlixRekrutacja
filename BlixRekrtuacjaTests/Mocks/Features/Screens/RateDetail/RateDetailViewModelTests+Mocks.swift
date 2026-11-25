@testable import BlixRekrtuacja
import Foundation

extension RateDetailViewModelTests {
    struct RowCountScenario {
        let change: String?
        let expectedRows: Int
    }

    nonisolated static let rowCounts: [RowCountScenario] = [
        RowCountScenario(change: "0.0028", expectedRows: 4),
        RowCountScenario(change: nil, expectedRows: 3)
    ]
}
