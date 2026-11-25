import SwiftUI

struct DayRatesView: View {
    let viewModel: DayRatesViewModel

    @State private var query = ""

    var body: some View {
        BlixList(spacing: Spacing.large) {
            BlixSectionHeader(configurator: viewModel.headerConfigurator)
            let rows = viewModel.rowConfigurators(matching: query)
            if rows.isEmpty {
                BlixEmptyState(configurator: viewModel.noResultsConfigurator(for: query))
            } else {
                VStack(spacing: .zero) {
                    ForEach(rows, id: \.code) { BlixRateRow(configurator: $0) }
                }
                .cardBackground(.primary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, placement: searchPlacement, prompt: Text(.ratesSearchPrompt))
    }

    /// Before iOS 26 the automatic drawer hides the field until the list is pulled down; Liquid Glass shows it below.
    private var searchPlacement: SearchFieldPlacement {
        if #available(iOS 26, *) { .automatic } else { .navigationBarDrawer(displayMode: .always) }
    }
}
