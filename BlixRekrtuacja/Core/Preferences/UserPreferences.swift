import Observation

@MainActor @Observable
final class UserPreferences {
    private(set) var appearance: Appearance
    private(set) var language: Language

    private let store: any KeyValueStore

    init(store: any KeyValueStore) {
        self.store = store
        appearance = store.value(for: .appearance)
        language = store.value(for: .language)
    }

    func set(_ appearance: Appearance) {
        guard appearance != self.appearance else { return }
        store.set(appearance, for: .appearance)
        self.appearance = appearance
    }

    func set(_ language: Language) {
        guard language != self.language else { return }
        store.set(language, for: .language)
        self.language = language
    }
}
