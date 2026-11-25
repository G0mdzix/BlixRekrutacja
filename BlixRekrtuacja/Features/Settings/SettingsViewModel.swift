import Observation

@MainActor @Observable
final class SettingsViewModel {
    private(set) var appearance: Appearance
    private(set) var error: AppError?

    private let store: any KeyValueStore

    init(store: any KeyValueStore) {
        self.store = store
        appearance = store.value(for: .appearance)
    }

    func select(_ appearance: Appearance) {
        guard appearance != self.appearance else { return }
        do {
            try store.set(appearance, for: .appearance)
            self.appearance = appearance
        } catch {
            self.error = AppError(error)
        }
    }

    func dismissError() {
        error = nil
    }
}

// MARK: - UI configurators

extension SettingsViewModel {
    var appearanceHeaderConfigurator: BlixLabelConfigurator {
        BlixLabelConfigurator(text: .localized(.settingsAppearance), style: .secondary, typography: .subheadline)
    }

    func appearanceRowConfigurator(_ appearance: Appearance) -> BlixSelectionRowConfigurator {
        BlixSelectionRowConfigurator(
            label: BlixLabelConfigurator(text: .localized(appearance.title)),
            isSelected: appearance == self.appearance
        ) { [weak self] in
            guard let self else { return }
            select(appearance)
        }
    }
}
