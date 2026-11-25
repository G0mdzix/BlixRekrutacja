import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        BlixList {
            BlixLabel(configurator: viewModel.appearanceHeaderConfigurator)

            appearanceRows
        }
        .navigationTitle(.settingsTitle)
        .errorAlert(viewModel.error) { viewModel.dismissError() }
    }

    private var appearanceRows: some View {
        ForEach(Appearance.allCases, id: \.self) {
            BlixSelectionRow(configurator: viewModel.appearanceRowConfigurator($0))
        }
    }
}

#Preview {
    NavigationStack { SettingsView(viewModel: SettingsViewModel(store: UserDefaultsStore.isolated())) }
}
