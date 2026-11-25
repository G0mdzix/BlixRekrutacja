import SwiftUI

struct DayRatesView: View {
    @Bindable var viewModel: DayRatesViewModel

    var body: some View {
        BlixList(spacing: Spacing.large) {
            BlixSectionHeader(configurator: viewModel.headerConfigurator)
            results
        }
        .navigationBarTitleDisplayMode(.inline)
        .blixSearchable(text: $viewModel.query, prompt: Text(.ratesSearchPrompt))
    }

    @ViewBuilder private var results: some View {
        switch viewModel.results {
        case .rows(let rows): ratesCard(rows)
        case .noResults(let noResults): BlixEmptyState(configurator: noResults)
        }
    }

    private func ratesCard(_ rows: [BlixRateRowConfigurator]) -> some View {
        VStack(spacing: .zero) {
            ForEach(rows, id: \.code) { BlixRateRow(configurator: $0) }
        }
        .cardBackground(.primary)
    }
}
