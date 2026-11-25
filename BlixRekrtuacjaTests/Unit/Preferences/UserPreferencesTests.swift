@testable import BlixRekrtuacja
import Observation
import Testing

@MainActor
@Suite(.tags(.unit, .preferences))
struct UserPreferencesTests {
    @Test(arguments: Self.savedPreferences)
    func loadsSavedPreferences(_ scenario: LoadScenario) throws {
        let store = UserDefaultsStore.isolated()
        if let appearance = scenario.savedAppearance { store.set(appearance, for: .appearance) }
        if let language = scenario.savedLanguage { store.set(language, for: .language) }

        let sut = UserPreferences(store: store)

        #expect(sut.appearance == scenario.expectedAppearance)
        #expect(sut.language == scenario.expectedLanguage)
    }

    @Test(arguments: Self.appearanceSaves)
    func persistsSelectedAppearance(_ scenario: AppearanceSaveScenario) throws {
        let store = UserDefaultsStore.isolated()
        store.set(scenario.saved, for: .appearance)
        let sut = UserPreferences(store: store)

        sut.set(scenario.selected)

        #expect(sut.appearance == scenario.selected)
        #expect(UserPreferences(store: store).appearance == scenario.selected)
    }

    @Test(arguments: Self.languageSaves)
    func persistsSelectedLanguage(_ scenario: LanguageSaveScenario) throws {
        let store = UserDefaultsStore.isolated()
        store.set(scenario.saved, for: .language)
        let sut = UserPreferences(store: store)

        sut.set(scenario.selected)

        #expect(sut.language == scenario.selected)
        #expect(UserPreferences(store: store).language == scenario.selected)
    }

    @Test(arguments: Self.preferences)
    func ignoresAnUnchangedPreference(_ preference: Preference) async {
        let sut = UserPreferences(store: UserDefaultsStore.isolated())

        await confirmation(expectedCount: 0) { changed in
            withObservationTracking { read(preference, from: sut) } onChange: { changed() }
            keep(preference, on: sut)
        }
    }

    @Test(arguments: Self.preferences)
    func notifiesObserversWhenPreferenceChanges(_ preference: Preference) async {
        let sut = UserPreferences(store: UserDefaultsStore.isolated())

        await confirmation { changed in
            withObservationTracking { read(preference, from: sut) } onChange: { changed() }
            change(preference, on: sut)
        }
    }

    // MARK: - Helpers

    private func read(_ preference: Preference, from sut: UserPreferences) {
        switch preference {
        case .appearance: _ = sut.appearance
        case .language: _ = sut.language
        }
    }

    private func change(_ preference: Preference, on sut: UserPreferences) {
        switch preference {
        case .appearance: sut.set(Appearance.dark)
        case .language: sut.set(Language.english)
        }
    }

    private func keep(_ preference: Preference, on sut: UserPreferences) {
        switch preference {
        case .appearance: sut.set(Appearance.system)
        case .language: sut.set(Language.system)
        }
    }
}
