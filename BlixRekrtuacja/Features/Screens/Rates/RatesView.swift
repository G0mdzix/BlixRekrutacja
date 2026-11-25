import SwiftUI

struct RatesView: View {
    let viewModel: RatesViewModel

    var body: some View {
        content
            .navigationTitle(.ratesTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { viewModel.openSettings() } label: {
                        Label { Text(.settingsTitle) } icon: { SFSymbol.settings.image }
                    }
                }
            }
            .task { await viewModel.start() }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.content {
        case .loading:
            BlixProgressRow(configurator: viewModel.progressConfigurator)
        case let .failed(emptyState, retry):
            ViewThatFits(in: .vertical) {
                failedState(emptyState, retry: retry)
                ScrollView { failedState(emptyState, retry: retry) }
                    .scrollIndicators(.hidden)
            }
        case .list:
            BlixList(spacing: Spacing.extraLarge) {
                if let baseInfo = viewModel.baseInfoConfigurator { BlixLabel(configurator: baseInfo) }
                ForEach(viewModel.days, id: \.day) { daySection($0) }
                footer
            }
        }
    }

    /// Centered when it fits; scrolls in landscape at large text sizes, so the retry button stays reachable.
    private func failedState(_ emptyState: BlixEmptyStateConfigurator, retry: BlixButtonConfigurator?) -> some View {
        VStack(spacing: Spacing.large) {
            BlixEmptyState(configurator: emptyState)
            if let retry { BlixButton(configurator: retry) }
        }
        .padding(Spacing.large)
        .failureFeedback(trigger: viewModel.failedRetries)
    }

    private func daySection(_ rates: DailyRates) -> some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            BlixSectionHeader(configurator: viewModel.headerConfigurator(rates))
            VStack(spacing: .zero) {
                ForEach(viewModel.rowConfigurators(rates), id: \.code) { BlixRateRow(configurator: $0) }
                if let showAll = viewModel.showAllButtonConfigurator(rates) {
                    BlixButton(configurator: showAll).padding(Spacing.medium)
                }
            }
            .cardBackground(.primary)
        }
    }

    @ViewBuilder private var footer: some View {
        switch viewModel.footer {
        case .loading:
            BlixProgressRow(configurator: viewModel.progressConfigurator)
                .task(id: viewModel.nextDay) { await viewModel.footerAppeared() }
        case .failed(let error):
            BlixMessageCard(configurator: viewModel.failedCardConfigurator(error))
                .failureFeedback(trigger: viewModel.failedRetries)
        case .quotaReached:
            BlixMessageCard(configurator: viewModel.quotaCardConfigurator)
        case .loadOlderButton:
            BlixButton(configurator: viewModel.loadOlderButtonConfigurator)
        case nil:
            EmptyView()
        }
    }
}
