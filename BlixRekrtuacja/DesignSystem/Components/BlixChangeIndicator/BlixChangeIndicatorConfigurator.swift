import Foundation
import SwiftUI

struct BlixChangeIndicatorConfigurator {
    enum Direction {
        case rise
        case fall
        case flat
    }

    /// Relative change as a fraction: `0.0028` is shown as `0.28%`.
    let change: Decimal

    /// The change rounded to the shown digits, so a value shown as `0.00%` never gets an arrow.
    var displayedChange: Decimal {
        var value = change
        var rounded = Decimal()
        NSDecimalRound(&rounded, &value, Self.fractionLength + Self.percentShift, .plain)
        return rounded
    }

    var direction: Direction {
        switch displayedChange {
        case ..<0: .fall
        case 0: .flat
        default: .rise
        }
    }

    var magnitude: Decimal { abs(displayedChange) }

    var label: BlixLabelConfigurator {
        BlixLabelConfigurator(
            text: .percent(magnitude, fractionLength: Self.fractionLength),
            style: direction.style,
            typography: .footnote,
            weight: .semibold,
            icon: direction.symbol,
            monospacedDigits: true
        )
    }

    private static let fractionLength = 2
    /// A percent shows the fraction × 100, i.e. two more decimal places of the fraction.
    private static let percentShift = 2
}

extension BlixChangeIndicatorConfigurator.Direction {
    var symbol: SFSymbol {
        switch self {
        case .rise: .arrowUp
        case .fall: .arrowDown
        case .flat: .minus
        }
    }

    var style: BlixLabelConfigurator.Style {
        switch self {
        case .rise: .positive
        case .fall: .negative
        case .flat: .secondary
        }
    }
}
