import SwiftUI

enum CardBackground {
    case primary
    case secondary

    var color: Color {
        switch self {
        case .primary: .backgroundPrimary
        case .secondary: .backgroundSecondary
        }
    }
}
