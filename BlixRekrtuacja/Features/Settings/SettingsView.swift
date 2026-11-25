import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        BlixList {
            BlixLabel(configurator: viewModel.appearanceHeaderConfigurator)
            selectionCard(Appearance.allCases, row: viewModel.appearanceRowConfigurator)

            BlixLabel(configurator: viewModel.languageHeaderConfigurator)
            selectionCard(Language.allCases, row: viewModel.languageRowConfigurator)
        }
        .navigationTitle(.settingsTitle)
        .errorAlert(viewModel.error) { viewModel.dismissError() }
    }

    private func selectionCard<Option: Hashable>(
        _ options: [Option],
        row: @escaping (Option) -> BlixSelectionRowConfigurator
    ) -> some View {
        VStack(spacing: .zero) {
            ForEach(options, id: \.self) { BlixSelectionRow(configurator: row($0)) }
        }
        .padding(.horizontal, Spacing.large)
        .cardBackground(.secondary)
    }
}

#Preview {
    NavigationStack {
        SettingsView(viewModel: SettingsViewModel(preferences: UserPreferences(store: UserDefaultsStore.isolated())))
    }
}
