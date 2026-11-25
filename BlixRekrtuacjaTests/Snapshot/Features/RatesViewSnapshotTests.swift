@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .feature))
struct RatesViewSnapshotTests {
    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) async throws {
        let preferences = UserPreferences(store: UserDefaultsStore.isolated())
        try preferences.set(Language.polish)
        let viewModel = RatesViewModel(
            repository: scenario.repository,
            preferences: preferences,
            now: { RatesSamples.wednesdayNoon },
            timeZone: .gmt,
            onSelectRate: { _ in },
            onShowDay: { _ in },
            onOpenSettings: {}
        )
        await viewModel.start()
        // Settle the paging, so no footer task can load a day while the window renders.
        for _ in 0..<RatesViewModel.Paging.autoLoadedDays where viewModel.footer == .loading {
            await viewModel.footerAppeared()
        }

        let sut = NavigationStack { RatesView(viewModel: viewModel) }
            .environment(\.locale, preferences.language.locale)

        assertSnapshots(of: sut, named: scenario.name, configurator: .screen)
    }
}
