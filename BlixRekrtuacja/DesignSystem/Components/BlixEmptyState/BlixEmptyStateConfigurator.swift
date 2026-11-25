import SwiftUI

struct BlixEmptyStateConfigurator {
    let icon: SFSymbol
    /// A small red mark on the icon, e.g. for a key that was rejected.
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
