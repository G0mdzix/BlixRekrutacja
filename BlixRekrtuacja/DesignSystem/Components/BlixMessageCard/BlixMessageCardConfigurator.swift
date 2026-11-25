import SwiftUI

struct BlixMessageCardConfigurator {
    enum Tone {
        case error
        case neutral
    }

    let icon: SFSymbol
    var tone = Tone.error
    let title: BlixLabelConfigurator.Content
    let message: BlixLabelConfigurator.Content
    var button: BlixButtonConfigurator?

    var titleLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: title, typography: .headline)
    }

    var messageLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: message, style: .secondary, typography: .subheadline)
    }
}

extension BlixMessageCardConfigurator.Tone {
    var iconColor: Color {
        switch self {
        case .error: .textNegative
        case .neutral: .textSecondary
        }
    }

    var iconBackground: Color {
        switch self {
        case .error: .errorSubtle
        case .neutral: .fillMuted
        }
    }
}
