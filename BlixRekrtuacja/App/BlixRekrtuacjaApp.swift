import SwiftUI

@main
struct BlixRekrtuacjaApp: App {
    @State private var settings = SettingsViewModel(store: UserDefaultsStore(defaults: .standard))

    var body: some Scene {
        WindowGroup {
            NavigationStack { SettingsView(viewModel: settings) }
                .preferredColorScheme(settings.appearance.colorScheme)
        }
    }
}
