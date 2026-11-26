import SwiftUI

struct RatesView: View {
    let viewModel: RatesViewModel

    var body: some View {
        content
            .blixNavigationTitle(.ratesTitle)
            .toolbar { settingsButton }
            .task { await viewModel.start() }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.content {
        case .loading: BlixSplash(configurator: viewModel.splashConfigurator).toolbar(.hidden, for: .navigationBar)
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
        BlixList(spacing: Spacing.large, anchor: .center) {
            BlixEmptyState(configurator: emptyState)
            if let retry { BlixButton(configurator: retry) }
        }
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
