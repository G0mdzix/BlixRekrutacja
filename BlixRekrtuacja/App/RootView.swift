import SwiftUI

struct RootView: View {
    let container: AppContainer

    var body: some View {
        CoordinatedStack(coordinator: container.coordinator) {
            RatesView(viewModel: container.coordinator.root)
        } destination: { MainDestination(route: $0) }
            .preferredColorScheme(container.preferences.appearance.colorScheme)
            .environment(\.locale, container.preferences.language.locale)
    }
}
