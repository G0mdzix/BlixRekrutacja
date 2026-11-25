import SwiftUI

struct BlixButtonConfigurator {
    enum Style {
        case primary
        case secondary
    }

    let title: BlixLabelConfigurator.Content
    var icon: SFSymbol?
    var style = Style.primary
    var isLoading = false
    let action: @MainActor () -> Void

    var isEnabled: Bool { !isLoading }

    var label: BlixLabelConfigurator {
        BlixLabelConfigurator(
            text: title,
            style: style.textStyle,
            typography: .subheadline,
            weight: .semibold,
            icon: isLoading ? nil : icon,
            alignment: .center
        )
    }
}

extension BlixButtonConfigurator.Style {
    var textStyle: BlixLabelConfigurator.Style {
        switch self {
        case .primary: .onBrand
        case .secondary: .accent
        }
    }

    var background: Color {
        switch self {
        case .primary: .brandPrimary
        case .secondary: .backgroundPrimary
        }
    }

    var border: Color? {
        switch self {
        case .primary: nil
        case .secondary: .hairline
        }
    }
}
