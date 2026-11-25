import SwiftUI

struct BlixEmptyStateConfigurator {
    let icon: SFSymbol
    var badge: SFSymbol?
    let title: BlixLabelConfigurator.Content
    let message: BlixLabelConfigurator.Content

    var titleLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: title, typography: .title, alignment: .center)
    }

    var messageLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: message, style: .secondary, alignment: .center)
    }
}
