import SwiftUI

struct RatesView: View {
    let viewModel: RatesViewModel

    var body: some View {
        content
            .navigationTitle(.ratesTitle)
            .toolbar { settingsButton }
            .task { await viewModel.start() }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.content {
        case .loading: BlixProgressRow(configurator: viewModel.progressConfigurator)
        case let .failed(emptyState, retry): failed(emptyState, retry: retry)
        case .list(let baseInfo): list(baseInfo: baseInfo)
        }
    }

    private var settingsButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button { viewModel.openSettings() } label: {
                Label { Text(.settingsTitle) } icon: { SFSymbol.settings.image }
            }
        }
    }

    @ViewBuilder private var footer: some View {
        switch viewModel.footer {
        case .loading:
            BlixProgressRow(configurator: viewModel.progressConfigurator)
                .task(id: viewModel.nextDay) { await viewModel.footerAppeared() }
        case .failed(let error):
            BlixMessageCard(configurator: viewModel.messageCardConfigurator(error))
        case .loadOlderButton:
            BlixButton(configurator: viewModel.loadOlderButtonConfigurator)
        case nil:
            EmptyView()
        }
    }

    private func list(baseInfo: BlixLabelConfigurator) -> some View {
        BlixList(spacing: Spacing.extraLarge) {
            BlixLabel(configurator: baseInfo)
            ForEach(viewModel.days, id: \.day) { daySection($0) }
            footer
        }
    }

    private func failed(_ emptyState: BlixEmptyStateConfigurator, retry: BlixButtonConfigurator?) -> some View {
        ViewThatFits(in: .vertical) {
            emptyStateCard(emptyState, retry: retry)
            ScrollView { emptyStateCard(emptyState, retry: retry) }.scrollIndicators(.hidden)
        }
    }

    private func emptyStateCard(_ emptyState: BlixEmptyStateConfigurator, retry: BlixButtonConfigurator?) -> some View {
        VStack(spacing: Spacing.large) {
            BlixEmptyState(configurator: emptyState)
            if let retry { BlixButton(configurator: retry) }
        }
        .padding(Spacing.large)
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
}
