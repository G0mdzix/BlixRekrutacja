import SwiftUI

struct RateDetailView: View {
    let viewModel: RateDetailViewModel

    var body: some View {
        BlixList(spacing: Spacing.large) {
            BlixSectionHeader(configurator: viewModel.headerConfigurator)
            valuesCard
            BlixButton(configurator: viewModel.copyButtonConfigurator)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var valuesCard: some View {
        let rows = viewModel.valueRowConfigurators
        return VStack(spacing: .zero) {
            ForEach(rows.indices, id: \.self) { BlixValueRow(configurator: rows[$0]) }
        }
        .padding(.horizontal, Spacing.large)
        .cardBackground(.primary)
    }
}
