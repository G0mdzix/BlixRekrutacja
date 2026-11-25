import Foundation
import Observation

@MainActor @Observable
final class SettingsViewModel {
    private let preferences: UserPreferences

    init(preferences: UserPreferences) {
        self.preferences = preferences
    }

    func select(_ appearance: Appearance) {
        preferences.set(appearance)
    }

    func select(_ language: Language) {
        preferences.set(language)
    }
}

// MARK: - UI configurators

extension SettingsViewModel {
    var appearanceHeaderConfigurator: BlixLabelConfigurator { secondaryLabel(.settingsAppearance) }

    var languageHeaderConfigurator: BlixLabelConfigurator { secondaryLabel(.settingsLanguage) }

    var dataHeaderConfigurator: BlixLabelConfigurator { secondaryLabel(.settingsData) }

    var dataInfoConfigurator: BlixLabelConfigurator { secondaryLabel(.settingsDataInfo) }

    func appearanceRowConfigurator(_ appearance: Appearance) -> BlixSelectionRowConfigurator {
        BlixSelectionRowConfigurator(
            title: .localized(appearance.title),
            isSelected: appearance == preferences.appearance
        ) { [weak self] in
            guard let self else { return }
            select(appearance)
        }
    }

    func languageRowConfigurator(_ language: Language) -> BlixSelectionRowConfigurator {
        BlixSelectionRowConfigurator(
            title: .localized(language.title),
            isSelected: language == preferences.language
        ) { [weak self] in
            guard let self else { return }
            select(language)
        }
    }

    private func secondaryLabel(_ text: LocalizedStringResource) -> BlixLabelConfigurator {
        BlixLabelConfigurator(text: .localized(text), style: .secondary, typography: .subheadline)
    }
}
