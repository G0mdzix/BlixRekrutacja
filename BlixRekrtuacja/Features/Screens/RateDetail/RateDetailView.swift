import SwiftUI

struct RateDetailView: View {
    let viewModel: RateDetailViewModel

    var body: some View {
        BlixList(spacing: Spacing.large) {
            BlixSectionHeader(configurator: viewModel.headerConfigurator)
            VStack(spacing: .zero) {
                ForEach(Array(viewModel.valueRowConfigurators.enumerated()), id: \.offset) {
                    BlixValueRow(configurator: $0.element)
                }
            }
            .padding(.horizontal, Spacing.large)
            .cardBackground(.primary)
            BlixButton(configurator: viewModel.copyButtonConfigurator)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
