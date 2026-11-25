@testable import BlixRekrtuacja
import Observation
import Testing

@MainActor
@Suite(.tags(.unit, .preferences))
struct UserPreferencesTests {
    @Test(arguments: Self.savedPreferences)
    func loadsSavedPreferences(_ scenario: LoadScenario) throws {
        let store = UserDefaultsStore.isolated()
        if let appearance = scenario.savedAppearance { try store.set(appearance, for: .appearance) }
        if let language = scenario.savedLanguage { try store.set(language, for: .language) }

        let sut = UserPreferences(store: store)

        #expect(sut.appearance == scenario.expectedAppearance)
        #expect(sut.language == scenario.expectedLanguage)
    }

    @Test(arguments: Self.appearanceSaves)
    func persistsSelectedAppearance(_ scenario: AppearanceSaveScenario) throws {
        let store = UserDefaultsStore.isolated()
        try store.set(scenario.saved, for: .appearance)
        let sut = UserPreferences(store: store)

        try sut.set(scenario.selected)

        #expect(sut.appearance == scenario.selected)
        #expect(UserPreferences(store: store).appearance == scenario.selected)
    }

    @Test(arguments: Self.languageSaves)
    func persistsSelectedLanguage(_ scenario: LanguageSaveScenario) throws {
        let store = UserDefaultsStore.isolated()
        try store.set(scenario.saved, for: .language)
        let sut = UserPreferences(store: store)

        try sut.set(scenario.selected)

        #expect(sut.language == scenario.selected)
        #expect(UserPreferences(store: store).language == scenario.selected)
    }

    @Test(arguments: Self.preferences)
    func keepsPreferencesWhenSaveFails(_ preference: Preference) {
        let sut = UserPreferences(store: FailingKeyValueStoreStub())

        #expect(throws: AppError.storage) { try change(preference, on: sut) }

        #expect(sut.appearance == .system)
        #expect(sut.language == .system)
    }

    @Test(arguments: Self.preferences)
    func skipsSavingUnchangedPreference(_ preference: Preference) {
        let sut = UserPreferences(store: FailingKeyValueStoreStub())

        #expect(throws: Never.self) { try keep(preference, on: sut) }
    }

    @Test(arguments: Self.preferences)
    func notifiesObserversWhenPreferenceChanges(_ preference: Preference) async throws {
        let sut = UserPreferences(store: UserDefaultsStore.isolated())

        try await confirmation { changed in
            withObservationTracking { read(preference, from: sut) } onChange: { changed() }
            try change(preference, on: sut)
        }
    }

    // MARK: - Helpers

    private func read(_ preference: Preference, from sut: UserPreferences) {
        switch preference {
        case .appearance: _ = sut.appearance
        case .language: _ = sut.language
        }
    }

    private func change(_ preference: Preference, on sut: UserPreferences) throws {
        switch preference {
        case .appearance: try sut.set(Appearance.dark)
        case .language: try sut.set(Language.english)
        }
    }

    private func keep(_ preference: Preference, on sut: UserPreferences) throws {
        switch preference {
        case .appearance: try sut.set(Appearance.system)
        case .language: try sut.set(Language.system)
        }
    }
}
