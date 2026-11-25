@testable import BlixRekrtuacja
import Observation
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct SettingsViewModelTests {
    @Test(arguments: Self.appearanceTaps)
    func tappingRowSelectsOnlyThatAppearance(_ scenario: AppearanceTapScenario) throws {
        let preferences = UserPreferences(store: UserDefaultsStore.isolated())
        try preferences.set(scenario.saved)
        let sut = SettingsViewModel(preferences: preferences)

        sut.appearanceRowConfigurator(scenario.tapped).action()

        #expect(preferences.appearance == scenario.tapped)
        #expect(Appearance.allCases.filter { sut.appearanceRowConfigurator($0).isSelected } == [scenario.tapped])
    }

    @Test(arguments: Self.languageTaps)
    func tappingRowSelectsOnlyThatLanguage(_ scenario: LanguageTapScenario) throws {
        let preferences = UserPreferences(store: UserDefaultsStore.isolated())
        try preferences.set(scenario.saved)
        let sut = SettingsViewModel(preferences: preferences)

        sut.languageRowConfigurator(scenario.tapped).action()

        #expect(preferences.language == scenario.tapped)
        #expect(Language.allCases.filter { sut.languageRowConfigurator($0).isSelected } == [scenario.tapped])
    }

    @Test(arguments: Self.failingTaps)
    func reportsErrorOnlyWhenSavingFails(_ scenario: FailingTapScenario) {
        let sut = Self.makeFailingSUT()

        tap(scenario.row, on: sut)

        #expect(sut.error == scenario.expectedError)
    }

    @Test func clearsErrorWhenDismissed() throws {
        let sut = Self.makeFailingSUT()
        tap(.appearance(.dark), on: sut)
        try #require(sut.error == .storage)

        sut.dismissError()

        #expect(sut.error == nil)
    }

    @Test(arguments: Self.observedChanges)
    func notifiesObserversWhenErrorChanges(_ change: ObservedChange) async {
        let sut = makeSUT(for: change)

        await confirmation { changed in
            withObservationTracking { _ = sut.error } onChange: { changed() }
            perform(change, on: sut)
        }
    }

    // MARK: - Helpers

    private static func makeFailingSUT() -> SettingsViewModel {
        SettingsViewModel(preferences: UserPreferences(store: FailingKeyValueStoreStub()))
    }

    private func makeSUT(for change: ObservedChange) -> SettingsViewModel {
        let sut = Self.makeFailingSUT()
        switch change {
        case .shown: break
        case .dismissed: tap(.appearance(.dark), on: sut)
        }
        return sut
    }

    private func perform(_ change: ObservedChange, on sut: SettingsViewModel) {
        switch change {
        case .shown: tap(.appearance(.dark), on: sut)
        case .dismissed: sut.dismissError()
        }
    }

    private func tap(_ row: Row, on sut: SettingsViewModel) {
        switch row {
        case .appearance(let appearance): sut.appearanceRowConfigurator(appearance).action()
        case .language(let language): sut.languageRowConfigurator(language).action()
        }
    }
}
