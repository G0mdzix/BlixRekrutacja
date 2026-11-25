import SwiftUI

enum Typography {
    case largeTitle, title, headline, body, subheadline, footnote

    var font: Font {
        switch self {
        case .largeTitle: .system(.largeTitle, design: .rounded, weight: .bold)
        case .title: .system(.title2, design: .rounded, weight: .semibold)
        case .headline: .headline
        case .body: .body
        case .subheadline: .subheadline
        case .footnote: .footnote
        }
    }
}
