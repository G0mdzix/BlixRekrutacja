@testable import BlixRekrtuacja
import SwiftUI

extension BlixRateRowConfiguratorTests {
    struct DataScenario {
        let name: String?
        let change: Decimal?
        let nameStyle: BlixLabelConfigurator.Style?
    }

    static let optionalData: [DataScenario] = [
        DataScenario(name: "złoty polski", change: 0.0028, nameStyle: .secondary),
        DataScenario(name: nil, change: nil, nameStyle: nil)
    ]
}
