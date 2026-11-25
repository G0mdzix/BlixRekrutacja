@testable import BlixRekrtuacja
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct SettingsViewModelTests {
    let preferences = UserPreferences.isolated()
    let sut: SettingsViewModel

    init() {
        sut = SettingsViewModel(preferences: preferences)
    }

    @Test(arguments: Self.appearanceTaps)
    func tappingRowSelectsOnlyThatAppearance(_ scenario: AppearanceTapScenario) {
        preferences.set(scenario.saved)

        sut.appearanceRowConfigurator(scenario.tapped).action()

        #expect(preferences.appearance == scenario.tapped)
        #expect(Appearance.allCases.filter { sut.appearanceRowConfigurator($0).isSelected } == [scenario.tapped])
    }

    @Test(arguments: Self.languageTaps)
    func tappingRowSelectsOnlyThatLanguage(_ scenario: LanguageTapScenario) {
        preferences.set(scenario.saved)

        sut.languageRowConfigurator(scenario.tapped).action()

        #expect(preferences.language == scenario.tapped)
        #expect(Language.allCases.filter { sut.languageRowConfigurator($0).isSelected } == [scenario.tapped])
    }
}
