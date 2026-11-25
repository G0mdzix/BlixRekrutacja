import Foundation

enum Language: String, CaseIterable, Codable, Sendable {
    case system
    case polish
    case english

    var title: LocalizedStringResource {
        switch self {
        case .system: .languageSystem
        case .polish: .languagePolish
        case .english: .languageEnglish
        }
    }

    var locale: Locale {
        switch self {
        case .system: .autoupdatingCurrent
        case .polish: Locale(identifier: "pl")
        case .english: Locale(identifier: "en")
        }
    }
}
