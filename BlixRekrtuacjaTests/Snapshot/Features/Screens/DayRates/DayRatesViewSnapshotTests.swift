@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .feature))
struct DayRatesViewSnapshotTests {
    let navigator = MainNavigatingSpy()

    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let viewModel = DayRatesViewModel(selection: Self.selection, navigator: navigator)
        viewModel.query = scenario.query

        let sut = NavigationStack { DayRatesView(viewModel: viewModel) }
            .environment(\.locale, Language.polish.locale)

        assertSnapshots(of: sut, named: scenario.name, configurator: .screen)
    }
}
