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
        let repository = RatesRepositorySpy(answer: scenario.answer)
        let viewModel = RatesViewModel(
            repository: repository,
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

        let requestsBeforeRender = repository.requests.count

        assertSnapshots(of: sut, named: scenario.name, configurator: .screen)

        #expect(repository.requests.count == requestsBeforeRender)
    }
}
