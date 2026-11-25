import SwiftUI

struct BlixSectionHeaderConfigurator {
    let title: BlixLabelConfigurator.Content
    var badge: BlixLabelConfigurator.Content?
    var caption: BlixLabelConfigurator.Content?

    var hasDetails: Bool { badge != nil || caption != nil }

    var titleLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: title, typography: .title)
    }

    var badgeLabel: BlixLabelConfigurator? {
        badge.map { BlixLabelConfigurator(text: $0, style: .onBrand, typography: .footnote, weight: .semibold) }
    }

    var captionLabel: BlixLabelConfigurator? {
        caption.map { BlixLabelConfigurator(text: $0, style: .secondary, typography: .footnote) }
    }
}
