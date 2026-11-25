import SwiftUI

/// The screen for a pushed route. Only `Navigation/` knows every screen.
struct MainDestination: View {
    let route: MainRoute

    var body: some View {
        switch route {
        case .day(let viewModel): DayRatesView(viewModel: viewModel)
        case .rate(let viewModel): RateDetailView(viewModel: viewModel)
        case .settings(let viewModel): SettingsView(viewModel: viewModel)
        }
    }
}
