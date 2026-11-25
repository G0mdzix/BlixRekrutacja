import SwiftUI

struct BlixValueRowConfigurator {
    let title: BlixLabelConfigurator.Content
    let value: BlixLabelConfigurator.Content

    var titleLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: title, style: .secondary, typography: .subheadline)
    }

    var valueLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: value, typography: .subheadline, weight: .semibold, monospacedDigits: true)
    }
}
