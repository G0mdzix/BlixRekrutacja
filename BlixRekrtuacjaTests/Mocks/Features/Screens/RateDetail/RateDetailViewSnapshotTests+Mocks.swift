@testable import BlixRekrtuacja
import Foundation

extension RateDetailViewSnapshotTests {
    struct Scenario {
        let name: String
        let rate: RateSelection
        var isCopied = false
    }

    nonisolated static let variants: [Scenario] = [
        Scenario(name: "with-change", rate: Rate.pln),
        Scenario(name: "without-change", rate: Rate.plnWithoutChange),
        Scenario(name: "copied", rate: Rate.pln, isCopied: true)
    ]
}

private enum Rate {
    static let pln = RatesSamples.selection("PLN", "złoty polski", "4.259811", change: "0.0020")
    /// The oldest loaded day has no previous day to compare with, so the change row is hidden.
    static let plnWithoutChange = RatesSamples.selection("PLN", "złoty polski", "4.251240", change: nil)
}
