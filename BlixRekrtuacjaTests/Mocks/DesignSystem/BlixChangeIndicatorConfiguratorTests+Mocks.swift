@testable import BlixRekrtuacja
import Foundation

extension BlixChangeIndicatorConfiguratorTests {
    struct ChangeScenario {
        let change: Decimal
        let direction: BlixChangeIndicatorConfigurator.Direction
        let magnitude: Decimal
    }

    struct DirectionScenario {
        let change: Decimal
        let symbol: SFSymbol
        let style: BlixLabelConfigurator.Style
    }

    static let changes: [ChangeScenario] = [
        ChangeScenario(change: Decimal(exact: "0.0028"), direction: .rise, magnitude: Decimal(exact: "0.0028")),
        ChangeScenario(change: Decimal(exact: "-0.0115"), direction: .fall, magnitude: Decimal(exact: "0.0115")),
        ChangeScenario(change: 0, direction: .flat, magnitude: 0),
        ChangeScenario(change: Decimal(exact: "0.000001"), direction: .flat, magnitude: 0),
        ChangeScenario(change: Decimal(exact: "-0.000001"), direction: .flat, magnitude: 0),
        ChangeScenario(change: Decimal(exact: "0.00005"), direction: .rise, magnitude: Decimal(exact: "0.0001")),
        ChangeScenario(change: Decimal(exact: "-0.00005"), direction: .fall, magnitude: Decimal(exact: "0.0001"))
    ]

    static let directions: [DirectionScenario] = [
        DirectionScenario(change: Decimal(exact: "0.0028"), symbol: .arrowUp, style: .positive),
        DirectionScenario(change: Decimal(exact: "-0.0115"), symbol: .arrowDown, style: .negative),
        DirectionScenario(change: 0, symbol: .minus, style: .secondary)
    ]
}
