@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .feature))
struct RatesViewSnapshotTests {
    let navigator = MainNavigatingSpy()

    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) async {
        let preferences = UserPreferences.isolated(language: .polish)
        let viewModel = RatesViewModel(
            repository: RatesRepositorySpy(answer: scenario.answer),
            preferences: preferences,
            dates: RatesSamples.dates,
            navigator: navigator
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
