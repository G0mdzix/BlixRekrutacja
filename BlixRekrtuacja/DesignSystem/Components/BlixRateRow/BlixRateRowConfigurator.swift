import SwiftUI

struct BlixRateRowConfigurator {
    let code: String
    var name: String?
    let value: Decimal
    var change: Decimal?
    var action: (@MainActor () -> Void)?

    var codeLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: .verbatim(code), typography: .headline)
    }

    var nameLabel: BlixLabelConfigurator? {
        name.map { BlixLabelConfigurator(text: .verbatim($0), style: .secondary, typography: .subheadline) }
    }

    var valueLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(
            text: .number(value, fractionLength: RateFormat.digits),
            typography: .headline,
            alignment: .trailing,
            monospacedDigits: true
        )
    }

    var changeIndicator: BlixChangeIndicatorConfigurator? {
        change.map { BlixChangeIndicatorConfigurator(change: $0) }
    }
}

// MARK: - Constants

private enum RateFormat {
    static let digits = 4
}
