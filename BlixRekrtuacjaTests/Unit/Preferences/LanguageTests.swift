@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .preferences))
struct LanguageTests {
    @Test(arguments: Self.explicitLanguages)
    func explicitLanguageIsLocalizedInApp(_ language: Language) throws {
        let sut = language

        let code = try #require(sut.locale.language.languageCode?.identifier)
        #expect(Bundle.main.localizations.contains(code))
    }
}
