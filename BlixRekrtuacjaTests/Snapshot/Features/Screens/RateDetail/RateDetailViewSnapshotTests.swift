@testable import BlixRekrtuacja
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot, .feature))
struct RateDetailViewSnapshotTests {
    let clipboard = ClipboardSpy()

    @Test(arguments: Self.variants)
    func recordSnapshot(_ scenario: Scenario) {
        let viewModel = RateDetailViewModel(rate: scenario.rate, clipboard: clipboard)
        if scenario.isCopied { viewModel.copyRate() }

        let sut = NavigationStack { RateDetailView(viewModel: viewModel) }
            .environment(\.locale, Language.polish.locale)

        assertSnapshots(of: sut, named: scenario.name, configurator: .screen)
    }
}
