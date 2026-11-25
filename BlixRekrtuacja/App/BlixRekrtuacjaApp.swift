import SwiftUI

@main
struct BlixRekrtuacjaApp: App {
    @State private var preferences: UserPreferences
    @State private var settings: SettingsViewModel

    init() {
        let preferences = UserPreferences(store: UserDefaultsStore(defaults: .standard))
        _preferences = State(initialValue: preferences)
        _settings = State(initialValue: SettingsViewModel(preferences: preferences))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack { SettingsView(viewModel: settings) }
                .preferredColorScheme(preferences.appearance.colorScheme)
                .environment(\.locale, preferences.language.locale)
        }
    }
}
