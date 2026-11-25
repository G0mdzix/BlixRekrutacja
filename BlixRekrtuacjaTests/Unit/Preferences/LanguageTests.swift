@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .preferences))
struct LanguageTests {
    @Test func systemLanguageFollowsDeviceLocale() {
        let sut = Language.system

        #expect(sut.locale == .autoupdatingCurrent)
    }

    @Test(arguments: Self.explicitLanguages)
    func explicitLanguageIsLocalizedInApp(_ language: Language) throws {
        let sut = language

        let code = try #require(sut.locale.language.languageCode?.identifier)
        #expect(Bundle.main.localizations.contains(code))
    }
}
