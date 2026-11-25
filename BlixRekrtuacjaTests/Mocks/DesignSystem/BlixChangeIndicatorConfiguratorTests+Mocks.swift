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
        ChangeScenario(change: exact("0.0028"), direction: .rise, magnitude: exact("0.0028")),
        ChangeScenario(change: exact("-0.0115"), direction: .fall, magnitude: exact("0.0115")),
        ChangeScenario(change: 0, direction: .flat, magnitude: 0),
        ChangeScenario(change: exact("0.000001"), direction: .flat, magnitude: 0),
        ChangeScenario(change: exact("-0.000001"), direction: .flat, magnitude: 0),
        ChangeScenario(change: exact("0.00005"), direction: .rise, magnitude: exact("0.0001")),
        ChangeScenario(change: exact("-0.00005"), direction: .fall, magnitude: exact("0.0001"))
    ]

    static let directions: [DirectionScenario] = [
        DirectionScenario(change: exact("0.0028"), symbol: .arrowUp, style: .positive),
        DirectionScenario(change: exact("-0.0115"), symbol: .arrowDown, style: .negative),
        DirectionScenario(change: 0, symbol: .minus, style: .secondary)
    ]
}

/// `Decimal` float literals go through `Double` (`0.0028` becomes `0.002800…0512`); expected values must be exact.
private func exact(_ text: String) -> Decimal {
    Decimal(string: text, locale: Locale(identifier: "en_US_POSIX")) ?? .nan
}
