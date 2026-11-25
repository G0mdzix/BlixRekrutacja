@testable import BlixRekrtuacja

extension LanguageTests {
    static let explicitLanguages: [Language] = Language.allCases.filter { $0 != .system }
}
