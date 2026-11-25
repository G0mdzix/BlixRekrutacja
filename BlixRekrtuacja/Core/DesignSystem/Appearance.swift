import SwiftUI

enum Appearance: String, CaseIterable, Codable, Sendable {
    case system
    case light
    case dark

    var title: LocalizedStringResource {
        switch self {
        case .system: .appearanceSystem
        case .light: .appearanceLight
        case .dark: .appearanceDark
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
