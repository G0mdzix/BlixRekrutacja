import SwiftUI

struct RateDetailView: View {
    let viewModel: RateDetailViewModel

    var body: some View {
        BlixList(spacing: Spacing.large) {
            BlixSectionHeader(configurator: viewModel.headerConfigurator)

            valuesCard(viewModel.valueRowConfigurators)

            BlixButton(configurator: viewModel.copyButtonConfigurator)

            history
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder private var history: some View {
        BlixSectionHeader(configurator: viewModel.historyHeaderConfigurator)
        switch viewModel.history {
        case .hint(let hint):
            BlixLabel(configurator: hint)
                .padding(Spacing.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardBackground(.primary)
        case let .loaded(chart, rows):
            BlixLineChart(configurator: chart)
            valuesCard(rows)
        }
    }

    private func valuesCard(_ rows: [BlixValueRowConfigurator]) -> some View {
        VStack(spacing: .zero) {
            ForEach(rows.indices, id: \.self) { BlixValueRow(configurator: rows[$0]) }
        }
        .padding(.horizontal, Spacing.large)
        .cardBackground(.primary)
    }
}
